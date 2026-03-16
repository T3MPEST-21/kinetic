class WorkoutHistory {
  final String id;
  final String missionTitle;
  final String timestampIso;
  final int durationSeconds;
  final int xpEarned;

  const WorkoutHistory({
    required this.id,
    required this.missionTitle,
    required this.timestampIso,
    required this.durationSeconds,
    required this.xpEarned,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'missionTitle': missionTitle,
      'timestampIso': timestampIso,
      'durationSeconds': durationSeconds,
      'xpEarned': xpEarned,
    };
  }

  factory WorkoutHistory.fromJson(Map<String, dynamic> json) {
    return WorkoutHistory(
      id: json['id'],
      missionTitle: json['missionTitle'],
      timestampIso: json['timestampIso'],
      durationSeconds: json['durationSeconds'],
      xpEarned: json['xpEarned'],
    );
  }
}
