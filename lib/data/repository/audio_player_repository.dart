import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:record_poc/data/repository/audio_player_repository_impl.dart';

final audioPlayerRepositoryProvider = Provider<AudioPlayerRepository>(
  (ref) => AudioPlayerRepository(),
);

final class AudioPlayerRepository extends AudioPlayerRepositoryImpl {
  final AudioPlayer _audioPlayer = AudioPlayer();
  PlayerStateCallback? _playerStateCallback;

  AudioPlayerRepository() {
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
    _audioPlayer.dispose();
  }
}
