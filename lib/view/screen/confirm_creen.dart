import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tiktok_clone/controller/upload_video_controller.dart';
import 'package:tiktok_clone/view/screen/preview_screen.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_player/video_player.dart';

class ConfirmScreen extends StatefulWidget {
  final File videeFile;
  final String videoPath;
  const ConfirmScreen(
      {super.key, required this.videeFile, required this.videoPath});

  @override
  State<ConfirmScreen> createState() => _ConfirmScreenState();
}

class _ConfirmScreenState extends State<ConfirmScreen> {
  late VideoPlayerController controller;
  TextEditingController songController = TextEditingController();
  TextEditingController captionController = TextEditingController();

  Future<File> _getThumnaile(String path) async {
    final thumnail = await VideoCompress.getFileThumbnail(path);
    return thumnail;
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      controller = VideoPlayerController.file(widget.videeFile);
    });
    controller.initialize();
    controller.play();
    controller.setVolume(1);
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: const Text('Posting')),
      body: SingleChildScrollView(
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                  width: size.width * 0.6,
                  height: 150,
                  child: TextField(
                    controller: captionController,
                    textAlignVertical: TextAlignVertical.top,
                    textInputAction: TextInputAction.newline,
                    maxLines: null,
                    maxLength: 2200,
                    decoration: const InputDecoration(
                        hintText: 'Sampaikan pendapat Anda dalam 2200 karakter',
                        hintStyle: TextStyle(
                            overflow: TextOverflow.visible, fontSize: 14),
                        enabledBorder: InputBorder.none,
                        border: InputBorder.none),
                  )),
              FutureBuilder(
                  future: _getThumnaile(widget.videoPath),
                  builder: (_, AsyncSnapshot<File> snapshot) {
                    var file = snapshot.data;
                    return snapshot.hasData
                        ? SizedBox(
                            width: size.width * 0.2,
                            child: AspectRatio(
                              aspectRatio: 4 / 5,
                              child: InkWell(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (_)=>PreviewScreen(videoFile: widget.videeFile)));
                                },
                                child: Image.file(
                                  file!,
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                            ),
                          )
                        : Container();
                  })
            ],
          ),
          Container(
            margin: const EdgeInsets.all(15),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Colors.grey[200]),
            child: TextField(
              controller: songController,
              textAlignVertical: TextAlignVertical.center,
              decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.music_note_rounded),
                  hintText: 'Masukan judul lagu (Opsional)',
                  hintStyle: TextStyle(
                    fontSize: 13,
                  ),
                  border: InputBorder.none),
            ),
          ),
          const Divider(),
          
          
        ]),
      ),
      persistentFooterButtons: [
        Container(
            margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: ElevatedButton(
                onPressed: () => UploadVideoController().uploapVideo(
                    songController.text,
                    captionController.text,
                    widget.videoPath,),
                child: const Text('Posting')))
      ],
    );
  }
}
