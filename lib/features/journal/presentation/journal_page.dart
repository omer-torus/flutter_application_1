import 'package:flutter/material.dart';

class JournalPage extends StatelessWidget {
  const JournalPage({super.key});

  static const routeName = 'journal';
  static const routePath = '/journal';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gezi Günlüğü & Bütçe')),
      body: Center(
        child: Text(
          'Harcama takibi, notlar ve medya ekleme akışları burada yer alacak.',
          style: Theme.of(context).textTheme.titleMedium,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}


