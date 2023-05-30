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
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: const Text('Upload video'),
      ),
      body: Container(
          color: Colors.white,
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  splashColor: Colors.black12,
                  onTap: () => picVideo(ImageSource.gallery, context),
                  child: Container(
                    alignment: Alignment.centerLeft,
                    height: 30,
                    width: 100,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.image, size: 40),
                        Text('Galeri'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () => picVideo(ImageSource.camera, context),
                  child: Container(
                    alignment: Alignment.centerLeft,
                    width: 100,
                    height: 30,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.camera_alt, size: 40),
                        Text('Kamera'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
