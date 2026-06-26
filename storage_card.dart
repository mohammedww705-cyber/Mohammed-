import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class StorageCard extends StatelessWidget {
  const StorageCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Row(children: [
          Text('مساحة التخزين', style: TextStyle(color: AppColors.text2, fontSize: 13)),
          Spacer(),
          Text('68 GB / 128 GB', style: TextStyle(color: AppColors.text1, fontSize: 13, fontWeight: FontWeight.w500)),
        ]),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: 0.53,
            backgroundColor: AppColors.surface3,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent),
            minHeight: 7,
          ),
        ),
        const SizedBox(height: 12),
        Row(children: [
          _StorageDot(color: AppColors.accent, label: 'تطبيقات', value: '22G'),
          const SizedBox(width: 14),
          _StorageDot(color: AppColors.accent3, label: 'صور', value: '18G'),
          const SizedBox(width: 14),
          _StorageDot(color: AppColors.accent2, label: 'مستندات', value: '14G'),
          const SizedBox(width: 14),
          _StorageDot(color: AppColors.text3, label: 'أخرى', value: '14G'),
        ]),
      ]),
    );
  }
}

class _StorageDot extends StatelessWidget {
  final Color color;
  final String label;
  final String value;
  const _StorageDot({required this.color, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Container(width: 8, height: 8, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
      const SizedBox(width: 4),
      Text('$label $value', style: const TextStyle(color: AppColors.text3, fontSize: 10)),
    ]);
  }
}
