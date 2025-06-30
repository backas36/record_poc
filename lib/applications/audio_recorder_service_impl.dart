abstract class AudioRecorderServiceImpl {
  Future<void> startRecording();

  Future<String?> stopRecording();

  Future<void> playAudio(String audioFilePath);

  Future<void> stopAudio();
}
