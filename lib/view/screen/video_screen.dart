import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/constans.dart';
import 'package:tiktok_clone/controller/video_controller.dart';
import 'package:tiktok_clone/view/screen/comment_screen.dart';
import 'package:tiktok_clone/view/screen/search_screen.dart';
import 'package:tiktok_clone/view/widgets/circle_animation.dart';
import 'package:tiktok_clone/view/widgets/video_player_item.dart';
import 'package:video_player/video_player.dart';

class VideoScreen extends StatefulWidget {
  VideoScreen({super.key});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen>
    with SingleTickerProviderStateMixin {
  final VideoControler videoControler = Get.put(VideoControler());

  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(initialIndex: 1, length: 2, vsync: this);
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
              child: const Image(
                image: NetworkImage(
                    'https://static.vecteezy.com/system/resources/previews/007/619/838/original/vinyl-disc-record-for-music-album-cover-design-vector.jpg'),
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
        foregroundColor: Colors.white,
        title: TabBar(
          dividerColor: Colors.transparent,
          indicatorColor: Colors.white,
          indicatorPadding: EdgeInsets.symmetric(horizontal: 18),
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
              onTap: () => Navigator.push(
                  context, MaterialPageRoute(builder: (_) => SearchScreen())),
              child: const SizedBox(
                height: 40,
                width: 40,
                child: Icon(
                  Icons.search_rounded,
                  size: 34,
                ),
              ),
            ),
          )
        ],
        backgroundColor: Colors.transparent,
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
                  VideoPlayerItem(
                    videoUrl: data.videoUrl,
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
                                Text(
                                  data.username,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  data.caption,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      data.songName,
                                      style: TextStyle(
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
                                  buildProfile(
                                      'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b5/Windows_10_Default_Profile_Picture.svg/2048px-Windows_10_Default_Profile_Picture.svg.png'),
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
                                              Icons.favorite,
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
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        CommentScreeen(
                                                          id: data.id,
                                                        ))),
                                            child: const Icon(Icons.comment,
                                                size: 35, color: Colors.white),
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
                                            child: Transform.flip(
                                              flipX: true,
                                              child: const Icon(
                                                Icons.reply,
                                                size: 35,
                                                color: Colors.white,
                                              ),
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
                                                    'profile photo')),
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
                  )
                ],
              );
            });
      }),
    );
  }
}
