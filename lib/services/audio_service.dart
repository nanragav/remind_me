import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import '../models/enums.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> initialize() async {
    await _audioPlayer.setReleaseMode(ReleaseMode.stop);
  }

  Future<void> playNotificationSound({
    SoundType soundType = SoundType.chime,
  }) async {
    try {
      switch (soundType) {
        case SoundType.chime:
          // Try custom chime first, fallback to system sound
          try {
            await _audioPlayer.play(AssetSource('sounds/chime.mp3'));
          } catch (e) {
            await SystemSound.play(SystemSoundType.click);
          }
          break;
        case SoundType.bell:
          try {
            await _audioPlayer.play(AssetSource('sounds/bell.mp3'));
          } catch (e) {
            await SystemSound.play(SystemSoundType.alert);
          }
          break;
        case SoundType.alarm:
          try {
            await _audioPlayer.play(AssetSource('sounds/alarm.mp3'));
          } catch (e) {
            await SystemSound.play(SystemSoundType.alert);
          }
          break;
        case SoundType.silent:
          // Do nothing for silent
          return;
      }
    } catch (e) {
      // Final fallback to system sound if all else fails
      if (soundType != SoundType.silent) {
        await SystemSound.play(SystemSoundType.alert);
      }
    }
  }

  Future<void> previewSound(SoundType soundType) async {
    await playNotificationSound(soundType: soundType);
  }

  Future<void> playChime() async {
    await playNotificationSound(soundType: SoundType.chime);
  }

  Future<void> playCustomSound(String assetPath) async {
    try {
      await _audioPlayer.play(AssetSource(assetPath));
    } catch (e) {
      print('Error playing custom sound: $e');
      await SystemSound.play(SystemSoundType.alert);
    }
  }

  Future<void> stopSound() async {
    await _audioPlayer.stop();
  }

  String getSoundDisplayName(SoundType soundType) {
    switch (soundType) {
      case SoundType.chime:
        return 'Chime';
      case SoundType.bell:
        return 'Bell';
      case SoundType.alarm:
        return 'Alarm';
      case SoundType.silent:
        return 'Silent';
    }
  }

  void dispose() {
    _audioPlayer.dispose();
  }
}
