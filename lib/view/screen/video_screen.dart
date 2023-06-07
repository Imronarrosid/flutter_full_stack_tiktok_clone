import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/constans.dart';
import 'package:tiktok_clone/controller/video_controller.dart';
import 'package:tiktok_clone/controller/video_player_controller_provider.dart';
import 'package:tiktok_clone/view/screen/comment_screen.dart';
import 'package:tiktok_clone/view/screen/search_screen.dart';
import 'package:tiktok_clone/view/widgets/circle_animation.dart';
import 'package:tiktok_clone/view/widgets/icon.dart';
import 'package:tiktok_clone/view/widgets/video_player_item.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({super.key});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen>
    with SingleTickerProviderStateMixin {
  final VideoControler videoControler = Get.put(VideoControler());
  final VideoPlayerControllerProvider _controllerProvider =
      Get.put(VideoPlayerControllerProvider());

  late TabController tabController;

  bool favoriteIconVisibility = false;

  @override
  void initState() {
    super.initState();
    tabController = TabController(initialIndex: 1, length: 2, vsync: this);
  }

  Future<bool> _checkVerified(String uid) async {
    final userData = await firestore.collection('user').doc(uid).get();
    var data = userData.data();
    if (data!.containsKey('isVerified') && userData['isVerified'] == true) {
      return true;
    } else {
      return false;
    }
  }

  buildProfile(String profileImg) {
    return SizedBox(
      width: 60,
      height: 60,
      child: Stack(
        children: [
          Positioned(
            left: 5,
            child: Container(
              height: 50,
              width: 50,
              padding: const EdgeInsets.all(1),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(25)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Image(
                  image: NetworkImage(profileImg),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  buildMusicAlbum(String profileImg) {
    return SizedBox(
      height: 50,
      width: 50,
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            padding: const EdgeInsets.all(1),
            decoration: BoxDecoration(
              gradient:
                  const LinearGradient(colors: [Colors.grey, Colors.white]),
              borderRadius: BorderRadius.circular(25),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Image(
                image: NetworkImage(profileImg),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.black),
        leading: UnconstrainedBox(
            child: Image.asset('assets/images/live_icon.png', width: 27)),
        foregroundColor: Colors.white,
        title: TabBar(
          dividerColor: Colors.transparent,
          indicatorColor: Colors.white,
          indicatorPadding: const EdgeInsets.symmetric(horizontal: 18),
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white54,
          controller: tabController,
          tabs: const [
            Tab(child: Text('Mengikuti')),
            Tab(child: Text('Untuk anda')),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: InkWell(
              borderRadius: BorderRadius.circular(50),
              onTap: () =>
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                _controllerProvider.pauseVideo();
                return SearchScreen();
              })),
              child: const SizedBox(
                height: 40,
                width: 40,
                child: Icon(
                  TikTokIcons.search,
                  size: 30,
                ),
              ),
            ),
          )
        ],
      ),
      backgroundColor: Colors.black,
      body: Obx(() {
        return PageView.builder(
            itemCount: videoControler.videoList.length,
            controller: PageController(initialPage: 0, viewportFraction: 1),
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              final data = videoControler.videoList[index];
              return Stack(
                children: [
                  GestureDetector(
                    onDoubleTap: () {
                      videoControler.doubleTaplikeVideo(data.id);

                      setState(() {
                        favoriteIconVisibility = true;
                      });

                      Future.delayed(const Duration(milliseconds: 300), () {
                        setState(() {
                          favoriteIconVisibility = false;
                        });
                      });
                    },
                    child: VideoPlayerItem(
                      videoUrl: data.videoUrl,
                    ),
                  ),
                  Column(
                    children: [
                      const SizedBox(
                        height: 150,
                      ),
                      Expanded(
                          child: Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                              child: Container(
                            padding: const EdgeInsets.only(
                              left: 20,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                FutureBuilder(
                                    future: _checkVerified(data.uid),
                                    builder: (_, AsyncSnapshot<bool> snapshot) {
                                      var isVerified = snapshot.data;
                                      return snapshot.hasData
                                          ? Row(
                                              children: [
                                                Text(
                                                  data.username,
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                isVerified!
                                                    ? Image.asset(
                                                        'assets/images/blue_check.png',
                                                        height: 15,
                                                      )
                                                    : Container()
                                              ],
                                            )
                                          : Container(
                                              height: 20,
                                            );
                                    }),
                                Text(
                                  data.caption,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      data.songName,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )),
                          Container(
                            width: 70,
                            margin: EdgeInsets.only(top: size.height / 3),
                            child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  buildProfile(data.profileImg),
                                  Expanded(
                                    child: SizedBox(
                                      height: double.infinity,
                                      width: 70,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          InkWell(
                                            onTap: () => videoControler
                                                .likeVideo(data.id),
                                            child: Icon(
                                              TikTokIcons.heart,
                                              size: 35,
                                              color: data.likes.contains(
                                                      authController.user.uid)
                                                  ? Colors.red
                                                  : Colors.white,
                                            ),
                                          ),
                                          Text(
                                            data.likes.length.toString(),
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 16),
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          InkWell(
                                            onTap: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (_) {
                                                _controllerProvider
                                                    .pauseVideo();
                                                return CommentScreeen(
                                                  id: data.id,
                                                );
                                              }),
                                            ),
                                            child: const Icon(
                                                TikTokIcons.chatBubble,
                                                size: 35,
                                                color: Colors.white),
                                          ),
                                          Text(
                                            data.commentCount.toString(),
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 16),
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          InkWell(
                                            onTap: () {},
                                            child: const Icon(
                                              TikTokIcons.reply,
                                              size: 26,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text(
                                            '${data.shareCount}',
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 16),
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Container(
                                            margin: EdgeInsets.zero,
                                            padding: const EdgeInsets.only(
                                                bottom: 5),
                                            child: CircleAnimation(
                                                child: buildMusicAlbum(
                                                    data.profileImg)),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                ]),
                          )
                        ],
                      ))
                    ],
                  ),
                  Center(
                    child: Visibility(
                        visible: favoriteIconVisibility,
                        child: const Icon(Icons.favorite_rounded,
                            size: 60, color: Colors.red)),
                  ),
                ],
              );
            });
      }),
    );
  }
}
