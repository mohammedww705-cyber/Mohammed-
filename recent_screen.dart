import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class RecentScreen extends StatelessWidget {
  const RecentScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.bg,
      body: Center(child: Text('الملفات الأخيرة', style: TextStyle(color: AppColors.text2))),
    );
  }
}
