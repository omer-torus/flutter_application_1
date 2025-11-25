import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../home/presentation/home_page.dart';
import '../../guides/presentation/guides_page.dart';
import '../../events/presentation/events_page.dart';
import '../../profile/presentation/profile_page.dart';

class MapPage extends ConsumerStatefulWidget {
  const MapPage({super.key});

  static const routeName = 'map';
  static const routePath = '/map';

  @override
  ConsumerState<MapPage> createState() => _MapPageState();
}

class _MapPageState extends ConsumerState<MapPage> {
  int _selectedIndex = 1; // Harita sekmesi aktif
  int _currentCardIndex = 0;

  final List<Map<String, dynamic>> _places = [
    {
      'title': 'Topkapı Sarayı',
      'description': 'Osmanlı İmparatorluğu\'nun muhteşem sarayı',
      'distance': '2.3 km',
      'rating': 4.8,
      'category': 'Tarihi Yerler',
    },
    {
      'title': 'Modern Sanat Müzesi',
      'description': 'Çağdaş sanat eserlerinin sergilendiği özel müze',
      'distance': '1.8 km',
      'rating': 4.6,
      'category': 'Müzeler',
    },
    {
      'title': 'Boğaz Cafe',
      'description': 'Boğaz manzaralı şık kafe',
      'distance': '0.5 km',
      'rating': 4.7,
      'category': 'Kafeler',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Harita Alanı (şimdilik placeholder)
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFE3F2FD), // Açık mavi
            ),
            child: Stack(
              children: [
                // Grid pattern
                CustomPaint(
                  painter: _GridPatternPainter(),
                ),
                // Konum pin'leri
                Positioned(
                  left: MediaQuery.of(context).size.width * 0.2,
                  top: MediaQuery.of(context).size.height * 0.2,
                  child: _buildMapPin(),
                ),
                Positioned(
                  left: MediaQuery.of(context).size.width * 0.5,
                  top: MediaQuery.of(context).size.height * 0.45,
                  child: Stack(
                    children: [
                      _buildMapPin(),
                      // Kullanıcı konumu (mavi nokta)
                      Positioned(
                        bottom: -8,
                        left: 8,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: const BoxDecoration(
                            color: Color(0xFF2196F3),
                            shape: BoxShape.circle,
                            border: Border.fromBorderSide(
                              BorderSide(color: Colors.white, width: 2),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: MediaQuery.of(context).size.width * 0.7,
                  top: MediaQuery.of(context).size.height * 0.7,
                  child: _buildMapPin(),
                ),
                // Navigasyon butonu (sağ alt)
                Positioned(
                  bottom: 200,
                  right: 16,
                  child: FloatingActionButton(
                    onPressed: () {},
                    backgroundColor: const Color(0xFF4DB6AC),
                    child: const Icon(Icons.send, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          
          // Alt Bilgi Kartları
          Positioned(
            bottom: 80, // Bottom nav bar için yer bırak
            left: 0,
            right: 0,
            child: Column(
              children: [
                // Kart Navigasyon İkonları
                if (_places.length > 1)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios, size: 20),
                          onPressed: _currentCardIndex > 0
                              ? () {
                                  setState(() {
                                    _currentCardIndex--;
                                  });
                                }
                              : null,
                          color: Colors.grey[700],
                        ),
                        IconButton(
                          icon: const Icon(Icons.arrow_forward_ios, size: 20),
                          onPressed: _currentCardIndex < _places.length - 1
                              ? () {
                                  setState(() {
                                    _currentCardIndex++;
                                  });
                                }
                              : null,
                          color: Colors.grey[700],
                        ),
                      ],
                    ),
                  ),
                
                // Bilgi Kartı
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _buildPlaceInfoCard(_places[_currentCardIndex]),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildMapPin() {
    return Container(
      width: 40,
      height: 40,
      decoration: const BoxDecoration(
        color: Color(0xFF2196F3),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: const Icon(
        Icons.location_on,
        color: Colors.white,
        size: 28,
      ),
    );
  }

  Widget _buildPlaceInfoCard(Map<String, dynamic> place) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      place['title'] as String,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF212121),
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      place['description'] as String,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  place['distance'] as String,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF212121),
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 18),
              const SizedBox(width: 4),
              Text(
                (place['rating'] as double).toStringAsFixed(1),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(width: 16),
              Text(
                place['category'] as String,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
              const Spacer(),
              FilledButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Rotaya Ekle'),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF4DB6AC),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              ),
            ],
          ),
        ],
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
            // Harita - zaten buradayız
            break;
          case 2:
            context.go(EventsPage.routePath);
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

class _GridPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..strokeWidth = 1;

    // Yatay çizgiler
    for (double y = 0; y < size.height; y += 50) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }

    // Dikey çizgiler
    for (double x = 0; x < size.width; x += 50) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

