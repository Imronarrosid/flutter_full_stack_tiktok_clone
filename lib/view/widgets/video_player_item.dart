
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerItem extends StatefulWidget {
  final String videoUrl;
  const VideoPlayerItem({super.key, required this.videoUrl});

  @override
  State<VideoPlayerItem> createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  late VideoPlayerController videoPlayerController;
  bool play = true;
  bool visibility = false;
  double opacity = 0.0;
  bool _isVideoEnded = false;

  @override
  void initState() {
    super.initState();
    videoPlayerController = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((value) {
        videoPlayerController.play();
        videoPlayerController.setVolume(1);
      });
    videoPlayerController.addListener(() {
      final isVideoEnded = videoPlayerController.value.position >=
          videoPlayerController.value.duration;
      if (isVideoEnded) {
        _isVideoEnded = true;
        play = false;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        if (play && _isVideoEnded == false) {
          setState(() {
            videoPlayerController.pause();
            play = false;
            visibility = true;

            opacity = 1;
          });
        } else if (_isVideoEnded && play == false) {
          setState(() {
            videoPlayerController.play();
            play = true;
            visibility = false;
            opacity = 0;
            _isVideoEnded=false;
          });
        } else if (play == false) {
          setState(() {
            videoPlayerController.play();
            play = true;
            visibility = false;
            opacity = 0;
            _isVideoEnded=false;
          });
        }
      },
      child: Stack(
        children: [
          Container(
              width: size.width,
              height: size.height,
              decoration: const BoxDecoration(color: Colors.black),
              child: VideoPlayer(videoPlayerController)),
          Center(
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: opacity,
              child: Visibility(
                  replacement: const Icon(
                    Icons.pause_rounded,
                    color: Colors.white30,
                    size: 60,
                  ),
                  visible: visibility,
                  child: const Icon(
                      Icons.play_arrow_rounded,
                      size: 60,
                      color: Colors.white30,
                    ),
                  ),
            ),
          )
        ],
      ),
    );
  }
}
