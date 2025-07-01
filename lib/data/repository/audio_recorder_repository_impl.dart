abstract class AudioRecorderRepositoryImpl {
  Future<void> startRecording(String audioFilePath);

  Future<String?> stopRecording();
}
