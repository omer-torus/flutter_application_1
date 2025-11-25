import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/services/google_places_service.dart';
import '../core/services/supabase_cache_service.dart';
import '../features/auth/application/auth_controller.dart';
import '../features/auth/application/auth_state.dart' as app_auth;
import '../features/auth/data/repositories/auth_repository_impl.dart';
import '../features/auth/domain/repositories/auth_repository.dart';

final dioProvider = Provider<Dio>((ref) {
  return Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );
});

final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

final googlePlacesServiceProvider = Provider<GooglePlacesService>((ref) {
  final dio = ref.watch(dioProvider);
  return GooglePlacesService(dio);
});

final supabaseCacheServiceProvider = Provider<SupabaseCacheService>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return SupabaseCacheService(client);
});

// Auth providers
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return AuthRepositoryImpl(supabase);
});

final authControllerProvider = StateNotifierProvider<AuthController, app_auth.AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthController(repository);
});

