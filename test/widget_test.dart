import 'package:flutter_test/flutter_test.dart';
import 'package:kinetic/models/mission.dart';
import 'package:kinetic/models/settings.dart';
import 'package:kinetic/models/user_stats.dart';
import 'package:kinetic/models/workout_history.dart';
import 'package:kinetic/models/workout_session.dart';
import 'package:kinetic/models/workout_step.dart';
import 'package:kinetic/providers/mission_engine.dart';

void main() {
  group('MissionEngine Tests', () {
    test('generateDailyMission creates valid mission for beginner difficulty', () {
      final mission = MissionEngine.generateDailyMission(Difficulty.beginner, targetMinutes: 10);
      expect(mission.id.isNotEmpty, true);
      expect(mission.title.isNotEmpty, true);
      expect(mission.difficulty, Difficulty.beginner);
      expect(mission.workout.steps.isNotEmpty, true);
    });

    test('generateDailyMission creates valid mission for advanced difficulty', () {
      final mission = MissionEngine.generateDailyMission(Difficulty.advanced, targetMinutes: 20);
      expect(mission.difficulty, Difficulty.advanced);
      expect(mission.workout.targetXp, 200);
      expect(mission.workout.steps.length > 2, true);
    });
  });

  group('Model Tests', () {
    test('UserStats serialization and copyWith', () {
      const stats = UserStats(
        xp: 100,
        level: 2,
        currentStreak: 3,
        longestStreak: 5,
        totalWorkouts: 10,
        totalMinutes: 120,
        lastWorkoutDateIso: '2026-02-18',
      );

      final json = stats.toJson();
      final restored = UserStats.fromJson(json);

      expect(restored.xp, 100);
      expect(restored.level, 2);
      expect(restored.currentStreak, 3);
      expect(restored.longestStreak, 5);

      final updated = stats.copyWith(xp: 200);
      expect(updated.xp, 200);
      expect(updated.level, 2);
    });

    test('Settings serialization and default values', () {
      const settings = Settings();
      expect(settings.voiceEnabled, true);
      expect(settings.trainerPersonality, TrainerPersonality.drill);
      expect(settings.globalDifficulty, Difficulty.beginner);

      final json = settings.toJson();
      final restored = Settings.fromJson(json);
      expect(restored.fontFamily, 'Outfit');
      expect(restored.accentColor, 0xFF34C759);
    });

    test('WorkoutStep and WorkoutSession', () {
      const step1 = WorkoutStep(
        id: 's1',
        name: 'Push Ups',
        durationSeconds: 30,
        type: StepType.exercise,
      );
      const step2 = WorkoutStep(
        id: 's2',
        name: 'Rest',
        durationSeconds: 15,
        type: StepType.rest,
      );

      final session = WorkoutSession(
        id: 'w1',
        name: 'Test Session',
        description: 'Test Description',
        targetXp: 50,
        steps: [step1, step2],
      );

      expect(session.totalDurationSeconds, 45);
      expect(session.steps.length, 2);

      final json = session.toJson();
      final restored = WorkoutSession.fromJson(json);
      expect(restored.name, 'Test Session');
      expect(restored.steps.first.name, 'Push Ups');
    });

    test('WorkoutHistory serialization', () {
      final history = WorkoutHistory(
        id: 'h1',
        missionTitle: 'Operation Apex',
        timestampIso: '2026-02-18T12:00:00.000Z',
        durationSeconds: 600,
        xpEarned: 100,
      );

      final json = history.toJson();
      final restored = WorkoutHistory.fromJson(json);

      expect(restored.id, 'h1');
      expect(restored.missionTitle, 'Operation Apex');
      expect(restored.durationSeconds, 600);
      expect(restored.xpEarned, 100);
    });
  });
}
