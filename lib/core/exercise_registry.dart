import '../models/workout_step.dart';

/// The single source of truth for all available exercises.
/// All 21 Lottie animations are registered here.
class ExerciseRegistry {
  static final List<WorkoutStep> exercises = [

    // ─── WARMUP ────────────────────────────────────────────────────────────
    const WorkoutStep(
      id: 'jumping_jacks',
      type: StepType.exercise,
      name: 'Jumping Jacks',
      category: 'warmup',
      durationSeconds: 30,
      animationPath: 'assets/animations/jumping_jack.json',
      coachTip: 'Land soft on your feet. Quiet landings = less joint stress.',
    ),
    const WorkoutStep(
      id: 'inchworm',
      type: StepType.exercise,
      name: 'Inchworm',
      category: 'warmup',
      durationSeconds: 30,
      animationPath: 'assets/animations/inchworm.json',
      coachTip: 'Walk your hands out slowly. Engage your core the whole way.',
    ),
    const WorkoutStep(
      id: 'high_knees',
      type: StepType.exercise,
      name: 'High Knees',
      category: 'warmup',
      durationSeconds: 30,
      animationPath: 'assets/animations/fitness_girl.json',
      coachTip: 'Drive those knees up to hip height. Pump your arms to match.',
    ),

    // ─── HIIT / STRENGTH ───────────────────────────────────────────────────
    const WorkoutStep(
      id: 'push_ups',
      type: StepType.exercise,
      name: 'Push Ups',
      category: 'hiit',
      durationSeconds: 45,
      animationPath: 'assets/animations/pushup.json',
      coachTip: 'Keep your back flat. No spaghetti code posture.',
    ),
    const WorkoutStep(
      id: 'burpees',
      type: StepType.exercise,
      name: 'Burpees',
      category: 'hiit',
      durationSeconds: 45,
      animationPath: 'assets/animations/burpee.json',
      coachTip: 'Explode up! Chest to floor, then power through.',
    ),
    const WorkoutStep(
      id: 'lunges',
      type: StepType.exercise,
      name: 'Lunges',
      category: 'hiit',
      durationSeconds: 45,
      animationPath: 'assets/animations/lunges.json',
      coachTip: 'Front knee stays over your ankle. Don\'t let it collapse inward.',
    ),
    const WorkoutStep(
      id: 'spider_pushups',
      type: StepType.exercise,
      name: 'Spider Pushups',
      category: 'hiit',
      durationSeconds: 45,
      animationPath: 'assets/animations/spiderman_pushup.json',
      coachTip: 'Bring the knee to meet the elbow each rep. Control the movement.',
    ),
    const WorkoutStep(
      id: 'split_jumps',
      type: StepType.exercise,
      name: 'Split Jumps',
      category: 'hiit',
      durationSeconds: 45,
      animationPath: 'assets/animations/split_jumps.json',
      coachTip: 'Switch feet fast. Land soft, like you\'re sneaking.',
    ),
    const WorkoutStep(
      id: 'squats',
      type: StepType.exercise,
      name: 'Squats',
      category: 'hiit',
      durationSeconds: 45,
      animationPath: 'assets/animations/squat.json',
      coachTip: 'Sit into it. Knees out, chest up, heels planted.',
    ),
    const WorkoutStep(
      id: 'pushup_toe_tap',
      type: StepType.exercise,
      name: 'Pushup Toe Tap',
      category: 'hiit',
      durationSeconds: 45,
      animationPath: 'assets/animations/pushup_toe_tap.json',
      coachTip: 'From push-up position, tap each foot out. Keep hips level.',
    ),

    // ─── CORE ──────────────────────────────────────────────────────────────
    const WorkoutStep(
      id: 'plank',
      type: StepType.exercise,
      name: 'Plank',
      category: 'core',
      durationSeconds: 60,
      animationPath: 'assets/animations/plank.json',
      coachTip: 'Hold steady. Your core is your foundation — build it strong.',
    ),
    const WorkoutStep(
      id: 'side_plank',
      type: StepType.exercise,
      name: 'Side Plank',
      category: 'core',
      durationSeconds: 30,
      animationPath: 'assets/animations/side_plank.json',
      coachTip: 'Switch sides halfway. Stack those feet perfectly.',
    ),
    const WorkoutStep(
      id: 'sit_ups',
      type: StepType.exercise,
      name: 'Sit Ups',
      category: 'core',
      durationSeconds: 45,
      animationPath: 'assets/animations/sit_ups.json',
      coachTip: 'Don\'t pull on your neck. Let your abs do the work.',
    ),
    const WorkoutStep(
      id: 'cobras',
      type: StepType.exercise,
      name: 'Cobras',
      category: 'core',
      durationSeconds: 45,
      animationPath: 'assets/animations/cobras.json',
      coachTip: 'Lengthen your spine. Hold at the top for a full breath.',
    ),
    const WorkoutStep(
      id: 'leg_ups',
      type: StepType.exercise,
      name: 'Leg Raises',
      category: 'core',
      durationSeconds: 45,
      animationPath: 'assets/animations/leg_ups.json',
      coachTip: 'Lower slowly. Don\'t let your lower back arch off the floor.',
    ),
    const WorkoutStep(
      id: 'bicycle_crunches',
      type: StepType.exercise,
      name: 'Bicycle Crunches',
      category: 'core',
      durationSeconds: 45,
      animationPath: 'assets/animations/bicycle_crunches.json',
      coachTip: 'Slow and controlled beats fast and sloppy every time.',
    ),
    const WorkoutStep(
      id: 'elbow_to_knee_crunch',
      type: StepType.exercise,
      name: 'Elbow to Knee Crunch',
      category: 'core',
      durationSeconds: 45,
      animationPath: 'assets/animations/elbow_to_knee_crunch.json',
      coachTip: 'Rotate from the torso, not your neck. Feel the obliques engage.',
    ),
    const WorkoutStep(
      id: 'leg_raises',
      type: StepType.exercise,
      name: 'Flutter Kicks',
      category: 'core',
      durationSeconds: 45,
      animationPath: 'assets/animations/leg_raises.json',
      coachTip: 'Small kicks, never touching the floor. Breathe steady.',
    ),
    const WorkoutStep(
      id: 'reverse_crunches',
      type: StepType.exercise,
      name: 'Reverse Crunches',
      category: 'core',
      durationSeconds: 45,
      animationPath: 'assets/animations/reverse_crunches.json',
      coachTip: 'Curl your hips off the floor. Control the descent.',
    ),
    const WorkoutStep(
      id: 't_plank',
      type: StepType.exercise,
      name: 'T-Plank Rotation',
      category: 'core',
      durationSeconds: 45,
      animationPath: 'assets/animations/t_plank.json',
      coachTip: 'Rotate fully at the top. Stack your feet or stagger them.',
    ),

    // ─── REST ──────────────────────────────────────────────────────────────
    const WorkoutStep(
      id: 'rest',
      type: StepType.rest,
      name: 'Rest',
      category: 'rest',
      durationSeconds: 15,
      animationPath: 'assets/animations/rest.json',
      coachTip: 'Reset your breathing. In through the nose, out through the mouth.',
    ),
  ];

  static List<WorkoutStep> getByCategory(String category) {
    return exercises.where((e) => e.category == category).toList();
  }
}
