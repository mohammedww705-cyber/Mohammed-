import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:archive/archive_io.dart';
import '../models/file_item.dart';

class FileService {
  static final FileService _instance = FileService._internal();
  factory FileService() => _instance;
  FileService._internal();

  Future<bool> requestPermissions() async {
    if (Platform.isAndroid) {
      final storage = await Permission.storage.request();
      final manage = await Permission.manageExternalStorage.request();
      return storage.isGranted || manage.isGranted;
    }
    return true;
  }

  Future<String> getRootPath() async {
    if (Platform.isAndroid) return '/storage/emulated/0';
    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  Future<List<FileItem>> listDirectory(String path) async {
    try {
      final dir = Directory(path);
      final entities = await dir.list().toList();
      final items = entities
          .map((e) => FileItem.fromFileSystemEntity(e))
          .toList();
      items.sort((a, b) {
        if (a.isDirectory && !b.isDirectory) return -1;
        if (!a.isDirectory && b.isDirectory) return 1;
        return a.name.compareTo(b.name);
      });
      return items;
    } catch (e) {
      return [];
    }
  }

  Future<bool> deleteFile(String path) async {
    try {
      final type = FileSystemEntity.typeSync(path);
      if (type == FileSystemEntityType.directory) {
        await Directory(path).delete(recursive: true);
      } else {
        await File(path).delete();
      }
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> renameFile(String path, String newName) async {
    try {
      final parent = path.substring(0, path.lastIndexOf('/'));
      final newPath = '$parent/$newName';
      final type = FileSystemEntity.typeSync(path);
      if (type == FileSystemEntityType.directory) {
        await Directory(path).rename(newPath);
      } else {
        await File(path).rename(newPath);
      }
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> createFolder(String parentPath, String name) async {
    try {
      await Directory('$parentPath/$name').create(recursive: true);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<String?> extractArchive(String archivePath, String destDir) async {
    try {
      final ext = archivePath.split('.').last.toLowerCase();
      final bytes = File(archivePath).readAsBytesSync();
      Archive archive;
      if (ext == 'zip') {
        archive = ZipDecoder().decodeBytes(bytes);
      } else {
        archive = TarDecoder().decodeBytes(GZipDecoder().decodeBytes(bytes));
      }
      final name = archivePath.split('/').last.replaceAll('.$ext', '');
      final outDir = '$destDir/$name';
      extractArchiveToDisk(archive, outDir);
      return outDir;
    } catch (e) {
      return null;
    }
  }

  Future<List<FileItem>> searchFiles(String root, String query) async {
    final results = <FileItem>[];
    try {
      await _searchRecursive(Directory(root), query.toLowerCase(), results);
    } catch (_) {}
    return results;
  }

  Future<void> _searchRecursive(Directory dir, String query, List<FileItem> results) async {
    try {
      final entities = await dir.list().toList();
      for (final e in entities) {
        final name = e.path.split('/').last.toLowerCase();
        if (name.contains(query)) results.add(FileItem.fromFileSystemEntity(e));
        if (e is Directory && results.length < 100) {
          await _searchRecursive(e, query, results);
        }
      }
    } catch (_) {}
  }
}
