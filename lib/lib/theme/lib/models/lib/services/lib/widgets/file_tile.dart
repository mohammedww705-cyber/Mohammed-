import 'package:flutter/material.dart';
import '../models/file_item.dart';
import '../theme/app_theme.dart';

class FileTile extends StatelessWidget {
  final FileItem file;
  final bool isGrid;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  const FileTile({super.key, required this.file, required this.isGrid, required this.onTap, required this.onLongPress});

  IconData get _icon {
    if (file.isDirectory) return Icons.folder_rounded;
    switch (file.category) {
      case FileCategory.pdf: return Icons.picture_as_pdf_rounded;
      case FileCategory.images: return Icons.image_rounded;
      case FileCategory.videos: return Icons.video_file_rounded;
      case FileCategory.audio: return Icons.audio_file_rounded;
      case FileCategory.archives: return Icons.folder_zip_rounded;
      case FileCategory.apk: return Icons.android_rounded;
      default: return Icons.insert_drive_file_rounded;
    }
  }

  Color get _color {
    if (file.isDirectory) return const Color(0xFFEF9F27);
    switch (file.category) {
      case FileCategory.pdf: return AppColors.accent3;
      case FileCategory.images: return AppColors.accent2;
      case FileCategory.videos: return const Color(0xFF378ADD);
      case FileCategory.audio: return const Color(0xFFFF6B6B);
      case FileCategory.archives: return const Color(0xFFEF9F27);
      default: return AppColors.accent;
    }
  }

  Color get _bgColor {
    if (file.isDirectory) return AppColors.cardAmber;
    switch (file.category) {
      case FileCategory.pdf: return AppColors.cardRed;
      case FileCategory.images: return AppColors.cardGreen;
      case FileCategory.videos: return AppColors.cardBlue;
      case FileCategory.archives: return AppColors.cardAmber;
      default: return AppColors.cardPurple;
    }
  }

  @override
  Widget build(BuildContext context) {
    return isGrid ? _buildGrid() : _buildList();
  }

  Widget _buildList() {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.all(11),
        decoration: BoxDecoration(
          color: AppColors.surface2,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(color: _bgColor, borderRadius: BorderRadius.circular(10)),
            child: Icon(_icon, color: _color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(file.name, style: const TextStyle(color: AppColors.text1, fontSize: 13, fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 2),
            Text(file.isDirectory ? 'مجلد' : '${file.formattedSize} · ${file.formattedDate}',
                style: const TextStyle(color: AppColors.text3, fontSize: 11)),
          ])),
          const Icon(Icons.more_vert_rounded, color: AppColors.text3, size: 16),
        ]),
      ),
    );
  }

  Widget _buildGrid() {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface2,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(color: _bgColor, borderRadius: BorderRadius.circular(12)),
            child: Icon(_icon, color: _color, size: 24),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Text(file.name, style: const TextStyle(color: AppColors.text1, fontSize: 11, fontWeight: FontWeight.w500), maxLines: 2, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center),
          ),
          const SizedBox(height: 2),
          Text(file.isDirectory ? 'مجلد' : file.formattedSize, style: const TextStyle(color: AppColors.text3, fontSize: 9)),
        ]),
      ),
    );
  }
}
