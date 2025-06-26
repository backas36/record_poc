import 'package:freezed_annotation/freezed_annotation.dart';

part 'audio_record_state.freezed.dart';

@freezed
class AudioRecordState with _$AudioRecordState {
  const factory AudioRecordState({
    required bool isRecording,
    required bool isPlaying,
    required bool isLoading,
    String? completedAudioFilePath,
  }) = _AudioRecordState;
}
