import 'package:flutter/material.dart';
import '../models/file_item.dart';
import '../services/file_service.dart';
import '../theme/app_theme.dart';
import '../widgets/file_tile.dart';
import 'file_viewer_screen.dart';

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
  String _sortBy = 'name';
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
    setState(() {
      _files = files;
      _loading = false;
    });
  }

  List<FileItem> get _filteredFiles {
    var list = _files.where((f) {
      final matchCat = _filterCat == FileCategory.all || f.category == _filterCat;
      final matchSearch = _searchCtrl.text.isEmpty || f.name.toLowerCase().contains(_searchCtrl.text.toLowerCase());
      return matchCat && matchSearch;
    }).toList();
    switch (_sortBy) {
      case 'size': list.sort((a, b) => b.size.compareTo(a.size));
      case 'date': list.sort((a, b) => b.modified.compareTo(a.modified));
      default: list.sort((a, b) {
        if (a.isDirectory && !b.isDirectory) return -1;
        if (!a.isDirectory && b.isDirectory) return 1;
        return a.name.compareTo(b.name);
      });
    }
    return list;
  }

  void _navigateTo(FileItem item) {
    if (item.isDirectory) {
      _pathStack.add(item.path);
      _loadFiles();
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (_) => FileViewerScreen(file: item)));
    }
  }

  void _navigateBack() {
    if (_pathStack.length > 1) {
      _pathStack.removeLast();
      _loadFiles();
    }
  }

  void _showFileOptions(FileItem file) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface2,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => _FileOptionsSheet(file: file, onAction: (action) async {
        Navigator.pop(context);
        switch (action) {
          case 'delete':
            final ok = await _fileService.deleteFile(file.path);
            if (ok) _loadFiles();
          case 'rename':
            _showRenameDialog(file);
        }
      }),
    );
  }

  void _showRenameDialog(FileItem file) {
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

  void _showCreateFolderDialog() {
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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('مستعرض الملفات', style: TextStyle(color: AppColors.text1, fontSize: 16, fontWeight: FontWeight.w600)),
            Text(_currentPath.split('/').last.isEmpty ? 'الجذر' : _currentPath.split('/').last,
                style: const TextStyle(color: AppColors.text3, fontSize: 11)),
          ],
        ),
        actions: [
          IconButton(icon: Icon(_searching ? Icons.close : Icons.search_rounded, color: AppColors.text2),
              onPressed: () => setState(() { _searching = !_searching; if (!_searching) _searchCtrl.clear(); })),
          IconButton(icon: Icon(_gridView ? Icons.list_rounded : Icons.grid_view_rounded, color: AppColors.text2),
              onPressed: () => setState(() => _gridView = !_gridView)),
          PopupMenuButton<String>(
            color: AppColors.surface2,
            icon: const Icon(Icons.sort_rounded, color: AppColors.text2),
            onSelected: (v) => setState(() => _sortBy = v),
            itemBuilder: (_) => [
              const PopupMenuItem(value: 'name', child: Text('الاسم', style: TextStyle(color: AppColors.text1))),
              const PopupMenuItem(value: 'size', child: Text('الحجم', style: TextStyle(color: AppColors.text1))),
              const PopupMenuItem(value: 'date', child: Text('التاريخ', style: TextStyle(color: AppColors.text1))),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          if (_searching) Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _searchCtrl,
              onChanged: (_) => setState(() {}),
              style: const TextStyle(color: AppColors.text1),
              decoration: InputDecoration(
                hintText: 'بحث في الملفات...',
                hintStyle: const TextStyle(color: AppColors.text3),
                prefixIcon: const Icon(Icons.search, color: AppColors.text3),
                filled: true, fillColor: AppColors.surface2,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
          ),

          // Category filter chips
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: FileCategory.values.map((cat) {
                final labels = {
                  FileCategory.all: 'الكل', FileCategory.documents: 'مستندات',
                  FileCategory.images: 'صور', FileCategory.videos: 'فيديو',
                  FileCategory.audio: 'صوت', FileCategory.archives: 'مضغوط',
                  FileCategory.pdf: 'PDF', FileCategory.apk: 'APK',
                };
                final selected = _filterCat == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(labels[cat]!, style: TextStyle(fontSize: 12, color: selected ? Colors.white : AppColors.text2)),
                    selected: selected,
                    onSelected: (_) => setState(() => _filterCat = cat),
                    backgroundColor: AppColors.surface2,
                    selectedColor: AppColors.accent,
                    checkmarkColor: Colors.white,
                    side: BorderSide(color: selected ? AppColors.accent : AppColors.border),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 8),

          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator(color: AppColors.accent))
                : _filteredFiles.isEmpty
                ? const Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Icon(Icons.folder_open_rounded, color: AppColors.text3, size: 64),
                    SizedBox(height: 12),
                    Text('لا توجد ملفات', style: TextStyle(color: AppColors.text3)),
                  ]))
                : _gridView
                ? GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 0.85),
                    itemCount: _filteredFiles.length,
                    itemBuilder: (_, i) => FileTile(
                      file: _filteredFiles[i], isGrid: true,
                      onTap: () => _navigateTo(_filteredFiles[i]),
                      onLongPress: () => _showFileOptions(_filteredFiles[i]),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filteredFiles.length,
                    itemBuilder: (_, i) => FileTile(
                      file: _filteredFiles[i], isGrid: false,
                      onTap: () => _navigateTo(_filteredFiles[i]),
                      onLongPress: () => _showFileOptions(_filteredFiles[i]),
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.accent,
        onPressed: _showCreateFolderDialog,
        child: const Icon(Icons.create_new_folder_rounded, color: Colors.white),
      ),
    );
  }
}

class _FileOptionsSheet extends StatelessWidget {
  final FileItem file;
  final Function(String) onAction;
  const _FileOptionsSheet({required this.file, required this.onAction});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.text3, borderRadius: BorderRadius.circular(2))),
        const SizedBox(height: 16),
        Text(file.name, style: const TextStyle(color: AppColors.text1, fontSize: 15, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
        const SizedBox(height: 4),
        Text(file.formattedSize, style: const TextStyle(color: AppColors.text3, fontSize: 12)),
        const SizedBox(height: 20),
        _OptionTile(icon: Icons.drive_file_rename_outline, label: 'تغيير الاسم', onTap: () => onAction('rename')),
        _OptionTile(icon: Icons.copy_rounded, label: 'نسخ', onTap: () => onAction('copy')),
        _OptionTile(icon: Icons.drive_file_move_rounded, label: 'نقل', onTap: () => onAction('move')),
        _OptionTile(icon: Icons.share_rounded, label: 'مشاركة', onTap: () => onAction('share')),
        _OptionTile(icon: Icons.delete_rounded, label: 'حذف', color: AppColors.accent3, onTap: () => onAction('delete')),
      ]),
    );
  }
}

class _OptionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _OptionTile({required this.icon, required this.label, this.color = AppColors.text1, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: color, size: 22),
      title: Text(label, style: TextStyle(color: color, fontSize: 14)),
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
    );
  }
}
