import 'package:flutter/material.dart';

class RecordingButtonWidget extends StatelessWidget {
  const RecordingButtonWidget({
    super.key,
    required this.isRecording,
    required this.startRecording,
    required this.stopRecording,
  });

  final bool isRecording;
  final VoidCallback startRecording;
  final VoidCallback stopRecording;

  @override
  Widget build(BuildContext context) {
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
