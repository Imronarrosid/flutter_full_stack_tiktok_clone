import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/controller/profile_controller.dart';

class ProfileConfirmScreen extends StatelessWidget {
  final File image;
  ProfileConfirmScreen({super.key, required this.image});

  final ProfileController profileController = Get.put(ProfileController());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Image.file(image),
          const SizedBox(
            height: 25,
          ),
          ElevatedButton(onPressed: ()=> profileController.changeProfileImg(image), child: const Text('Simpan'))
        ],
      ),
    );
  }
}
