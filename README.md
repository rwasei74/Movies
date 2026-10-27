<div align="center">

<h1>🎬 Movies</h1>

<h3>اكتشف فيلمك القادم، احفظه، وشاهده من مكان واحد</h3>

<p>تطبيق Flutter للأفلام بتصميم داكن ولمسات صفراء، يجمع البحث، التصفح حسب النوع، قائمة المشاهدة، وسجل المشاهدة في تجربة واحدة.</p>

<p>
  <img src="https://img.shields.io/badge/Flutter-Dart-02569B?logo=flutter&amp;logoColor=white" alt="Flutter and Dart">
  <img src="https://img.shields.io/badge/Firebase-Auth%20%2B%20Firestore-FFCA28?logo=firebase&amp;logoColor=black" alt="Firebase Authentication and Firestore">
  <img src="https://img.shields.io/badge/State-Cubit%20%2F%20BLoC-6A4C93" alt="Cubit and BLoC">
  <img src="https://img.shields.io/badge/Local%20Storage-Hive-FFC400" alt="Hive storage">
</p>

<p><a href="#screenshots">الشاشات</a> · <a href="#features">الميزات</a> · <a href="#architecture">بنية المشروع</a></p>

</div>

---

## Screenshots

### 01 · Onboarding — التعريف بالتطبيق

ست شاشات تعرّف المستخدم بفكرة التطبيق: اكتشاف الأفلام، استكشاف الأنواع، قائمة المشاهدة، ثم بدء الاستخدام.

<table>
  <tr>
    <td align="center"><a href="docs/screenshots/onboarding-01.png"><img src="docs/screenshots/onboarding-01.png" height="340" alt="Onboarding: Find Your Next Favorite Movie Here"></a><br><b>01 · البداية</b><br><sub>Find your next favorite movie</sub></td>
    <td align="center"><a href="docs/screenshots/onboarding-02.png"><img src="docs/screenshots/onboarding-02.png" height="340" alt="Onboarding: Discover Movies"></a><br><b>02 · اكتشاف الأفلام</b><br><sub>Discover movies</sub></td>
    <td align="center"><a href="docs/screenshots/onboarding-03.png"><img src="docs/screenshots/onboarding-03.png" height="340" alt="Onboarding: Explore All Genres"></a><br><b>03 · استكشاف الأنواع</b><br><sub>Explore all genres</sub></td>
  </tr>
  <tr>
    <td align="center"><a href="docs/screenshots/onboarding-04.png"><img src="docs/screenshots/onboarding-04.png" height="340" alt="Onboarding: Create Watchlists"></a><br><b>04 · قائمة المشاهدة</b><br><sub>Create watchlists</sub></td>
    <td align="center"><a href="docs/screenshots/onboarding-05.png"><img src="docs/screenshots/onboarding-05.png" height="340" alt="Onboarding: Rate, Review, and Learn"></a><br><b>05 · تفاصيل الأفلام</b><br><sub>Rate, review, and learn</sub></td>
    <td align="center"><a href="docs/screenshots/onboarding-06.png"><img src="docs/screenshots/onboarding-06.png" height="340" alt="Onboarding: Start Watching Now"></a><br><b>06 · ابدأ الآن</b><br><sub>Start watching now</sub></td>
  </tr>
</table>

### 02 · Main experience — التجربة الأساسية

<table>
  <tr>
    <td align="center"><a href="docs/screenshots/login.png"><img src="docs/screenshots/login.png" height="340" alt="Login screen"></a><br><b>Login</b><br><sub>تسجيل الدخول بالبريد أو Google<br>والتبديل بين العربية والإنجليزية</sub></td>
    <td align="center"><a href="docs/screenshots/register.png"><img src="docs/screenshots/register.png" height="340" alt="Register screen"></a><br><b>Register</b><br><sub>إنشاء حساب جديد<br>بالاسم والبريد وكلمة المرور</sub></td>
    <td align="center"><a href="docs/screenshots/home.png"><img src="docs/screenshots/home.png" height="340" alt="Home screen"></a><br><b>Home</b><br><sub>أفلام مميزة وأحدث الأفلام<br>مع شريط تنقل سفلي</sub></td>
  </tr>
  <tr>
    <td align="center"><a href="docs/screenshots/search.png"><img src="docs/screenshots/search.png" height="340" alt="Search screen"></a><br><b>Search</b><br><sub>البحث عن فيلم وعرض<br>آخر نتائج البحث المحفوظة</sub></td>
    <td align="center"><a href="docs/screenshots/browse.png"><img src="docs/screenshots/browse.png" height="340" alt="Browse screen"></a><br><b>Browse</b><br><sub>تصفية الأفلام حسب النوع<br>وعرضها في شبكة ملصقات</sub></td>
    <td align="center"><a href="docs/screenshots/movie-details.png"><img src="docs/screenshots/movie-details.png" height="340" alt="Movie details screen"></a><br><b>Movie Details</b><br><sub>تفاصيل الفيلم والتقييم والملخص<br>والإضافة إلى قائمة المشاهدة</sub></td>
  </tr>
</table>

> توجد أيضًا شاشات استعادة كلمة المرور، الملف الشخصي، وقائمة المشاهدة داخل التطبيق؛ الصور أعلاه هي اللقطات المتوفرة لهذه النسخة من README.

## Features

| الجزء | الموجود حاليًا |
| --- | --- |
| **الدخول والحساب** | إنشاء حساب وتسجيل الدخول بالبريد وكلمة المرور، تسجيل الدخول عبر Google، استعادة كلمة المرور، وتسجيل الخروج باستخدام Firebase Authentication. |
| **الصفحة الرئيسية** | عرض أفلام مميزة وأحدث الأفلام ببيانات وملصقات من YTS API. |
| **البحث** | بحث عن الأفلام مع تأخير قصير أثناء الكتابة، وإظهار آخر نتائج البحث المحفوظة محليًا. |
| **التصفح** | عرض الأفلام حسب النوع: Action وAdventure وAnimation وBiography وComedy. |
| **تفاصيل الفيلم** | الملصق، العنوان، سنة الإصدار، النوع، المدة، التقييم، الملخص، وخيارات الجودة المتوفرة. |
| **قائمة المشاهدة** | إضافة الأفلام وإزالتها، مع مزامنة قائمة كل مستخدم عبر Cloud Firestore. |
| **التشغيل والسجل** | اختيار جودة التورنت وتشغيله على Android، وتسجيل الفيلم الذي يبدأ تشغيله في سجل محلي باستخدام Hive. |
| **التخزين المحلي** | حفظ الأفلام المميزة وآخر نتائج البحث لتظهر عند تعذر الاتصال، مع حفظ سجل المشاهدة وتفضيل اللغة. |
| **اللغة** | التبديل بين العربية والإنجليزية من واجهة الدخول، مع تذكر الاختيار عند فتح التطبيق لاحقًا. |

## Architecture

المشروع منظّم حسب الميزة، وداخل كل ميزة تُفصل طبقات **presentation / domain / data** وفق Clean Architecture وMVVM. تستخدم شاشات البيانات والمصادقة والمشغّل `Cubit` من `flutter_bloc` لإدارة حالات التحميل والنجاح والخطأ، بينما تستخدم شاشة التعريف `ChangeNotifier` لتتبع الصفحة الحالية.

```text
lib/
├── app/                 # إعداد التطبيق، المسارات والثيم
├── core/                # الخدمات المشتركة، حقن الاعتماديات واللغة
├── features/
│   ├── auth/            # الدخول، التسجيل واستعادة كلمة المرور
│   ├── onboarding/      # شاشات التعريف
│   ├── home/            # الرئيسية، البحث، التصفح، التفاصيل والمشغّل
│   ├── watchlist/       # قائمة المشاهدة على Firestore
│   ├── history/         # سجل المشاهدة المحلي على Hive
│   └── profile/         # الملف الشخصي
└── main.dart
```

**التقنيات:** Flutter · Dart · Firebase Authentication · Cloud Firestore · YTS API · Hive CE · flutter_bloc · video_player.

---

<div align="center"><sub>Built with Flutter · Screenshots captured on Android</sub></div>
