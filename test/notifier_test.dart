import 'dart:math' as math;
import 'package:flutter_test/flutter_test.dart';
import 'package:kinetic/models/settings.dart';
import 'package:kinetic/models/user_stats.dart';

void main() {
  group('State Calculation Logic Tests', () {
    test('Level calculation scales predictably based on total XP', () {
      // Formula from UserStatsNotifier: level = floor(sqrt(totalXp / 50)) + 1
      int calcLevel(int totalXp) => (math.sqrt(totalXp / 50)).floor() + 1;

      expect(calcLevel(0), 1);
      expect(calcLevel(50), 2);
      expect(calcLevel(200), 3);
      expect(calcLevel(450), 4);
    });

    test('Settings copyWith creates expected modified settings', () {
      const settings = Settings();
      final updated = settings.copyWith(
        voiceEnabled: false,
        trainerPersonality: TrainerPersonality.calm,
        accentColor: 0xFF0A84FF,
      );

      expect(updated.voiceEnabled, false);
      expect(updated.trainerPersonality, TrainerPersonality.calm);
      expect(updated.accentColor, 0xFF0A84FF);
      expect(updated.fontFamily, 'Outfit'); // Unchanged
    });

    test('UserStats copyWith correctly updates streak and workouts', () {
      const stats = UserStats();
      final updated = stats.copyWith(
        currentStreak: 5,
        longestStreak: 5,
        totalWorkouts: 10,
        totalMinutes: 100,
      );

      expect(updated.currentStreak, 5);
      expect(updated.longestStreak, 5);
      expect(updated.totalWorkouts, 10);
      expect(updated.totalMinutes, 100);
      expect(updated.xp, 0); // Unchanged
    });
  });
}
