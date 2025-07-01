import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:record/record.dart';
import 'package:record_poc/data/repository/audio_recorder_repository.dart';

final audioRecorderRepositoryProvider = Provider<AudioRecorderRepository>(
  (ref) => AudioRecorderRepositoryImpl(),
);

final class AudioRecorderRepositoryImpl extends AudioRecorderRepository {
  final AudioRecorder _audioRecorder = AudioRecorder();

  Future<bool> _hasPermission() async {
    try {
      final hasPermission = await _audioRecorder.hasPermission();
      return hasPermission;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> startRecording(String audioFilePath) async {
    try {
      final hasPermission = await _hasPermission();
      if (!hasPermission) {
        throw Exception('No permission to record audio');
      }
      await _audioRecorder.start(RecordConfig(), path: audioFilePath);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String?> stopRecording() async {
    try {
      final audioFilePath = await _audioRecorder.stop();
      return audioFilePath;
    } catch (e) {
      rethrow;
    }
  }
}
