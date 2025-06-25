import 'dart:io';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

// TODO: refactor
// TODO: isPlaying 轉換狀態有延遲
// TODO: 播放完畢沒有回到 isPlaying true
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AudioRecorder _audioRecorder = AudioRecorder();
  final AudioPlayer _audioPlayer = AudioPlayer();

  bool _isRecording = false;
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
              // TODO: add emoji here
              child: const Text("No Audio Recording Found : ("),
            ),
        ],
      ),
    );
  }

  Widget _buildRecordButton() {
    return FloatingActionButton(
      onPressed: () async {
        if (_isRecording) {
          String? audioFilePath = await _audioRecorder.stop();
          if (audioFilePath != null) {
            setState(() {
              _isRecording = false;
              _completedAudioFilePath = audioFilePath;
            });
          }
        } else {
          if (await _audioRecorder.hasPermission()) {
            final Directory appDocumentsDirectory =
                await getApplicationDocumentsDirectory();
            final String audioFilePath = p.join(
              appDocumentsDirectory.path,
              "recording.wav",
            );
            await _audioRecorder.start(RecordConfig(), path: audioFilePath);
            setState(() {
              _isRecording = true;
              _completedAudioFilePath = null;
            });
          }
        }
      },
      child: _isRecording ? const Icon(Icons.mic_off) : const Icon(Icons.mic),
    );
  }
}
