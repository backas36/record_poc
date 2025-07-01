import 'package:record_poc/data/repository/audio_player_repository_impl.dart';

abstract class AudioRecorderServiceImpl {
  Future<void> startRecording();

  Future<String?> stopRecording();

  Future<void> playAudio(String audioFilePath);

  Future<void> stopAudio();

  void setPlayerStateCallback(PlayerStateCallback callback);
}
