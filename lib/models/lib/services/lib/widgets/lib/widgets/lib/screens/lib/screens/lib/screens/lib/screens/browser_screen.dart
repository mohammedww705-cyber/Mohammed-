import 'package:flutter/material.dart';
import '../models/file_item.dart';
import '../services/file_service.dart';
import '../theme/app_theme.dart';
import '../widgets/file_tile.dart';

class BrowserScreen extends StatefulWidget {
  final String? initialPath;
  const BrowserScreen({super.key, this.initialPath});
  @override
  State<BrowserScreen> createState() => _BrowserScreenState();
}

class _BrowserScreenState extends State<BrowserScreen> {
  final _fileService = FileService();
  List<FileItem> _files = [];
  List<String> _pathStack = [];
  bool _loading = true;
  bool _gridView = false;
  FileCategory _filterCat = FileCategory.all;
  final _searchCtrl = TextEditingController();
  bool _searching = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await _fileService.requestPermissions();
    final root = widget.initialPath ?? await _fileService.getRootPath();
    _pathStack = [root];
    await _loadFiles();
  }

  String get _currentPath => _pathStack.isNotEmpty ? _pathStack.last : '/';

  Future<void> _loadFiles() async {
    setState(() => _loading = true);
    final files = await _fileService.listDirectory(_currentPath);
    setState(() { _files = files; _loading = false; });
  }

  List<FileItem> get _filteredFiles {
    return _files.where((f) {
      final matchCat = _filterCat == FileCategory.all || f.category == _filterCat;
      final matchSearch = _searchCtrl.text.isEmpty || f.name.toLowerCase().contains(_searchCtrl.text.toLowerCase());
      return matchCat && matchSearch;
    }).toList();
  }

  void _navigateTo(FileItem item) {
    if (item.isDirectory) {
      _pathStack.add(item.path);
      _loadFiles();
    }
  }

  void _navigateBack() {
    if (_pathStack.length > 1) {
      _pathStack.removeLast();
      _loadFiles();
    }
  }

  void _showOptions(FileItem file) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface2,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.text3, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 16),
          Text(file.name, style: const TextStyle(color: AppColors.text1, fontSize: 15, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 4),
          Text(file.formattedSize, style: const TextStyle(color: AppColors.text3, fontSize: 12)),
          const SizedBox(height: 20),
          _OptionTile(icon: Icons.drive_file_rename_outline, label: 'تغيير الاسم', onTap: () { Navigator.pop(context); _showRename(file); }),
          _OptionTile(icon: Icons.share_rounded, label: 'مشاركة', onTap: () => Navigator.pop(context)),
          _OptionTile(icon: Icons.delete_rounded, label: 'حذف', color: AppColors.accent3, onTap: () async {
            Navigator.pop(context);
            await _fileService.deleteFile(file.path);
            _loadFiles();
          }),
        ]),
      ),
    );
  }

  void _showRename(FileItem file) {
    final ctrl = TextEditingController(text: file.name);
    showDialog(context: context, builder: (_) => AlertDialog(
      backgroundColor: AppColors.surface2,
      title: const Text('تغيير الاسم', style: TextStyle(color: AppColors.text1)),
      content: TextField(
        controller: ctrl,
        style: const TextStyle(color: AppColors.text1),
        decoration: const InputDecoration(
          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.accent)),
          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.accent)),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء', style: TextStyle(color: AppColors.text2))),
        TextButton(onPressed: () async {
          Navigator.pop(context);
          await _fileService.renameFile(file.path, ctrl.text);
          _loadFiles();
        }, child: const Text('تغيير', style: TextStyle(color: AppColors.accent))),
      ],
    ));
  }

  void _showCreateFolder() {
    final ctrl = TextEditingController();
    showDialog(context: context, builder: (_) => AlertDialog(
      backgroundColor: AppColors.surface2,
      title: const Text('مجلد جديد', style: TextStyle(color: AppColors.text1)),
      content: TextField(
        controller: ctrl,
        style: const TextStyle(color: AppColors.text1),
        decoration: const InputDecoration(
          hintText: 'اسم المجلد',
          hintStyle: TextStyle(color: AppColors.text3),
          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.accent)),
          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.accent)),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء', style: TextStyle(color: AppColors.text2))),
        TextButton(onPressed: () async {
          Navigator.pop(context);
          await _fileService.createFolder(_currentPath, ctrl.text);
          _loadFiles();
        }, child: const Text('إنشاء', style: TextStyle(color: AppColors.accent))),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        leading: _pathStack.length > 1
            ? IconButton(icon: const Icon(Icons.arrow_back_ios_rounded, color: AppColors.text2), onPressed: _navigateBack)
            : null,
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('مستعرض الملفات', style: TextStyle(color: AppColors.text1, fontSize: 16, fontWeight: FontWeight.w600)),
          Text(_currentPath.split('/').last.isEmpty ? 'الجذر' : _currentPath.split('/').last,
              style: const TextStyle(color: AppColors.text3, fontSize: 11)),
        ]),
        actions: [
          IconButton(icon: Icon(_searching ? Icons.close : Icons.search_rounded, color: AppColors.text2),
              onPressed: () => setState(() { _searching = !_searching; if (!_searching) _searchCtrl.clear(); })),
          IconButton(icon: Icon(_gridView ? Icons.list_rounded : Icons.grid_view_rounded, color: AppColors.text
