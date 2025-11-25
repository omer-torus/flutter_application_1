import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/presentation/login_page.dart';
import '../features/auth/presentation/signup_page.dart';
import '../features/guides/presentation/guides_page.dart';
import '../features/home/presentation/home_page.dart';
import '../features/interests/presentation/interests_page.dart';
import '../features/journal/presentation/journal_page.dart';
import '../features/map/presentation/map_page.dart';
import '../features/events/presentation/events_page.dart';
import '../features/profile/presentation/profile_page.dart';
import '../features/onboarding/presentation/onboarding_page.dart';
import '../features/onboarding/presentation/splash_page.dart';
import '../features/routes/presentation/route_planner_page.dart';

final _rootKey = GlobalKey<NavigatorState>(debugLabel: 'rootNavigator');

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootKey,
    initialLocation: SplashPage.routePath,
    routes: [
      GoRoute(
        path: SplashPage.routePath,
        name: SplashPage.routeName,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: OnboardingPage.routePath,
        name: OnboardingPage.routeName,
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(
        path: LoginPage.routePath,
        name: LoginPage.routeName,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: SignupPage.routePath,
        name: SignupPage.routeName,
        builder: (context, state) => const SignupPage(),
      ),
      GoRoute(
        path: InterestsPage.routePath,
        name: InterestsPage.routeName,
        builder: (context, state) => const InterestsPage(),
      ),
      GoRoute(
        path: HomePage.routePath,
        name: HomePage.routeName,
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: MapPage.routePath,
        name: MapPage.routeName,
        builder: (context, state) => const MapPage(),
      ),
      GoRoute(
        path: EventsPage.routePath,
        name: EventsPage.routeName,
        builder: (context, state) => const EventsPage(),
      ),
      GoRoute(
        path: RoutePlannerPage.routePath,
        name: RoutePlannerPage.routeName,
        builder: (context, state) => const RoutePlannerPage(),
      ),
      GoRoute(
        path: GuidesPage.routePath,
        name: GuidesPage.routeName,
        builder: (context, state) => const GuidesPage(),
      ),
      GoRoute(
        path: ProfilePage.routePath,
        name: ProfilePage.routeName,
        builder: (context, state) => const ProfilePage(),
      ),
      GoRoute(
        path: JournalPage.routePath,
        name: JournalPage.routeName,
        builder: (context, state) => const JournalPage(),
      ),
    ],
  );
});


