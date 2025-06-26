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
  //final AudioRecorder _audioRecorder = AudioRecorder();
  final AudioPlayer _audioPlayer = AudioPlayer();

  //final bool _isRecording = false;
  String? _completedAudioFilePath;
  bool _isPlaying = false;

  @override
  Widget build(BuildContext context) {
    debugPrint("isPlaying: $_isPlaying");
    return Scaffold(
      floatingActionButton: _buildRecordButton(),
      body: _buildPlayAudio(),
    );
  }

  Widget _buildPlayAudio() {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (_completedAudioFilePath != null)
            MaterialButton(
              onPressed: () async {
                if (_audioPlayer.playing) {
                  await _audioPlayer.stop();

                  setState(() {
                    _isPlaying = false;
                  });
                } else {
                  await _audioPlayer.setFilePath(_completedAudioFilePath!);
                  await _audioPlayer.play();
                  setState(() {
                    _isPlaying = true;
                  });
                }
              },
              color: Theme.of(context).colorScheme.primary,
              child: Text(
                _isPlaying ? "Stop Audio" : "Play Audio",
                style: TextStyle(color: Colors.white),
              ),
            ),
          if (_completedAudioFilePath == null)
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
