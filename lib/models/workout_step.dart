enum StepType { exercise, rest }

class WorkoutStep {
  final String id;
  final StepType type;
  final String name;
  final String category; // e.g., 'warmup', 'hiit', 'core', 'rest'
  final int durationSeconds;
  final int reps; // 0 if time-based
  final String animationPath;
  final String startVoiceMessage;
  final String halfwayVoiceMessage;
  final String coachTip; // Senior dev style tips

  const WorkoutStep({
    required this.id,
    required this.name,
    required this.durationSeconds,
    required this.type,
    this.animationPath = '',
    this.startVoiceMessage = '',
    this.halfwayVoiceMessage = '',
    this.category = 'hiit',
    this.coachTip = '',
    this.reps = 0,
  });

  WorkoutStep copyWith({
    String? id,
    String? name,
    int? durationSeconds,
    StepType? type,
    String? animationPath,
    String? startVoiceMessage,
    String? halfwayVoiceMessage,
    String? category,
    String? coachTip,
    int? reps,
  }) {
    return WorkoutStep(
      id: id ?? this.id,
      name: name ?? this.name,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      type: type ?? this.type,
      animationPath: animationPath ?? this.animationPath,
      startVoiceMessage: startVoiceMessage ?? this.startVoiceMessage,
      halfwayVoiceMessage: halfwayVoiceMessage ?? this.halfwayVoiceMessage,
      category: category ?? this.category,
      coachTip: coachTip ?? this.coachTip,
      reps: reps ?? this.reps,
    );
  }

  factory WorkoutStep.fromJson(Map<String, dynamic> json) {
    return WorkoutStep(
      id: json['id'] as String,
      type: StepType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => StepType.exercise,
      ),
      name: json['name'] as String,
      category: json['category'] as String? ?? 'hiit',
      durationSeconds: json['durationSeconds'] as int,
      reps: json['reps'] as int? ?? 0,
      animationPath: json['animationPath'] as String? ?? '',
      startVoiceMessage: json['startVoiceMessage'] as String? ?? '',
      halfwayVoiceMessage: json['halfwayVoiceMessage'] as String? ?? '',
      coachTip: json['coachTip'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      'name': name,
      'category': category,
      'durationSeconds': durationSeconds,
      'reps': reps,
      'animationPath': animationPath,
      'startVoiceMessage': startVoiceMessage,
      'halfwayVoiceMessage': halfwayVoiceMessage,
      'coachTip': coachTip,
    };
  }
}
