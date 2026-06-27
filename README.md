📱 FileX — دليل بناء التطبيق وتثبيته
الخطوة 1: رفع الكود على GitHub
افتح github.com وسجل دخول (أو أنشئ حساباً مجانياً)
اضغط New Repository
اسمه: filex-app → اضغط Create
ارفع مجلد filex_app كاملاً بالسحب والإفلات
الخطوة 2: بناء APK مجاناً على Codemagic
افتح codemagic.io
سجل دخول بحساب GitHub
اضغط Add application
اختر مستودع filex-app
اختر Flutter App
في إعدادات البناء:
Build for: Android
Mode: Debug (للتجربة السريعة)
اضغط Start new build
انتظر 10-15 دقيقة
حمّل ملف app-debug.apk من نتائج البناء
الخطوة 3: تثبيت APK على جهازك
على Android:
افتح الإعدادات → الأمان
فعّل السماح بتثبيت تطبيقات من مصادر غير معروفة
افتح ملف APK المحمّل → تثبيت
على iPhone:
استخدم TestFlight أو Codemagic مع Apple Developer Account
الخطوة 4 (اختيارية): بناء نسخة Release موقعة
# على جهازك المحلي بعد تثبيت Flutter:
cd filex_app
flutter build apk --release
# الملف في: build/app/outputs/flutter-apk/app-release.apk
هيكل ملفات المشروع
filex_app/
├── lib/
│   ├── main.dart              ← نقطة البداية
│   ├── theme/
│   │   └── app_theme.dart     ← الألوان والتصميم
│   ├── models/
│   │   └── file_item.dart     ← نموذج الملف
│   ├── services/
│   │   └── file_service.dart  ← عمليات الملفات
│   ├── screens/
│   │   ├── home_screen.dart   ← الشاشة الرئيسية
│   │   ├── browser_screen.dart← مستعرض الملفات
│   │   ├── file_viewer_screen.dart ← عارض الملفات
│   │   ├── cloud_screen.dart  ← إدارة السحابات
│   │   └── settings_screen.dart   ← الإعدادات
│   └── widgets/
│       ├── file_tile.dart     ← بطاقة الملف
│       └── storage_card.dart  ← بطاقة التخزين
├── android/
│   └── app/src/main/
│       └── AndroidManifest.xml← صلاحيات Android
└── pubspec.yaml               ← التبعيات
مميزات التطبيق
الميزة
التفاصيل
📁 مستعرض ملفات
تصفح كامل لجميع ملفات الجهاز
🔍 بحث متقدم
بحث فوري مع فلترة حسب النوع
📄 قارئ PDF
عارض PDF مدمج مع تنقل بين الصفحات
🖼️ عارض صور
تكبير وتصغير وتمرير
🎬 مشغل فيديو
تشغيل كامل مع تحكم
🗜️ ملفات مضغوطة
فك ضغط ZIP, TAR.GZ
☁️ سحابات
Google Drive, OneDrive, Dropbox, iCloud
🎨 تصميم داكن
واجهة عصرية بألوان احترافية
🔒 أمان
قفل بالبصمة وحماية الملفات
🌐 عربي كامل
واجهة عربية 100%
متطلبات Flutter للبناء المحلي
# تثبيت Flutter (مجاني)
# من: https://flutter.dev/docs/get-started/install

flutter --version   # تحقق من التثبيت
flutter pub get     # تحميل المكتبات
flutter build apk   # بناء APK
Flutter SDK: 3.0.0+
Dart SDK: 3.0.0+
Android SDK: API 21+ (Android 5.0)
iOS: 12.0+
