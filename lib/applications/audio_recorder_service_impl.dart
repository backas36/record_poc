import 'package:just_audio/just_audio.dart';

typedef PlayerStateCallback = void Function(PlayerState state);

abstract class AudioRecorderServiceImpl {
  Future<void> startRecording();

  Future<String?> stopRecording();

  Future<void> playAudio(String audioFilePath);

  Future<void> stopAudio();
  
  void setPlayerStateCallback(PlayerStateCallback callback);
}
