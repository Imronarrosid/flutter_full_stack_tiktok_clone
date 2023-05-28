import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:tiktok_clone/constans.dart';
import 'package:tiktok_clone/controller/profile_controller.dart';
import 'package:tiktok_clone/view/screen/profile_confirm_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;

  const ProfileScreen({super.key, required this.uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileController profileController = Get.put(ProfileController());
  bool _isVerified = false;
  _checkVerified() async {
    final userData = await firestore.collection('user').doc(widget.uid).get();
    var data = userData.data();
    if (data!.containsKey('isVerified') && userData['isVerified']==true) {
      _isVerified = true;
    } else {
      _isVerified = false;
    }
  }

  picImage(ImageSource source, BuildContext context) async {
    final image = await ImagePicker().pickImage(source: source);
    if (image != null && context.mounted) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => ProfileConfirmScreen(image: File(image.path))));
    }
  }

  showOptionDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (_) => SimpleDialog(
              children: [
                SimpleDialogOption(
                  onPressed: () async =>
                      await picImage(ImageSource.gallery, context),
                  child: const Row(
                    children: [
                      Icon(Icons.image),
                      Text('Galeri'),
                    ],
                  ),
                ),
                SimpleDialogOption(
                  onPressed: () async =>
                      await picImage(ImageSource.camera, context),
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
  void initState() {
    super.initState();
    _checkVerified();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      profileController.updateUserId(widget.uid);
    });
  }

  @override
  Widget build(BuildContext context) {
    NumberFormat numberFormat = NumberFormat.compact(locale: 'id_ID');
    var size = MediaQuery.of(context).size;
    return GetBuilder<ProfileController>(
        init: ProfileController(),
        builder: (controller) {
          print(controller.user['username']);
          if (controller.user.isEmpty) {
            // Show a loading indicator or placeholder content while data is being fetched
            return Container(
                color: Colors.white,
                width: size.width,
                height: size.height,
                child: const Center(child: CircularProgressIndicator()));
          } else {
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                centerTitle: true,
                actions: const [Icon(Icons.more_horiz)],
                title: Text(
                  controller.user['username'],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              body: SafeArea(
                  child: SingleChildScrollView(
                child: Column(
                  children: [
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: widget.uid == authController.user.uid
                                  ? () => showOptionDialog(context)
                                  : null,
                              child: ClipOval(
                                child: CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  width: 100,
                                  height: 100,
                                  imageUrl: controller.user['profileImg'],
                                  placeholder: (context, url) =>
                                      const CircularProgressIndicator(),
                                  errorWidget: (_, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('@${controller.user['username']}',
                                style: const TextStyle(fontSize: 18)),
                            _isVerified
                                ? Image.asset(
                                    'assets/images/blue_check.png',
                                    fit: BoxFit.cover,
                                    width: 15,
                                    height: 15,
                                  )
                                : Container()
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    Text(
                                      controller.user['following'],
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    const Text(
                                      'Mengikuti',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Text(
                                      numberFormat.format(int.parse(
                                          profileController.user['followers'])),
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    const Text(
                                      'Pengikut',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Text(
                                      controller.user['likes'],
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    const Text(
                                      'suka',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Container(
                          width: 140,
                          height: 47,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: Colors.black12)),
                          child: InkWell(
                              onTap: () {
                                if (widget.uid == authController.user.uid) {
                                  authController.signOut();
                                } else {
                                  controller.followUser();
                                }
                              },
                              child: Center(
                                  child: Text(
                                widget.uid == authController.user.uid
                                    ? 'Sign Out'
                                    : controller.user['isFollowing']
                                        ? 'Unfollow'
                                        : 'Follow',
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ))),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        GridView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 1),
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controller.user['thumnails'].length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    childAspectRatio: 4 / 6,
                                    crossAxisSpacing: 1),
                            itemBuilder: (_, index) {
                              String thumbnail =
                                  controller.user['thumnails'][index];
                              return CachedNetworkImage(
                                imageUrl: thumbnail,
                                fit: BoxFit.cover,
                              );
                            })
                      ],
                    )
                  ],
                ),
              )),
            );
          }
        });
  }
}
