import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../../home/presentation/home_page.dart';

class InterestsPage extends ConsumerStatefulWidget {
  const InterestsPage({super.key});

  static const routeName = 'interests';
  static const routePath = '/interests';

  @override
  ConsumerState<InterestsPage> createState() => _InterestsPageState();
}

class _InterestsPageState extends ConsumerState<InterestsPage> {
  final Set<String> _selectedInterests = {};
  bool _isSaving = false;

  final List<InterestCategory> _categories = [
    InterestCategory(
      id: 'history',
      name: 'Tarih',
      icon: Icons.castle,
    ),
    InterestCategory(
      id: 'shopping',
      name: 'Alışveriş',
      icon: Icons.shopping_bag,
    ),
    InterestCategory(
      id: 'cafes',
      name: 'Kafeler',
      icon: Icons.local_cafe,
    ),
    InterestCategory(
      id: 'music',
      name: 'Müzik',
      icon: Icons.music_note,
    ),
    InterestCategory(
      id: 'food',
      name: 'Yemek',
      icon: Icons.restaurant,
    ),
    InterestCategory(
      id: 'nature',
      name: 'Doğa',
      icon: Icons.landscape,
    ),
    InterestCategory(
      id: 'photography',
      name: 'Fotoğraf',
      icon: Icons.camera_alt,
    ),
    InterestCategory(
      id: 'art',
      name: 'Sanat',
      icon: Icons.palette,
    ),
  ];

  Future<void> _handleSave() async {
    if (_selectedInterests.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lütfen en az 3 ilgi alanı seçin'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    final authState = ref.read(authControllerProvider);
    final userId = authState.user?.id;

    if (userId == null) {
      setState(() {
        _isSaving = false;
      });
      return;
    }

    // Supabase'e kaydet
    try {
      final supabase = ref.read(supabaseClientProvider);
      
      // Önce mevcut ilgi alanlarını temizle
      await supabase.from('user_interests').delete().eq('user_id', userId);

      // Yeni ilgi alanlarını ekle
      final interests = _selectedInterests.map((category) {
        return {
          'user_id': userId,
          'category': category,
          'weight': 1.0,
        };
      }).toList();

      await supabase.from('user_interests').insert(interests);

      if (mounted) {
        context.go(HomePage.routePath);
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Hata: $error'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF424242), // Dark grey background
      body: SafeArea(
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(20),
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height - 40,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                  // Başlık
                  Text(
                    'İlgi Alanlarınız',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF212121),
                        ),
                  ),
                  const SizedBox(height: 8),
                  
                  // Alt başlık
                  Text(
                    'Size özel öneriler sunabilmemiz için en az 3 ilgi alanı seçin',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFF212121),
                        ),
                  ),
                  const SizedBox(height: 32),

                  // İlgi Alanları Grid
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.0,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      final category = _categories[index];
                      final isSelected = _selectedInterests.contains(category.id);

                      return InkWell(
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              _selectedInterests.remove(category.id);
                            } else {
                              _selectedInterests.add(category.id);
                            }
                          });
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFF4DB6AC)
                                  : Colors.grey[300]!,
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Gri daire içinde ikon
                              Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey[200],
                                ),
                                child: Icon(
                                  category.icon,
                                  size: 28,
                                  color: isSelected
                                      ? const Color(0xFF4DB6AC)
                                      : const Color(0xFF212121),
                                ),
                              ),
                              const SizedBox(height: 12),
                              
                              // İlgi alanı adı
                              Text(
                                category.name,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: isSelected
                                      ? const Color(0xFF4DB6AC)
                                      : const Color(0xFF212121),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 32),

                  // Tamamla Butonu
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: (_selectedInterests.length >= 3 && !_isSaving)
                          ? _handleSave
                          : null,
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF4DB6AC), // Light blue-green
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        disabledBackgroundColor: Colors.grey[300],
                      ),
                      child: _isSaving
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Tamamla',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class InterestCategory {
  const InterestCategory({
    required this.id,
    required this.name,
    required this.icon,
  });

  final String id;
  final String name;
  final IconData icon;
}
