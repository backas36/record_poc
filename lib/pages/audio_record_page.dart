import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:record_poc/widgets/play_audio_widget.dart';
import 'package:record_poc/widgets/recording_button_widget.dart';

class AudioRecordPage extends ConsumerStatefulWidget {
  const AudioRecordPage({super.key});

  @override
  ConsumerState<AudioRecordPage> createState() => _AudioRecordPageState();
}

class _AudioRecordPageState extends ConsumerState<AudioRecordPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: RecordingButtonWidget(),
      body: PlayAudioWidget(),
    );
  }
}
