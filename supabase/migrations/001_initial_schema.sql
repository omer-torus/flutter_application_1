-- =====================================================
-- Turizm Gezi Rehberi - Initial Database Schema
-- =====================================================

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =====================================================
-- 1. USERS TABLE
-- =====================================================
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  email TEXT UNIQUE NOT NULL,
  full_name TEXT,
  avatar_url TEXT,
  phone TEXT,
  preferred_language TEXT DEFAULT 'tr',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =====================================================
-- 2. USER INTERESTS TABLE
-- =====================================================
CREATE TABLE user_interests (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  category TEXT NOT NULL,
  weight DOUBLE PRECISION DEFAULT 1.0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(user_id, category)
);

CREATE INDEX idx_user_interests_user_id ON user_interests(user_id);

-- =====================================================
-- 3. PLACES TABLE (Hibrit Cache)
-- =====================================================
CREATE TABLE places (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  google_place_id TEXT UNIQUE,
  name TEXT NOT NULL,
  category TEXT NOT NULL,
  description TEXT,
  lat DOUBLE PRECISION NOT NULL,
  lng DOUBLE PRECISION NOT NULL,
  rating DOUBLE PRECISION,
  price_level INTEGER,
  opening_hours JSONB,
  images TEXT[],
  source TEXT DEFAULT 'google', -- 'google', 'manual', 'cached'
  cache_expiry TIMESTAMP WITH TIME ZONE,
  popularity_score DOUBLE PRECISION DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Spatial index for location queries (basit versiyon)
CREATE INDEX idx_places_lat ON places(lat);
CREATE INDEX idx_places_lng ON places(lng);

CREATE INDEX idx_places_category ON places(category);
CREATE INDEX idx_places_google_place_id ON places(google_place_id);

-- =====================================================
-- 4. VISITED PLACES TABLE
-- =====================================================
CREATE TABLE visited_places (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  place_id UUID REFERENCES places(id) ON DELETE CASCADE,
  visited_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  rating INTEGER CHECK (rating >= 1 AND rating <= 5),
  notes TEXT,
  photos TEXT[],
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(user_id, place_id)
);

CREATE INDEX idx_visited_places_user_id ON visited_places(user_id);
CREATE INDEX idx_visited_places_place_id ON visited_places(place_id);

-- =====================================================
-- 5. GUIDES TABLE
-- =====================================================
CREATE TABLE guides (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  bio TEXT,
  languages TEXT[],
  specialties TEXT[],
  hourly_rate DOUBLE PRECISION,
  is_volunteer BOOLEAN DEFAULT false,
  rating DOUBLE PRECISION DEFAULT 0,
  total_reviews INTEGER DEFAULT 0,
  is_verified BOOLEAN DEFAULT false,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_guides_user_id ON guides(user_id);
CREATE INDEX idx_guides_rating ON guides(rating DESC);

-- =====================================================
-- 6. GUIDE REVIEWS TABLE
-- =====================================================
CREATE TABLE guide_reviews (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  guide_id UUID REFERENCES guides(id) ON DELETE CASCADE,
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
  comment TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(guide_id, user_id)
);

CREATE INDEX idx_guide_reviews_guide_id ON guide_reviews(guide_id);

-- =====================================================
-- 7. MESSAGES TABLE (Realtime Chat)
-- =====================================================
CREATE TABLE messages (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  sender_id UUID REFERENCES users(id) ON DELETE CASCADE,
  receiver_id UUID REFERENCES users(id) ON DELETE CASCADE,
  guide_id UUID REFERENCES guides(id) ON DELETE SET NULL,
  content TEXT NOT NULL,
  is_read BOOLEAN DEFAULT false,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_messages_sender_id ON messages(sender_id);
CREATE INDEX idx_messages_receiver_id ON messages(receiver_id);
CREATE INDEX idx_messages_created_at ON messages(created_at DESC);

-- =====================================================
-- 8. EXPENSES TABLE (Bütçe Takibi)
-- =====================================================
CREATE TABLE expenses (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  place_id UUID REFERENCES places(id) ON DELETE SET NULL,
  category TEXT NOT NULL, -- 'food', 'transport', 'accommodation', 'entertainment', 'shopping', 'other'
  amount DOUBLE PRECISION NOT NULL,
  currency TEXT DEFAULT 'TRY',
  description TEXT,
  expense_date TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_expenses_user_id ON expenses(user_id);
CREATE INDEX idx_expenses_expense_date ON expenses(expense_date DESC);

-- =====================================================
-- 9. ROUTES TABLE (AI Önerileri)
-- =====================================================
CREATE TABLE routes (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  description TEXT,
  place_ids UUID[],
  estimated_duration_hours DOUBLE PRECISION,
  total_distance_km DOUBLE PRECISION,
  is_ai_generated BOOLEAN DEFAULT false,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_routes_user_id ON routes(user_id);

-- =====================================================
-- 10. AI LOGS TABLE (Model İzleme)
-- =====================================================
CREATE TABLE ai_logs (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  request_type TEXT NOT NULL, -- 'route_recommendation', 'similar_users', 'content_based'
  request_payload JSONB,
  response_payload JSONB,
  execution_time_ms INTEGER,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_ai_logs_user_id ON ai_logs(user_id);
CREATE INDEX idx_ai_logs_created_at ON ai_logs(created_at DESC);

-- =====================================================
-- 11. EVENTS TABLE (Etkinlikler)
-- =====================================================
CREATE TABLE events (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL,
  description TEXT,
  category TEXT,
  lat DOUBLE PRECISION NOT NULL,
  lng DOUBLE PRECISION NOT NULL,
  start_date TIMESTAMP WITH TIME ZONE NOT NULL,
  end_date TIMESTAMP WITH TIME ZONE,
  venue TEXT,
  organizer TEXT,
  ticket_url TEXT,
  images TEXT[],
  source TEXT DEFAULT 'manual', -- 'eventbrite', 'manual', 'api'
  external_id TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_events_start_date ON events(start_date);
CREATE INDEX idx_events_lat ON events(lat);
CREATE INDEX idx_events_lng ON events(lng);

-- =====================================================
-- TRIGGERS: Updated_at otomatik güncelleme
-- =====================================================
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_places_updated_at BEFORE UPDATE ON places
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_guides_updated_at BEFORE UPDATE ON guides
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_routes_updated_at BEFORE UPDATE ON routes
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_events_updated_at BEFORE UPDATE ON events
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- =====================================================
-- FUNCTION: Guide rating'i otomatik güncelle
-- =====================================================
CREATE OR REPLACE FUNCTION update_guide_rating()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE guides
  SET 
    rating = (SELECT AVG(rating)::DOUBLE PRECISION FROM guide_reviews WHERE guide_id = NEW.guide_id),
    total_reviews = (SELECT COUNT(*) FROM guide_reviews WHERE guide_id = NEW.guide_id)
  WHERE id = NEW.guide_id;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_guide_rating_trigger
AFTER INSERT OR UPDATE ON guide_reviews
FOR EACH ROW EXECUTE FUNCTION update_guide_rating();

