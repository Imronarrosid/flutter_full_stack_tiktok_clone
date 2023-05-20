import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tiktok_clone/view/widgets/form_field.dart';
import 'package:video_player/video_player.dart';

class ConfirmScreen extends StatefulWidget {
  final File videeFile;
  final String videoPath;
  const ConfirmScreen({super.key, required this.videeFile, required this.videoPath});

  @override
  State<ConfirmScreen> createState() => _ConfirmScreenState();
}

class _ConfirmScreenState extends State<ConfirmScreen> {
  late VideoPlayerController controller;
  TextEditingController songController = TextEditingController();
  TextEditingController captionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      controller = VideoPlayerController.file(widget.videeFile);
    });
    controller.initialize();
    controller.play();
    controller.setVolume(1);
    controller.setLooping(true);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(children: [
          const SizedBox(height: 25,),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height/1.5,
            child: VideoPlayer(controller),
          ),
            const SizedBox(height: 25,),
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    width: MediaQuery.of(context).size.width -20,
                    child: CustomFormField(controller: songController, labelText: 'Nama lagu',prefixIcon:Icons.music_note_rounded),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    width: MediaQuery.of(context).size.width -20,
                    child: CustomFormField(controller: captionController, labelText: 'Caption',prefixIcon:Icons.closed_caption),
                  ),
                  const SizedBox(height: 25,),
                  ElevatedButton(onPressed: (){}, child: const Text('Upload'))
              ]),
            )
        ]),
      ),

    );
  }
}