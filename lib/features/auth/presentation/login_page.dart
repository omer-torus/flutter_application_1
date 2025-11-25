import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../../../core/services/user_interests_service.dart';
import '../../home/presentation/home_page.dart';
import '../application/auth_state.dart';
import '../../interests/presentation/interests_page.dart';
import 'signup_page.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  static const routeName = 'login';
  static const routePath = '/login';

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;


  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    await ref.read(authControllerProvider.notifier).signInWithEmail(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    // Auth state değişikliklerini dinle
    ref.listen(authControllerProvider, (previous, next) async {
      if (!mounted) return;
      
      if (next.status == AuthStatus.authenticated && next.user != null) {
        // Kullanıcının ilgi alanlarını kontrol et
        final hasInterests = await UserInterestsService.hasCompletedInterests(
          next.user!.id,
        );
        
        if (!mounted) return;
        
        if (hasInterests) {
          // İlgi alanları seçilmiş, home'a git
          context.go(HomePage.routePath);
        } else {
          // İlgi alanları seçilmemiş, interests sayfasına git
          context.go(InterestsPage.routePath);
        }
      } else if (next.status == AuthStatus.error && next.error != null) {
        // Hata mesajını göster
        String errorMessage = next.error!;
        
        // Supabase yapılandırma hatası kontrolü
        if (errorMessage.contains('Supabase yapılandırması eksik')) {
          errorMessage = 'Supabase yapılandırması eksik. Lütfen .env dosyasını kontrol edin.';
        } else if (errorMessage.contains('your-project.supabase.co')) {
          errorMessage = 'Supabase URL ve API key\'lerinizi .env dosyasına ekleyin.';
        }
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 5),
            ),
          );
        }
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Başlık
                  Text(
                    'Hoş Geldiniz',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF212121),
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Hesabınızı oluşturun veya giriş yapın',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                  const SizedBox(height: 40),

                  // Email
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'E-posta',
                      hintText: 'ornek@email.com',
                      labelStyle: const TextStyle(color: Color(0xFF212121)),
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email gerekli';
                      }
                      if (!value.contains('@')) {
                        return 'Geçerli bir email girin';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Şifre
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: 'Şifre',
                      hintText: '••••••••',
                      labelStyle: const TextStyle(color: Color(0xFF212121)),
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: Colors.grey[600],
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Şifre gerekli';
                      }
                      if (value.length < 6) {
                        return 'Şifre en az 6 karakter olmalı';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),

                  // Giriş Yap Butonu
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: authState.isLoading ? null : _handleLogin,
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF4DB6AC), // Light blue-green
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: authState.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Giriş Yap',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Hesap Oluştur Butonu
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: authState.isLoading
                          ? null
                          : () => context.go(SignupPage.routePath),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: BorderSide(color: Colors.grey[300]!),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Hesap Oluştur',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF212121),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

