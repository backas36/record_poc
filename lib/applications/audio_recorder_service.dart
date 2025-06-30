import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:record_poc/applications/audio_recorder_service_impl.dart';

final audioRecorderServiceProvider = Provider<AudioRecorderService>(
  (ref) => AudioRecorderService(),
);

final class AudioRecorderService extends AudioRecorderServiceImpl {
  final AudioRecorder _audioRecorder = AudioRecorder();
  final AudioPlayer _audioPlayer = AudioPlayer();
  PlayerStateCallback? _playerStateCallback;

  AudioRecorderService() {
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
      final audioFilePath = await _audioRecorder.stop();
      return audioFilePath;
    } catch (e) {
      throw (e.toString());
    }
  }

  @override
  Future<void> startRecording() async {
    try {
      final hasMicPermission = await _hasPermission();
      if (hasMicPermission) {
        final Directory appDocumentsDirectory =
            await getApplicationDocumentsDirectory();
        String? audioFilePath = p.join(
          appDocumentsDirectory.path,
          "recording.wav",
        );
        await _audioRecorder.start(RecordConfig(), path: audioFilePath);
      }
    } catch (e) {
      throw (e.toString());
    }
  }

  @override
  void setPlayerStateCallback(PlayerStateCallback callback) {
    _playerStateCallback = callback;
  }

  Future<bool> _hasPermission() async {
    try {
      final hasPermission = await _audioRecorder.hasPermission();
      return hasPermission;
    } catch (e) {
      throw (e.toString());
    }
  }
}
