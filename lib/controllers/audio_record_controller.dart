import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:record_poc/applications/audio_recorder_service.dart';
import 'package:record_poc/state/audio_record_state.dart';

///
/// TODO:
/// 1. 分離關注點: 拆分 Controller 為  PlaybackService, FileService
/// 2. 增加資源管理: 實現 dispose 方法清理資源
/// 3. 完善錯誤處理: 在狀態中加入錯誤信息
/// 4. 改進文件管理: 使用時間戳生成唯一文件名
/// 5. 增強狀態模型: 加入播放進度、錄音時長等信息
/// 6. 引入介面抽象: 便於測試和平台適配
///

final audioRecordControllerProvider =
    AutoDisposeNotifierProvider<AudioRecordController, AudioRecordState>(
      () => AudioRecordController(),
    );

class AudioRecordController extends AutoDisposeNotifier<AudioRecordState> {

  @override
  AudioRecordState build() {
    final audioRecorderService = ref.read(audioRecorderServiceProvider);
    audioRecorderService.setPlayerStateCallback((playerState) {
      if (playerState.processingState == ProcessingState.ready) {
        state = state.copyWith(isPlaying: true);
      }
      if (playerState.processingState == ProcessingState.buffering) {
        state = state.copyWith(isLoading: true);
      }
      if (playerState.processingState == ProcessingState.completed) {
        state = state.copyWith(isPlaying: false);
      }
      if (playerState.processingState == ProcessingState.idle) {
        state = state.copyWith(isLoading: false, isPlaying: false);
      }
    });
    
    return const AudioRecordState(
      isRecording: false,
      isLoading: false,
      isPlaying: false,
    );
  }

  Future<void> startRecording() async {
    try {
      final audioRecorderService = ref.read(audioRecorderServiceProvider);
      await audioRecorderService.startRecording();
      state = state.copyWith(isRecording: true, completedAudioFilePath: null);
    } catch (e) {
      state = state.copyWith(isRecording: false, completedAudioFilePath: null);
      log(e.toString());
      rethrow;
    }
  }

  Future<void> stopRecording() async {
    final audioRecorderService = ref.read(audioRecorderServiceProvider);
    String? audioFilePath = await audioRecorderService.stopRecording();
    state = state.copyWith(
      isRecording: false,
      completedAudioFilePath: audioFilePath,
    );
  }

  Future<void> togglePlayAudio() async {
    final audioRecorderService = ref.read(audioRecorderServiceProvider);
    if (state.isPlaying) {
      await audioRecorderService.stopAudio();
    } else {
      await audioRecorderService.playAudio(state.completedAudioFilePath!);
    }
  }
}
