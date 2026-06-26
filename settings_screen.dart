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
  String _sortDefault = 'name';
  String _viewDefault = 'list';
  String _language = 'ar';

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
      _sortDefault = prefs.getString('sortDefault') ?? 'name';
      _viewDefault = prefs.getString('viewDefault') ?? 'list';
    });
  }

  Future<void> _save(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is bool) prefs.setBool(key, value);
    if (value is String) prefs.setString(key, value);
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

          // Profile card
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
                SizedBox(height: 2),
                Text('النسخة 1.0.0', style: TextStyle(color: AppColors.text3, fontSize: 12)),
              ]),
              const Spacer(),
              const Icon(Icons.edit_rounded, color: AppColors.text3, size: 18),
            ]),
          ),
          const SizedBox(height: 20),

          _Section(title: 'العرض', children: [
            _ToggleTile(icon: Icons.visibility_off_rounded, label: 'إظهار الملفات المخفية', value: _showHidden,
                onChanged: (v) { setState(() => _showHidden = v); _save('showHidden', v); }),
            _ToggleTile(icon: Icons.image_rounded, label: 'معاينة الصور', value: _previewImages,
                onChanged: (v) { setState(() => _previewImages = v); _save('previewImages', v); }),
            _SelectTile(icon: Icons.sort_rounded, label: 'الترتيب الافتراضي', value: _sortDefault,
                options: const {'name': 'الاسم', 'size': 'الحجم', 'date': 'التاريخ'},
                onChanged: (v) { setState(() => _sortDefault = v); _save('sortDefault', v); }),
            _SelectTile(icon: Icons.view_list_rounded, label: 'طريقة العرض', value: _viewDefault,
                options: const {'list': 'قائمة', 'grid': 'شبكة'},
                onChanged: (v) { setState(() => _viewDefault = v); _save('viewDefault', v); }),
          ]),

          _Section(title: 'الملفات', children: [
            _ToggleTile(icon: Icons.folder_zip_rounded, label: 'فك الضغط التلقائي', value: _autoExtract,
                onChanged: (v) { setState(() => _autoExtract = v); _save('autoExtract', v); }),
            _ToggleTile(icon: Icons.history_rounded, label: 'سجل الملفات الأخيرة', value: _recentFiles,
                onChanged: (v) { setState(() => _recentFiles = v); _save('recentFiles', v); }),
          ]),

          _Section(title: 'الخصوصية والأمان', children: [
            _ToggleTile(icon: Icons.fingerprint_rounded, label: 'قفل بالبصمة', value: _biometric,
                onChanged: (v) { setState(() => _biometric = v); _save('biometric', v); }),
            _ActionTile(icon: Icons.lock_reset_rounded, label: 'تغيير رمز المرور', onTap: () {}),
            _ActionTile(icon: Icons.security_rounded, label: 'الملفات المخفية المحمية', onTap: () {}),
          ]),

          _Section(title: 'اللغة والمنطقة', children: [
            _SelectTile(icon: Icons.language_rounded, label: 'اللغة', value: _language,
                options: const {'ar': 'العربية', 'en': 'English'},
                onChanged: (v) { setState(() => _language = v); _save('language', v); }),
          ]),

          _Section(title: 'حول التطبيق', children: [
            _ActionTile(icon: Icons.info_outline_rounded, label: 'معلومات التطبيق', onTap: () {}),
            _ActionTile(icon: Icons.star_rounded, label: 'تقييم التطبيق', onTap: () {}),
            _ActionTile(icon: Icons.share_rounded, label: 'مشاركة التطبيق', onTap: () {}),
            _ActionTile(icon: Icons.privacy_tip_rounded, label: 'سياسة الخصوصية', onTap: () {}),
          ]),

          const SizedBox(height: 20),
          TextButton(
            onPressed: () {},
            child: const Text('تسجيل الخروج', style: TextStyle(color: AppColors.accent3, fontSize: 14)),
          ),
          const SizedBox(height: 8),
          const Text('FileX v1.0.0 — جميع الحقوق محفوظة', style: TextStyle(color: AppColors.text3, fontSize: 11)),
          const SizedBox(height: 20),
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
        child: Column(children: children.map((child) {
          final idx = children.indexOf(child);
          return Column(children: [
            child,
            if (idx < children.length - 1) const Divider(height: 0, color: AppColors.border, indent: 48),
          ]);
        }).toList()),
      ),
      const SizedBox(height: 16),
    ]);
  }
}

class _ToggleTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  const _ToggleTile({required this.icon, required this.label, required this.value, required this.onChanged});

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

class _SelectTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Map<String, String> options;
  final ValueChanged<String> onChanged;
  const _SelectTile({required this.icon, required this.label, required this.value, required this.options, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.accent, size: 20),
      title: Text(label, style: const TextStyle(color: AppColors.text1, fontSize: 13)),
      trailing: DropdownButton<String>(
        value: value,
        dropdownColor: AppColors.surface2,
        underline: const SizedBox(),
        style: const TextStyle(color: AppColors.text2, fontSize: 12),
        items: options.entries.map((e) => DropdownMenuItem(value: e.key, child: Text(e.value))).toList(),
        onChanged: (v) { if (v != null) onChanged(v); },
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14),
      dense: true,
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _ActionTile({required this.icon, required this.label, required this.onTap});

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
