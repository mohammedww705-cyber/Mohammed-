import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class RecentScreen extends StatelessWidget {
  const RecentScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.history_rounded, color: AppColors.text3, size: 64),
            SizedBox(height: 12),
            Text('لا توجد ملفات أخيرة', style: TextStyle(color: AppColors.text3, fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
