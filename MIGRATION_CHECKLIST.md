# ✅ Migration Kontrol Listesi

Bu dosyayı kullanarak Supabase migration'larınızı doğru sırayla çalıştırın.

---

## 🎯 Migration Sırası (MUTLAKA BU SIRAYLA!)

### ☐ 1. PostGIS Extension (Opsiyonel)

**Dosya:** `supabase/migrations/000_enable_postgis.sql`

**Ne yapar?**
- PostGIS extension'ı etkinleştirir
- Coğrafi veriler için gerekli (konum sorguları, mesafe hesaplamaları)

**Gerekli mi?**
- Hayır, ancak gelecekte kullanılacak
- Şimdi çalıştırmanız önerilir

```bash
# Supabase SQL Editor'de çalıştırın
```

---

### ☐ 2. Initial Schema (ZORUNLU)

**Dosya:** `supabase/migrations/001_initial_schema.sql`

**Ne yapar?**
- 11 ana tabloyu oluşturur:
  1. `users` - Kullanıcı profilleri
  2. `user_interests` - İlgi alanları
  3. `places` - Mekanlar (hibrit cache)
  4. `visited_places` - Ziyaret geçmişi
  5. `guides` - Rehber profilleri
  6. `guide_reviews` - Rehber yorumları
  7. `messages` - Chat mesajları
  8. `expenses` - Harcama takibi
  9. `routes` - Rota önerileri
  10. `ai_logs` - AI model logları
  11. `events` - Etkinlikler

- Trigger'lar:
  - `updated_at` otomatik güncelleme
  - Rehber rating'i otomatik hesaplama

**Dikkat:**
- `users` tablosu `auth.users`'a foreign key ile bağlı
- `ON DELETE CASCADE` ile güvenli silme

```bash
# Supabase SQL Editor'de çalıştırın
# Başarı mesajı: "Success. No rows returned"
```

---

### ☐ 3. Row Level Security (ZORUNLU)

**Dosya:** `supabase/migrations/002_row_level_security.sql`

**Ne yapar?**
- Tüm tablolarda RLS'i etkinleştirir
- Güvenlik politikaları:
  - Kullanıcılar sadece kendi verilerini görebilir
  - Public veriler herkes tarafından okunabilir
  - Sadece authenticated kullanıcılar yazabilir

**Politikalar:**

| Tablo | SELECT | INSERT | UPDATE | DELETE |
|-------|--------|--------|--------|--------|
| users | Own | Own | Own | - |
| user_interests | Own | Own | Own | Own |
| places | Public | Auth | Auth | - |
| visited_places | Own | Own | Own | Own |
| guides | Public | Own | Own | Own |
| guide_reviews | Public | Own | Own | Own |
| messages | Sent/Received | Sender | Sender | Sender |
| expenses | Own | Own | Own | Own |
| routes | Own | Own | Own | Own |
| ai_logs | Own | Service | - | - |
| events | Public | Auth | Auth | Auth |

```bash
# Supabase SQL Editor'de çalıştırın
```

---

### ☐ 4. Auto User Profile Trigger (ZORUNLU) 🆕

**Dosya:** `supabase/migrations/003_auto_create_user_profile.sql`

**Ne yapar?**
- Yeni kullanıcı kayıt olduğunda otomatik olarak `public.users` tablosuna profil oluşturur
- Manuel insert'e gerek kalmaz!

**Trigger'lar:**
1. `on_auth_user_created` - Yeni kullanıcı oluşturulduğunda
2. `on_auth_user_updated` - Kullanıcı bilgileri güncellendiğinde

**Avantajlar:**
- ✅ RLS ihlali riski yok
- ✅ Email confirmation beklemeden profil hazır
- ✅ Otomatik ve güvenilir
- ✅ Bakım kolaylığı

```bash
# Supabase SQL Editor'de çalıştırın
# Bu migration MUTLAKA çalıştırılmalı!
```

**Önemli:**
- Bu trigger olmazsa, kullanıcı kaydı başarısız olur!
- RLS politikası yüzünden manuel insert yapılamaz

---

### ☐ 5. Test Verileri (Opsiyonel)

**Dosya:** `supabase/seed.sql`

**Ne yapar?**
- 10 örnek mekan ekler (İstanbul)
- 3 örnek etkinlik ekler

**Gerekli mi?**
- Hayır, sadece test için
- Production'da çalıştırmayın!

```bash
# Sadece geliştirme ortamında çalıştırın
```

---

## 📋 Çalıştırma Adımları

### Supabase Dashboard

1. https://supabase.com → Projenizi açın
2. Sol menüden **SQL Editor**'e tıklayın
3. Her migration için:
   - **New Query** butonuna tıklayın
   - Migration dosyasının içeriğini kopyalayın
   - SQL Editor'e yapıştırın
   - **Run** butonuna tıklayın
   - ✅ Başarılı mesajını bekleyin

### Doğrulama

```sql
-- 1. Tablolar oluşturuldu mu?
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public'
ORDER BY table_name;

-- 11 tablo görmelisiniz:
-- ai_logs, events, expenses, guide_reviews, guides, 
-- messages, places, routes, user_interests, users, visited_places
```

```sql
-- 2. RLS aktif mi?
SELECT schemaname, tablename, rowsecurity
FROM pg_tables
WHERE schemaname = 'public';

-- Tüm tablolarda rowsecurity = true olmalı
```

```sql
-- 3. Trigger'lar oluşturuldu mu?
SELECT 
  trigger_name, 
  event_manipulation, 
  event_object_table
FROM information_schema.triggers
WHERE trigger_schema = 'public'
ORDER BY event_object_table;

-- on_auth_user_created ve on_auth_user_updated trigger'larını görmelisiniz
```

```sql
-- 4. Trigger fonksiyonları var mı?
SELECT 
  routine_name,
  routine_type
FROM information_schema.routines
WHERE routine_schema = 'public'
  AND routine_type = 'FUNCTION';

-- handle_new_user ve handle_user_update fonksiyonlarını görmelisiniz
```

---

## ⚙️ Ek Ayarlar

### Email Confirmation (Test İçin)

**Geliştirme ortamında email confirmation'ı kapatabilirsiniz:**

1. Supabase Dashboard → **Authentication** → **Settings**
2. **Email Confirmations** bölümünü bulun
3. **Disable email confirmations** → ✅
4. Değişiklikleri kaydedin

**⚠️ DİKKAT:** Production'da MUTLAKA AÇIK tutun!

---

### Email Templates (Opsiyonel)

Email şablonlarını Türkçeleştirebilirsiniz:

1. Supabase Dashboard → **Authentication** → **Email Templates**
2. Her template için Türkçe versiyonunu yazın

---

## 🧪 Test Senaryosu

### Yeni Kullanıcı Kaydı

1. Flutter uygulamasında signup sayfasına gidin
2. Formu doldurun:
   - Ad Soyad: "Test Kullanıcı"
   - Email: "test@example.com"
   - Şifre: "123456"
3. "Hesap Oluştur" butonuna tıklayın
4. ✅ İlgi alanları sayfasına yönlendirilmelisiniz

### Doğrulama (Supabase Dashboard)

```sql
-- auth.users tablosunu kontrol et
SELECT id, email, created_at
FROM auth.users
WHERE email = 'test@example.com';

-- public.users tablosunu kontrol et
SELECT id, email, full_name, created_at
FROM public.users
WHERE email = 'test@example.com';

-- İki tablodaki ID'ler aynı olmalı!
```

### İlgi Alanları Kaydı

1. İlgi alanları sayfasında kategorileri seçin
2. "Devam Et" butonuna tıklayın
3. ✅ Ana sayfaya yönlendirilmelisiniz

```sql
-- user_interests tablosunu kontrol et
SELECT user_id, category, weight
FROM user_interests
WHERE user_id = (
  SELECT id FROM users WHERE email = 'test@example.com'
);

-- Seçtiğiniz kategorileri görmelisiniz
```

---

## ✅ Tamamlandı Kontrol Listesi

Migration'ları çalıştırdığınızda işaretleyin:

- [ ] 000_enable_postgis.sql ✓
- [ ] 001_initial_schema.sql ✓✓ (ZORUNLU)
- [ ] 002_row_level_security.sql ✓✓ (ZORUNLU)
- [ ] 003_auto_create_user_profile.sql ✓✓✓ (ÇOK ÖNEMLİ!)
- [ ] seed.sql (Opsiyonel)

**Ek Ayarlar:**
- [ ] Email confirmation devre dışı bırakıldı (test için)
- [ ] API key'ler .env dosyasına eklendi
- [ ] Flutter uygulaması test edildi

---

## 🆘 Hata Durumunda

### "new row violates row-level security policy"

**Neden?** Trigger çalıştırılmamış.

**Çözüm:**
```sql
-- 003_auto_create_user_profile.sql dosyasını çalıştırın
```

---

### "relation does not exist"

**Neden?** Tablolar oluşturulmamış.

**Çözüm:**
```sql
-- 001_initial_schema.sql dosyasını çalıştırın
```

---

### "duplicate key value"

**Neden?** Migration zaten çalıştırılmış veya kullanıcı zaten var.

**Çözüm:**
- Yeni kullanıcı email'i deneyin
- Veya mevcut kullanıcıyı silin

---

## 📞 Yardım

Sorun yaşıyorsanız:

1. **Supabase Logs** → API Logs'u kontrol edin
2. **Flutter Console** → Hata mesajlarını okuyun
3. **SQL Editor** → Query'leri manuel çalıştırın
4. **Table Editor** → Verileri görsel kontrol edin

---

**Hazırladı:** AI Assistant 🤖  
**Tarih:** 29 Kasım 2025  
**Durum:** ✅ Hazır



