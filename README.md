# 🌍 Turizm Gezi Rehberi - AI Destekli Mobil Uygulama

Kişiselleştirilmiş, yapay zeka destekli turizm rehberi uygulaması.

---

## 🚀 Özellikler

### ✅ Tamamlanan Özellikler
- 🏗️ **Clean Architecture** - Feature-based modüler yapı
- 🎨 **Modern UI** - Material 3 tema
- 🗺️ **Hibrit Mekan Sistemi** - Google Places + Supabase cache
- 🔐 **Güvenli Backend** - Supabase + Row Level Security
- 🌐 **Çok Dilli Destek** - TR, EN, AR, RU
- 🧭 **Akıllı Navigasyon** - GoRouter ile deklaratif routing
- ⚡ **State Management** - Riverpod

### 🚧 Geliştirme Aşamasında
- 🤖 AI Rota Motoru (Python backend)
- 💬 Realtime Rehber Chat
- 📊 Bütçe Takibi ve Grafikler
- 🎫 Etkinlik Entegrasyonu
- 📸 Gezi Günlüğü

---

## 🛠️ Teknoloji Stack

### Frontend
- **Flutter** (Dart)
- **Riverpod** - State management
- **GoRouter** - Navigation
- **Google Maps Flutter** - Harita entegrasyonu
- **Dio** - HTTP client

### Backend
- **Supabase** - Auth, Database, Realtime, Storage
- **PostgreSQL** + PostGIS - Konum tabanlı sorgular
- **Row Level Security** - Veri güvenliği

### AI (Planlanan)
- **Python** - FastAPI/Flask
- **Collaborative Filtering** - Kullanıcı benzerliği
- **Content-Based Filtering** - İçerik analizi

---

## 📁 Proje Yapısı

```
lib/
├── app/
│   ├── app.dart              # Ana uygulama widget'ı
│   ├── bootstrap.dart        # Başlangıç yapılandırması
│   ├── providers.dart        # Global provider'lar
│   └── router.dart           # GoRouter yapılandırması
├── core/
│   ├── config/
│   │   └── app_env.dart      # Environment variables
│   ├── constants/
│   │   └── app_constants.dart
│   ├── localization/
│   │   └── app_locale.dart   # Çok dilli destek
│   ├── services/
│   │   ├── google_places_service.dart
│   │   └── supabase_cache_service.dart
│   └── theme/
│       └── app_theme.dart
└── features/
    ├── places/
    │   ├── domain/           # Entity, Repository interface
    │   ├── data/             # Model, Repository impl
    │   └── application/      # State, Controller
    ├── home/
    ├── onboarding/
    ├── routes/
    ├── guides/
    └── journal/
```

---

## 🔧 Kurulum

### 1. Gereksinimleri Yükle

```bash
# Flutter SDK (3.10.1+)
flutter --version

# Bağımlılıkları yükle
flutter pub get
```

### 2. Supabase Kurulumu

Detaylı talimatlar için: [SUPABASE_SETUP.md](SUPABASE_SETUP.md)

**Özet:**
1. Supabase hesabı oluştur
2. Yeni proje aç
3. SQL Editor'de migration dosyalarını çalıştır:
   - `supabase/migrations/001_initial_schema.sql`
   - `supabase/migrations/002_row_level_security.sql`
   - `supabase/seed.sql` (opsiyonel test verileri)
4. API key'lerini al

### 3. Environment Variables

```bash
# env.example dosyasını .env olarak kopyala
cp env.example .env

# .env dosyasını düzenle
nano .env
```

`.env` içeriği:
```
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
GOOGLE_PLACES_KEY=AIzaSyXXXXXXXXXXXXXXXXXXXXXXXXXXXX
```

### 4. Uygulamayı Çalıştır

```bash
# .env dosyasıyla
flutter run --dart-define-from-file=.env

# Veya manuel
flutter run \
  --dart-define=SUPABASE_URL=https://xxx.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=eyJhbGc... \
  --dart-define=GOOGLE_PLACES_KEY=AIzaSy...
```

---

## 🧪 Test

```bash
# Tüm testleri çalıştır
flutter test

# Kod analizi
flutter analyze

# Coverage raporu
flutter test --coverage
```

---

## 📊 Veritabanı Şeması

### Ana Tablolar
- **users** - Kullanıcı profilleri
- **user_interests** - İlgi alanları
- **places** - Mekan cache (hibrit sistem)
- **visited_places** - Ziyaret geçmişi
- **guides** - Rehber profilleri
- **guide_reviews** - Rehber değerlendirmeleri
- **messages** - Realtime chat
- **expenses** - Bütçe takibi
- **routes** - AI rota önerileri
- **ai_logs** - Model performans izleme
- **events** - Etkinlikler

---

## 🔐 Güvenlik

- ✅ Row Level Security (RLS) tüm tablolarda aktif
- ✅ API key'ler environment variables'da
- ✅ Supabase Auth entegrasyonu
- ✅ HTTPS zorunlu
- ✅ KVKK uyumlu veri işleme

---

## 🌐 Çok Dilli Destek

Desteklenen diller:
- 🇹🇷 Türkçe
- 🇬🇧 İngilizce
- 🇸🇦 Arapça
- 🇷🇺 Rusça

---

## 📱 Platform Desteği

- ✅ Android
- ✅ iOS
- ⚠️ Web (deneysel)
- ⚠️ Windows (deneysel)

---

## 🤝 Katkıda Bulunma

1. Fork yapın
2. Feature branch oluşturun (`git checkout -b feature/amazing-feature`)
3. Commit edin (`git commit -m 'feat: Add amazing feature'`)
4. Push edin (`git push origin feature/amazing-feature`)
5. Pull Request açın

---

## 📝 Lisans

Bu proje MIT lisansı altındadır.

---

## 🆘 Destek

Sorun yaşıyorsanız:
- [SUPABASE_SETUP.md](SUPABASE_SETUP.md) dosyasını okuyun
- GitHub Issues'da sorun bildirin
- Supabase Dashboard → Logs'u kontrol edin

---

## 🗺️ Roadmap

### Q1 2025
- [x] Temel mimari kurulumu
- [x] Supabase entegrasyonu
- [x] Hibrit mekan sistemi
- [ ] Kullanıcı auth ve onboarding
- [ ] Google Places entegrasyonu

### Q2 2025
- [ ] AI rota motoru (Python)
- [ ] Harita görselleştirme
- [ ] Realtime rehber chat
- [ ] Bütçe takibi

### Q3 2025
- [ ] Etkinlik entegrasyonu
- [ ] Gezi günlüğü
- [ ] Sosyal özellikler
- [ ] Beta release

---

## 👥 Ekip

- **Geliştirici:** [İsminiz]
- **Mimari Tasarım:** AI + Human Collaboration
- **Backend:** Supabase
- **AI Model:** Python (planlanan)

---

**⭐ Projeyi beğendiyseniz yıldız vermeyi unutmayın!**
