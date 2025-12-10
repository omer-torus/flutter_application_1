# 🎫 Ticketmaster Discovery API Entegrasyonu

## ✅ Ne Yapıldı?

- `lib/core/services/ticketmaster_service.dart` dosyası ile Ticketmaster Discovery API bağlandı.
- `Event` domain katmanı oluşturuldu (entity, repository, controller, state).
- `EventsPage` gerçek verilerle (konum bazlı) çalışacak şekilde güncellendi.
- Konum servisinden gelen GPS koordinatları kullanılarak yakın etkinlikler çekiliyor.
- `env.example` dosyasına `TICKETMASTER_API_KEY` alanı eklendi.

## 🔑 API Key

1. https://developer.ticketmaster.com adresinden **ücretsiz** hesap aç.
2. “My Apps” → “Create App” diyerek Discovery API için key oluştur.
3. `.env` dosyana şunu ekle:
   ```
   TICKETMASTER_API_KEY=xxxxxxxxxxxxxxxxxxxx
   ```
4. Flutter’ı her zamanki gibi başlat:
   ```
   flutter run --dart-define-from-file=.env
   ```

> ⚠️ API key’i eklemeden uygulama “Ticketmaster API anahtarı bulunamadı” hatası verir.

## 📍 Çalışma Mantığı

```
Kullanıcı Etkinlikler sayfasına girer
        ↓
Konum izni sorulur → Geolocator ile koordinatlar alınır
        ↓
Ticketmaster Discovery API’ye şu parametrelerle istek atılır:
   - latlong: <kullanıcı_lat,kullanıcı_lng>
   - radius: 50 km
   - classificationName: (Konserler, Festivaller, Sergiler…)
        ↓
Sonuçlar EventController üzerinden UI’ya aktarılır
        ↓
Yaklaşan etkinlikler listesi + “Bu hafta” grid’i gerçek verilerle dolar
```

## 🎛 Kategori Haritası

| UI Kategorisi | Ticketmaster classificationName |
|---------------|---------------------------------|
| Hepsi         | (boş)                           |
| Konserler     | `Music`                         |
| Festivaller   | `Festival`                      |
| Sergiler      | `Arts & Theatre`                |

## 📱 UI Davranışı

- Konum alınıyor → turuncu ikon + bilgi.
- Konum hatası → kırmızı ikon, “Tekrar Dene” butonu (İstanbul fallback).
- Loading/Error/Empty state’ler Ticketmaster verisine göre güncellenir.
- Öne çıkan kart + listeler gerçek etkinlik bilgilerini gösterir:
  - İsim, kategori, tarih, mekân, şehir, fiyat aralığı, görsel.

## 🧪 Test

1. `.env` dosyasındaki key’i doldur.
2. `flutter run --dart-define-from-file=.env`
3. Chrome’da konum izni ver (veya Android/iOS cihazda GPS açık olsun).
4. Etkinlikler sekmesine git:
   - Konserler → Music etkinlikleri
   - Festivaller → Festival etkinlikleri
   - Sergiler → Arts & Theatre etkinlikleri

> Türkiye’de veri sınırlıysa radius’u artırabilir veya farklı şehir konumlarıyla test edebilirsin.

## 🔧 İleri Çalışmalar

- Supabase `events` tablosuna cacheleyip offline destek ekleme.
- Etkinlik detay sayfası (Ticketmaster `url` veya yerel sayfa).
- Ücret filtreleri, takvim/sıralama seçenekleri.
- Ticketmaster rate limit (saatte 500 istek) aşılırsa response header’daki `rate-limit` bilgilerine göre otomatik bekleme uygulanabilir.

---

Hazırladı: AI Assistant 🤖  
Tarih: 29 Kasım 2025  
Durum: ✅ Production-ready entegrasyon



