import 'package:shared_preferences/shared_preferences.dart';

class OnboardingService {
  static const String _keyOnboardingCompleted = 'onboarding_completed';

  /// İlk kullanım kontrolü - onboarding tamamlandı mı?
  static Future<bool> isOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyOnboardingCompleted) ?? false;
  }

  /// Onboarding'i tamamlandı olarak işaretle
  static Future<void> setOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyOnboardingCompleted, true);
  }

  /// Onboarding durumunu sıfırla (test için)
  static Future<void> resetOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyOnboardingCompleted);
  }
}

