-- =====================================================
-- Seed Data - Test Verileri
-- =====================================================

-- Test kullanıcıları (gerçek auth olmadan test için)
-- NOT: Gerçek uygulamada bu veriler Supabase Auth ile otomatik oluşturulacak

-- =====================================================
-- 1. Örnek Mekanlar (İstanbul)
-- =====================================================

INSERT INTO places (google_place_id, name, category, description, lat, lng, rating, price_level, images, source, popularity_score) VALUES
  ('ChIJdVOxCZq5yhQRH9aZVZZZZZZ', 'Ayasofya Camii', 'museum', 'Bizans ve Osmanlı mimarisinin muhteşem örneği', 41.0086, 28.9802, 4.8, 1, ARRAY['https://example.com/ayasofya.jpg'], 'manual', 9.5),
  ('ChIJYeW0dJu5yhQRYYYYYYYYYY', 'Topkapı Sarayı', 'museum', 'Osmanlı İmparatorluğu''nun tarihi sarayı', 41.0115, 28.9833, 4.7, 2, ARRAY['https://example.com/topkapi.jpg'], 'manual', 9.2),
  ('ChIJ3dWvdZu5yhQRXXXXXXXXXX', 'Kapalıçarşı', 'shopping', 'Dünyanın en eski ve büyük kapalı çarşılarından biri', 41.0108, 28.9680, 4.5, 2, ARRAY['https://example.com/kapalicarsi.jpg'], 'manual', 8.8),
  ('ChIJ4eW0dJu5yhQRZZZZZZZZZZ', 'Galata Kulesi', 'landmark', 'İstanbul''un simge yapılarından biri', 41.0256, 28.9744, 4.6, 2, ARRAY['https://example.com/galata.jpg'], 'manual', 9.0),
  ('ChIJ5eW0dJu5yhQRAAAAAAAAA', 'Sultanahmet Meydanı', 'landmark', 'Tarihi yarımadanın kalbi', 41.0054, 28.9768, 4.7, 0, ARRAY['https://example.com/sultanahmet.jpg'], 'manual', 8.9),
  ('ChIJ6eW0dJu5yhQRBBBBBBBBB', 'Mısır Çarşısı', 'shopping', 'Baharat ve şekerleme çarşısı', 41.0166, 28.9704, 4.4, 2, ARRAY['https://example.com/misir.jpg'], 'manual', 8.5),
  ('ChIJ7eW0dJu5yhQRCCCCCCCCC', 'Dolmabahçe Sarayı', 'museum', 'Boğaz kıyısındaki görkemli saray', 41.0391, 29.0003, 4.7, 2, ARRAY['https://example.com/dolmabahce.jpg'], 'manual', 8.7),
  ('ChIJ8eW0dJu5yhQRDDDDDDDDD', 'Beylerbeyi Sarayı', 'museum', 'Anadolu yakasının tarihi sarayı', 41.0417, 29.0394, 4.5, 2, ARRAY['https://example.com/beylerbeyi.jpg'], 'manual', 7.8),
  ('ChIJ9eW0dJu5yhQREEEEEEEEE', 'Çamlıca Kulesi', 'landmark', 'İstanbul''un en yüksek yapısı', 41.0224, 29.0658, 4.3, 1, ARRAY['https://example.com/camlica.jpg'], 'manual', 7.5),
  ('ChIJ0eW0dJu5yhQRFFFFFFFFF', 'Miniatürk', 'museum', 'Türkiye''nin minyatür eserleri', 41.0606, 28.9472, 4.4, 1, ARRAY['https://example.com/miniaturk.jpg'], 'manual', 7.9);

-- =====================================================
-- 2. Örnek Etkinlikler
-- =====================================================

INSERT INTO events (name, description, category, lat, lng, start_date, end_date, venue, organizer, source) VALUES
  ('İstanbul Müzik Festivali', 'Klasik müzik konserleri', 'music', 41.0082, 28.9784, NOW() + INTERVAL '7 days', NOW() + INTERVAL '14 days', 'Cemal Reşit Rey Konser Salonu', 'İKSV', 'manual'),
  ('Boğaziçi Film Festivali', 'Uluslararası film gösterimleri', 'film', 41.0082, 28.9784, NOW() + INTERVAL '30 days', NOW() + INTERVAL '37 days', 'Çeşitli Sinema Salonları', 'İKSV', 'manual'),
  ('Sultanahmet Meydanı Konseri', 'Açık hava konseri', 'music', 41.0054, 28.9768, NOW() + INTERVAL '3 days', NOW() + INTERVAL '3 days', 'Sultanahmet Meydanı', 'İBB', 'manual');

-- =====================================================
-- 3. İlgi Alanı Kategorileri (Referans)
-- =====================================================

-- Bu kategoriler user_interests tablosunda kullanılacak
-- Kategoriler: museum, shopping, food, nature, history, art, nightlife, sports, beach, adventure

-- =====================================================
-- 4. Örnek Harcama Kategorileri (Referans)
-- =====================================================

-- Kategoriler: food, transport, accommodation, entertainment, shopping, other

-- =====================================================
-- NOT: Gerçek kullanıcı verileri
-- =====================================================
-- Gerçek kullanıcılar Supabase Auth ile kayıt olduğunda:
-- 1. users tablosuna otomatik eklenir (auth.uid() ile)
-- 2. Onboarding sırasında user_interests eklenir
-- 3. Uygulama kullanımıyla visited_places, expenses, routes oluşur

-- =====================================================
-- Faydalı Sorgular (Test için)
-- =====================================================

-- Yakındaki mekanları bul (5km yarıçap)
-- SELECT * FROM places 
-- WHERE ST_DWithin(
--   ST_MakePoint(lng, lat)::geography,
--   ST_MakePoint(28.9784, 41.0082)::geography,
--   5000
-- );

-- Popüler mekanlar
-- SELECT * FROM places ORDER BY popularity_score DESC LIMIT 10;

-- Kategori bazlı mekanlar
-- SELECT * FROM places WHERE category = 'museum' ORDER BY rating DESC;


