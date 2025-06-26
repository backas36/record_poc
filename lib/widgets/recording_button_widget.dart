import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:record_poc/controllers/audio_record_controller.dart';

class RecordingButtonWidget extends ConsumerWidget {
  const RecordingButtonWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isRecording = ref.watch(
      audioRecordControllerProvider.select((value) => value.isRecording),
    );
    final startRecording = ref
        .read(audioRecordControllerProvider.notifier)
        .startRecording;
    final stopRecording = ref
        .read(audioRecordControllerProvider.notifier)
        .stopRecording;
    return FloatingActionButton(
      onPressed: () async {
        if (isRecording) {
          stopRecording();
        } else {
          startRecording();
        }
      },
      child: isRecording ? const Icon(Icons.mic_off) : const Icon(Icons.mic),
    );
  }
}
