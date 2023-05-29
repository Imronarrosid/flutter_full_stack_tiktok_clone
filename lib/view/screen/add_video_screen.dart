import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tiktok_clone/view/screen/confirm_creen.dart';

class AddVideoScreen extends StatelessWidget {
  const AddVideoScreen({super.key});

  picVideo(ImageSource source, BuildContext context) async {
    final galleryVideo = await ImagePicker().pickVideo(source: source);
    if (galleryVideo != null && context.mounted) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => ConfirmScreen(
                videeFile: File(galleryVideo.path),
                videoPath: galleryVideo.path,
              )));
    }
  }

  showOptionDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (_) => SimpleDialog(
              children: [
                SimpleDialogOption(
                  onPressed: () => picVideo(ImageSource.gallery, context),
                  child: const Row(
                    children: [
                      Icon(Icons.image),
                      Text('Galeri'),
                    ],
                  ),
                ),
                SimpleDialogOption(
                  onPressed: () => picVideo(ImageSource.camera, context),
                  child: const Row(
                    children: [
                      Icon(Icons.camera_alt),
                      Text('Kamera'),
                    ],
                  ),
                ),
                SimpleDialogOption(
                  onPressed: () => Navigator.pop(context),
                  child: const Row(
                    children: [
                      Icon(Icons.cancel),
                      Text('Batal'),
                    ],
                  ),
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload video'),
      ),
      body: Container(
          color: Colors.white,
          child: Center(
            child: ElevatedButton(
                onPressed: () => showOptionDialog(context),
                child: const Text('Upload vidio')),
          )),
    );
  }
}
