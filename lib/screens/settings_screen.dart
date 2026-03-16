import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/settings.dart';
import '../models/mission.dart';
import '../providers/settings_provider.dart';
import '../core/voice_coach.dart';
import '../core/widgets/background_wrapper.dart';
import '../core/widgets/glass_card.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  static const List<int> _accentColors = [
    0xFF34C759, // Green
    0xFF0A84FF, // Blue
    0xFFFF375F, // Rose
    0xFFFFD60A, // Yellow
    0xFFBF5AF2, // Purple
    0xFFFF9F0A, // Orange
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final settingsNotifier = ref.read(settingsProvider.notifier);
    final voiceCoach = ref.read(voiceCoachProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.transparent,
      ),
      body: BackgroundWrapper(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              _SectionHeader(title: 'AI Trainer'),
              GlassCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text('Trainer Personality', style: TextStyle(color: Colors.white70)),
                    const SizedBox(height: 12),
                    SegmentedButton<TrainerPersonality>(
                      segments: const [
                        ButtonSegment(value: TrainerPersonality.calm, label: Text('Calm')),
                        ButtonSegment(value: TrainerPersonality.drill, label: Text('Drill')),
                        ButtonSegment(value: TrainerPersonality.sarcastic, label: Text('Sarc')),
                        ButtonSegment(value: TrainerPersonality.oldSchool, label: Text('Old')),
                      ],
                      selected: {settings.trainerPersonality},
                      onSelectionChanged: (value) => settingsNotifier.updateSettings(trainerPersonality: value.first),
                    ),
                    const Divider(height: 32, color: Colors.white10),
                    const Text('Trainer Voice', style: TextStyle(color: Colors.white70)),
                    const SizedBox(height: 8),
                    FutureBuilder<List<Map<String, String>>>(
                      future: voiceCoach.getAvailableVoices(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) return const LinearProgressIndicator();
                        final voices = snapshot.data!;
                        
                        return DropdownButtonFormField<String>(
                          dropdownColor: Colors.grey[900],
                          initialValue: settings.voiceName,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 12),
                          ),
                          hint: const Text('Select a natural voice', style: TextStyle(color: Colors.white54)),
                          items: voices.map((v) => DropdownMenuItem(
                            value: v['name'],
                            child: Text(v['name']!, style: const TextStyle(fontSize: 12, color: Colors.white)),
                          )).toList(),
                          onChanged: (name) {
                            final voice = voices.firstWhere((v) => v['name'] == name);
                            settingsNotifier.updateSettings(
                              voiceName: voice['name'],
                              voiceLocale: voice['locale'],
                            );
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.volume_up, size: 18),
                        label: const Text('Test Voice'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white24),
                        ),
                        onPressed: () {
                          voiceCoach.speak(
                            "Mission control to trainee. Systems online. Let's move!",
                            personality: settings.trainerPersonality,
                            duckAudio: settings.duckAudio,
                            voiceName: settings.voiceName,
                            voiceLocale: settings.voiceLocale,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              _SectionHeader(title: 'Mission Configuration'),
              GlassCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Global Difficulty', style: TextStyle(color: Colors.white70)),
                    const SizedBox(height: 12),
                    SegmentedButton<Difficulty>(
                      segments: const [
                        ButtonSegment(value: Difficulty.beginner, label: Text('Beginner')),
                        ButtonSegment(value: Difficulty.intermediate, label: Text('Interm.')),
                        ButtonSegment(value: Difficulty.advanced, label: Text('Advanc.')),
                      ],
                      selected: {settings.globalDifficulty},
                      onSelectionChanged: (value) => settingsNotifier.updateSettings(globalDifficulty: value.first),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              _SectionHeader(title: 'Appearance'),
              GlassCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Accent Color', style: TextStyle(color: Colors.white)),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 40,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _accentColors.length,
                        separatorBuilder: (context, index) => const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          final color = _accentColors[index];
                          final isSelected = settings.accentColor == color;
                          return GestureDetector(
                            onTap: () => settingsNotifier.updateSettings(accentColor: color),
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Color(color),
                                shape: BoxShape.circle,
                                border: isSelected ? Border.all(color: Colors.white, width: 3) : null,
                                boxShadow: isSelected ? [BoxShadow(color: Color(color).withAlpha((0.5 * 255).toInt()), blurRadius: 10)] : null,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const Divider(height: 32, color: Colors.white10),
                    ListTile(
                      title: const Text('Font Family', style: TextStyle(color: Colors.white)),
                      contentPadding: EdgeInsets.zero,
                      trailing: DropdownButton<String>(
                        dropdownColor: Colors.grey[900],
                        value: settings.fontFamily,
                        items: ['Inter', 'Roboto', 'Outfit', 'System'].map((f) => DropdownMenuItem(value: f, child: Text(f))).toList(),
                        onChanged: (val) => settingsNotifier.updateSettings(fontFamily: val),
                      ),
                    ),
                    const Divider(color: Colors.white10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Font Size Scale', style: TextStyle(color: Colors.white)),
                        Text('${(settings.fontSizeScale * 100).toInt()}%', style: const TextStyle(color: Colors.white70)),
                      ],
                    ),
                    Slider(
                      value: settings.fontSizeScale,
                      min: 0.8,
                      max: 1.4,
                      divisions: 6,
                      onChanged: (val) => settingsNotifier.updateSettings(fontSizeScale: val),
                    ),
                    const Divider(color: Colors.white10),
                    const Text('Corner Radius', style: TextStyle(color: Colors.white)),
                    Slider(
                      value: settings.borderRadius,
                      min: 0,
                      max: 40,
                      onChanged: (val) => settingsNotifier.updateSettings(borderRadius: val),
                    ),
                    const Divider(color: Colors.white10),
                    const Text('Glass Intensity', style: TextStyle(color: Colors.white)),
                    Slider(
                      value: settings.glassIntensity,
                      min: 0.0,
                      max: 1.0,
                      onChanged: (val) => settingsNotifier.updateSettings(glassIntensity: val),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              _SectionHeader(title: 'Physical Feedback'),
              GlassCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SwitchListTile(
                      title: const Text('Haptic Feedback', style: TextStyle(color: Colors.white)),
                      value: settings.hapticsEnabled,
                      contentPadding: EdgeInsets.zero,
                      onChanged: (val) => settingsNotifier.updateSettings(hapticsEnabled: val),
                    ),
                    if (settings.hapticsEnabled) ...[
                      const Divider(color: Colors.white10),
                      const SizedBox(height: 12),
                      const Text('Haptic Intensity', style: TextStyle(color: Colors.white70, fontSize: 13)),
                      const SizedBox(height: 12),
                      SegmentedButton<HapticIntensity>(
                        segments: const [
                          ButtonSegment(value: HapticIntensity.light, label: Text('Light')),
                          ButtonSegment(value: HapticIntensity.medium, label: Text('Med')),
                          ButtonSegment(value: HapticIntensity.heavy, label: Text('Heavy')),
                        ],
                        selected: {settings.hapticIntensity},
                        onSelectionChanged: (val) => settingsNotifier.updateSettings(hapticIntensity: val.first),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: Colors.white54,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
