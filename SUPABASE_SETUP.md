# 🚀 Supabase Kurulum Rehberi

Bu dosya, Supabase veritabanını kurmak için adım adım talimatlar içerir.

---

## 📋 Adım 1: Supabase Dashboard'a Git

1. https://supabase.com adresine git
2. Projenizi açın
3. Sol menüden **SQL Editor**'ü seç

---

## 📋 Adım 2: Migration Dosyalarını Çalıştır

### 2.1. İlk Schema (Tablolar)

1. SQL Editor'de **New Query** butonuna tıkla
2. `supabase/migrations/001_initial_schema.sql` dosyasının içeriğini kopyala
3. SQL Editor'e yapıştır
4. **Run** butonuna tıkla
5. ✅ "Success. No rows returned" mesajını gör

### 2.2. Row Level Security (Güvenlik)

1. Yeni bir query aç
2. `supabase/migrations/002_row_level_security.sql` dosyasını kopyala
3. SQL Editor'e yapıştır
4. **Run** butonuna tıkla
5. ✅ Başarılı olduğunu doğrula

### 2.3. Test Verileri (Opsiyonel)

1. Yeni bir query aç
2. `supabase/seed.sql` dosyasını kopyala
3. SQL Editor'e yapıştır
4. **Run** butonuna tıkla
5. ✅ 10 mekan ve 3 etkinlik eklendiğini gör

---

## 📋 Adım 3: API Key'leri Al

1. Sol menüden **Settings** → **API**'ye git
2. Şu bilgileri kopyala:
   - **Project URL** (örn: `https://xxxxx.supabase.co`)
   - **anon public** key (uzun bir token)

---

## 📋 Adım 4: .env Dosyası Oluştur

1. Proje kök dizininde `env.example` dosyasını `.env` olarak kopyala:
   ```bash
   cp env.example .env
   ```

2. `.env` dosyasını aç ve gerçek değerleri yapıştır:
   ```
   SUPABASE_URL=https://your-actual-project.supabase.co
   SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
   GOOGLE_PLACES_KEY=AIzaSyXXXXXXXXXXXXXXXXXXXXXXXXXXXX
   ```

---

## 📋 Adım 5: Google Places API Key Al (Opsiyonel)

Google Places API kullanmak için:

1. https://console.cloud.google.com adresine git
2. Yeni proje oluştur veya mevcut projeyi seç
3. **APIs & Services** → **Library**'ye git
4. "Places API" ara ve etkinleştir
5. **Credentials** → **Create Credentials** → **API Key**
6. API Key'i `.env` dosyasına ekle

**NOT:** Google Places API ücretlidir. Başlangıç için mock verilerle test edebilirsin.

---

## 📋 Adım 6: Flutter Uygulamasını Çalıştır

```bash
# .env dosyasıyla çalıştır
flutter run --dart-define-from-file=.env

# Veya manuel olarak:
flutter run \
  --dart-define=SUPABASE_URL=https://xxx.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=eyJhbGc... \
  --dart-define=GOOGLE_PLACES_KEY=AIzaSy...
```

---

## ✅ Doğrulama

Uygulama başarıyla çalışıyorsa:

1. ✅ Splash ekranı görünür
2. ✅ Onboarding sayfası açılır
3. ✅ Home ekranında "Yakındaki Öneriler" bölümü var
4. ✅ Refresh butonuna basınca mekanlar yüklenir (seed data varsa)

---

## 🔧 Sorun Giderme

### Hata: "Invalid API key"
- `.env` dosyasındaki key'leri kontrol et
- Supabase dashboard'dan key'leri yeniden kopyala

### Hata: "Table does not exist"
- SQL migration dosyalarını sırayla çalıştırdığından emin ol
- Supabase SQL Editor'de hata mesajlarını oku

### Hata: "Row Level Security policy violation"
- RLS migration dosyasını çalıştırdığından emin ol
- Supabase Auth ile giriş yapmadan önce `anon` politikalarını kontrol et

---

## 📚 Sonraki Adımlar

1. ✅ Supabase Auth entegrasyonu (email/password veya OAuth)
2. ✅ Gerçek kullanıcı kaydı ve onboarding akışı
3. ✅ Google Places API entegrasyonu
4. ✅ AI rota motoru Python servisi
5. ✅ Realtime chat özelliği

---

## 🆘 Yardım

Sorun yaşıyorsan:
- Supabase Dashboard → Logs → API Logs'u kontrol et
- Flutter console'da hata mesajlarını oku
- `flutter analyze` ve `flutter test` çalıştır


