import 'dart:async';

import 'package:flutter/material.dart';

import '../../../onboarding/presentation/pages/onboarding_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(milliseconds: 1600), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (_) => const OnboardingPage()),
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => const Scaffold(
    backgroundColor: Color(0xFF101111),
    body: Center(child: _PlayMark()),
  );
}

class _PlayMark extends StatelessWidget {
  const _PlayMark();

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 74,
    height: 64,
    child: Stack(
      alignment: Alignment.center,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFFFC400), width: 1.6),
              shape: BoxShape.circle,
            ),
          ),
        ),
        const Align(
          alignment: Alignment.centerLeft,
          child: Icon(
            Icons.play_arrow_rounded,
            color: Color(0xFFFFC400),
            size: 52,
          ),
        ),
      ],
    ),
  );
}
