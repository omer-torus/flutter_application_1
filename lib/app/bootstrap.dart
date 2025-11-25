import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/config/app_env.dart';
import 'app.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Supabase yapılandırmasını kontrol et
  final supabaseUrl = AppEnv.supabaseUrl;
  final supabaseAnonKey = AppEnv.supabaseAnonKey;

  // Eğer default değerler kullanılıyorsa sadece debug modda uyarı ver
  if (supabaseUrl.contains('your-project') || 
      supabaseAnonKey.contains('public-anon-key')) {
    // Sadece debug modda göster, production'da gösterme
    if (const bool.fromEnvironment('dart.vm.product') == false) {
      debugPrint('ℹ️ Supabase yapılandırması: Default değerler kullanılıyor (UI test için)');
    }
  }

  try {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
    // Başarı mesajını sadece debug modda göster
    if (const bool.fromEnvironment('dart.vm.product') == false) {
      debugPrint('✅ Supabase başlatıldı');
    }
  } catch (e) {
    // Hata durumunda detaylı log göster
    debugPrint('❌ Supabase başlatma hatası: $e');
    // Hata olsa bile uygulamayı çalıştır (UI test için)
    // rethrow; // UI test için hata fırlatmayı kaldırdık
  }

  runApp(const ProviderScope(child: TravelGuideApp()));
}

