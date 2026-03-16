import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/user_stats_provider.dart';
import '../core/widgets/background_wrapper.dart';
import '../core/widgets/glass_card.dart';

class AchievementsScreen extends ConsumerWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userStats = ref.watch(userStatsProvider);

    final achievements = [
      _Achievement(
        name: 'First Blood',
        description: 'Complete your first workout.',
        icon: Icons.flash_on,
        isUnlocked: userStats.totalWorkouts >= 1,
      ),
      _Achievement(
        name: 'Week Warrior',
        description: 'Maintain a 7-day streak.',
        icon: Icons.calendar_today,
        isUnlocked: userStats.longestStreak >= 7,
      ),
      _Achievement(
        name: 'Centurion',
        description: 'Complete 100 workouts.',
        icon: Icons.workspace_premium,
        isUnlocked: userStats.totalWorkouts >= 100,
      ),
      _Achievement(
        name: 'Iron Lungs',
        description: '1000 total minutes trained.',
        icon: Icons.air,
        isUnlocked: userStats.totalMinutes >= 1000,
      ),
    ];

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Achievements'),
        backgroundColor: Colors.transparent,
      ),
      body: BackgroundWrapper(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Unlock Mastery',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: ListView.builder(
                    itemCount: achievements.length,
                    itemBuilder: (context, index) {
                      final achievement = achievements[index];
                      return _AchievementTile(achievement: achievement);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Achievement {
  final String name;
  final String description;
  final IconData icon;
  final bool isUnlocked;

  _Achievement({
    required this.name,
    required this.description,
    required this.icon,
    required this.isUnlocked,
  });
}

class _AchievementTile extends StatelessWidget {
  final _Achievement achievement;

  const _AchievementTile({required this.achievement});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        color: achievement.isUnlocked ? Colors.orange : Colors.white,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: achievement.isUnlocked ? Colors.orange.withValues(alpha: 0.1) : Colors.grey.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
              child: Icon(
                achievement.isUnlocked ? achievement.icon : Icons.lock,
                color: achievement.isUnlocked ? Colors.orange : Colors.grey[600],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    achievement.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: achievement.isUnlocked ? Colors.white : Colors.grey,
                    ),
                  ),
                  Text(
                    achievement.description,
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),
            if (achievement.isUnlocked)
              const Icon(Icons.check_circle, color: Colors.green, size: 20),
          ],
        ),
      ),
    );
  }
}
