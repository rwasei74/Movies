import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

import 'app/app.dart';
import 'core/di/injection.dart';
import 'core/localization/app_language.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  try {
    await Hive.initFlutter();
    await Hive.openBox<dynamic>('movie_cache');
    await AppLanguage.restore();
  } catch (_) {
    // The app can still load movies from the network if local storage fails.
  }
  configureDependencies();
  runApp(const MoviesApp());
}
