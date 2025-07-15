import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:record_poc/applications/audio_recorder_service_impl.dart';
import 'package:record_poc/state/audio_record_state.dart';

final audioRecordControllerProvider =
    AutoDisposeNotifierProvider<AudioRecordController, AudioRecordState>(
      () => AudioRecordController(),
    );

class AudioRecordController extends AutoDisposeNotifier<AudioRecordState> {
  @override
  AudioRecordState build() {
    final audioRecorderService = ref.watch(audioRecorderServiceProvider);

    // 監聽播放器狀態流
    audioRecorderService.playerStateStream.listen((playerState) {
      _handlePlayerStateChange(playerState);
    });

    return const AudioRecordState(
      isRecording: false,
      isLoading: false,
      isPlaying: false,
    );
  }

  void _handlePlayerStateChange(PlayerState playerState) {
    switch (playerState.processingState) {
      case ProcessingState.ready:
        state = state.copyWith(isPlaying: true, isLoading: false);
        break;
      case ProcessingState.buffering:
      case ProcessingState.loading:
        state = state.copyWith(isLoading: true, isPlaying: false);
        break;
      case ProcessingState.completed:
        state = state.copyWith(isPlaying: false, isLoading: false);
        break;
      case ProcessingState.idle:
        state = state.copyWith(isLoading: false, isPlaying: false);
        break;
    }
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

/// 完整的生命週期流程

/// 1. 用戶進入頁面
/// 2. Controller build() 被調用
/// 3. ref.watch 建立依賴 + 監聽狀態流
/// 4. Service 初始化並設定狀態流轉發

/// 5. 用戶離開頁面
/// 6. Service 被釋放 (dispose 關閉 StreamController)
/// 7. Controller 偵測到依賴變化
/// 8. Controller 重建並重新監聽狀態流
