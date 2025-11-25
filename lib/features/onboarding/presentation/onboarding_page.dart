import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/services/onboarding_service.dart';
import '../../auth/presentation/login_page.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  static const routeName = 'onboarding';
  static const routePath = '/onboarding';

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingItem> _pages = [
    OnboardingItem(
      topColor: const Color(0xFF009688), // Teal
      icon: Icons.location_on,
      title: 'Kişiselleştirilmiş Rotalar',
      description: 'Yapay zeka destekli önerilerle size özel gezi rotaları oluşturun',
    ),
    OnboardingItem(
      topColor: const Color(0xFFFF9800), // Orange
      icon: Icons.calendar_today,
      title: 'Yakın Etkinlikler',
      description: 'Bulunduğunuz yere yakın festivaller ve etkinlikleri keşfedin',
    ),
    OnboardingItem(
      topColor: const Color(0xFF2196F3), // Blue (gradient için)
      gradientColors: [
        const Color(0xFF2196F3), // Blue
        const Color(0xFFFF9800), // Orange
      ],
      icon: Icons.people,
      title: 'Yerel Rehberler',
      description: 'Deneyimli yerel rehberlerle iletişime geçin ve sohbet edin',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  Future<void> _completeOnboarding() async {
    await OnboardingService.setOnboardingCompleted();
    if (!mounted) return;
    context.go(LoginPage.routePath);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageView.builder(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentPage = index;
            });
          },
          itemCount: _pages.length,
          itemBuilder: (context, index) {
            return _OnboardingItemWidget(
              item: _pages[index],
              isLastPage: index == _pages.length - 1,
              currentPage: index,
              totalPages: _pages.length,
              onNext: _nextPage,
            );
          },
        ),
      ),
    );
  }
}

class OnboardingItem {
  final Color topColor;
  final List<Color>? gradientColors;
  final IconData icon;
  final String title;
  final String description;

  OnboardingItem({
    required this.topColor,
    this.gradientColors,
    required this.icon,
    required this.title,
    required this.description,
  });
}

class _OnboardingItemWidget extends StatelessWidget {
  final OnboardingItem item;
  final bool isLastPage;
  final int currentPage;
  final int totalPages;
  final VoidCallback onNext;

  const _OnboardingItemWidget({
    required this.item,
    required this.isLastPage,
    required this.currentPage,
    required this.totalPages,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final bottomSectionHeight = screenHeight * 0.4;
    
    return Stack(
      children: [
        // Top Section with Icon (Full background)
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: item.gradientColors != null
                ? null
                : item.topColor,
            gradient: item.gradientColors != null
                ? LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: item.gradientColors!,
                  )
                : null,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Large Circle Background
              Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: item.gradientColors != null
                      ? Colors.white.withOpacity(0.2)
                      : item.topColor.withOpacity(0.3),
                ),
              ),
              // Icon
              Icon(
                item.icon,
                size: 120,
                color: Colors.white,
              ),
            ],
          ),
        ),
        
        // Bottom Section with Content (Positioned white card)
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            child: Container(
              width: double.infinity,
              height: bottomSectionHeight,
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(height: 24),
                  
                  // Title
                  Text(
                    item.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF212121),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Description
                  Text(
                    item.description,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                      height: 1.5,
                    ),
                  ),
                  
                  const Spacer(),
                  
                  // Page Indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      totalPages,
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: index == currentPage ? 32 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: index == currentPage
                              ? item.topColor
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Button
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: onNext,
                      style: FilledButton.styleFrom(
                        backgroundColor: item.topColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            isLastPage ? 'Devam Et' : 'İleri',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
