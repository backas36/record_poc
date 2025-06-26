import 'package:flutter/material.dart';

class PlayAudioWidget extends StatelessWidget {
  const PlayAudioWidget({
    super.key,
    required this.isLoading,
    required this.completedAudioFilePath,
    required this.isPlaying,
    required this.togglePlayAudio,
  });

  final bool isLoading;
  final String? completedAudioFilePath;
  final bool isPlaying;
  final VoidCallback togglePlayAudio;

  @override
  Widget build(BuildContext context) {
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
                togglePlayAudio();
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
}
