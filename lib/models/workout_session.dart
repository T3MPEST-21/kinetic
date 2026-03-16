import 'workout_step.dart';

class WorkoutSession {
  final String id;
  final String name;
  final String description;
  final int targetXp;
  final List<WorkoutStep> steps;

  const WorkoutSession({
    required this.id,
    required this.name,
    required this.description,
    required this.targetXp,
    required this.steps,
  });

  int get totalDurationSeconds => steps.fold(0, (sum, step) => sum + step.durationSeconds);

  factory WorkoutSession.fromJson(Map<String, dynamic> json) {
    return WorkoutSession(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      targetXp: json['targetXp'] as int? ?? 0,
      steps: (json['steps'] as List<dynamic>?)
              ?.map((e) => WorkoutStep.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'targetXp': targetXp,
      'steps': steps.map((e) => e.toJson()).toList(),
    };
  }
}
