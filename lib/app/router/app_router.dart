import 'package:flutter/material.dart';
import '../../features/splash/presentation/pages/splash_page.dart';

abstract final class AppRouter {
  static const splash = '/';
  static Route<void> onGenerateRoute(RouteSettings settings) =>
      MaterialPageRoute<void>(
        settings: settings,
        builder: (_) => const SplashPage(),
      );
}
