import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:audio_session/audio_session.dart';
import '../models/settings.dart';

class VoiceCoach {
  final FlutterTts _tts = FlutterTts();
  bool _isInit = false;

  VoiceCoach() {
    _init();
  }

  Future<void> _init() async {
    final session = await AudioSession.instance;
    await session.configure(
      const AudioSessionConfiguration(
        avAudioSessionCategory: AVAudioSessionCategory.playback,
        avAudioSessionCategoryOptions: AVAudioSessionCategoryOptions.duckOthers,
        avAudioSessionMode: AVAudioSessionMode.spokenAudio,
        avAudioSessionRouteSharingPolicy:
            AVAudioSessionRouteSharingPolicy.defaultPolicy,
        avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
        androidAudioAttributes: AndroidAudioAttributes(
          contentType: AndroidAudioContentType.speech,
          usage: AndroidAudioUsage.assistant,
        ),
        androidAudioFocusGainType:
            AndroidAudioFocusGainType.gainTransientMayDuck,
      ),
    );

    await _tts.setLanguage("en-US");
    await _tts.setSpeechRate(0.5);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);
    _isInit = true;
  }

  Future<void> speak(
    String text, {
    TrainerPersonality personality = TrainerPersonality.drill,
    bool duckAudio = true,
    String? voiceName,
    String? voiceLocale,
  }) async {
    if (!_isInit) await _init();

    // Set voice if provided
    if (voiceName != null && voiceLocale != null) {
      await _tts.setVoice({"name": voiceName, "locale": voiceLocale});
    } else {
      await _tts.setLanguage("en-US");
    }

    // Adjust pitch/rate/voice based on personality archetype
    switch (personality) {
      case TrainerPersonality.drill:
        await _tts.setVoice({"name": "en-us-x-tpd-local", "locale": "en-US"});
        await _tts.setPitch(1.0);
        await _tts.setSpeechRate(0.5);
        break;
      case TrainerPersonality.calm:
        await _tts.setVoice({"name": "en-gb-x-gba-local", "locale": "en-GB"});
        await _tts.setPitch(1.0);
        await _tts.setSpeechRate(0.45);
        break;
      case TrainerPersonality.sarcastic:
        await _tts.setVoice({"name": "en-us-x-iol-local", "locale": "en-US"});
        await _tts.setPitch(1.3);
        await _tts.setSpeechRate(0.5);
        break;
      case TrainerPersonality.oldSchool:
        await _tts.setVoice({"name": "en-au-x-aud-local", "locale": "en-AU"});
        await _tts.setPitch(1.2);
        await _tts.setSpeechRate(0.5);
        break;
    }

    if (duckAudio) {
      final session = await AudioSession.instance;
      await session.setActive(true);
    }

    await _tts.speak(text);
  }

  Future<List<Map<String, String>>> getAvailableVoices() async {
    if (!_isInit) await _init();
    try {
      List<dynamic> voices = await _tts.getVoices;
      return voices
          .map((v) => {
                "name": v["name"].toString(),
                "locale": v["locale"].toString(),
              })
          .where((v) => v["locale"]!.contains("en"))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> stop() async {
    await _tts.stop();
    final session = await AudioSession.instance;
    await session.setActive(false);
  }
}

final voiceCoachProvider = Provider<VoiceCoach>((ref) {
  return VoiceCoach();
});
