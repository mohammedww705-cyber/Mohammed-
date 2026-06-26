import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'browser_screen.dart';
import 'cloud_screen.dart';
import 'recent_screen.dart';
import 'settings_screen.dart';
import '../widgets/storage_card.dart';

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
          selectedLabelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
          unselectedLabelStyle: const TextStyle(fontSize: 11),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  width: 42, height: 42,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.accent, AppColors.accent2],
                      begin: Alignment.topLeft, end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.folder_open_rounded, color: Colors.white, size: 22),
                ),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('FileX', style: TextStyle(color: AppColors.text1, fontSize: 22, fontWeight: FontWeight.w700)),
                    Text('مدير الملفات الاحترافي', style: TextStyle(color: AppColors.text3, fontSize: 12)),
                  ],
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.notifications_outlined, color: AppColors.text2),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Storage Card
            const StorageCard(),
            const SizedBox(height: 20),

            // Quick Categories
            const Text('الفئات', style: TextStyle(color: AppColors.text2, fontSize: 13, fontWeight: FontWeight.w500)),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 4,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 10, mainAxisSpacing: 10,
              children: const [
                _CategoryCard(icon: Icons.picture_as_pdf_rounded, label: 'PDF', color: Color(0xFFFF6B6B), bgColor: AppColors.cardRed),
                _CategoryCard(icon: Icons.image_rounded, label: 'صور', color: AppColors.accent2, bgColor: AppColors.cardGreen),
                _CategoryCard(icon: Icons.video_file_rounded, label: 'فيديو', color: Color(0xFF378ADD), bgColor: AppColors.cardBlue),
                _CategoryCard(icon: Icons.folder_zip_rounded, label: 'مضغوط', color: Color(0xFFEF9F27), bgColor: AppColors.cardAmber),
                _CategoryCard(icon: Icons.description_rounded, label: 'مستندات', color: AppColors.accent, bgColor: AppColors.cardPurple),
                _CategoryCard(icon: Icons.music_note_rounded, label: 'صوت', color: Color(0xFFFF6B6B), bgColor: AppColors.cardRed),
                _CategoryCard(icon: Icons.android_rounded, label: 'APK', color: AppColors.accent2, bgColor: AppColors.cardGreen),
                _CategoryCard(icon: Icons.more_horiz_rounded, label: 'أخرى', color: AppColors.text2, bgColor: AppColors.surface2),
              ],
            ),
            const SizedBox(height: 20),

            // Quick Actions
            const Text('إجراءات سريعة', style: TextStyle(color: AppColors.text2, fontSize: 13, fontWeight: FontWeight.w500)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _QuickAction(
                  icon: Icons.create_new_folder_rounded,
                  label: 'مجلد جديد',
                  color: AppColors.accent,
                  onTap: () {},
                )),
                const SizedBox(width: 10),
                Expanded(child: _QuickAction(
                  icon: Icons.upload_file_rounded,
                  label: 'رفع ملف',
                  color: AppColors.accent2,
                  onTap: () {},
                )),
                const SizedBox(width: 10),
                Expanded(child: _QuickAction(
                  icon: Icons.search_rounded,
                  label: 'بحث',
                  color: const Color(0xFFEF9F27),
                  onTap: () {},
                )),
              ],
            ),
            const SizedBox(height: 20),

            // Recent Files
            const RecentFilesWidget(),
          ],
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Color bgColor;
  const _CategoryCard({required this.icon, required this.label, required this.color, required this.bgColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 26),
          const SizedBox(height: 6),
          Text(label, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _QuickAction({required this.icon, required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 6),
            Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}

class RecentFilesWidget extends StatelessWidget {
  const RecentFilesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final mockFiles = [
      {'name': 'تقرير الربع الرابع.pdf', 'size': '2.3 MB', 'icon': Icons.picture_as_pdf_rounded, 'color': const Color(0xFFFF6B6B), 'bg': AppColors.cardRed},
      {'name': 'مشروع_النهائي.zip', 'size': '48 MB', 'icon': Icons.folder_zip_rounded, 'color': const Color(0xFFEF9F27), 'bg': AppColors.cardAmber},
      {'name': 'عرض تقديمي.pptx', 'size': '5.1 MB', 'icon': Icons.slideshow_rounded, 'color': AppColors.accent, 'bg': AppColors.cardPurple},
      {'name': 'فيديو الاجتماع.mp4', 'size': '312 MB', 'icon': Icons.video_file_rounded, 'color': const Color(0xFF378ADD), 'bg': AppColors.cardBlue},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Text('الملفات الأخيرة', style: TextStyle(color: AppColors.text2, fontSize: 13, fontWeight: FontWeight.w500)),
            Spacer(),
            Text('عرض الكل', style: TextStyle(color: AppColors.accent, fontSize: 12)),
          ],
        ),
        const SizedBox(height: 12),
        ...mockFiles.map((f) => Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.surface2,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Container(
                width: 42, height: 42,
                decoration: BoxDecoration(color: f['bg'] as Color, borderRadius: BorderRadius.circular(10)),
                child: Icon(f['icon'] as IconData, color: f['color'] as Color, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(f['name'] as String, style: const TextStyle(color: AppColors.text1, fontSize: 13, fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2),
                  Text(f['size'] as String, style: const TextStyle(color: AppColors.text3, fontSize: 11)),
                ],
              )),
              const Icon(Icons.more_vert_rounded, color: AppColors.text3, size: 18),
            ],
          ),
        )),
      ],
    );
  }
}
