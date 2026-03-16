import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/settings.dart';
import '../models/mission.dart';
import 'storage_provider.dart';

final settingsProvider = NotifierProvider<SettingsNotifier, Settings>(SettingsNotifier.new);

class SettingsNotifier extends Notifier<Settings> {
  late final StorageService _storageService;

  @override
  Settings build() {
    _storageService = ref.watch(storageServiceProvider);
    return _storageService.getSettings();
  }

  void updateSettings({
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
    state = state.copyWith(
      voiceEnabled: voiceEnabled,
      trainerPersonality: trainerPersonality,
      duckAudio: duckAudio,
      globalDifficulty: globalDifficulty,
      fontFamily: fontFamily,
      borderRadius: borderRadius,
      glassIntensity: glassIntensity,
      tabStyle: tabStyle,
      accentColor: accentColor,
      fontSizeScale: fontSizeScale,
      voiceName: voiceName,
      voiceLocale: voiceLocale,
      hapticsEnabled: hapticsEnabled,
      hapticIntensity: hapticIntensity,
    );
    _storageService.saveSettings(state);
  }
}
