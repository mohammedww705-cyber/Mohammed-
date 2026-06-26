import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/storage_card.dart';
import 'browser_screen.dart';
import 'cloud_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    _DashboardTab(),
    BrowserScreen(initialPath: null),
    CloudScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: AppColors.accent,
          unselectedItemColor: AppColors.text3,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'الرئيسية'),
            BottomNavigationBarItem(icon: Icon(Icons.folder_rounded), label: 'الملفات'),
            BottomNavigationBarItem(icon: Icon(Icons.cloud_rounded), label: 'السحابة'),
            BottomNavigationBarItem(icon: Icon(Icons.settings_rounded), label: 'الإعدادات'),
          ],
        ),
      ),
    );
  }
}

class _DashboardTab extends StatelessWidget {
  const _DashboardTab();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(
              width: 42, height: 42,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [AppColors.accent, AppColors.accent2], begin: Alignment.topLeft, end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.folder_open_rounded, color: Colors.white, size: 22),
            ),
            const SizedBox(width: 12),
            const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('FileX', style: TextStyle(color: AppColors.text1, fontSize: 22, fontWeight: FontWeight.w700)),
              Text('مدير الملفات الاحترافي', style: TextStyle(color: AppColors.text3, fontSize: 12)),
            ]),
          ]),
          const SizedBox(height: 20),
          const StorageCard(),
          const SizedBox(height: 20),
          const Text('الفئات', style: TextStyle(color: AppColors.text2, fontSize: 13, fontWeight: FontWeight.w500)),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 10, mainAxisSpacing: 10,
            children: const [
              _CatCard(icon: Icons.picture_as_pdf_rounded, label: 'PDF', color: Color(0xFFFF6B6B), bg: AppColors.cardRed),
              _CatCard(icon: Icons.image_rounded, label: 'صور', color: AppColors.accent2, bg: AppColors.cardGreen),
              _CatCard(icon: Icons.video_file_rounded, label: 'فيديو', color: Color(0xFF378ADD), bg: AppColors.cardBlue),
              _CatCard(icon: Icons.folder_zip_rounded, label: 'مضغوط', color: Color(0xFFEF9F27), bg: AppColors.cardAmber),
              _CatCard(icon: Icons.description_rounded, label: 'مستندات', color: AppColors.accent, bg: AppColors.cardPurple),
              _CatCard(icon: Icons.music_note_rounded, label: 'صوت', color: Color(0xFFFF6B6B), bg: AppColors.cardRed),
              _CatCard(icon: Icons.android_rounded, label: 'APK', color: AppColors.accent2, bg: AppColors.cardGreen),
              _CatCard(icon: Icons.more_horiz_rounded, label: 'أخرى', color: AppColors.text2, bg: AppColors.surface2),
            ],
          ),
          const SizedBox(height: 20),
          const Row(children: [
            Text('الملفات الأخيرة', style: TextStyle(color: AppColors.text2, fontSize: 13, fontWeight: FontWeight.w500)),
            Spacer(),
            Text('عرض الكل', style: TextStyle(color: AppColors.accent, fontSize: 12)),
          ]),
          const SizedBox(height: 12),
          ...[
            {'name': 'تقرير الربع الرابع.pd
