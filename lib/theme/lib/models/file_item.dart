import 'dart:io';

enum FileCategory { all, documents, images, videos, audio, archives, pdf, apk }

class FileItem {
  final String name;
  final String path;
  final int size;
  final DateTime modified;
  final bool isDirectory;
  final String extension;

  FileItem({
    required this.name,
    required this.path,
    required this.size,
    required this.modified,
    required this.isDirectory,
    required this.extension,
  });

  factory FileItem.fromFileSystemEntity(FileSystemEntity entity) {
    final stat = entity.statSync();
    final name = entity.path.split('/').last;
    final ext = name.contains('.') ? name.split('.').last.toLowerCase() : '';
    return FileItem(
      name: name,
      path: entity.path,
      size: stat.size,
      modified: stat.modified,
      isDirectory: entity is Directory,
      extension: ext,
    );
  }

  FileCategory get category {
    if (isDirectory) return FileCategory.all;
    const images = ['jpg','jpeg','png','gif','bmp','webp','heic'];
    const videos = ['mp4','mkv','avi','mov','wmv','flv','webm'];
    const audio = ['mp3','wav','aac','flac','ogg','m4a'];
    const archives = ['zip','rar','7z','tar','gz','bz2'];
    const docs = ['doc','docx','xls','xlsx','ppt','pptx','txt','csv'];
    if (extension == 'pdf') return FileCategory.pdf;
    if (extension == 'apk') return FileCategory.apk;
    if (images.contains(extension)) return FileCategory.images;
    if (videos.contains(extension)) return FileCategory.videos;
    if (audio.contains(extension)) return FileCategory.audio;
    if (archives.contains(extension)) return FileCategory.archives;
    if (docs.contains(extension)) return FileCategory.documents;
    return FileCategory.documents;
  }

  String get formattedSize {
    if (size < 1024) return '$size B';
    if (size < 1024 * 1024) return '${(size/1024).toStringAsFixed(1)} KB';
    if (size < 1024 * 1024 * 1024) return '${(size/(1024*1024)).toStringAsFixed(1)} MB';
    return '${(size/(1024*1024*1024)).toStringAsFixed(2)} GB';
  }

  String get formattedDate {
    final now = DateTime.now();
    final diff = now.difference(modified);
    if (diff.inDays == 0) return 'اليوم';
    if (diff.inDays == 1) return 'أمس';
    if (diff.inDays < 7) return 'منذ ${diff.inDays} أيام';
    return '${modified.day}/${modified.month}/${modified.year}';
  }
}
