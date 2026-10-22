import 'package:flutter/material.dart';

import 'router/app_router.dart';
import 'theme/app_theme.dart';

class MoviesApp extends StatelessWidget {
  const MoviesApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Movies',
    debugShowCheckedModeBanner: false,
    theme: AppTheme.light,
    initialRoute: AppRouter.splash,
    onGenerateRoute: AppRouter.onGenerateRoute,
  );
}
