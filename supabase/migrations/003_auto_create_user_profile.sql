-- =====================================================
-- Automatic User Profile Creation Trigger
-- =====================================================
-- Bu trigger, auth.users tablosuna yeni kullanıcı eklendiğinde
-- otomatik olarak public.users tablosuna da profil oluşturur

-- Trigger fonksiyonu
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER SET search_path = public
AS $$
BEGIN
  INSERT INTO public.users (id, email, full_name, created_at, updated_at)
  VALUES (
    new.id,
    new.email,
    COALESCE(new.raw_user_meta_data->>'full_name', new.raw_user_meta_data->>'name'),
    now(),
    now()
  )
  ON CONFLICT (id) DO NOTHING;
  RETURN new;
END;
$$;

-- Trigger tanımı
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_new_user();

-- =====================================================
-- User Profile Update Trigger (Optional)
-- =====================================================
-- Auth user güncellendiğinde public.users'ı da güncelle

CREATE OR REPLACE FUNCTION public.handle_user_update()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER SET search_path = public
AS $$
BEGIN
  UPDATE public.users
  SET
    email = new.email,
    full_name = COALESCE(new.raw_user_meta_data->>'full_name', new.raw_user_meta_data->>'name'),
    updated_at = now()
  WHERE id = new.id;
  RETURN new;
END;
$$;

DROP TRIGGER IF EXISTS on_auth_user_updated ON auth.users;
CREATE TRIGGER on_auth_user_updated
  AFTER UPDATE ON auth.users
  FOR EACH ROW
  WHEN (
    old.email IS DISTINCT FROM new.email OR
    old.raw_user_meta_data IS DISTINCT FROM new.raw_user_meta_data
  )
  EXECUTE FUNCTION public.handle_user_update();



