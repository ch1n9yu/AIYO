import 'package:aiyo11/login_pages/welcome_page.dart';
import 'package:aiyo11/widget/on_boarding_widget.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Widget> _pages = [
    const OnboardingWidget(
      title: 'Easy to Get Started',
      description: '"All you need is a phone to \nstart your yoga journey."',
      imagePath: 'asset/images/onboarding1.png',
    ),
    const OnboardingWidget(
      title: 'Track Your Progress',
      description:
      'Monitor your health and fitness goals \n and see your progress.',
      imagePath: 'asset/images/onboarding2.png',
    ),
    const OnboardingWidget(
      title: 'Keep an Exercise Habit',
      description: 'Set alarms to remind yourself \nto exercise daily.',
      imagePath: 'asset/images/onboarding3.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemCount: _pages.length,
            itemBuilder: (context, index) {
              return _pages[index];
            },
          ),
          Positioned(
            bottom: 20.0,
            left: 20.0,
            right: 20.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    _pageController.animateToPage(
                      _pages.length - 1,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: const Text(
                    'Skip',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                Row(
                  children: List.generate(
                    _pages.length,
                        (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4.0),
                      width: _currentPage == index ? 12.0 : 8.0,
                      height: _currentPage == index ? 12.0 : 8.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color:
                        _currentPage == index ? Colors.blue : Colors.grey,
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    if (_currentPage == _pages.length - 1) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                          const WelcomeScreen(), // 跳转到 WelcomeScreen
                        ),
                      );
                    } else {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  child: Text(
                    _currentPage == _pages.length - 1 ? 'Start' : 'Next',
                    style: const TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
