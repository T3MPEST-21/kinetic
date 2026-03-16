import '../models/workout_session.dart';
import '../models/workout_step.dart';

enum Difficulty { beginner, intermediate, advanced }

class Mission {
  final String id;
  final String title;
  final String description;
  final Difficulty difficulty;
  final WorkoutSession workout;

  const Mission({
    required this.id,
    required this.title,
    required this.description,
    required this.difficulty,
    required this.workout,
  });
}

final baseMissions = [
  Mission(
    id: 'm_beginner_1',
    title: 'Morning Essentials',
    description: 'Jumpstart your day with a light session.',
    difficulty: Difficulty.beginner,
    workout: WorkoutSession(
      id: 'w_morning_essentials',
      name: 'Morning Essentials',
      description: 'Gentle workout to wake up your body.',
      targetXp: 40,
      steps: [
        const WorkoutStep(
          id: 'step_bm_1',
          type: StepType.exercise,
          name: 'Jumping Jacks',
          durationSeconds: 30,
          animationPath: 'assets/animations/jumping_jack.json',
        ),
        const WorkoutStep(
          id: 'step_bm_2',
          type: StepType.rest,
          name: 'Rest',
          durationSeconds: 15,
          animationPath: 'assets/animations/rest.json',
        ),
        const WorkoutStep(
          id: 'step_bm_3',
          type: StepType.exercise,
          name: 'Squat Reach',
          durationSeconds: 30,
          animationPath: 'assets/animations/squat.json',
        ),
      ],
    ),
  ),
  Mission(
    id: 'm_intermediate_1',
    title: 'Core Crusher',
    description: 'Stable core, stable life.',
    difficulty: Difficulty.intermediate,
    workout: WorkoutSession(
      id: 'w_core_crusher',
      name: 'Core Crusher',
      description: 'Intense core and balance session.',
      targetXp: 60,
      steps: [
        const WorkoutStep(
          id: 'step_cc_1',
          type: StepType.exercise,
          name: 'Plank',
          durationSeconds: 45,
          animationPath: 'assets/animations/plank.json',
        ),
        const WorkoutStep(
          id: 'step_cc_2',
          type: StepType.rest,
          name: 'Rest',
          durationSeconds: 10,
          animationPath: 'assets/animations/rest.json',
        ),
        const WorkoutStep(
          id: 'step_cc_3',
          type: StepType.exercise,
          name: 'T-Plank',
          durationSeconds: 30,
          animationPath: 'assets/animations/t_plank.json',
        ),
        const WorkoutStep(
          id: 'step_cc_4',
          type: StepType.rest,
          name: 'Rest',
          durationSeconds: 10,
          animationPath: 'assets/animations/rest.json',
        ),
        const WorkoutStep(
          id: 'step_cc_5',
          type: StepType.exercise,
          name: 'Reverse Crunches',
          durationSeconds: 30,
          animationPath: 'assets/animations/reverse_crunches.json',
        ),
      ],
    ),
  ),
  Mission(
    id: 'm_advanced_1',
    title: 'Kinetic Overload',
    description: 'Push your limits with high intensity.',
    difficulty: Difficulty.advanced,
    workout: WorkoutSession(
      id: 'w_kinetic_overload',
      name: 'Kinetic Overload',
      description: 'Full body blast until fatigue.',
      targetXp: 100,
      steps: [
        const WorkoutStep(
          id: 'step_ko_1',
          type: StepType.exercise,
          name: 'Burpees',
          durationSeconds: 45,
          animationPath: 'assets/animations/burpee.json',
        ),
        const WorkoutStep(
          id: 'step_ko_2',
          type: StepType.rest,
          name: 'Quick Rest',
          durationSeconds: 5,
          animationPath: 'assets/animations/rest.json',
        ),
        const WorkoutStep(
          id: 'step_ko_3',
          type: StepType.exercise,
          name: 'Push Ups',
          durationSeconds: 45,
          animationPath: 'assets/animations/pushup.json',
        ),
        const WorkoutStep(
          id: 'step_ko_4',
          type: StepType.exercise,
          name: 'Squat Reach',
          durationSeconds: 45,
          animationPath: 'assets/animations/squat.json',
        ),
        const WorkoutStep(
          id: 'step_ko_5',
          type: StepType.rest,
          name: 'Final Rest',
          durationSeconds: 30,
          animationPath: 'assets/animations/rest.json',
        ),
      ],
    ),
  ),
];
