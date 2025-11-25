import '../entities/user_entity.dart';

abstract class AuthRepository {
  /// Mevcut kullanıcıyı döndürür
  Future<UserEntity?> getCurrentUser();

  /// Email ve şifre ile giriş
  Future<UserEntity> signInWithEmail({
    required String email,
    required String password,
  });

  /// Email ve şifre ile kayıt
  Future<UserEntity> signUpWithEmail({
    required String email,
    required String password,
    String? fullName,
  });

  /// Çıkış yap
  Future<void> signOut();

  /// Şifre sıfırlama emaili gönder
  Future<void> resetPassword(String email);

  /// Auth state değişikliklerini dinle
  Stream<UserEntity?> authStateChanges();
}

