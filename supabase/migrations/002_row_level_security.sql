-- =====================================================
-- Row Level Security (RLS) Policies
-- =====================================================

-- Enable RLS on all tables
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_interests ENABLE ROW LEVEL SECURITY;
ALTER TABLE places ENABLE ROW LEVEL SECURITY;
ALTER TABLE visited_places ENABLE ROW LEVEL SECURITY;
ALTER TABLE guides ENABLE ROW LEVEL SECURITY;
ALTER TABLE guide_reviews ENABLE ROW LEVEL SECURITY;
ALTER TABLE messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE expenses ENABLE ROW LEVEL SECURITY;
ALTER TABLE routes ENABLE ROW LEVEL SECURITY;
ALTER TABLE ai_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE events ENABLE ROW LEVEL SECURITY;

-- =====================================================
-- USERS TABLE POLICIES
-- =====================================================

-- Users can read their own data
CREATE POLICY "Users can view own profile"
  ON users FOR SELECT
  USING (auth.uid() = id);

-- Users can update their own data
CREATE POLICY "Users can update own profile"
  ON users FOR UPDATE
  USING (auth.uid() = id);

-- Users can insert their own data (signup)
CREATE POLICY "Users can insert own profile"
  ON users FOR INSERT
  WITH CHECK (auth.uid() = id);

-- =====================================================
-- USER INTERESTS POLICIES
-- =====================================================

CREATE POLICY "Users can view own interests"
  ON user_interests FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own interests"
  ON user_interests FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own interests"
  ON user_interests FOR UPDATE
  USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own interests"
  ON user_interests FOR DELETE
  USING (auth.uid() = user_id);

-- =====================================================
-- PLACES TABLE POLICIES (Public Read, Service Write)
-- =====================================================

-- Everyone can read places (public data)
CREATE POLICY "Places are publicly readable"
  ON places FOR SELECT
  TO authenticated, anon
  USING (true);

-- Only authenticated users can insert places (via service)
CREATE POLICY "Authenticated users can insert places"
  ON places FOR INSERT
  TO authenticated
  WITH CHECK (true);

-- Only authenticated users can update places
CREATE POLICY "Authenticated users can update places"
  ON places FOR UPDATE
  TO authenticated
  USING (true);

-- =====================================================
-- VISITED PLACES POLICIES
-- =====================================================

CREATE POLICY "Users can view own visited places"
  ON visited_places FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own visited places"
  ON visited_places FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own visited places"
  ON visited_places FOR UPDATE
  USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own visited places"
  ON visited_places FOR DELETE
  USING (auth.uid() = user_id);

-- =====================================================
-- GUIDES TABLE POLICIES
-- =====================================================

-- Everyone can read guides (public profiles)
CREATE POLICY "Guides are publicly readable"
  ON guides FOR SELECT
  TO authenticated, anon
  USING (true);

CREATE POLICY "Users can create own guide profile"
  ON guides FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own guide profile"
  ON guides FOR UPDATE
  USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own guide profile"
  ON guides FOR DELETE
  USING (auth.uid() = user_id);

-- =====================================================
-- GUIDE REVIEWS POLICIES
-- =====================================================

-- Everyone can read reviews
CREATE POLICY "Reviews are publicly readable"
  ON guide_reviews FOR SELECT
  TO authenticated, anon
  USING (true);

CREATE POLICY "Users can create reviews"
  ON guide_reviews FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own reviews"
  ON guide_reviews FOR UPDATE
  USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own reviews"
  ON guide_reviews FOR DELETE
  USING (auth.uid() = user_id);

-- =====================================================
-- MESSAGES POLICIES (Realtime Chat)
-- =====================================================

-- Users can read messages they sent or received
CREATE POLICY "Users can view own messages"
  ON messages FOR SELECT
  USING (auth.uid() = sender_id OR auth.uid() = receiver_id);

-- Users can send messages
CREATE POLICY "Users can send messages"
  ON messages FOR INSERT
  WITH CHECK (auth.uid() = sender_id);

-- Users can update messages they sent (mark as edited)
CREATE POLICY "Users can update own messages"
  ON messages FOR UPDATE
  USING (auth.uid() = sender_id);

-- Users can delete messages they sent
CREATE POLICY "Users can delete own messages"
  ON messages FOR DELETE
  USING (auth.uid() = sender_id);

-- =====================================================
-- EXPENSES POLICIES
-- =====================================================

CREATE POLICY "Users can view own expenses"
  ON expenses FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own expenses"
  ON expenses FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own expenses"
  ON expenses FOR UPDATE
  USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own expenses"
  ON expenses FOR DELETE
  USING (auth.uid() = user_id);

-- =====================================================
-- ROUTES POLICIES
-- =====================================================

CREATE POLICY "Users can view own routes"
  ON routes FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own routes"
  ON routes FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own routes"
  ON routes FOR UPDATE
  USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own routes"
  ON routes FOR DELETE
  USING (auth.uid() = user_id);

-- =====================================================
-- AI LOGS POLICIES
-- =====================================================

CREATE POLICY "Users can view own AI logs"
  ON ai_logs FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Service can insert AI logs"
  ON ai_logs FOR INSERT
  WITH CHECK (true);

-- =====================================================
-- EVENTS POLICIES (Public Read)
-- =====================================================

-- Everyone can read events
CREATE POLICY "Events are publicly readable"
  ON events FOR SELECT
  TO authenticated, anon
  USING (true);

-- Only authenticated users can create events
CREATE POLICY "Authenticated users can create events"
  ON events FOR INSERT
  TO authenticated
  WITH CHECK (true);

-- Only authenticated users can update events
CREATE POLICY "Authenticated users can update events"
  ON events FOR UPDATE
  TO authenticated
  USING (true);

-- Only authenticated users can delete events
CREATE POLICY "Authenticated users can delete events"
  ON events FOR DELETE
  TO authenticated
  USING (true);


