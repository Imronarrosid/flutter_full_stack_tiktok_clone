import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/constans.dart';
import 'package:tiktok_clone/controller/profile_controller.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;

  const ProfileScreen({super.key, required this.uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileController profileController = Get.put(ProfileController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      profileController.updateUserId(widget.uid);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
        init: ProfileController(),
        builder: (controller) {
          print(controller.user['username']);
          if (controller.user.isEmpty) {
            // Show a loading indicator or placeholder content while data is being fetched
            return CircularProgressIndicator();
          } else {
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                leading: Icon(Icons.person_add_alt_1_outlined),
                actions: [Icon(Icons.more_horiz)],
                title: Text(
                  controller.user['username'],
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              body: SafeArea(
                  child: Column(
                children: [
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClipOval(
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
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Text(
                                '0',
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                'Mengikuti',
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                profileController.user['followers'].toString(),
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                'Pengikut',
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                '0',
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                'Likes',
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
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
                              }else{
                                controller.followUser();
                              }
                            },
                            child: Center(
                                child: Text(
                                  widget.uid == authController.user.uid?
                              'Sign Out':controller.user['isFollowing']?'Unfollow':'Follow',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ))),
                      )
                    ],
                  )
                ],
              )),
            );
          }
        });
  }
}
