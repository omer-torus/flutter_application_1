import 'package:flutter/material.dart';

class RoutePlannerPage extends StatelessWidget {
  const RoutePlannerPage({super.key});

  static const routeName = 'route-planner';
  static const routePath = '/routes';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Rota Motoru')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Yakında Python tabanlı AI motoru ile personalize rota önerileri burada listelenecek.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            const Placeholder(fallbackHeight: 200),
          ],
        ),
      ),
    );
  }
}


