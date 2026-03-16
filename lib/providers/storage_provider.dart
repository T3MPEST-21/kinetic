import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mmkv/mmkv.dart';
import 'dart:convert';
import '../models/user_stats.dart';
import '../models/settings.dart';
import '../models/workout_history.dart';

final mmkvProvider = Provider<MMKV>((ref) {
  return MMKV.defaultMMKV();
});

class StorageService {
  final MMKV _mmkv;

  StorageService(this._mmkv);

  static const _userStatsKey = 'user_stats';
  static const _settingsKey = 'settings';
  static const _historyKey = 'workout_history';
  static const _firstLaunchKey = 'first_launch_v1';

  bool isFirstLaunch() {
    return _mmkv.decodeBool(_firstLaunchKey, defaultValue: true);
  }

  void setFirstLaunchComplete() {
    _mmkv.encodeBool(_firstLaunchKey, false);
  }

  UserStats getUserStats() {
    final jsonStr = _mmkv.decodeString(_userStatsKey);
    if (jsonStr != null) {
      try {
        final Map<String, dynamic> jsonMap = jsonDecode(jsonStr);
        return UserStats.fromJson(jsonMap);
      } catch (e) {
        // Fallback or handle error
      }
    }
    return const UserStats(); // Default empty stats
  }

  void saveUserStats(UserStats stats) {
    _mmkv.encodeString(_userStatsKey, jsonEncode(stats.toJson()));
  }

  Settings getSettings() {
    final jsonStr = _mmkv.decodeString(_settingsKey);
    if (jsonStr != null) {
      try {
        final Map<String, dynamic> jsonMap = jsonDecode(jsonStr);
        return Settings.fromJson(jsonMap);
      } catch (e) {
        // Fallback or handle error
      }
    }
    return const Settings(); // Default settings
  }

  void saveSettings(Settings settings) {
    _mmkv.encodeString(_settingsKey, jsonEncode(settings.toJson()));
  }

  List<WorkoutHistory> getWorkoutHistory() {
    final jsonStr = _mmkv.decodeString(_historyKey);
    if (jsonStr != null) {
      try {
        final List<dynamic> jsonList = jsonDecode(jsonStr);
        return jsonList.map((j) => WorkoutHistory.fromJson(j as Map<String, dynamic>)).toList();
      } catch (e) {
        // Handle error
      }
    }
    return [];
  }

  void saveWorkoutHistory(WorkoutHistory record) {
    var history = getWorkoutHistory();
    // Prepend to show newest first
    history.insert(0, record);
    // Limit to 50 entries for "Apollo" efficiency
    if (history.length > 50) {
      history = history.sublist(0, 50);
    }
    _mmkv.encodeString(_historyKey, jsonEncode(history.map((h) => h.toJson()).toList()));
  }
}

final storageServiceProvider = Provider<StorageService>((ref) {
  final mmkv = ref.watch(mmkvProvider);
  return StorageService(mmkv);
});

class FirstLaunchNotifier extends Notifier<bool> {
  @override
  bool build() {
    return ref.watch(storageServiceProvider).isFirstLaunch();
  }

  void complete() {
    ref.read(storageServiceProvider).setFirstLaunchComplete();
    state = false;
  }
}

final firstLaunchProvider = NotifierProvider<FirstLaunchNotifier, bool>(FirstLaunchNotifier.new);
