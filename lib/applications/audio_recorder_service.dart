import 'package:just_audio/just_audio.dart';

abstract interface class AudioRecorderService {
  Future<void> startRecording();

  Future<String?> stopRecording();

  Future<void> playAudio(String audioFilePath);

  Future<void> stopAudio();

  Stream<PlayerState> get playerStateStream;
}
