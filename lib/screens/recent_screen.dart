import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _autoExtract = true;
  bool _showHidden = false;
  bool _biometric = true;
  bool _recentFiles = true;
  bool _previewImages = true;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _autoExtract = prefs.getBool('autoExtract') ?? true;
      _showHidden = prefs.getBool('showHidden') ?? false;
      _biometric = prefs.getBool('biometric') ?? true;
      _recentFiles = prefs.getBool('recentFiles') ?? true;
      _previewImages = prefs.getBool('previewImages') ?? true;
    });
  }

  Future<void> _save(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        title: const Text('الإعدادات', style: TextStyle(color: AppColors.text1, fontSize: 20, fontWeight: FontWeight.w700)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface2,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(children: [
              Container(
                width: 52, height: 52,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [AppColors.accent, AppColors.accent2]),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.person_rounded, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 14),
              const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('مستخدم FileX', style: TextStyle(color: AppColors.text1, fontSize: 15, fontWeight: FontWeight.w600)),
                Text('النسخة 1.0.0', style: TextStyle(color: AppColors.text3, fontSize: 12)),
              ]),
            ]),
          ),
          const SizedBox(height: 20),
          _Section(title: 'العرض', children: [
            _Toggle(icon: Icons.visibility_off_rounded, label: 'إظهار الملفات المخفية', value: _showHidden,
                onChanged: (v) { setState(() => _showHidden = v); _save('showHidden', v); }),
            _Toggle(icon: Icons.image_rounded, label: 'معاينة الصور', value: _previewImages,
                onChanged: (v) { setState(() => _previewImages = v); _save('previewImages', v); }),
          ]),
          _Section(title: 'الملفات', children: [
            _Toggle(icon: Icons.folder_zip_rounded, label: 'فك الضغط التلقائي', value: _autoExtract,
                onChanged: (v) { setState(() => _autoExtract = v); _save('autoExtract', v); }),
            _Toggle(icon: Icons.history_rounded, label: 'سجل الملفات الأخيرة', value: _recentFiles,
                onChanged: (v) { setState(() => _recentFiles = v); _save('recentFiles', v); }),
          ]),
          _Section(title: 'الأمان', children: [
            _Toggle(icon: Icons.fingerprint_rounded, label: 'قفل بالبصمة', value: _biometric,
                onChanged: (v) { setState(() => _biometric = v); _save('biometric', v); }),
          ]),
          _Section(title: 'حول التطبيق', children: [
            _Action(icon: Icons.info_outline_rounded, label: 'معلومات التطبيق', onTap: () {}),
            _Action(icon: Icons.star_rounded, label: 'تقييم التطبيق', onTap: () {}),
            _Action(icon: Icons.privacy_tip_rounded, label: 'سياسة الخصوصية', onTap: () {}),
          ]),
          const SizedBox(height: 20),
          const Text('FileX v1.0.0', style: TextStyle(color: AppColors.text3, fontSize: 11)),
        ]),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _Section({required this.title, required this.children});
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(title.toUpperCase(), style: const TextStyle(color: AppColors.text3, fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.8)),
      ),
      Container(
        decoration: BoxDecoration(color: AppColors.surface2, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
        child: Column(children: children.asMap().entries.map((e) {
          return Column(children: [
            e.value,
            if (e.key < children.length - 1) const Divider(height: 0, color: AppColors.border, indent: 48),
          ]);
        }).toList()),
      ),
      const SizedBox(height: 16),
    ]);
  }
}

class _Toggle extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  const _Toggle({required this.icon, required this.label, required this.value, required this.onChanged});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.accent, size: 20),
      title: Text(label, style: const TextStyle(color: AppColors.text1, fontSize: 13)),
      trailing: Switch(value: value, onChanged: onChanged, activeColor: AppColors.accent),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14),
      dense: true,
    );
  }
}

class _Action extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _Action({required this.icon, required this.label, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.accent, size: 20),
      title: Text(label, style: const TextStyle(color: AppColors.text1, fontSize: 13)),
      trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.text3, size: 18),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14),
      dense: true,
    );
  }
}
