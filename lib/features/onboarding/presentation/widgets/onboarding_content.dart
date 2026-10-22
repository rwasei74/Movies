class OnboardingContent {
  const OnboardingContent({
    required this.imagePath,
    required this.title,
    required this.description,
    required this.primaryLabel,
    this.secondaryLabel,
  });

  final String imagePath;
  final String title;
  final String description;
  final String primaryLabel;
  final String? secondaryLabel;
}
