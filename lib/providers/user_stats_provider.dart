import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/user_stats.dart';
import '../models/workout_history.dart';
import 'storage_provider.dart';
import 'dart:math' as math;

final userStatsProvider = NotifierProvider<UserStatsNotifier, UserStats>(UserStatsNotifier.new);

class UserStatsNotifier extends Notifier<UserStats> {
  late final StorageService _storageService;

  @override
  UserStats build() {
    _storageService = ref.watch(storageServiceProvider);
    return _loadStats();
  }

  UserStats _loadStats() {
    final stats = _storageService.getUserStats();
    return _checkStreak(stats);
  }

  UserStats _checkStreak(UserStats currentStats) {
    if (currentStats.lastWorkoutDateIso.isEmpty) return currentStats;

    final lastWorkout = DateTime.parse(currentStats.lastWorkoutDateIso);
    final now = DateTime.now();
    final difference = DateTime(now.year, now.month, now.day)
        .difference(DateTime(lastWorkout.year, lastWorkout.month, lastWorkout.day))
        .inDays;

    if (difference > 1) {
      // Streak broken
      final updated = currentStats.copyWith(currentStreak: 0);
      _storageService.saveUserStats(updated);
      return updated;
    }
    return currentStats;
  }

  void addWorkoutStats({
    required String missionTitle,
    required int earnedXp, 
    required int durationMinutes,
  }) {
    final now = DateTime.now();
    
    // Check if streak increases
    int newStreak = state.currentStreak;
    if (state.lastWorkoutDateIso.isNotEmpty) {
      final last = DateTime.parse(state.lastWorkoutDateIso);
      final daysDiff = DateTime(now.year, now.month, now.day)
          .difference(DateTime(last.year, last.month, last.day))
          .inDays;
      if (daysDiff == 1) {
        newStreak++;
      } else if (daysDiff > 1) {
        newStreak = 1; // Start new streak
      }
      // If daysDiff == 0, they already trained today, streak remains same
    } else {
      newStreak = 1; // First ever workout
    }

    final newLongestStreak = newStreak > state.longestStreak ? newStreak : state.longestStreak;
    final newTotalXp = state.xp + earnedXp;
    
    // Level scaling: Apollo Rule - Predictable and rewarding.
    // Formula: level = floor(sqrt(totalXp / 50)) + 1
    // 50 XP -> L2, 200 XP -> L3, 450 XP -> L4, 800 XP -> L5
    int newLevel = (math.sqrt(newTotalXp / 50)).floor() + 1;

    state = state.copyWith(
      xp: newTotalXp,
      level: newLevel,
      currentStreak: newStreak,
      longestStreak: newLongestStreak,
      totalWorkouts: state.totalWorkouts + 1,
      totalMinutes: state.totalMinutes + durationMinutes,
      lastWorkoutDateIso: DateFormat('yyyy-MM-dd').format(now),
    );

    _storageService.saveUserStats(state);

    // Save history record
    _storageService.saveWorkoutHistory(WorkoutHistory(
      id: now.millisecondsSinceEpoch.toString(),
      missionTitle: missionTitle,
      timestampIso: now.toIso8601String(),
      durationSeconds: durationMinutes * 60,
      xpEarned: earnedXp,
    ));
  }
}
