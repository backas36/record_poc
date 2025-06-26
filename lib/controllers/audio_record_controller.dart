import 'dart:developer';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:record_poc/state/audio_record_state.dart';

final audioRecordControllerProvider =
    AutoDisposeNotifierProvider<AudioRecordController, AudioRecordState>(
      () => AudioRecordController(),
    );

class AudioRecordController extends AutoDisposeNotifier<AudioRecordState> {
  final AudioRecorder _audioRecorder = AudioRecorder();
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  AudioRecordState build() {
    return const AudioRecordState(
      isRecording: false,
      isLoading: false,
      isPlaying: false,
    );
  }

  Future<void> startRecording() async {
    state = state.copyWith(isLoading: true);
    final hasMicrophonePermission = await _audioRecorder.hasPermission();
    try {
      if (hasMicrophonePermission) {
        final Directory appDocumentsDirectory =
            await getApplicationDocumentsDirectory();
        String? audioFilePath = p.join(
          appDocumentsDirectory.path,
          "recording.wav",
        );
        await _audioRecorder.start(RecordConfig(), path: audioFilePath);
        state = state.copyWith(
          isLoading: false,
          isRecording: true,
          completedAudioFilePath: null,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isRecording: false,
        completedAudioFilePath: null,
      );
      log(e.toString());
      rethrow;
    }
  }

  Future<void> stopRecording() async {
    state = state.copyWith(isLoading: true);
    String? audioFilePath = await _audioRecorder.stop();
    if (audioFilePath != null) {
      state = state.copyWith(
        isLoading: false,
        isRecording: false,
        completedAudioFilePath: audioFilePath,
      );
    }
  }

  Future<void> togglePlayAudio() async {
    if (state.isPlaying) {
      await _stopAudio();
    } else {
      await _playAudio();
    }
  }

  Future<void> _playAudio() async {
    await _audioPlayer.setFilePath(state.completedAudioFilePath!);
    await _audioPlayer.play();
    state = state.copyWith(isPlaying: true);
  }

  Future<void> _stopAudio() async {
    await _audioPlayer.stop();
    state = state.copyWith(isPlaying: false);
  }
}
