class UserStats {
  final int xp;
  final int level;
  final int currentStreak;
  final int longestStreak;
  final int totalWorkouts;
  final int totalMinutes;
  final String lastWorkoutDateIso;

  const UserStats({
    this.xp = 0,
    this.level = 1,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.totalWorkouts = 0,
    this.totalMinutes = 0,
    this.lastWorkoutDateIso = '',
  });

  factory UserStats.fromJson(Map<String, dynamic> json) {
    return UserStats(
      xp: json['xp'] as int? ?? 0,
      level: json['level'] as int? ?? 1,
      currentStreak: json['currentStreak'] as int? ?? 0,
      longestStreak: json['longestStreak'] as int? ?? 0,
      totalWorkouts: json['totalWorkouts'] as int? ?? 0,
      totalMinutes: json['totalMinutes'] as int? ?? 0,
      lastWorkoutDateIso: json['lastWorkoutDateIso'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'xp': xp,
      'level': level,
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'totalWorkouts': totalWorkouts,
      'totalMinutes': totalMinutes,
      'lastWorkoutDateIso': lastWorkoutDateIso,
    };
  }

  UserStats copyWith({
    int? xp,
    int? level,
    int? currentStreak,
    int? longestStreak,
    int? totalWorkouts,
    int? totalMinutes,
    String? lastWorkoutDateIso,
  }) {
    return UserStats(
      xp: xp ?? this.xp,
      level: level ?? this.level,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      totalWorkouts: totalWorkouts ?? this.totalWorkouts,
      totalMinutes: totalMinutes ?? this.totalMinutes,
      lastWorkoutDateIso: lastWorkoutDateIso ?? this.lastWorkoutDateIso,
    );
  }
}
