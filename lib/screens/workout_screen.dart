import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import '../providers/workout_provider.dart';
import '../providers/settings_provider.dart';
import '../models/workout_step.dart';
import '../core/widgets/background_wrapper.dart';
import '../core/widgets/glass_card.dart';

class WorkoutScreen extends ConsumerWidget {
  const WorkoutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workoutState = ref.watch(workoutProvider);
    final workoutNotifier = ref.read(workoutProvider.notifier);
    final settings = ref.watch(settingsProvider);
    
    // If finished, navigate to complete screen
    if (workoutState.isFinished) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
         context.go('/workout-complete'); 
      });
    }

    final currentStep = workoutState.currentStep;
    final nextStep = workoutState.nextStep;

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: BackgroundWrapper(
        child: SafeArea(
          child: Column(
            children: [
              // Top Navigation Row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white70),
                      onPressed: () {
                        workoutNotifier.stop();
                        context.pop();
                      },
                    ),
                    GlassCard(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Text(
                        '${workoutState.currentStepIndex + 1} / ${workoutState.session?.steps.length ?? 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        workoutState.isRunning ? Icons.pause_circle_filled : Icons.play_circle_filled,
                        color: Colors.white,
                        size: 32,
                      ),
                      onPressed: () {
                        if (workoutState.isRunning) {
                          workoutNotifier.pause();
                        } else {
                          workoutNotifier.resume();
                        }
                      },
                    ),
                  ],
                ),
              ),
              
              // Animation Display Area
              Expanded(
                flex: 4,
                child: Center(
                  child: currentStep != null && currentStep.animationPath.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Lottie.asset(
                            currentStep.animationPath,
                            fit: BoxFit.contain,
                            animate: workoutState.isRunning,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.fitness_center, size: 100, color: Colors.white24);
                            },
                          ),
                        )
                      : const Icon(Icons.fitness_center, size: 100, color: Colors.white24),
                ),
              ),

              // Step Info & Timer
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    Text(
                      currentStep?.name ?? 'Loading...',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        fontFamily: settings.fontFamily,
                        letterSpacing: 1.2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      currentStep?.type == StepType.rest ? 'Catch your breath' : 'Give it your all!',
                      style: const TextStyle(color: Colors.white54, fontSize: 16),
                    ),
                    const SizedBox(height: 32),
                    
                    // Large Monospaced Timer
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: Text(
                        _formatTime(workoutState.currentStepRemainingSeconds),
                        key: ValueKey<int>(workoutState.currentStepRemainingSeconds),
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 84,
                          fontWeight: FontWeight.bold,
                          color: workoutState.currentStepRemainingSeconds <= 5 
                              ? Colors.redAccent 
                              : Colors.white,
                          letterSpacing: -4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Bottom Progress & Next Step Preview
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    // Step Progress Indicator
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: _calculateProgress(workoutState),
                        minHeight: 12,
                        backgroundColor: Colors.white10,
                        color: currentStep?.type == StepType.rest ? Colors.blueAccent : Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Next Step Label
                    if (nextStep != null)
                      GlassCard(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('NEXT: ', style: TextStyle(color: Colors.white54, fontSize: 12, fontWeight: FontWeight.bold)),
                            Text(
                              nextStep.name.toUpperCase(),
                              style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w900),
                            ),
                          ],
                        ),
                      )
                    else
                      const Text('FINAL PUSH!', style: TextStyle(color: Colors.orangeAccent, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(int seconds) {
    if (seconds <= 0) return "00:00";
    int m = seconds ~/ 60;
    int s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  double _calculateProgress(WorkoutState state) {
    final step = state.currentStep;
    if (step == null || step.durationSeconds == 0) return 0.0;
    
    final passed = step.durationSeconds - state.currentStepRemainingSeconds;
    return (passed / step.durationSeconds).clamp(0.0, 1.0);
  }
}
