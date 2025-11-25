class AppEnv {
  AppEnv._();

  static const supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://your-project.supabase.co',
  );

  static const supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'public-anon-key',
  );

  static const googlePlacesKey = String.fromEnvironment(
    'GOOGLE_PLACES_KEY',
    defaultValue: 'google-places-key',
  );
}


