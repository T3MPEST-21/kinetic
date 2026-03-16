import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/user_stats_provider.dart';
import '../providers/workout_provider.dart';
import '../providers/mission_provider.dart';
import '../models/mission.dart';
import '../core/widgets/background_wrapper.dart';
import '../core/widgets/glass_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userStats = ref.watch(userStatsProvider);
    
    // XP progress relative to next level (MVP: 150XP per level)
    final xpInCurrentLevel = userStats.xp % 150;
    final xpProgress = xpInCurrentLevel / 150.0;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Kinetic'),
        backgroundColor: Colors.transparent,
      ),
      body: BackgroundWrapper(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Flame Streak + Energy row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GlassCard(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Row(
                        children: [
                          Icon(
                            Icons.local_fire_department, 
                            color: userStats.currentStreak > 0 ? Colors.orange : Colors.grey,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${userStats.currentStreak} Day Streak',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: userStats.currentStreak > 0 ? Colors.orange : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GlassCard(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Text(
                        'Lvl ${userStats.level} • ${userStats.xp} XP', 
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 16),
                
                // XP Progress Bar
                GlassCard(
                  padding: const EdgeInsets.all(4),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: xpProgress,
                      minHeight: 8,
                      backgroundColor: Colors.white10,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),

                const Spacer(),
                
                // Daily Mission Card
                Consumer(
                  builder: (context, ref, child) {
                    final todayMission = ref.watch(todayMissionProvider);
                    
                    return GlassCard(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Today\'s Mission', style: TextStyle(color: Colors.white70, fontSize: 14)),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: todayMission.difficulty == Difficulty.advanced 
                                    ? Colors.redAccent.withAlpha((0.2 * 255).toInt())
                                    : todayMission.difficulty == Difficulty.intermediate
                                      ? Colors.orangeAccent.withAlpha((0.2 * 255).toInt())
                                      : Colors.greenAccent.withAlpha((0.2 * 255).toInt()),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  todayMission.difficulty.name.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: todayMission.difficulty == Difficulty.advanced 
                                      ? Colors.redAccent
                                      : todayMission.difficulty == Difficulty.intermediate
                                        ? Colors.orangeAccent
                                        : Colors.greenAccent,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            todayMission.title,
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            todayMission.description,
                            style: const TextStyle(color: Colors.white70, fontSize: 13),
                          ),
                          const SizedBox(height: 16),
                          const Divider(color: Colors.white10),
                          const SizedBox(height: 16),
                          FilledButton(
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              backgroundColor: Theme.of(context).colorScheme.primary,
                            ),
                            onPressed: () => _showDurationPicker(context, ref, todayMission),
                            child: const Center(
                              child: Text('Start Workout', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDurationPicker(BuildContext context, WidgetRef ref, Mission mission) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => GlassCard(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'MISSION BRIEFING',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
                fontSize: 12,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Select Target Duration',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 24),
            
            _DurationOption(
              title: 'Recommended',
              subtitle: 'Optimized for ${mission.difficulty.name}',
              icon: Icons.auto_awesome,
              onTap: () => _startWithDuration(context, ref, null),
            ),
            _DurationOption(
              title: 'Quick Burst',
              subtitle: '7 Minutes',
              icon: Icons.bolt,
              onTap: () => _startWithDuration(context, ref, 7),
            ),
            _DurationOption(
              title: 'Endurance',
              subtitle: '25 Minutes',
              icon: Icons.timer,
              onTap: () => _startWithDuration(context, ref, 25),
            ),
            
            const SizedBox(height: 16),
            const SizedBox(height: 16),
            const Divider(color: Colors.white10),
            const SizedBox(height: 16),
            
            _CustomDurationPicker(
              onStart: (mins) => _startWithDuration(context, ref, mins),
            ),

            const SizedBox(height: 24),
            Center(
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _startWithDuration(BuildContext context, WidgetRef ref, int? minutes) {
    if (minutes != null) {
      ref.read(missionsProvider.notifier).updateTargetDuration(minutes);
    }
    
    // Tiny delay to ensure provider state updates before picking up the workout
    Future.delayed(const Duration(milliseconds: 50), () {
      final mission = ref.read(todayMissionProvider);
      ref.read(workoutProvider.notifier).startSession(mission.workout);
      context.pop(); // Close bottom sheet
      context.push('/workout');
    });
  }
}

class _DurationOption extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _DurationOption({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha((0.05 * 255).toInt()),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white10),
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.white70),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                  Text(subtitle, style: const TextStyle(color: Colors.white54, fontSize: 12)),
                ],
              ),
              const Spacer(),
              const Icon(Icons.chevron_right, color: Colors.white24),
            ],
          ),
        ),
      ),
    );
  }
}

class _CustomDurationPicker extends StatefulWidget {
  final Function(int) onStart;
  const _CustomDurationPicker({required this.onStart});

  @override
  State<_CustomDurationPicker> createState() => _CustomDurationPickerState();
}

class _CustomDurationPickerState extends State<_CustomDurationPicker> {
  double _currentVal = 15.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Custom Session', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withAlpha((0.2 * 255).toInt()),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                '${_currentVal.round()} min',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Slider(
          value: _currentVal,
          min: 5,
          max: 60,
          divisions: 55,
          activeColor: Theme.of(context).colorScheme.primary,
          inactiveColor: Colors.white10,
          onChanged: (val) => setState(() => _currentVal = val),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            icon: const Icon(Icons.play_arrow_rounded),
            label: const Text('Start Custom Mission'),
            onPressed: () => widget.onStart(_currentVal.round()),
            style: FilledButton.styleFrom(
              backgroundColor: Colors.white10,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
      ],
    );
  }
}
