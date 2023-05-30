import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class PreviewScreen extends StatefulWidget {
  final File videoFile;
  const PreviewScreen({super.key, required this.videoFile});

  @override
  State<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  late VideoPlayerController videoPlayerController;
  bool visibility = false;
  double opacity = 0.0;
  bool _isVideoEnded = false;
  @override
  void initState() {
    super.initState();
    videoPlayerController = VideoPlayerController.file(widget.videoFile)
      ..initialize().then((value) {
        videoPlayerController.play();
        videoPlayerController.setVolume(1);
      });
    videoPlayerController.addListener(() {
      final isVideoEnded = videoPlayerController.value.position >=
          videoPlayerController.value.duration;
      if (isVideoEnded) {
        _isVideoEnded = true;
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
    var size = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Pratinjau'),
        centerTitle: true,
        foregroundColor: Colors.white,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          InkWell(
            onTap: () {
              if (videoPlayerController.value.isPlaying &&
                  _isVideoEnded == false) {
                setState(() {
                  videoPlayerController.pause();
                  visibility = true;

                  opacity = 1;
                });
              } else if (_isVideoEnded &&
                  !videoPlayerController.value.isPlaying) {
                setState(() {
                  videoPlayerController.play();
                  visibility = false;
                  opacity = 0;
                  _isVideoEnded = false;
                });
              } else if (!videoPlayerController.value.isPlaying) {
                setState(() {
                  videoPlayerController.play();
                  visibility = false;
                  opacity = 0;
                  _isVideoEnded = false;
                });
              }
            },
            child: SizedBox(
                width: size.width,
                height: size.height,
                child: VideoPlayer(videoPlayerController)),
          ),
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
