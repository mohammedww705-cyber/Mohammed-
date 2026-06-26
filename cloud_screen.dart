import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CloudScreen extends StatefulWidget {
  const CloudScreen({super.key});
  @override
  State<CloudScreen> createState() => _CloudScreenState();
}

class _CloudScreenState extends State<CloudScreen> {
  final List<Map<String, dynamic>> _clouds = [
    {'name': 'Google Drive', 'icon': Icons.add_to_drive_rounded, 'color': const Color(0xFF4285F4), 'connected': true, 'storage': '15 GB', 'used': '8.2 GB'},
    {'name': 'OneDrive', 'icon': Icons.cloud_rounded, 'color': const Color(0xFF0078D4), 'connected': true, 'storage': '5 GB', 'used': '2.1 GB'},
    {'name': 'Dropbox', 'icon': Icons.cloud_download_rounded, 'color': const Color(0xFF0061FE), 'connected': false, 'storage': '2 GB', 'used': '0 GB'},
    {'name': 'iCloud', 'icon': Icons.apple_rounded, 'color': const Color(0xFF999999), 'connected': false, 'storage': '5 GB', 'used': '0 GB'},
    {'name': 'Amazon S3', 'icon': Icons.storage_rounded, 'color': const Color(0xFFFF9900), 'connected': false, 'storage': 'مخصص', 'used': '0 GB'},
    {'name': 'Box', 'icon': Icons.inventory_2_rounded, 'color': const Color(0xFF0061D5), 'connected': false, 'storage': '10 GB', 'used': '0 GB'},
  ];

  @override
  Widget build(BuildContext context) {
    final connected = _clouds.where((c) => c['connected'] == true).toList();
    final notConnected = _clouds.where((c) => c['connected'] == false).toList();

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        title: const Text('السحابات', style: TextStyle(color: AppColors.text1, fontSize: 20, fontWeight: FontWeight.w700)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

          // Summary card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF1A1A40), Color(0xFF0D1530)], begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.accent.withOpacity(0.3)),
            ),
            child: Row(children: [
              const Icon(Icons.cloud_done_rounded, color: AppColors.accent, size: 36),
              const SizedBox(width: 16),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('إجمالي السحابة', style: TextStyle(color: AppColors.text2, fontSize: 12)),
                const Text('20 GB', style: TextStyle(color: AppColors.text1, fontSize: 28, fontWeight: FontWeight.w700)),
                Text('${connected.length} خدمات متصلة', style: const TextStyle(color: AppColors.accent, fontSize: 12)),
              ]),
            ]),
          ),
          const SizedBox(height: 24),

          // Connected
          const Text('متصل', style: TextStyle(color: AppColors.text2, fontSize: 13, fontWeight: FontWeight.w500)),
          const SizedBox(height: 10),
          ...connected.map((c) => _CloudTile(cloud: c, onToggle: () => setState(() => c['connected'] = !c['connected']))),
          const SizedBox(height: 20),

          // Not connected
          const Text('غير متصل', style: TextStyle(color: AppColors.text2, fontSize: 13, fontWeight: FontWeight.w500)),
          const SizedBox(height: 10),
          ...notConnected.map((c) => _CloudTile(cloud: c, onToggle: () => _connectCloud(c))),
        ]),
      ),
    );
  }

  void _connectCloud(Map<String, dynamic> cloud) {
    showDialog(context: context, builder: (_) => AlertDialog(
      backgroundColor: AppColors.surface2,
      title: Text('ربط ${cloud['name']}', style: const TextStyle(color: AppColors.text1)),
      content: const Text('سيتم فتح نافذة تسجيل الدخول لربط حسابك.', style: TextStyle(color: AppColors.text2)),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء', style: TextStyle(color: AppColors.text2))),
        TextButton(onPressed: () {
          Navigator.pop(context);
          setState(() => cloud['connected'] = true);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('تم ربط ${cloud['name']} بنجاح'),
            backgroundColor: AppColors.accent2,
          ));
        }, child: const Text('ربط', style: TextStyle(color: AppColors.accent))),
      ],
    ));
  }
}

class _CloudTile extends StatelessWidget {
  final Map<String, dynamic> cloud;
  final VoidCallback onToggle;
  const _CloudTile({required this.cloud, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    final connected = cloud['connected'] as bool;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: connected ? (cloud['color'] as Color).withOpacity(0.3) : AppColors.border),
      ),
      child: Row(children: [
        Container(
          width: 44, height: 44,
          decoration: BoxDecoration(color: (cloud['color'] as Color).withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
          child: Icon(cloud['icon'] as IconData, color: cloud['color'] as Color, size: 22),
        ),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(cloud['name'] as String, style: const TextStyle(color: AppColors.text1, fontSize: 14, fontWeight: FontWeight.w500)),
          const SizedBox(height: 2),
          Text(connected ? '${cloud['used']} / ${cloud['storage']}' : 'غير متصل',
              style: TextStyle(color: connected ? AppColors.text3 : AppColors.text3, fontSize: 11)),
        ])),
        connected
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: AppColors.accent2.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
                child: const Text('متصل', style: TextStyle(color: AppColors.accent2, fontSize: 11, fontWeight: FontWeight.w500)),
              )
            : GestureDetector(
                onTap: onToggle,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: AppColors.accent.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
                  child: const Text('ربط', style: TextStyle(color: AppColors.accent, fontSize: 11, fontWeight: FontWeight.w500)),
                ),
              ),
      ]),
    );
  }
}
