import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

abstract final class AppLanguage {
  static const _storageKey = 'app_language';
  static final ValueNotifier<Locale> locale = ValueNotifier(const Locale('en'));

  static bool isArabic(BuildContext context) =>
      Localizations.localeOf(context).languageCode == 'ar';

  static String text(
    BuildContext context, {
    required String en,
    required String ar,
  }) => isArabic(context) ? ar : en;

  static Future<void> restore() async {
    if (!Hive.isBoxOpen('movie_cache')) return;
    final code = Hive.box<dynamic>('movie_cache').get(_storageKey) as String?;
    if (code == 'ar' || code == 'en') locale.value = Locale(code!);
  }

  static Future<void> set(Locale value) async {
    if (locale.value == value) return;
    locale.value = value;
    if (Hive.isBoxOpen('movie_cache')) {
      await Hive.box<dynamic>(
        'movie_cache',
      ).put(_storageKey, value.languageCode);
    }
  }
}

class LanguageSwitcher extends StatelessWidget {
  const LanguageSwitcher({super.key});

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<Locale>(
    valueListenable: AppLanguage.locale,
    builder: (context, locale, _) => Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFFFC400)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _FlagButton(
            flag: '🇺🇸',
            active: locale.languageCode == 'en',
            onTap: () => AppLanguage.set(const Locale('en')),
          ),
          _FlagButton(
            flag: '🇪🇬',
            active: locale.languageCode == 'ar',
            onTap: () => AppLanguage.set(const Locale('ar')),
          ),
        ],
      ),
    ),
  );
}

class _FlagButton extends StatelessWidget {
  const _FlagButton({
    required this.flag,
    required this.active,
    required this.onTap,
  });
  final String flag;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(12),
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        color: active ? const Color(0x33FFC400) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(flag, style: const TextStyle(fontSize: 17)),
    ),
  );
}
