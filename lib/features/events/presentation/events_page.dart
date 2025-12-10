import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/providers.dart';
import '../../guides/presentation/guides_page.dart';
import '../../home/presentation/home_page.dart';
import '../../map/presentation/map_page.dart';
import '../../profile/presentation/profile_page.dart';
import '../application/event_controller.dart';
import '../application/event_state.dart';
import '../domain/entities/event_entity.dart';

class EventsPage extends ConsumerStatefulWidget {
  const EventsPage({super.key});

  static const routeName = 'events';
  static const routePath = '/events';

  @override
  ConsumerState<EventsPage> createState() => _EventsPageState();
}

String _formatDate(DateTime? date) {
  if (date == null) return 'Tarihi duyurulacak';
  final formatter = DateFormat('d MMM yyyy', 'tr');
  return formatter.format(date);
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

  // Varsayılan koordinatlar (İstanbul)
  static const double _defaultLat = 41.0082;
  static const double _defaultLng = 28.9784;

  double? _userLat;
  double? _userLng;
  bool _isLoadingLocation = false;
  String? _locationError;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeLocation();
    });
  }

  Future<void> _initializeLocation() async {
    setState(() {
      _isLoadingLocation = true;
      _locationError = null;
    });

    try {
      final locationService = ref.read(locationServiceProvider);
      final position = await locationService.getCurrentLocation();

      if (mounted) {
        if (position != null) {
          _userLat = position.latitude;
          _userLng = position.longitude;
          _locationError = null;
        } else {
          _locationError = 'Konum alınamadı, İstanbul gösteriliyor';
        }
        _isLoadingLocation = false;
      }
    } catch (e) {
      if (mounted) {
        _locationError = 'Konum hatası: ${e.toString()}';
        _isLoadingLocation = false;
      }
    }

    _loadEvents();
  }

  void _loadEvents() {
    final categories = _mapCategories(_selectedCategory);
    final lat = _userLat ?? _defaultLat;
    final lng = _userLng ?? _defaultLng;

    ref.read(eventControllerProvider.notifier).loadEvents(
          latitude: lat,
          longitude: lng,
          categories: categories,
        );
  }

  List<String> _mapCategories(String category) {
    switch (category) {
      case 'Konserler':
        return ['Music'];
      case 'Festivaller':
        return ['Festival'];
      case 'Sergiler':
        return ['Arts & Theatre'];
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final eventState = ref.watch(eventControllerProvider);
    final events = eventState.events;

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
                                _loadEvents();
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
                    _buildLocationStatus(),
                    const SizedBox(height: 16),
                    // Öne Çıkan Etkinlik
                    _FeaturedEventCard(event: events.isNotEmpty ? events.first : null),
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
                    _buildUpcomingEventsList(eventState),
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
                    _buildThisWeekEvents(events),
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

  Widget _buildLocationStatus() {
    return Row(
      children: [
        Icon(
          _isLoadingLocation
              ? Icons.location_searching
              : _locationError != null
                  ? Icons.location_off
                  : Icons.location_on,
          color: _isLoadingLocation
              ? Colors.orange
              : _locationError != null
                  ? Colors.red
                  : Colors.green,
          size: 18,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            _isLoadingLocation
                ? 'Konum alınıyor...'
                : _locationError ?? 'Konumunuza göre etkinlikleri listeliyoruz',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
        ),
        if (_locationError != null)
          TextButton.icon(
            onPressed: _initializeLocation,
            icon: const Icon(Icons.refresh, size: 16),
            label: const Text('Tekrar Dene'),
          ),
      ],
    );
  }

  Widget _FeaturedEventCard({EventEntity? event}) {
    final imageUrl = event?.imageUrl ??
        'https://images.unsplash.com/photo-1470229722913-7c0e2dbbafd3?w=400';

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
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.grey[300],
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.event, size: 50, color: Colors.grey),
                  );
                },
              ),
            ),
          ),
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
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event?.name ?? 'Yakınınızdaki etkinlikler',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, color: Colors.white, size: 18),
                        const SizedBox(width: 6),
                        Text(
                          _formatDate(event?.startDate),
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.white,
                              ),
                        ),
                        const SizedBox(width: 16),
                        const Icon(Icons.location_on, color: Colors.white, size: 18),
                        const SizedBox(width: 6),
                        Text(
                          event != null ? '${event.city}, ${event.country}' : 'Konumunuza göre',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.white,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: event?.url != null ? () {} : null,
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: BorderSide.none,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      event?.url != null ? 'Detayları Gör' : 'Etkinlikleri keşfet',
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

  Widget _buildUpcomingEventsList(EventState state) {
    if (state.status == EventStatus.loading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (state.status == EventStatus.failure) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Icon(Icons.error_outline, size: 40, color: Colors.red),
              const SizedBox(height: 12),
              Text(
                'Etkinlikler yüklenemedi',
                style: TextStyle(color: Colors.grey[700]),
              ),
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: _loadEvents,
                icon: const Icon(Icons.refresh),
                label: const Text('Tekrar Dene'),
              ),
            ],
          ),
        ),
      );
    }

    if (state.events.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Icon(Icons.event_busy, size: 40, color: Colors.grey),
            const SizedBox(height: 12),
            Text(
              'Seçili kategoride etkinlik bulunamadı',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    final List<EventEntity> upcoming = state.events.take(5).toList();

    return Column(
      children: upcoming.map<Widget>((event) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _UpcomingEventCard(event: event),
        );
      }).toList(),
    );
  }

  Widget _buildThisWeekEvents(List<EventEntity> events) {
    if (events.isEmpty) {
      return const SizedBox.shrink();
    }

    final List<EventEntity> gridEvents = events.skip(1).take(6).toList();
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: gridEvents.length,
      itemBuilder: (context, index) {
        final event = gridEvents[index];
        return _ThisWeekEventCard(event: event);
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
  final EventEntity event;

  const _UpcomingEventCard({required this.event});

  @override
  Widget build(BuildContext context) {
    final imageUrl = event.imageUrl ??
        'https://images.unsplash.com/photo-1489515217757-5fd1be406fef?w=400';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    event.category,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  event.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF212121),
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      _formatDate(event.startDate),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        '${event.venueName} • ${event.city}',
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
                Text(
                  event.priceRange ?? 'Fiyat bilgisi yakında',
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
  final EventEntity event;

  const _ThisWeekEventCard({required this.event});

  @override
  Widget build(BuildContext context) {
    final imageUrl = event.imageUrl ??
        'https://images.unsplash.com/photo-1470229722913-7c0e2dbbafd3?w=400';
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
                    event.name,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF212121),
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        _formatDate(event.startDate),
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

