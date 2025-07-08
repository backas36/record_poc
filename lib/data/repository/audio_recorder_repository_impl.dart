import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:record/record.dart';
import 'package:record_poc/data/repository/audio_recorder_repository.dart';

final audioRecorderRepositoryProvider =
    AutoDisposeProvider<AudioRecorderRepository>((ref) {
      final repository = AudioRecorderImplRepository();

      // 確保麥克風資源被正確釋放
      ref.onDispose(() {
        repository.dispose();
      });

      return repository;
    });

final class AudioRecorderImplRepository implements AudioRecorderRepository {
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

  @override
  void dispose() {
    /// 🎙️ 釋放 AudioRecorder 資源
    /// - 停止任何進行中的錄音
    /// - 釋放麥克風資源
    /// - 清理平台原生資源
    /// - 讓其他 app 可以使用麥克風
    _audioRecorder.dispose();
  }
}
