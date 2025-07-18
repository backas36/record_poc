import 'package:just_audio/just_audio.dart';

typedef PlayerStateCallback = void Function(PlayerState state);

abstract interface class AudioPlayerRepository {
  Future<void> playAudio(String audioFilePath);

  Future<void> stopAudio();

  void setPlayerStateCallback(PlayerStateCallback callback);

  void dispose();
}
