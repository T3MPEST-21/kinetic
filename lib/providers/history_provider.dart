import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/workout_history.dart';
import 'storage_provider.dart';
import 'user_stats_provider.dart';

final workoutHistoryProvider = NotifierProvider<WorkoutHistoryNotifier, List<WorkoutHistory>>(WorkoutHistoryNotifier.new);

class WorkoutHistoryNotifier extends Notifier<List<WorkoutHistory>> {
  late final StorageService _storageService;

  @override
  List<WorkoutHistory> build() {
    _storageService = ref.watch(storageServiceProvider);
    // Apollo Rule: Keep UI in sync. Watch stats to trigger history refresh.
    ref.watch(userStatsProvider);
    return _storageService.getWorkoutHistory();
  }

  void refresh() {
    state = _storageService.getWorkoutHistory();
  }
}
