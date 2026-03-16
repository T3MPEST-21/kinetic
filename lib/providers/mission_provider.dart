import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/mission.dart';
import 'settings_provider.dart';
import 'mission_engine.dart';

class MissionsNotifier extends Notifier<Mission> {
  @override
  Mission build() {
    final settings = ref.watch(settingsProvider);
    return MissionEngine.generateDailyMission(settings.globalDifficulty);
  }

  void updateTargetDuration(int minutes) {
    final settings = ref.read(settingsProvider);
    state = MissionEngine.generateDailyMission(settings.globalDifficulty, targetMinutes: minutes);
  }
}

final missionsProvider = NotifierProvider<MissionsNotifier, Mission>(MissionsNotifier.new);

final todayMissionProvider = Provider<Mission>((ref) {
  return ref.watch(missionsProvider);
});
