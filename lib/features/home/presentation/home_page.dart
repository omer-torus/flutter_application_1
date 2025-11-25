import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../routes/presentation/route_planner_page.dart';
import '../../guides/presentation/guides_page.dart';
import '../../map/presentation/map_page.dart';
import '../../profile/presentation/profile_page.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  static const routeName = 'home';
  static const routePath = '/home';

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _selectedIndex = 0;
  String _selectedCategory = 'Hepsi';

  final List<String> _categories = [
    'Hepsi',
    'Müzeler',
    'Tarihi Yerler',
    'Kafeler',
    'Alışveriş',
    'Yemek',
    'Doğa',
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Başlık
                  Text(
                    'Keşfet',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF212121),
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Konumunuza göre akıllı öneriler',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Arama Çubuğu
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Mekan, etkinlik ara...',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Kategori Filtreleri
                  SizedBox(
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _categories.length,
                      itemBuilder: (context, index) {
                        final category = _categories[index];
                        final isSelected = _selectedCategory == category;
                        
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(category),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                _selectedCategory = category;
                              });
                            },
                            selectedColor: const Color(0xFF4DB6AC),
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.white : const Color(0xFF212121),
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                          ),
                        );
                      },
                    ),
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
                    // Akıllı Rotanız
                    _SmartRouteCard(),
                    const SizedBox(height: 24),
                    
                    // AI Önerisi
                    _AIRecommendationCard(),
                    const SizedBox(height: 24),
                    
                    // Popüler Mekanlar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Popüler Mekanlar',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF212121),
                              ),
                        ),
                        Icon(
                          Icons.trending_up,
                          color: Colors.orange[400],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // Mekan Listesi
                    _buildPlaceList(),
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

  Widget _SmartRouteCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Akıllı Rotanız',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '1 durak • ~27 dakika',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                ],
              ),
              FilledButton.icon(
                onPressed: () => context.go(RoutePlannerPage.routePath),
                icon: const Icon(Icons.send, size: 18),
                label: const Text('Başlat'),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF4DB6AC),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _PlaceCard(
            imageUrl: 'https://images.unsplash.com/photo-1555993539-5d4e8e0e8b8b?w=400',
            category: 'Tarihi Yerler',
            title: 'Topkapı Sarayı',
            description: 'Osmanlı İmparatorluğu\'nun muhteşem sarayı',
            rating: 4.8,
            distance: 2.3,
            price: 200,
            showTimeTag: true,
          ),
        ],
      ),
    );
  }

  Widget _AIRecommendationCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF4DB6AC), Color(0xFF26A69A)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'AI Önerisi',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.orange[400],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Kültürel deneyim',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Kültürel gezinize devam edelim! Bulunduğunuz yere yakın bir müze önerimiz:',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withOpacity(0.9),
                ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.star, color: Colors.white, size: 20),
              const SizedBox(width: 4),
              Text(
                'Modern Sanat Müzesi',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.location_on, color: Colors.white, size: 16),
              const SizedBox(width: 4),
              Text(
                '1.8 km',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white.withOpacity(0.9),
                    ),
              ),
              const SizedBox(width: 16),
              const Icon(Icons.access_time, color: Colors.white, size: 16),
              const SizedBox(width: 4),
              Text(
                '~21 dk',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white.withOpacity(0.9),
                    ),
              ),
              const Spacer(),
              Text(
                '₺100',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    'Rotaya Ekle',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: () {},
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF4DB6AC),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('Detay'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceList() {
    final places = [
      {
        'imageUrl': 'https://images.unsplash.com/photo-1555993539-5d4e8e0e8b8b?w=400',
        'category': 'Tarihi Yerler',
        'title': 'Topkapı Sarayı',
        'description': 'Osmanlı İmparatorluğu\'nun muhteşem sarayı',
        'rating': 4.8,
        'distance': 2.3,
        'price': 200,
      },
      {
        'imageUrl': 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=400',
        'category': 'Müzeler',
        'title': 'Modern Sanat Müzesi',
        'description': 'Çağdaş sanat eserlerinin sergilendiği özel müze',
        'rating': 4.6,
        'distance': 1.8,
        'price': 200,
      },
      {
        'imageUrl': 'https://images.unsplash.com/photo-1554118811-1e0d58224f24?w=400',
        'category': 'Kafeler',
        'title': 'Boğaz Cafe',
        'description': 'Boğaz manzaralı şık kafe',
        'rating': 4.7,
        'distance': 0.5,
        'price': 100,
      },
      {
        'imageUrl': 'https://images.unsplash.com/photo-1526304640581-d334cdbbf45e?w=400',
        'category': 'Alışveriş',
        'title': 'Kapalıçarşı',
        'description': 'Dünyanın en eski ve büyük kapalı çarşılarından biri',
        'rating': 4.5,
        'distance': 3.1,
        'price': 0, // Ücretsiz
      },
    ];

    return Column(
      children: places.map((place) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _PlaceCard(
            imageUrl: place['imageUrl'] as String,
            category: place['category'] as String,
            title: place['title'] as String,
            description: place['description'] as String,
            rating: place['rating'] as double,
            distance: place['distance'] as double,
            price: place['price'] as int,
          ),
        );
      }).toList(),
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
            // Keşfet - zaten buradayız
            break;
          case 1:
            context.go(MapPage.routePath);
            break;
          case 2:
            // Etkinlikler - TODO: Etkinlikler sayfası
            break;
          case 3:
            context.go(GuidesPage.routePath);
            break;
          case 4:
            context.go(ProfilePage.routePath);
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

class _PlaceCard extends StatelessWidget {
  final String imageUrl;
  final String category;
  final String title;
  final String description;
  final double rating;
  final double distance;
  final int price;
  final bool showTimeTag;

  const _PlaceCard({
    required this.imageUrl,
    required this.category,
    required this.title,
    required this.description,
    required this.rating,
    required this.distance,
    required this.price,
    this.showTimeTag = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Görsel
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Container(
                  height: 200,
                  width: double.infinity,
                  color: Colors.grey[300],
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Icon(Icons.image, size: 50, color: Colors.grey),
                      );
                    },
                  ),
                ),
              ),
              // Kategori etiketi
              Positioned(
                bottom: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4DB6AC),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    category,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              // Favori butonu
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.favorite_border, size: 20),
                    onPressed: () {},
                    color: Colors.black,
                  ),
                ),
              ),
              // Zaman etiketi (opsiyonel)
              if (showTimeTag)
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.orange[400],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Şimdi',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          // İçerik
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF212121),
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      rating.toStringAsFixed(1),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(width: 16),
                    const Icon(Icons.location_on, color: Colors.grey, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      '$distance km',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                    const Spacer(),
                    if (price == 0)
                      Text(
                        'Ücretsiz',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: const Color(0xFF4DB6AC),
                              fontWeight: FontWeight.w600,
                            ),
                      )
                    else
                      Text(
                        '₺$price',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF212121),
                            ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
