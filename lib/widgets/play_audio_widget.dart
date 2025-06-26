import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:record_poc/controllers/audio_record_controller.dart';

class PlayAudioWidget extends ConsumerWidget {
  const PlayAudioWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
}
