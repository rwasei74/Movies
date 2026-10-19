import 'package:flutter/material.dart';

import '../../../auth/presentation/pages/login_page.dart';

import '../viewmodels/onboarding_view_model.dart';
import '../widgets/onboarding_content.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _controller = PageController();
  final _viewModel = OnboardingViewModel();

  static const _screens = [
    OnboardingContent(
      imagePath: 'assets/images/Movies Posters.png',
      title: 'Find Your Next\nFavorite Movie Here',
      description:
          'Get access to a huge library of movies\nto suit all tastes. You will surely like it.',
      primaryLabel: 'Explore Now',
    ),
    OnboardingContent(
      imagePath: 'assets/images/62f0c6c02841c54f59afbbac6b00172109786308.jpg',
      title: 'Discover Movies',
      description:
          'Explore a vast collection of movies in all\nqualities and genres. Find your next\nfavorite film with ease.',
      primaryLabel: 'Next',
    ),
    OnboardingContent(
      imagePath: 'assets/images/a8c73981364e3d0cf59c2d39a783a625ed5aa2b9.jpg',
      title: 'Explore All Genres',
      description:
          'Discover movies from every genre, in all\navailable qualities. Find something new\nand exciting to watch every day.',
      primaryLabel: 'Next',
      secondaryLabel: 'Back',
    ),
    OnboardingContent(
      imagePath:
          'assets/images/85593b85e656364c771cd28e82a4747f0311ae29 (1).jpg',
      title: 'Create Watchlists',
      description:
          'Save movies to your watchlist to keep\ntrack of what you want to watch next.\nEnjoy films in various qualities and\ngenres.',
      primaryLabel: 'Next',
      secondaryLabel: 'Back',
    ),
    OnboardingContent(
      imagePath: 'assets/images/467ec0bd3c2e949be39e10168ae20d3a4c9ffad7.jpg',
      title: 'Rate, Review, and Learn',
      description:
          'Share your thoughts on the movies\nyou’ve watched. Dive deep into film\ndetails and help others discover great\nmovies with your reviews.',
      primaryLabel: 'Next',
      secondaryLabel: 'Back',
    ),
    OnboardingContent(
      imagePath:
          'assets/images/62a91993882ebf7b39030a68c87492f1e5e33643 (1).jpg',
      title: 'Start Watching Now',
      description: '',
      primaryLabel: 'Finish',
      secondaryLabel: 'Back',
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  void _next() {
    if (_viewModel.currentPage == _screens.length - 1) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (_) => const LoginPage()),
      );
      return;
    }
    _controller.nextPage(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOut,
    );
  }

  void _back() {
    if (_viewModel.currentPage == 0) return;
    _controller.previousPage(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _viewModel,
    builder: (_, _) => Scaffold(
      backgroundColor: const Color(0xFF101111),
      body: PageView.builder(
        controller: _controller,
        itemCount: _screens.length,
        onPageChanged: _viewModel.changePage,
        itemBuilder: (_, index) => _OnboardingSlide(
          content: _screens[index],
          onPrimaryTap: _next,
          onSecondaryTap: _back,
        ),
      ),
    ),
  );
}

class _OnboardingSlide extends StatelessWidget {
  const _OnboardingSlide({
    required this.content,
    required this.onPrimaryTap,
    required this.onSecondaryTap,
  });
  final OnboardingContent content;
  final VoidCallback onPrimaryTap;
  final VoidCallback onSecondaryTap;

  @override
  Widget build(BuildContext context) => Stack(
    fit: StackFit.expand,
    children: [
      Image.asset(content.imagePath, fit: BoxFit.cover),
      const DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.transparent, Color(0x33000000), Color(0xFF101111)],
            stops: [0.36, 0.56, 0.82],
          ),
        ),
      ),
      SafeArea(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
            child: _BottomSheet(
              content: content,
              onPrimaryTap: onPrimaryTap,
              onSecondaryTap: onSecondaryTap,
            ),
          ),
        ),
      ),
    ],
  );
}

class _BottomSheet extends StatelessWidget {
  const _BottomSheet({
    required this.content,
    required this.onPrimaryTap,
    required this.onSecondaryTap,
  });
  final OnboardingContent content;
  final VoidCallback onPrimaryTap;
  final VoidCallback onSecondaryTap;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.fromLTRB(18, 14, 18, 8),
    decoration: const BoxDecoration(
      color: Color(0xFF101111),
      borderRadius: BorderRadius.vertical(top: Radius.circular(19)),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          content.title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 17,
            height: 1.06,
          ),
        ),
        if (content.description.isNotEmpty) ...[
          const SizedBox(height: 12),
          Text(
            content.description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFFD2D2D2),
              fontSize: 10,
              height: 1.16,
            ),
          ),
        ],
        const SizedBox(height: 13),
        _ActionButton(
          label: content.primaryLabel,
          filled: true,
          onTap: onPrimaryTap,
        ),
        if (content.secondaryLabel != null) ...[
          const SizedBox(height: 7),
          _ActionButton(
            label: content.secondaryLabel!,
            filled: false,
            onTap: onSecondaryTap,
          ),
        ],
      ],
    ),
  );
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.filled,
    required this.onTap,
  });
  final String label;
  final bool filled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    height: 36,
    child: OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        backgroundColor: filled ? const Color(0xFFFFC400) : Colors.transparent,
        foregroundColor: filled ? Colors.black : const Color(0xFFFFC400),
        side: const BorderSide(color: Color(0xFFFFC400), width: 1.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
      ),
      child: Text(label),
    ),
  );
}
