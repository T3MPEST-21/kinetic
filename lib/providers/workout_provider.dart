import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import '../models/settings.dart';
import '../models/workout_session.dart';
import '../models/workout_step.dart';
import '../core/voice_coach.dart';
import 'settings_provider.dart';
import 'user_stats_provider.dart';

class WorkoutState {
  final WorkoutSession? session;
  final int currentStepIndex;
  final int currentStepRemainingSeconds;
  final bool isRunning;
  final bool isFinished;
  final int totalElapsedSeconds;

  const WorkoutState({
    this.session,
    this.currentStepIndex = 0,
    this.currentStepRemainingSeconds = 0,
    this.isRunning = false,
    this.isFinished = false,
    this.totalElapsedSeconds = 0,
  });

  WorkoutStep? get currentStep {
    if (session == null || isFinished) return null;
    if (currentStepIndex >= session!.steps.length) return null;
    return session!.steps[currentStepIndex];
  }

  WorkoutStep? get nextStep {
    if (session == null || isFinished) return null;
    if (currentStepIndex + 1 >= session!.steps.length) return null;
    return session!.steps[currentStepIndex + 1];
  }

  WorkoutState copyWith({
    WorkoutSession? session,
    int? currentStepIndex,
    int? currentStepRemainingSeconds,
    bool? isRunning,
    bool? isFinished,
    int? totalElapsedSeconds,
  }) {
    return WorkoutState(
      session: session ?? this.session,
      currentStepIndex: currentStepIndex ?? this.currentStepIndex,
      currentStepRemainingSeconds: currentStepRemainingSeconds ?? this.currentStepRemainingSeconds,
      isRunning: isRunning ?? this.isRunning,
      isFinished: isFinished ?? this.isFinished,
      totalElapsedSeconds: totalElapsedSeconds ?? this.totalElapsedSeconds,
    );
  }
}

final workoutProvider = NotifierProvider<WorkoutNotifier, WorkoutState>(WorkoutNotifier.new);

class WorkoutNotifier extends Notifier<WorkoutState> {
  late final VoiceCoach _voiceCoach;
  final _chimePlayer = AudioPlayer();
  Timer? _timer;

  @override
  WorkoutState build() {
    _voiceCoach = ref.read(voiceCoachProvider);
    return const WorkoutState();
  }

  void startSession(WorkoutSession session) {
    if (session.steps.isEmpty) return;
    
    _timer?.cancel();
    state = WorkoutState(
      session: session,
      currentStepIndex: 0,
      currentStepRemainingSeconds: session.steps[0].durationSeconds,
      isRunning: true,
      isFinished: false,
      totalElapsedSeconds: 0,
    );

    _playCurrentStepVoice();
    _startTimer();
  }

  void pause() {
    _timer?.cancel();
    state = state.copyWith(isRunning: false);
  }

  void resume() {
    if (state.isFinished || state.session == null) return;
    state = state.copyWith(isRunning: true);
    _startTimer();
  }

  void stop() {
    _timer?.cancel();
    state = const WorkoutState();
  }

  void _startTimer() {
    _timer?.cancel();
    // EXACTLY 1 second interval. Apollo rule: 
    // Backend doesn't need to rebuild UI 60x a sec.
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!state.isRunning || state.isFinished) {
        timer.cancel();
        return;
      }

      final newTotalElapsed = state.totalElapsedSeconds + 1;
      final newRemaining = state.currentStepRemainingSeconds - 1;

      if (newRemaining <= 0) {
        _nextStep(newTotalElapsed);
      } else {
        // Sensory Polish: Haptic Proximity & Audio Pre-roll
        _checkSensoryTriggers(newRemaining);

        // Final Minute Pulse (Haptic every 10s in the last 60s)
        final totalSecs = state.session?.totalDurationSeconds ?? 0;
        final remainingTotal = totalSecs - newTotalElapsed;
        if (remainingTotal <= 60 && remainingTotal > 0 && remainingTotal % 10 == 0) {
          _triggerHaptics(); // Subtle pulse
        }
        
        state = state.copyWith(
          currentStepRemainingSeconds: newRemaining,
          totalElapsedSeconds: newTotalElapsed,
        );
      }
    });
  }

  void _triggerHaptics() {
    final settings = ref.read(settingsProvider);
    if (!settings.hapticsEnabled) return;

    switch (settings.hapticIntensity) {
      case HapticIntensity.light:
        HapticFeedback.lightImpact();
        break;
      case HapticIntensity.medium:
        HapticFeedback.mediumImpact();
        break;
      case HapticIntensity.heavy:
        HapticFeedback.heavyImpact();
        break;
    }
  }
  void _nextStep(int totalElapsed) {
    _triggerHaptics();
    final nextIndex = state.currentStepIndex + 1;
    
    if (state.session != null && nextIndex >= state.session!.steps.length) {
      // Workout finished
      _timer?.cancel();
      final settings = ref.read(settingsProvider);
      final msg = _getPersonalityMessage(settings.trainerPersonality, 'workout_complete');
      _playChimethenSpeak(msg, isVictory: true);
      
      state = state.copyWith(
        isFinished: true,
        isRunning: false,
        currentStepRemainingSeconds: 0,
        totalElapsedSeconds: totalElapsed,
      );

      // Save to stats & history
      ref.read(userStatsProvider.notifier).addWorkoutStats(
        missionTitle: state.session!.name,
        earnedXp: state.session!.targetXp,
        durationMinutes: (totalElapsed / 60).ceil(),
      );
      return;
    }

    final nextStep = state.session!.steps[nextIndex];
    state = state.copyWith(
      currentStepIndex: nextIndex,
      currentStepRemainingSeconds: nextStep.durationSeconds,
      totalElapsedSeconds: totalElapsed,
    );
    
    _playCurrentStepVoice();
  }

  void _playCurrentStepVoice() {
    final step = state.currentStep;
    final settings = ref.read(settingsProvider);
    if (step == null || !settings.voiceEnabled) return;
    
    String message = '';
    if (step.startVoiceMessage.isNotEmpty) {
      message = step.startVoiceMessage;
    } else {
      message = _getPersonalityMessage(
        settings.trainerPersonality, 
        step.type == StepType.rest ? 'rest_start' : 'exercise_start',
        exerciseName: step.name,
        duration: step.durationSeconds,
      );
    }
    _playChimethenSpeak(message);
  }

  void _checkSensoryTriggers(int remainingSeconds) {
    final step = state.currentStep;
    final settings = ref.read(settingsProvider);
    if (step == null) return;

    // 1. Haptic Proximity (3-2-1)
    if (settings.hapticsEnabled && remainingSeconds <= 3 && remainingSeconds > 0) {
      _triggerProximityHaptic(remainingSeconds);
    }

    // 2. Audio Pre-roll & Tips
    if (settings.voiceEnabled) {
      final halfwayPoint = step.durationSeconds ~/ 2;
      
      // AI Coach Tip at Mid-point
      if (remainingSeconds == halfwayPoint && step.coachTip.isNotEmpty) {
        _playChimethenSpeak(step.coachTip);
      } else if (remainingSeconds == halfwayPoint) {
        final msg = _getPersonalityMessage(settings.trainerPersonality, 'halfway');
        _playChimethenSpeak(msg);
      } else if (remainingSeconds == 10) {
        final msg = _getPersonalityMessage(settings.trainerPersonality, '10_seconds');
        _playChimethenSpeak(msg);
      }
    }
  }

  void _triggerProximityHaptic(int seconds) {
    // Apollo: Sharper haptics as we get closer
    switch (seconds) {
      case 3:
        HapticFeedback.lightImpact();
        break;
      case 2:
        HapticFeedback.mediumImpact();
        break;
      case 1:
        HapticFeedback.heavyImpact();
        break;
    }
  }

  Future<void> _playChimethenSpeak(String text, {bool isVictory = false}) async {
    // 1. Play Haptic Alert
    if (isVictory) {
      // Triple pulse for victory
      HapticFeedback.heavyImpact();
      Future.delayed(const Duration(milliseconds: 200), () => HapticFeedback.heavyImpact());
      Future.delayed(const Duration(milliseconds: 400), () => HapticFeedback.heavyImpact());
    } else {
      HapticFeedback.mediumImpact();
    }
    
    // 2. Play Audio Chime
    try {
      await _chimePlayer.play(AssetSource('sounds/chime.mp3'), volume: 1.0);
    } catch (e) {
      debugPrint('Chime asset missing: $e');
    }

    // 3. Speak
    Future.delayed(const Duration(milliseconds: 500), () {
      final settings = ref.read(settingsProvider);
      _voiceCoach.speak(
        text,
        personality: settings.trainerPersonality,
        duckAudio: settings.duckAudio,
        voiceName: settings.voiceName,
        voiceLocale: settings.voiceLocale,
      );
    });
  }

  String _getPersonalityMessage(TrainerPersonality p, String event, {String? exerciseName, int? duration}) {
    final random = DateTime.now().millisecond;
    
    switch (p) {
      case TrainerPersonality.drill:
        return {
          'exercise_start': [
            'Drop and give me $exerciseName! Now!',
            'Movement is life! Start $exerciseName!',
            'No excuses! $exerciseName, go go go!'
          ][random % 3],
          'rest_start': 'Take $duration seconds. Don\'t get comfortable.',
          'halfway': 'Halfway! I don\'t see sweat yet! Push harder!',
          '10_seconds': '10 seconds! Finish strong or do it again!',
          'workout_complete': 'Mision accomplished! You survived! Now get back to work tomorrow!',
        }[event] ?? '';
        
      case TrainerPersonality.calm:
        return {
          'exercise_start': 'Begin $exerciseName. Focus on your breath.',
          'rest_start': 'Well done. Rest for $duration seconds.',
          'halfway': 'You are doing great. Keep the rhythm.',
          '10_seconds': 'Almost there. Maintain your form.',
          'workout_complete': 'Session complete. Take a moment to breathe and reflect on your hard work.',
        }[event] ?? '';
        
      case TrainerPersonality.sarcastic:
        return {
          'exercise_start': [
            'Oh look, $exerciseName. My favorite. Try to look like you\'re trying.',
            'Time for $exerciseName. Don\'t hurt yourself, champ.',
            'Let\'s see some $exerciseName. Or just stand there, I guess.'
          ][random % 3],
          'rest_start': 'Take a break. You look like you need a year-long one anyway.',
          'halfway': 'Halfway done. Only another half to go. Math is fun.',
          '10_seconds': '10 seconds left. Even you can handle that.',
          'workout_complete': 'Wow, you actually finished. I was busy checking my oil, but good for you.',
        }[event] ?? '';
        
      case TrainerPersonality.oldSchool:
        return {
          'exercise_start': 'In my day, we did $exerciseName all day! Get to it!',
          'rest_start': 'Rest for $duration. I remember when rest was a luxury!',
          'halfway': 'Halfway! Show me that grit! Don\'t you dare quit!',
          '10_seconds': '10 seconds! Dig deep! Finish like a champion!',
          'workout_complete': 'That\'s what I call a workout! Outstanding discipline, soldier!',
        }[event] ?? '';
    }
  }
}
