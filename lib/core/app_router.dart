import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screens/home_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/progress_screen.dart';
import '../screens/achievements_screen.dart';
import '../screens/main_screen.dart';
import '../screens/workout_screen.dart';
import '../screens/workout_complete_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _homeNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'home');
final _progressNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'progress');
final _achievementsNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'achievements');
final _settingsNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'settings');

final appRouter = GoRouter(
  initialLocation: '/home',
  navigatorKey: _rootNavigatorKey,
  routes: [
    GoRoute(
      path: '/workout',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const WorkoutScreen(),
    ),
    GoRoute(
      path: '/workout-complete',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const WorkoutCompleteScreen(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainScreen(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          navigatorKey: _homeNavigatorKey,
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _progressNavigatorKey,
          routes: [
            GoRoute(
              path: '/progress',
              builder: (context, state) => const ProgressScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _achievementsNavigatorKey,
          routes: [
            GoRoute(
              path: '/awards',
              builder: (context, state) => const AchievementsScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _settingsNavigatorKey,
          routes: [
            GoRoute(
              path: '/settings',
              builder: (context, state) => const SettingsScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);
