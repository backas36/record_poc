import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:record_poc/applications/audio_recorder_service_impl.dart';
import 'package:record_poc/data/repository/audio_recorder_repository_impl.dart';

final audioRecorderServiceProvider = Provider<AudioRecorderService>((ref) {
  final audioRecorderRepository = ref.read(audioRecorderRepositoryProvider);
  return AudioRecorderService(audioRecorderRepository);
});

final class AudioRecorderService extends AudioRecorderServiceImpl {
  final AudioRecorderRepository _audioRecorderRepository;
  final AudioPlayer _audioPlayer = AudioPlayer();
  PlayerStateCallback? _playerStateCallback;

  AudioRecorderService(this._audioRecorderRepository) {
    _audioPlayer.playerStateStream.listen((playerState) {
      _playerStateCallback?.call(playerState);
    });
  }

  @override
  Future<void> playAudio(String audioFilePath) async {
    try {
      await _audioPlayer.setFilePath(audioFilePath);
      await _audioPlayer.play();
    } catch (e) {
      throw (e.toString());
    }
  }

  @override
  Future<void> stopAudio() async {
    try {
      await _audioPlayer.stop();
    } catch (e) {
      throw (e.toString());
    }
  }

  @override
  Future<String?> stopRecording() async {
    try {
      final audioFilePath = await _audioRecorderRepository.stopRecording();
      return audioFilePath;
    } catch (e) {
      throw (e.toString());
    }
  }

  @override
  Future<void> startRecording() async {
    try {
      final Directory appDocumentsDirectory =
          await getApplicationDocumentsDirectory();
      String? audioFilePath = p.join(
        appDocumentsDirectory.path,
        "recording.wav",
      );
      await _audioRecorderRepository.startRecording(audioFilePath);
    } catch (e) {
      throw (e.toString());
    }
  }

  @override
  void setPlayerStateCallback(PlayerStateCallback callback) {
    _playerStateCallback = callback;
  }
}
