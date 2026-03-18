import 'dart:math';
import 'package:flutter/foundation.dart';
import '../models/mission.dart';
import '../models/workout_step.dart';
import '../models/workout_session.dart';
import '../core/exercise_registry.dart';

class MissionEngine {
  static Mission generateDailyMission(Difficulty difficulty, {int? targetMinutes}) {
    try {
      // Apollo Rule: Daily mission title stays stable using the date seed.
      // But step selection uses a fresh seed each call for genuine variety.
      final dailyRandom = Random(DateTime.now().day + DateTime.now().month * 31);
      final stepRandom = Random(); // Fresh every call — no two sessions are alike

      int finalTargetMins = targetMinutes ?? 10;
      if (targetMinutes == null) {
        if (difficulty == Difficulty.intermediate) finalTargetMins = 20;
        if (difficulty == Difficulty.advanced) finalTargetMins = 30;
      }

      final targetSeconds = finalTargetMins * 60;

      double durMult = 1.0;
      double restMult = 1.0;
      switch (difficulty) {
        case Difficulty.beginner:
          durMult = 1.0; restMult = 1.0;
          break;
        case Difficulty.intermediate:
          durMult = 1.5; restMult = 0.7;
          break;
        case Difficulty.advanced:
          durMult = 2.0; restMult = 0.5;
          break;
      }

      final warmupPool = ExerciseRegistry.getByCategory('warmup');
      final hiitPool   = List<WorkoutStep>.from(ExerciseRegistry.getByCategory('hiit'))..shuffle(stepRandom);
      final corePool   = List<WorkoutStep>.from(ExerciseRegistry.getByCategory('core'))..shuffle(stepRandom);
      final restPool   = ExerciseRegistry.getByCategory('rest');

      if (warmupPool.isEmpty || hiitPool.isEmpty || corePool.isEmpty || restPool.isEmpty) {
        throw Exception("Exercise pools are empty. Check ExerciseRegistry.");
      }

      final List<WorkoutStep> steps = [];
      int currentTotalSeconds = 0;

      // ── 1. Warmup — pick one randomly ────────────────────────────────────
      final warmup = warmupPool[stepRandom.nextInt(warmupPool.length)];
      final scaledWarmup = _scaleStep(warmup, durMult);
      steps.add(scaledWarmup);
      currentTotalSeconds += scaledWarmup.durationSeconds;

      final restStep = _scaleStep(restPool.first, restMult);

      // ── 2. Main Loop — alternate hiit/core with no-repeat guarantee ───────
      // We use pre-shuffled index cycling so we exhaust the pool before repeating.
      int hiitIndex = 0;
      int coreIndex = 0;
      bool pickHiit = true;

      while (currentTotalSeconds < targetSeconds - 60) {
        steps.add(restStep);
        currentTotalSeconds += restStep.durationSeconds;

        WorkoutStep drill;
        if (pickHiit) {
          drill = hiitPool[hiitIndex % hiitPool.length];
          hiitIndex++;
          // Re-shuffle when we've exhausted the pool to restart with fresh order
          if (hiitIndex % hiitPool.length == 0) hiitPool.shuffle(stepRandom);
        } else {
          drill = corePool[coreIndex % corePool.length];
          coreIndex++;
          if (coreIndex % corePool.length == 0) corePool.shuffle(stepRandom);
        }

        final scaledDrill = _scaleStep(drill, durMult);
        steps.add(scaledDrill);
        currentTotalSeconds += scaledDrill.durationSeconds;

        pickHiit = !pickHiit;
      }

      // ── 3. Final Burnout ──────────────────────────────────────────────────
      steps.add(restStep);
      currentTotalSeconds += restStep.durationSeconds;

      final burnoutPool = difficulty == Difficulty.advanced ? hiitPool : corePool;
      final burnout = burnoutPool[stepRandom.nextInt(burnoutPool.length)];
      final burnoutMultiplier = difficulty == Difficulty.advanced ? durMult * 1.2 : durMult;
      final scaledBurnout = _scaleStep(burnout, burnoutMultiplier);
      steps.add(scaledBurnout);
      currentTotalSeconds += scaledBurnout.durationSeconds;

      final title = _generateTitle(difficulty, dailyRandom);

      return Mission(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        description: "A precision-tuned ${finalTargetMins}-minute session for ${difficulty.name} levels.",
        difficulty: difficulty,
        workout: WorkoutSession(
          id: "daily_${DateTime.now().day}",
          name: title,
          description: "Generated kinetic mission",
          targetXp: 10 * finalTargetMins,
          steps: steps,
        ),
      );
    } catch (e) {
      debugPrint("MISSION_ENGINE_CRASH: $e. Falling back to safety mission.");
      return _generateSafetyMission(difficulty);
    }
  }

  static Mission _generateSafetyMission(Difficulty difficulty) {
    return Mission(
      id: 'safety_mission',
      title: 'Emergency Drill',
      description: 'Systems nominal. Perform a quick maintenance circuit.',
      difficulty: difficulty,
      workout: WorkoutSession(
        id: 'safety_workout',
        name: 'Emergency Drill',
        description: 'Safety fallback',
        targetXp: 50,
        steps: [
          const WorkoutStep(
            id: 'fallback_plank',
            name: 'Plank',
            durationSeconds: 300,
            type: StepType.exercise,
            animationPath: 'assets/animations/plank.json',
          ),
        ],
      ),
    );
  }

  static WorkoutStep _scaleStep(WorkoutStep step, double multiplier) {
    return step.copyWith(
      durationSeconds: (step.durationSeconds * multiplier).round().clamp(10, 300),
    );
  }

  static String _generateTitle(Difficulty difficulty, Random random) {
    final prefixes = ["Operation", "Project", "Mission", "Protocol", "Directive"];
    final codenames = ["Apex", "Vortex", "Kinetic", "Titan", "Shadow", "Nova", "Flux", "Zenith"];
    final prefix = prefixes[random.nextInt(prefixes.length)];
    final codename = codenames[random.nextInt(codenames.length)];
    return "$prefix $codename";
  }
}
