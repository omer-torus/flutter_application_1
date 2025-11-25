import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../home/presentation/home_page.dart';
import '../../map/presentation/map_page.dart';
import '../../events/presentation/events_page.dart';
import '../../guides/presentation/guides_page.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  static const routeName = 'profile';
  static const routePath = '/profile';

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  int _selectedIndex = 4; // Profil sekmesi aktif

  final List<Map<String, dynamic>> _recentVisits = [
    {
      'name': 'Topkapı Sarayı',
      'date': '15 Kas 2024',
      'imageUrl': 'https://images.unsplash.com/photo-1555993539-5d4e8e0e8b8b?w=400',
    },
    {
      'name': 'Modern Sanat Müzesi',
      'date': '12 Kas 2024',
      'imageUrl': 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=400',
    },
    {
      'name': 'Boğaz Cafe',
      'date': '10 Kas 2024',
      'imageUrl': 'https://images.unsplash.com/photo-1554118811-1e0d58224f24?w=400',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Profil',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF212121),
                        ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings),
                    onPressed: () {},
                    color: const Color(0xFF212121),
                  ),
                ],
              ),
            ),
            
            // İçerik
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Kullanıcı Profil Kartı
                    _UserProfileCard(),
                    const SizedBox(height: 24),
                    
                    // İstatistikler
                    _StatisticsGrid(),
                    const SizedBox(height: 24),
                    
                    // Başarılar
                    _AchievementsSection(),
                    const SizedBox(height: 24),
                    
                    // Keşif Ruhu
                    _DiscoveryProgressCard(),
                    const SizedBox(height: 24),
                    
                    // Son Ziyaretler
                    _RecentVisitsSection(),
                    const SizedBox(height: 24),
                    
                    // Hızlı Erişim
                    _QuickAccessSection(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _UserProfileCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF4DB6AC), Color(0xFF26A69A)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Profil Fotoğrafı
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.2),
                  border: Border.all(color: Colors.white, width: 3),
                ),
                child: const Icon(
                  Icons.person,
                  size: 40,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 16),
              
              // Kullanıcı Bilgileri
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Zeynep Yıldız',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'zeynep@example.com',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withOpacity(0.9),
                          ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.public, color: Colors.white, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          'İstanbul, Türkiye',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.white.withOpacity(0.9),
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Badge'ler
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Deneyimli Gezgin',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Premium',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _StatisticsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: [
        _StatCard(
          icon: Icons.location_on,
          value: '24',
          label: 'Ziyaret Edilen',
        ),
        _StatCard(
          icon: Icons.calendar_today,
          value: '8',
          label: 'Tur Sayısı',
        ),
        _StatCard(
          icon: Icons.trending_up,
          value: '₺3,450',
          label: 'Toplam Harcama',
        ),
        _StatCard(
          icon: Icons.workspace_premium,
          value: '12',
          label: 'Rozetler',
        ),
      ],
    );
  }

  Widget _StatCard({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: const Color(0xFF4DB6AC), size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF212121),
                ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _AchievementsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Başarılar',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF212121),
                  ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text('Hepsini Gör >'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _AchievementCard(
          title: 'İlk Adım',
          description: 'İlk gezinizi tamamladınız',
          progress: 1.0,
          isCompleted: true,
        ),
        const SizedBox(height: 12),
        _AchievementCard(
          title: 'Kültür Aşığı',
          description: '5 müze ziyaret edin (3/5)',
          progress: 3 / 5,
          isCompleted: false,
        ),
      ],
    );
  }

  Widget _AchievementCard({
    required String title,
    required String description,
    required double progress,
    required bool isCompleted,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF212121),
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isCompleted ? Colors.green : const Color(0xFF4DB6AC),
                    ),
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          ),
          if (isCompleted)
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.amber[100],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.workspace_premium,
                color: Colors.amber[700],
                size: 24,
              ),
            ),
        ],
      ),
    );
  }

  Widget _DiscoveryProgressCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Keşif Ruhu',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF212121),
                ),
          ),
          const SizedBox(height: 8),
          Text(
            '10 farklı kategori keşfedin (7/10)',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: 7 / 10,
              backgroundColor: Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF4DB6AC)),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _RecentVisitsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Son Ziyaretler',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF212121),
                  ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text('Hepsini Gör >'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ..._recentVisits.map((visit) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _RecentVisitCard(
              name: visit['name'] as String,
              date: visit['date'] as String,
              imageUrl: visit['imageUrl'] as String,
            ),
          );
        }),
      ],
    );
  }

  Widget _RecentVisitCard({
    required String name,
    required String date,
    required String imageUrl,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          // Thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 60,
              height: 60,
              color: Colors.grey[300],
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.image, size: 24, color: Colors.grey),
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 12),
          // İçerik
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF212121),
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _QuickAccessSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hızlı Erişim',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: const Color(0xFF212121),
              ),
        ),
        const SizedBox(height: 16),
        _QuickAccessItem(
          icon: Icons.favorite_border,
          title: 'Favorilerim',
          subtitle: 'Kaydettiğiniz mekanlar',
          onTap: () {},
        ),
        const SizedBox(height: 12),
        _QuickAccessItem(
          icon: Icons.bookmark_border,
          title: 'Kaydedilen Rotalar',
          subtitle: 'Planladığınız turlar',
          onTap: () {},
        ),
        const SizedBox(height: 12),
        _QuickAccessItem(
          icon: Icons.language,
          title: 'Dil Ayarları',
          subtitle: 'Türkçe, English, Deutsch',
          onTap: () {},
        ),
      ],
    );
  }

  Widget _QuickAccessItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: const Color(0xFF4DB6AC), size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF212121),
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });
        
        switch (index) {
          case 0:
            context.go(HomePage.routePath);
            break;
          case 1:
            context.go(MapPage.routePath);
            break;
          case 2:
            context.go(EventsPage.routePath);
            break;
          case 3:
            context.go(GuidesPage.routePath);
            break;
          case 4:
            // Profil - zaten buradayız
            break;
        }
      },
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFF4DB6AC),
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.explore),
          label: 'Keşfet',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          label: 'Harita',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          label: 'Etkinlikler',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people),
          label: 'Rehberler',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profil',
        ),
      ],
    );
  }
}

