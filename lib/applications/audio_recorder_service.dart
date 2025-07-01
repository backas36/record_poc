import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:record_poc/applications/audio_recorder_service_impl.dart';
import 'package:record_poc/data/repository/audio_player_repository.dart';
import 'package:record_poc/data/repository/audio_player_repository_impl.dart';
import 'package:record_poc/data/repository/audio_recorder_repository.dart';

final audioRecorderServiceProvider = Provider<AudioRecorderService>((ref) {
  final audioRecorderRepository = ref.read(audioRecorderRepositoryProvider);
  final audioPlayerRepository = ref.read(audioPlayerRepositoryProvider);
  return AudioRecorderService(audioRecorderRepository, audioPlayerRepository);
});

final class AudioRecorderService extends AudioRecorderServiceImpl {
  final AudioRecorderRepository _audioRecorderRepository;
  final AudioPlayerRepository _audioPlayerRepository;

  AudioRecorderService(
    this._audioRecorderRepository,
    this._audioPlayerRepository,
  );

  @override
  Future<void> playAudio(String audioFilePath) async {
    try {
      await _audioPlayerRepository.playAudio(audioFilePath);
    } catch (e) {
      throw (e.toString());
    }
  }

  @override
  Future<void> stopAudio() async {
    try {
      await _audioPlayerRepository.stopAudio();
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
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final Directory appDocumentsDirectory =
          await getApplicationDocumentsDirectory();
      String? audioFilePath = p.join(
        appDocumentsDirectory.path,
        "recording_$timestamp.wav",
      );
      await _audioRecorderRepository.startRecording(audioFilePath);
    } catch (e) {
      throw (e.toString());
    }
  }

  @override
  void setPlayerStateCallback(PlayerStateCallback callback) {
    _audioPlayerRepository.setPlayerStateCallback(callback);
  }
}
