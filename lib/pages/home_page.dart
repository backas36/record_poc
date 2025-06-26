import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:record_poc/controllers/audio_record_controller.dart';
import 'package:record_poc/widgets/play_audio_widget.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    final completedAudioFilePath = ref.watch(
      audioRecordControllerProvider.select(
        (value) => value.completedAudioFilePath,
      ),
    );
    final isPlaying = ref.watch(
      audioRecordControllerProvider.select((value) => value.isPlaying),
    );

    final isLoading = ref.watch(
      audioRecordControllerProvider.select((value) => value.isLoading),
    );
    return Scaffold(
      floatingActionButton: _buildRecordButton(),
      body: PlayAudioWidget(
        isLoading: isLoading,
        completedAudioFilePath: completedAudioFilePath,
        isPlaying: isPlaying,
        togglePlayAudio: () async {
          ref.read(audioRecordControllerProvider.notifier).togglePlayAudio();
        },
      ),
    );
  }

  Widget _buildRecordButton() {
    final isRecording = ref.watch(
      audioRecordControllerProvider.select((value) => value.isRecording),
    );
    return FloatingActionButton(
      onPressed: () async {
        if (isRecording) {
          ref.read(audioRecordControllerProvider.notifier).stopRecording();
        } else {
          ref.read(audioRecordControllerProvider.notifier).startRecording();
        }
      },
      child: isRecording ? const Icon(Icons.mic_off) : const Icon(Icons.mic),
    );
  }
}
