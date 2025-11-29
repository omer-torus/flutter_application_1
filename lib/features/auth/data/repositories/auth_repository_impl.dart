import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._supabase);

  final SupabaseClient _supabase;

  @override
  Future<UserEntity?> getCurrentUser() async {
    final session = _supabase.auth.currentSession;
    if (session == null) return null;

    final userId = session.user.id;
    final response = await _supabase
        .from('users')
        .select()
        .eq('id', userId)
        .maybeSingle();

    if (response == null) return null;
    return UserModel.fromJson(response);
  }

  @override
  Future<UserEntity> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw Exception('Giriş işlemi başarısız oldu. Lütfen tekrar deneyin.');
      }

      final userId = response.user!.id;
      final userResponse = await _supabase
          .from('users')
          .select()
          .eq('id', userId)
          .maybeSingle();

      if (userResponse == null) {
        // Eğer users tablosunda kayıt yoksa, sadece auth bilgileriyle oluştur
        return UserModel(
          id: userId,
          email: email,
        );
      }

      return UserModel.fromJson(userResponse);
    } on AuthException catch (e) {
      // Supabase auth hatalarını daha anlaşılır hale getir
      String errorMessage = 'Giriş işlemi başarısız oldu.';
      
      if (e.message.contains('Invalid login credentials') ||
          e.message.contains('Invalid credentials')) {
        errorMessage = 'E-posta veya şifre hatalı.';
      } else if (e.message.contains('Email not confirmed')) {
        errorMessage = 'E-posta adresinizi doğrulamanız gerekiyor.';
      } else if (e.message.contains('Failed to fetch') || 
                 e.message.contains('Network') ||
                 e.message.contains('fetch')) {
        errorMessage = 'İnternet bağlantınızı kontrol edin.';
      } else {
        errorMessage = e.message.isNotEmpty 
            ? e.message 
            : 'Giriş işlemi başarısız oldu. Lütfen tekrar deneyin.';
      }
      
      throw Exception(errorMessage);
    } catch (e) {
      // Diğer hatalar - daha detaylı hata mesajı
      String errorMessage = 'Giriş işlemi başarısız oldu.';
      final errorString = e.toString();
      
      // Supabase yapılandırma hatası kontrolü
      if (errorString.contains('your-project.supabase.co') ||
          errorString.contains('public-anon-key') ||
          errorString.contains('Invalid API key') ||
          errorString.contains('Invalid URL')) {
        errorMessage = 'Supabase yapılandırması eksik. Lütfen .env dosyasını kontrol edin.';
      } else if (errorString.contains('Failed to fetch') || 
          errorString.contains('Network') ||
          errorString.contains('fetch') ||
          errorString.contains('ClientException')) {
        // Gerçek hatayı göster (debug için)
        if (errorString.contains('ClientException')) {
          errorMessage = 'Supabase bağlantı hatası. URL ve API key\'lerinizi kontrol edin.';
        } else {
          errorMessage = 'İnternet bağlantınızı kontrol edin.';
        }
      } else if (errorString.contains('timeout')) {
        errorMessage = 'Bağlantı zaman aşımına uğradı. Lütfen tekrar deneyin.';
      } else {
        // Gerçek hata mesajını göster
        errorMessage = errorString
            .replaceAll('Exception: ', '')
            .replaceAll('AuthRetryableFetchException(message: ', '')
            .replaceAll('ClientException: ', '')
            .replaceAll(')', '');
        
        // Çok uzunsa kısalt
        if (errorMessage.length > 100) {
          errorMessage = 'Bağlantı hatası: ${errorMessage.substring(0, 100)}...';
        }
      }
      
      throw Exception(errorMessage);
    }
  }

  @override
  Future<UserEntity> signUpWithEmail({
    required String email,
    required String password,
    String? fullName,
  }) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: fullName != null ? {'full_name': fullName} : null,
      );

      if (response.user == null) {
        throw Exception('Kayıt işlemi başarısız oldu. Lütfen tekrar deneyin.');
      }

      final userId = response.user!.id;

      // Trigger otomatik olarak users tablosuna ekleyecek
      // Kısa bir gecikme sonra user profilini al
      await Future.delayed(const Duration(milliseconds: 500));

      final userResponse = await _supabase
          .from('users')
          .select()
          .eq('id', userId)
          .maybeSingle();

      if (userResponse == null) {
        // Eğer users tablosunda kayıt yoksa, sadece auth bilgileriyle oluştur
        return UserModel(
          id: userId,
          email: email,
          fullName: fullName,
        );
      }

      return UserModel.fromJson(userResponse);
    } on AuthException catch (e) {
      // Supabase auth hatalarını daha anlaşılır hale getir
      String errorMessage = 'Kayıt işlemi başarısız oldu.';
      
      if (e.message.contains('User already registered')) {
        errorMessage = 'Bu e-posta adresi zaten kayıtlı.';
      } else if (e.message.contains('Invalid email')) {
        errorMessage = 'Geçersiz e-posta adresi.';
      } else if (e.message.contains('Password')) {
        errorMessage = 'Şifre çok kısa. En az 6 karakter olmalı.';
      } else if (e.message.contains('Failed to fetch') || 
                 e.message.contains('Network') ||
                 e.message.contains('fetch')) {
        errorMessage = 'İnternet bağlantınızı kontrol edin.';
      } else {
        errorMessage = e.message.isNotEmpty 
            ? e.message 
            : 'Kayıt işlemi başarısız oldu. Lütfen tekrar deneyin.';
      }
      
      throw Exception(errorMessage);
    } catch (e) {
      // Diğer hatalar - daha detaylı hata mesajı
      String errorMessage = 'Kayıt işlemi başarısız oldu.';
      final errorString = e.toString();
      
      // Supabase yapılandırma hatası kontrolü
      if (errorString.contains('your-project.supabase.co') ||
          errorString.contains('public-anon-key') ||
          errorString.contains('Invalid API key') ||
          errorString.contains('Invalid URL')) {
        errorMessage = 'Supabase yapılandırması eksik. Lütfen .env dosyasını kontrol edin.';
      } else if (errorString.contains('Failed to fetch') || 
          errorString.contains('Network') ||
          errorString.contains('fetch') ||
          errorString.contains('ClientException')) {
        // Gerçek hatayı göster (debug için)
        if (errorString.contains('ClientException')) {
          errorMessage = 'Supabase bağlantı hatası. URL ve API key\'lerinizi kontrol edin.';
        } else {
          errorMessage = 'İnternet bağlantınızı kontrol edin.';
        }
      } else if (errorString.contains('timeout')) {
        errorMessage = 'Bağlantı zaman aşımına uğradı. Lütfen tekrar deneyin.';
      } else {
        // Gerçek hata mesajını göster
        errorMessage = errorString
            .replaceAll('Exception: ', '')
            .replaceAll('AuthRetryableFetchException(message: ', '')
            .replaceAll('ClientException: ', '')
            .replaceAll(')', '');
        
        // Çok uzunsa kısalt
        if (errorMessage.length > 100) {
          errorMessage = 'Bağlantı hatası: ${errorMessage.substring(0, 100)}...';
        }
      }
      
      throw Exception(errorMessage);
    }
  }

  @override
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  @override
  Future<void> resetPassword(String email) async {
    await _supabase.auth.resetPasswordForEmail(email);
  }

  @override
  Stream<UserEntity?> authStateChanges() {
    return _supabase.auth.onAuthStateChange.asyncMap((data) async {
      final session = data.session;
      if (session == null) return null;

      final userId = session.user.id;
      final response = await _supabase
          .from('users')
          .select()
          .eq('id', userId)
          .maybeSingle();

      if (response == null) return null;
      return UserModel.fromJson(response);
    });
  }
}

