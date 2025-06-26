import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:record_poc/controllers/audio_record_controller.dart';

// TODO: refactor
// TODO: isPlaying 轉換狀態有延遲
// TODO: 播放完畢沒有回到 isPlaying true
class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _buildRecordButton(),
      body: _buildPlayAudio(),
    );
  }

  Widget _buildPlayAudio() {
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

    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (isLoading) const CircularProgressIndicator(),
          if (completedAudioFilePath != null)
            MaterialButton(
              onPressed: () async {
                ref
                    .read(audioRecordControllerProvider.notifier)
                    .togglePlayAudio();
              },
              color: Theme.of(context).colorScheme.primary,
              child: Text(
                isPlaying ? "Stop Audio" : "Play Audio",
                style: TextStyle(color: Colors.white),
              ),
            ),
          if (completedAudioFilePath == null)
            MaterialButton(
              onPressed: () {},
              child: const Text("No Audio Recording Found 😀 "),
            ),
        ],
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
