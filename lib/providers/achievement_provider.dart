import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'user_stats_provider.dart';
import '../models/user_stats.dart';

class Achievement {
  final String id;
  final String title;
  final String description;
  final bool Function(UserStats) condition;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.condition,
  });
}

final achievementsList = [
  Achievement(
    id: 'first_blood',
    title: 'First Blood',
    description: 'Completed your first workout!',
    condition: (stats) => stats.totalWorkouts >= 1,
  ),
  Achievement(
    id: 'week_warrior',
    title: 'Week Warrior',
    description: 'Maintained a 7-day streak!',
    condition: (stats) => stats.longestStreak >= 7,
  ),
  Achievement(
    id: 'centurion',
    title: 'Centurion',
    description: 'Completed 100 workouts!',
    condition: (stats) => stats.totalWorkouts >= 100,
  ),
  Achievement(
    id: 'iron_lungs',
    title: 'Iron Lungs',
    description: 'Trained for 1000 total minutes!',
    condition: (stats) => stats.totalMinutes >= 1000,
  ),
];

class AchievementNotifier extends Notifier<Achievement?> {
  final Set<String> _notifiedIds = {};

  @override
  Achievement? build() {
    _listenToStats();
    return null;
  }

  void _listenToStats() {
    ref.listen<UserStats>(userStatsProvider, (previous, next) {
      for (final achievement in achievementsList) {
        if (achievement.condition(next) && !_notifiedIds.contains(achievement.id)) {
          // If previous exists and it wasn't achieved yet, then this is a NEW unlock
          if (previous == null || !achievement.condition(previous)) {
            _unlock(achievement);
          } else {
            // Already unlocked in previous sessions, just mark it
            _notifiedIds.add(achievement.id);
          }
        }
      }
    });
  }

  void _unlock(Achievement achievement) {
    _notifiedIds.add(achievement.id);
    state = achievement;
    
    // Auto-clear notification after 5 seconds
    Future.delayed(const Duration(seconds: 5), () {
      if (state?.id == achievement.id) {
        state = null;
      }
    });
  }

  void clear() => state = null;
}

final achievementNotificationProvider = NotifierProvider<AchievementNotifier, Achievement?>(AchievementNotifier.new);
