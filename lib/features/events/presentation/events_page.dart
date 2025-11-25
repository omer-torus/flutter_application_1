import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../home/presentation/home_page.dart';
import '../../map/presentation/map_page.dart';
import '../../guides/presentation/guides_page.dart';
import '../../profile/presentation/profile_page.dart';

class EventsPage extends ConsumerStatefulWidget {
  const EventsPage({super.key});

  static const routeName = 'events';
  static const routePath = '/events';

  @override
  ConsumerState<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends ConsumerState<EventsPage> {
  int _selectedIndex = 2; // Etkinlikler sekmesi aktif
  String _selectedCategory = 'Hepsi';

  final List<String> _categories = [
    'Hepsi',
    'Konserler',
    'Festivaller',
    'Sergiler',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Kategori Filtreleri
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, size: 18),
                    onPressed: () {},
                    color: Colors.grey[600],
                  ),
                  Expanded(
                    child: SizedBox(
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
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios, size: 18),
                    onPressed: () {},
                    color: Colors.grey[600],
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
                    // Öne Çıkan Etkinlik
                    _FeaturedEventCard(),
                    const SizedBox(height: 24),
                    
                    // Yaklaşan Etkinlikler
                    Row(
                      children: [
                        Text(
                          'Yaklaşan Etkinlikler',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF212121),
                              ),
                        ),
                        const SizedBox(width: 8),
                        Icon(Icons.trending_up, color: Colors.blue[400], size: 20),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // Yaklaşan Etkinlik Listesi
                    _buildUpcomingEventsList(),
                    const SizedBox(height: 24),
                    
                    // Bu Hafta
                    Text(
                      'Bu Hafta',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF212121),
                          ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Bu Hafta Etkinlikleri (Grid)
                    _buildThisWeekEvents(),
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

  Widget _FeaturedEventCard() {
    return Container(
      height: 280,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Arka plan görseli
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.grey[300],
              child: Image.network(
                'https://images.unsplash.com/photo-1470229722913-7c0e2dbbafd3?w=400',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.music_note, size: 50, color: Colors.grey),
                  );
                },
              ),
            ),
          ),
          // Gradient overlay
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.7),
                ],
              ),
            ),
          ),
          // İçerik
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Öne Çıkan etiketi
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.orange[400],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star, color: Colors.white, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        'Öne Çıkan',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                ),
                // Başlık ve detaylar
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Jazz Festivali 2024',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, color: Colors.white, size: 18),
                        const SizedBox(width: 6),
                        Text(
                          '25 Kasım 2024',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.white,
                              ),
                        ),
                        const SizedBox(width: 16),
                        const Icon(Icons.access_time, color: Colors.white, size: 18),
                        const SizedBox(width: 6),
                        Text(
                          '19:00',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.white,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
                // Detayları Gör butonu
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: BorderSide.none,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Detayları Gör',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: const Color(0xFF212121),
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingEventsList() {
    final events = [
      {
        'imageUrl': 'https://images.unsplash.com/photo-1485846234645-a62644f84728?w=400',
        'category': 'Festivaller',
        'title': 'Uluslararası Film Festivali',
        'date': '1-10 Aralık 2024',
        'location': 'Kadıköy Sineması',
        'price': '₺100-350',
      },
      {
        'imageUrl': 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=400',
        'category': 'Sergiler',
        'title': 'Modern Sanat Sergisi',
        'date': '20 Kasım - 5 Aralık',
        'location': 'İstanbul Modern',
        'price': '₺75',
      },
    ];

    return Column(
      children: events.map((event) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _UpcomingEventCard(
            imageUrl: event['imageUrl'] as String,
            category: event['category'] as String,
            title: event['title'] as String,
            date: event['date'] as String,
            location: event['location'] as String,
            price: event['price'] as String,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildThisWeekEvents() {
    final events = [
      {
        'imageUrl': 'https://images.unsplash.com/photo-1470229722913-7c0e2dbbafd3?w=400',
        'title': 'Jazz Festivali 2024',
        'interested': 120,
      },
      {
        'imageUrl': 'https://images.unsplash.com/photo-1485846234645-a62644f84728?w=400',
        'title': 'Uluslararası Film Festivali',
        'interested': 150,
      },
      {
        'imageUrl': 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=400',
        'title': 'Modern Sanat Sergisi',
        'interested': 180,
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return _ThisWeekEventCard(
          imageUrl: event['imageUrl'] as String,
          title: event['title'] as String,
          interested: event['interested'] as int,
        );
      },
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
            // Etkinlikler - zaten buradayız
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

class _UpcomingEventCard extends StatelessWidget {
  final String imageUrl;
  final String category;
  final String title;
  final String date;
  final String location;
  final String price;

  const _UpcomingEventCard({
    required this.imageUrl,
    required this.category,
    required this.title,
    required this.date,
    required this.location,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
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
              width: 100,
              height: 100,
              color: Colors.grey[300],
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.image, size: 30, color: Colors.grey),
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
                // Kategori etiketi
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    category,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
                const SizedBox(height: 8),
                // Başlık
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF212121),
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                // Tarih
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      date,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                // Konum
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        location,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Fiyat
                Text(
                  price,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: const Color(0xFF4DB6AC),
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ThisWeekEventCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final int interested;

  const _ThisWeekEventCard({
    required this.imageUrl,
    required this.title,
    required this.interested,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Görsel
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Container(
              height: 120,
              width: double.infinity,
              color: Colors.grey[300],
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.image, size: 30, color: Colors.grey),
                  );
                },
              ),
            ),
          ),
          // İçerik
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF212121),
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    children: [
                      const Icon(Icons.people, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        '$interested+ kişi ilgileniyor',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

