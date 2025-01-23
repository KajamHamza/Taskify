import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      title: 'The best Service in your\nhands with Taskify',
      description: 'Discover the convenience of finding\nyour perfect service with our Taskify app.',
      image: 'assets/images/onboarding1.png',
    ),
    OnboardingPage(
      title: 'The perfect service is\njust a tap away!',
      description: 'Your journey begins with Taskify.\nFind your ideal service effortlessly.',
      image: 'assets/images/onboarding2.png',
    ),
    OnboardingPage(
      title: 'Your Needs, your way.\nLet\'s get Started',
      description: 'Want to promote your service?\nSit back, and let us take care of the rest.',
      image: 'assets/images/onboarding3.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: Column(
          children: [
            // Skip Button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/auth');
                  },
                  child: Text(
                    'Skip',
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
            // PageView for Onboarding Screens
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemBuilder: (context, index) {
                  return _pages[index];
                },
              ),
            ),
            // Dot Indicators
            Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: SmoothPageIndicator(
                controller: _pageController,
                count: _pages.length,
                effect: ExpandingDotsEffect(
                  activeDotColor: theme.colorScheme.primary,
                  dotColor: theme.colorScheme.surface,
                  dotHeight: 8,
                  dotWidth: 8,
                  spacing: 8,
                  expansionFactor: 3,
                ),
              ),
            ),
            // Next/Get Started Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    if (_currentPage < _pages.length - 1) {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      Navigator.pushReplacementNamed(context, '/auth');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    _currentPage < _pages.length - 1 ? 'Next' : 'Get Started',
                    style: TextStyle(
                      color: theme.colorScheme.onPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String title;
  final String description;
  final String image;

  const OnboardingPage({
    Key? key,
    required this.title,
    required this.description,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image
          Image.asset(
            image,
            height: MediaQuery.of(context).size.height * 0.4,
          ),
          const SizedBox(height: 32),
          // Title
          Text(
            title,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          // Description
          Text(
            description,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.secondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}