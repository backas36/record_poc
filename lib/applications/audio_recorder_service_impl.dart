import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:record_poc/applications/audio_recorder_service.dart';
import 'package:record_poc/data/repository/audio_player_repository.dart';
import 'package:record_poc/data/repository/audio_player_repository_impl.dart';
import 'package:record_poc/data/repository/audio_recorder_repository.dart';
import 'package:record_poc/data/repository/audio_recorder_repository_impl.dart';

/// - ref.read：只讀取一次，不會監聽變化
/// - ref.watch：建立依賴關係，當 Repository 重建時 Service 也會重建
/// Repository dispose → Service 也會跟著 dispose → 完整的資源清理
final audioRecorderServiceProvider = AutoDisposeProvider<AudioRecorderService>((
  ref,
) {
  final audioRecorderRepository = ref.watch(audioRecorderRepositoryProvider);
  final audioPlayerRepository = ref.watch(audioPlayerRepositoryProvider);

  final service = AudioRecorderServiceImpl(
    audioRecorderRepository,
    audioPlayerRepository,
  );

  // 確保資源清理
  ref.onDispose(() {
    service.dispose();
  });

  return service;
});

final class AudioRecorderServiceImpl implements AudioRecorderService {
  final AudioRecorderRepository _audioRecorderRepository;
  final AudioPlayerRepository _audioPlayerRepository;
  final StreamController<PlayerState> _playerStateController =
      StreamController<PlayerState>.broadcast();

  AudioRecorderServiceImpl(
    this._audioRecorderRepository,
    this._audioPlayerRepository,
  ) {
    // 設定播放器狀態回調，轉發到 Stream
    _audioPlayerRepository.setPlayerStateCallback((playerState) {
      _playerStateController.add(playerState);
    });
  }

  @override
  Stream<PlayerState> get playerStateStream => _playerStateController.stream;

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

  void dispose() {
    _playerStateController.close();
  }
}
