import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/services/onboarding_service.dart';
import '../../auth/presentation/login_page.dart';
import 'onboarding_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  static const routeName = 'splash';
  static const routePath = '/';

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF00BCD4), // Cyan-blue
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            
            // Logo Container
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.location_on,
                size: 60,
                color: Color(0xFF00BCD4),
              ),
            ),
            const SizedBox(height: 32),
            
            // App Name
            const Text(
              'GezginAl',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            
            // Tagline
            const Text(
              'Yapay zeka destekli turizm rehberiniz',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            
            const Spacer(),
            
            // Başlayalım Button
            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () async {
                    final isCompleted = await OnboardingService.isOnboardingCompleted();
                    if (!mounted) return;
                    
                    if (isCompleted) {
                      context.go(LoginPage.routePath);
                    } else {
                      context.go(OnboardingPage.routePath);
                    }
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Başlayalım',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF00BCD4),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.arrow_forward,
                        color: Color(0xFF00BCD4),
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
