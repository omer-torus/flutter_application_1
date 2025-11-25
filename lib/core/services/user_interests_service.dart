import 'package:supabase_flutter/supabase_flutter.dart';

class UserInterestsService {
  /// Kullanıcının ilgi alanlarını kontrol et
  /// Eğer 3 veya daha fazla ilgi alanı varsa true döner
  static Future<bool> hasCompletedInterests(String userId) async {
    try {
      final supabase = Supabase.instance.client;
      final response = await supabase
          .from('user_interests')
          .select('id')
          .eq('user_id', userId);

      return (response as List).length >= 3;
    } catch (e) {
      return false;
    }
  }

  /// Kullanıcının ilgi alanlarını getir
  static Future<List<String>> getUserInterests(String userId) async {
    try {
      final supabase = Supabase.instance.client;
      final response = await supabase
          .from('user_interests')
          .select('category')
          .eq('user_id', userId);

      return (response as List)
          .map((item) => item['category'] as String)
          .toList();
    } catch (e) {
      return [];
    }
  }
}

