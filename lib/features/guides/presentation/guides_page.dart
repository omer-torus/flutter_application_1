import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../home/presentation/home_page.dart';
import '../../map/presentation/map_page.dart';
import '../../events/presentation/events_page.dart';
import '../../profile/presentation/profile_page.dart';

class GuidesPage extends StatefulWidget {
  const GuidesPage({super.key});

  static const routeName = 'guides';
  static const routePath = '/guides';

  @override
  State<GuidesPage> createState() => _GuidesPageState();
}

class _GuidesPageState extends State<GuidesPage> {
  int _selectedIndex = 3; // Rehberler sekmesi aktif

  final List<Map<String, dynamic>> _guides = [
    {
      'name': 'Ahmet Yılmaz',
      'tourType': 'Tarihi Yerler',
      'languages': ['Türkçe', 'İngilizce', 'Almanca'],
      'rating': 4.9,
      'tours': 347,
      'price': 350,
      'imageUrl': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400',
      'isFeatured': true,
    },
    {
      'name': 'Ahmet Yılmaz',
      'tourType': 'Tarihi Yerler',
      'languages': ['Türkçe', 'İngilizce'],
      'rating': 4.9,
      'tours': 347,
      'price': 350,
      'imageUrl': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400',
      'isFeatured': false,
    },
    {
      'name': 'Elif Demir',
      'tourType': 'Yemek Turları',
      'languages': ['Türkçe', 'İngilizce'],
      'rating': 4.8,
      'tours': 289,
      'price': 300,
      'imageUrl': 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=400',
      'isFeatured': false,
    },
    {
      'name': 'Mehmet Kaya',
      'tourType': 'Fotoğraf Turları',
      'languages': ['Türkçe', 'İngilizce'],
      'rating': 4.7,
      'tours': 195,
      'price': 400,
      'imageUrl': 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=400',
      'isFeatured': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final featuredGuide = _guides.firstWhere((g) => g['isFeatured'] == true);
    final allGuides = _guides.where((g) => g['isFeatured'] == false).toList();

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
                    'Rehberler',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF212121),
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Yerel uzman rehberler',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Arama Çubuğu
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Rehber ara...',
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
                    // En Çok Tercih Edilen
                    _FeaturedGuideCard(guide: featuredGuide),
                    const SizedBox(height: 24),
                    
                    // Tüm Rehberler
                    Text(
                      'Tüm Rehberler',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF212121),
                          ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Rehber Listesi
                    ...allGuides.map((guide) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _GuideCard(guide: guide),
                      );
                    }),
                    
                    const SizedBox(height: 24),
                    
                    // Neden Rehber Tutmalısınız?
                    _WhyHireGuideSection(),
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

  Widget _FeaturedGuideCard({required Map<String, dynamic> guide}) {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // En Çok Tercih Edilen etiketi
          Row(
            children: [
              const Icon(Icons.workspace_premium, color: Colors.white, size: 20),
              const SizedBox(width: 6),
              Text(
                'En Çok Tercih Edilen',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Rehber Bilgileri
          Row(
            children: [
              // Profil Fotoğrafı
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                ),
                child: ClipOval(
                  child: Image.network(
                    guide['imageUrl'] as String,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Icon(Icons.person, size: 40),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 16),
              
              // İsim ve Detaylar
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      guide['name'] as String,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 18),
                        const SizedBox(width: 4),
                        Text(
                          (guide['rating'] as double).toStringAsFixed(1),
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${guide['tours']} tur',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
          
          // Dil Etiketleri
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: (guide['languages'] as List<String>).map((lang) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  lang,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          
          // Mesaj Gönder Butonu
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () {},
              style: FilledButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF4DB6AC),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.chat_bubble_outline, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Mesaj Gönder',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _GuideCard({required Map<String, dynamic> guide}) {
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
        children: [
          Row(
            children: [
              // Profil Fotoğrafı
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey[300]!, width: 2),
                ),
                child: ClipOval(
                  child: Image.network(
                    guide['imageUrl'] as String,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Icon(Icons.person, size: 30),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 12),
              
              // İsim ve Tur Tipi
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      guide['name'] as String,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF212121),
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      guide['tourType'] as String,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Dil Etiketleri
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: (guide['languages'] as List<String>).map((lang) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.person, size: 12, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      lang,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          
          // Rating, Tur Sayısı ve Fiyat
          Row(
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 18),
              const SizedBox(width: 4),
              Text(
                (guide['rating'] as double).toStringAsFixed(1),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(width: 8),
              Text(
                '${guide['tours']} tur',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
              const Spacer(),
              Text(
                '₺${guide['price']}/saat',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF212121),
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Mesaj Gönder Butonu
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.chat_bubble_outline, size: 18),
              label: const Text('Mesaj Gönder'),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.grey[300]!),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _WhyHireGuideSection() {
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
            'Neden Rehber Tutmalısınız?',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF212121),
                ),
          ),
          const SizedBox(height: 20),
          _BenefitItem(
            icon: Icons.check_circle,
            text: 'Yerel bilgi ve kültürel içgörüler',
          ),
          const SizedBox(height: 12),
          _BenefitItem(
            icon: Icons.check_circle,
            text: 'Kişiselleştirilmiş geziler',
          ),
          const SizedBox(height: 12),
          _BenefitItem(
            icon: Icons.check_circle,
            text: 'Zamandan tasarruf',
          ),
          const SizedBox(height: 12),
          _BenefitItem(
            icon: Icons.check_circle,
            text: 'Güvenli ve rahat deneyim',
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
            context.go(MapPage.routePath);
            break;
          case 2:
            context.go(EventsPage.routePath);
            break;
          case 3:
            // Rehberler - zaten buradayız
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

class _BenefitItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _BenefitItem({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF4DB6AC), size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF212121),
                ),
          ),
        ),
      ],
    );
  }
}
