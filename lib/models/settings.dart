import 'mission.dart';

enum TrainerPersonality { drill, calm, sarcastic, oldSchool }

enum TabStyle { minimal, filled, glass }

enum HapticIntensity { light, medium, heavy }

class Settings {
  final bool voiceEnabled;
  final TrainerPersonality trainerPersonality;
  final bool duckAudio;
  
  // Workout
  final Difficulty globalDifficulty;
  
  // Customization
  final String fontFamily;
  final double borderRadius;
  final double glassIntensity;
  final TabStyle tabStyle;
  final int accentColor;
  final double fontSizeScale;
  
  // Voice
  final String? voiceName;
  final String? voiceLocale;
  
  // Haptics
  final bool hapticsEnabled;
  final HapticIntensity hapticIntensity;

  const Settings({
    this.voiceEnabled = true,
    this.trainerPersonality = TrainerPersonality.drill,
    this.duckAudio = true,
    this.globalDifficulty = Difficulty.beginner,
    this.fontFamily = 'Outfit',
    this.borderRadius = 16.0,
    this.glassIntensity = 0.5,
    this.tabStyle = TabStyle.minimal,
    this.accentColor = 0xFF34C759, // Default Kinetic Green
    this.fontSizeScale = 1.0,
    this.voiceName,
    this.voiceLocale,
    this.hapticsEnabled = true,
    this.hapticIntensity = HapticIntensity.medium,
  });

  factory Settings.fromJson(Map<String, dynamic> json) {
    return Settings(
      voiceEnabled: json['voiceEnabled'] ?? true,
      trainerPersonality: TrainerPersonality.values[json['trainerPersonality'] ?? 0],
      duckAudio: json['duckAudio'] ?? true,
      globalDifficulty: Difficulty.values[json['globalDifficulty'] ?? 0],
      fontFamily: json['fontFamily'] ?? 'Outfit',
      borderRadius: (json['borderRadius'] ?? 16.0).toDouble(),
      glassIntensity: (json['glassIntensity'] ?? 0.5).toDouble(),
      tabStyle: TabStyle.values[json['tabStyle'] ?? 0],
      accentColor: json['accentColor'] ?? 0xFF34C759,
      fontSizeScale: (json['fontSizeScale'] ?? 1.0).toDouble(),
      voiceName: json['voiceName'],
      voiceLocale: json['voiceLocale'],
      hapticsEnabled: json['hapticsEnabled'] ?? true,
      hapticIntensity: HapticIntensity.values[json['hapticIntensity'] ?? 1],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'voiceEnabled': voiceEnabled,
      'trainerPersonality': trainerPersonality.index,
      'duckAudio': duckAudio,
      'globalDifficulty': globalDifficulty.index,
      'fontFamily': fontFamily,
      'borderRadius': borderRadius,
      'glassIntensity': glassIntensity,
      'tabStyle': tabStyle.index,
      'accentColor': accentColor,
      'fontSizeScale': fontSizeScale,
      'voiceName': voiceName,
      'voiceLocale': voiceLocale,
      'hapticsEnabled': hapticsEnabled,
      'hapticIntensity': hapticIntensity.index,
    };
  }

  Settings copyWith({
    bool? voiceEnabled,
    TrainerPersonality? trainerPersonality,
    bool? duckAudio,
    Difficulty? globalDifficulty,
    String? fontFamily,
    double? borderRadius,
    double? glassIntensity,
    TabStyle? tabStyle,
    int? accentColor,
    double? fontSizeScale,
    String? voiceName,
    String? voiceLocale,
    bool? hapticsEnabled,
    HapticIntensity? hapticIntensity,
  }) {
    return Settings(
      voiceEnabled: voiceEnabled ?? this.voiceEnabled,
      trainerPersonality: trainerPersonality ?? this.trainerPersonality,
      duckAudio: duckAudio ?? this.duckAudio,
      globalDifficulty: globalDifficulty ?? this.globalDifficulty,
      fontFamily: fontFamily ?? this.fontFamily,
      borderRadius: borderRadius ?? this.borderRadius,
      glassIntensity: glassIntensity ?? this.glassIntensity,
      tabStyle: tabStyle ?? this.tabStyle,
      accentColor: accentColor ?? this.accentColor,
      fontSizeScale: fontSizeScale ?? this.fontSizeScale,
      voiceName: voiceName ?? this.voiceName,
      voiceLocale: voiceLocale ?? this.voiceLocale,
      hapticsEnabled: hapticsEnabled ?? this.hapticsEnabled,
      hapticIntensity: hapticIntensity ?? this.hapticIntensity,
    );
  }
}
