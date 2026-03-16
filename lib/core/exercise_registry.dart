import '../models/workout_step.dart';

class ExerciseRegistry {
  static final List<WorkoutStep> exercises = [
    // WARMUPS
    const WorkoutStep(
      id: 'jumping_jacks',
      type: StepType.exercise,
      name: 'Jumping Jacks',
      category: 'warmup',
      durationSeconds: 30,
      animationPath: 'assets/animations/jumping_jack.json',
      coachTip: 'Land soft on your feet like you\'re avoiding a memory leak.',
    ),
    const WorkoutStep(
      id: 'inchworm',
      type: StepType.exercise,
      name: 'Inchworm',
      category: 'warmup',
      durationSeconds: 30,
      animationPath: 'assets/animations/inchworm.json',
      coachTip: 'Walk your hands out slowly. Think of it as a rolling deployment.',
    ),
    
    // HIIT / STRENGTH
    const WorkoutStep(
      id: 'push_ups',
      type: StepType.exercise,
      name: 'Push Ups',
      category: 'hiit',
      durationSeconds: 45,
      animationPath: 'assets/animations/pushup.json',
      coachTip: 'Keep your back straight. No spaghetti code posture here.',
    ),
    const WorkoutStep(
      id: 'burpees',
      type: StepType.exercise,
      name: 'Burpees',
      category: 'hiit',
      durationSeconds: 45,
      animationPath: 'assets/animations/burpee.json',
      coachTip: 'Explode up! Optimize for maximum power output.',
    ),
    const WorkoutStep(
      id: 'lunges',
      type: StepType.exercise,
      name: 'Lunges',
      category: 'hiit',
      durationSeconds: 45,
      animationPath: 'assets/animations/lunges.json',
      coachTip: 'Balance is key. Keep your state synchronized.',
    ),
    const WorkoutStep(
      id: 'spider_pushups',
      type: StepType.exercise,
      name: 'Spider Pushups',
      category: 'hiit',
      durationSeconds: 45,
      animationPath: 'assets/animations/spiderman_pushup.json',
      coachTip: 'Knees to elbows. Crawl through the bugs.',
    ),
    const WorkoutStep(
      id: 'split_jumps',
      type: StepType.exercise,
      name: 'Split Jumps',
      category: 'hiit',
      durationSeconds: 45,
      animationPath: 'assets/animations/split_jumps.json',
      coachTip: 'Switch feet fast. Context switching at its best.',
    ),
    
    // CORE
    const WorkoutStep(
      id: 'plank',
      type: StepType.exercise,
      name: 'Plank',
      category: 'core',
      durationSeconds: 60,
      animationPath: 'assets/animations/plank.json',
      coachTip: 'Hold steady. Your core is the root of your application.',
    ),
    const WorkoutStep(
      id: 'side_plank',
      type: StepType.exercise,
      name: 'Side Plank',
      category: 'core',
      durationSeconds: 30,
      animationPath: 'assets/animations/side_plank.json',
      coachTip: 'Switch sides halfway. Stay vertically scaled.',
    ),
    const WorkoutStep(
      id: 'sit_ups',
      type: StepType.exercise,
      name: 'Sit Ups',
      category: 'core',
      durationSeconds: 45,
      animationPath: 'assets/animations/sit_ups.json',
      coachTip: 'Isolation is good for abs, bad for microservices.',
    ),
    const WorkoutStep(
      id: 'cobras',
      type: StepType.exercise,
      name: 'Cobras',
      category: 'core',
      durationSeconds: 45,
      animationPath: 'assets/animations/cobras.json',
      coachTip: 'Stretch that spine. Release the accumulated technical debt.',
    ),
    const WorkoutStep(
      id: 'leg_ups',
      type: StepType.exercise,
      name: 'Leg Ups',
      category: 'core',
      durationSeconds: 45,
      animationPath: 'assets/animations/leg_ups.json',
      coachTip: 'Don\'t let them touch the floor. Keep the stack clean.',
    ),
    
    // REST / RECOVERY
    const WorkoutStep(
      id: 'rest',
      type: StepType.rest,
      name: 'Rest',
      category: 'rest',
      durationSeconds: 15,
      animationPath: 'assets/animations/rest.json',
      coachTip: 'Collecting garbage... Take a breath.',
    ),
  ];

  static List<WorkoutStep> getByCategory(String category) {
    return exercises.where((e) => e.category == category).toList();
  }
}
