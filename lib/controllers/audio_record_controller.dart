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

/// 完整的生命週期流程

/// 1. 用戶進入頁面
/// 2. Controller build() 被調用
/// 3. ref.watch 建立依賴 + 設定回調
/// 4. Service 提供功能

/// 5. 用戶離開頁面
/// 6. Service 被釋放
/// 7. Controller 偵測到依賴變化
/// 8. Controller 重建並設定新的回調
