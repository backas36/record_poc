abstract class AudioRecorderRepository {
  Future<void> startRecording(String audioFilePath);

  Future<String?> stopRecording();
}
