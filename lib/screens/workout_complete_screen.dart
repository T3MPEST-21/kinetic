import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import '../providers/workout_provider.dart';
import '../providers/user_stats_provider.dart';

class WorkoutCompleteScreen extends ConsumerStatefulWidget {
  const WorkoutCompleteScreen({super.key});

  @override
  ConsumerState<WorkoutCompleteScreen> createState() => _WorkoutCompleteScreenState();
}

class _WorkoutCompleteScreenState extends ConsumerState<WorkoutCompleteScreen> {
  @override
  void initState() {
    super.initState();
    // Update stats once when screen is mounted
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final workoutState = ref.read(workoutProvider);
      if (workoutState.session != null) {
        ref.read(userStatsProvider.notifier).addWorkoutStats(
          missionTitle: workoutState.session!.name,
          earnedXp: workoutState.session!.targetXp,
          durationMinutes: workoutState.totalElapsedSeconds ~/ 60,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final workoutState = ref.watch(workoutProvider);
    final userStats = ref.watch(userStatsProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              // Celebration Animation
              SizedBox(
                height: 200,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Lottie.network(
                      'https://raw.githubusercontent.com/xvrh/lottie-flutter/master/example/assets/Mobilo/A.json', // Confetti fallback
                      repeat: true,
                      errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
                    ),
                    Lottie.network(
                      'https://raw.githubusercontent.com/xvrh/lottie-flutter/master/example/assets/Mobilo/A.json', // Trophy fallback
                      repeat: true,
                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.emoji_events, size: 100, color: Colors.amber),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Workout Complete!',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Consistency is the key to mastery.',
                style: TextStyle(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              
              // Stats Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _SummaryStat(
                    label: 'XP Earned',
                    value: '+${workoutState.session?.targetXp ?? 0}',
                    color: Colors.greenAccent,
                  ),
                  _SummaryStat(
                    label: 'Streak',
                    value: '${userStats.currentStreak} Days',
                    color: Colors.orangeAccent,
                  ),
                ],
              ),
              
              const Spacer(),
              
              // Finish Button
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: () {
                    ref.read(workoutProvider.notifier).stop();
                    context.go('/home');
                  },
                  child: const Text(
                    'Return Home',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryStat extends StatelessWidget {
  const _SummaryStat({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.grey, fontSize: 14),
        ),
      ],
    );
  }
}
