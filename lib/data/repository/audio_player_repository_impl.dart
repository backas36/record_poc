import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:record_poc/data/repository/audio_player_repository.dart';

/// ref.onDispose() 的觸發時機：
///   1. 使用者離開頁面
///     AudioRecordPage → 其他頁面 → Widget 被銷毀 → 觸發 onDispose
///   2. App 進入背景
///     App 最小化 → Widget 樹重建 → 觸發 onDispose
///   3. Hot Reload 開發時
///     修改代碼 → 重新載入 → 觸發 onDispose
final audioPlayerRepositoryProvider =
    AutoDisposeProvider<AudioPlayerRepository>((ref) {
      final repository = AudioPlayerImplRepository();

      ref.onDispose(() {
        repository.dispose();
      });

      return repository;
    });

final class AudioPlayerImplRepository implements AudioPlayerRepository {
  final AudioPlayer _audioPlayer = AudioPlayer();
  PlayerStateCallback? _playerStateCallback;
  StreamSubscription<PlayerState>? _playerStateSubscription;

  AudioPlayerImplRepository() {
    _playerStateSubscription = _audioPlayer.playerStateStream.listen((
      playerState,
    ) {
      _playerStateCallback?.call(playerState);
    });
  }

  @override
  Future<void> playAudio(String audioFilePath) async {
    try {
      await _audioPlayer.setFilePath(audioFilePath);
      await _audioPlayer.play();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> stopAudio() async {
    try {
      await _audioPlayer.stop();
    } catch (e) {
      rethrow;
    }
  }

  @override
  void setPlayerStateCallback(PlayerStateCallback callback) {
    _playerStateCallback = callback;
  }

  @override
  void dispose() {
    // 先取消 Stream 訂閱，避免在 AudioPlayer dispose 後仍收到事件
    _playerStateSubscription?.cancel();
    _playerStateSubscription = null;

    // 清空回調引用，防止已釋放的物件仍被回調，避免潛在的 null reference
    _playerStateCallback = null;

    // 釋放 AudioPlayer 資源，這會釋放音頻相關的原生資源（記憶體、CPU、音頻設備等）
    _audioPlayer.dispose();
  }
}
