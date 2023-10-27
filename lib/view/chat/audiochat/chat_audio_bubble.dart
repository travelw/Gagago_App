// BubbleNormalAudio(
// color: Color(0xFFE8E8EE),
// duration: messages[index].duration == null ? 0.0 : messages[index].duration!.inSeconds.toDouble(),
// position: messages[index].position == null ? 0.0 : messages[index].position!.inSeconds.toDouble(),
// isPlaying: messages[index].isPlaying ?? false,
// isLoading: messages[index].isLoading ?? false,
// isPause: messages[index].isPause ?? false,
// onSeekChanged: (double value) {
// print("value --> $value");
// setState(() {
// if (messages[index].audioPlayer != null) {
// messages[index].audioPlayer!.seek(Duration(seconds: value.toInt()));
// }
// });
// },
// onPlayPauseButtonClick: () {
// _messagePlayAudio(index);
// // _currentPlayAudio(utf8.decode(base64.decode(messages[index].message.toString())));
// },
// sent: true,
// )

import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:gagagonew/view/chat/audiochat/chat_globals.dart';
import 'package:just_audio/just_audio.dart';

class ChatAudioBubble extends StatefulWidget {

   ChatAudioBubble({Key? key, required this.path}) : super(key: key);

  String path;

  @override
  State<ChatAudioBubble> createState() => _CHatAudioBubbleState();
}

class _CHatAudioBubbleState extends State<ChatAudioBubble> {

  final player = AudioPlayer();
  Duration? duration;

  @override
  void initState() {
    super.initState();
    player.setFilePath(widget.path).then((value) {
      setState(() {
        duration = value;
      });
    });
  }


    @override
    Widget build(BuildContext context) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(width: MediaQuery.of(context).size.width * 0.4),
            Expanded(
              child: Container(
                height: 45,
                padding: const EdgeInsets.only(left: 12, right: 18),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(ChatGlobals.borderRadius - 10),
                  color: Colors.black,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // const SizedBox(height: 4),
                    Row(
                      children: [
                        StreamBuilder<PlayerState>(
                          stream: player.playerStateStream,
                          builder: (context, snapshot) {
                            final playerState = snapshot.data;
                            final processingState = playerState?.processingState;
                            final playing = playerState?.playing;
                            if (processingState == ProcessingState.loading ||
                                processingState == ProcessingState.buffering) {
                              return GestureDetector(
                                child: const Icon(Icons.play_arrow),
                                onTap: player.play,
                              );
                            } else if (playing != true) {
                              return GestureDetector(
                                child: const Icon(Icons.play_arrow),
                                onTap: player.play,
                              );
                            } else if (processingState !=
                                ProcessingState.completed) {
                              return GestureDetector(
                                child: const Icon(Icons.pause),
                                onTap: player.pause,
                              );
                            } else {
                              return GestureDetector(
                                child: const Icon(Icons.replay),
                                onTap: () {
                                  player.seek(Duration.zero);
                                },
                              );
                            }
                          },
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: StreamBuilder<Duration>(
                            stream: player.positionStream,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Column(
                                  children: [
                                    const SizedBox(height: 4),
                                    LinearProgressIndicator(
                                      value: snapshot.data!.inMilliseconds /
                                          (duration?.inMilliseconds ?? 1),
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          prettyDuration(
                                              snapshot.data! == Duration.zero
                                                  ? duration ?? Duration.zero
                                                  : snapshot.data!),
                                          style: const TextStyle(
                                            fontSize: 10,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        const Text(
                                          "M4A",
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              } else {
                                return const LinearProgressIndicator();
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
  }

  String prettyDuration(Duration d) {
    var min = d.inMinutes < 10 ? "0${d.inMinutes}" : d.inMinutes.toString();
    var sec = d.inSeconds < 10 ? "0${d.inSeconds}" : d.inSeconds.toString();
    return min + ":" + sec;
  }
}





