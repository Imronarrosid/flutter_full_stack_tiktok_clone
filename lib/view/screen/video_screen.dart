import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/controller/video_controller.dart';
import 'package:tiktok_clone/view/screen/comment_screen.dart';
import 'package:tiktok_clone/view/widgets/circle_animation.dart';
import 'package:tiktok_clone/view/widgets/video_player_item.dart';
import 'package:video_player/video_player.dart';

class VideoScreen extends StatelessWidget {
 VideoScreen({super.key});

final VideoControler videoControler= Get.put(VideoControler());
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
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Image(
                      image: NetworkImage(profileImg),
                    ),
                  )))
        ],
      ),
    );
  }

  buildMusicAlbum(String profileImg) {
    return SizedBox(
      height: 60,
      width: 60,
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            padding: const EdgeInsets.all(1),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Colors.grey,Colors.white]),

              borderRadius: BorderRadius.circular(25),

            ),
            child: ClipRRect(borderRadius: BorderRadius.circular(25) ,child:const Image(image: NetworkImage( 'https://static.vecteezy.com/system/resources/previews/007/619/838/original/vinyl-disc-record-for-music-album-cover-design-vector.jpg')),),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(
        () {
          return PageView.builder(
              itemCount: videoControler.videoList.length,
              controller: PageController(initialPage: 0, viewportFraction: 1),
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                final data =videoControler.videoList[index];
                return Stack(
                  children: [
                    VideoPlayerItem(videoUrl: data.videoUrl,),
                    Column(
                      children: [
                        const SizedBox(
                          height: 100,
                        ),
                        Expanded(
                            child: Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                                child: Container(
                              padding: EdgeInsets.only(
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
                              width: 100,
                              margin: EdgeInsets.only(top: size.height / 5),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    buildProfile(
                                        'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b5/Windows_10_Default_Profile_Picture.svg/2048px-Windows_10_Default_Profile_Picture.svg.png'),
                                    Column(
                                      children: [
                                        InkWell(
                                          onTap: ()=> videoControler.likeVideo(data.id),
                                          child: Icon(
                                            Icons.favorite,
                                            size: 40,
                                            color: data.likes.contains(data.uid)? Colors.red :Colors.white,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 7,
                                        ),
                                         Text(
                                          data.likes.length.toString(),
                                          style: TextStyle(
                                              color: Colors.white, fontSize: 20),
                                        ),
                                        const SizedBox(
                                          height: 7,
                                        ),
                                        InkWell(
                                          onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (_)=>CommentScreeen(id: data.id,))),
                                          child: Icon(Icons.comment,
                                              size: 40, color: Colors.white),
                                        ),
                                        const SizedBox(
                                          height: 7,
                                        ),
                                        Text(
                                          data.commentCount.toString(),
                                          style: TextStyle(
                                              color: Colors.white, fontSize: 20),
                                        ),
                                        const SizedBox(
                                          height: 7,
                                        ),
                                        InkWell(
                                          onTap: () {},
                                          child: Icon(
                                            Icons.reply,
                                            size: 40,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 7,
                                        ),
                                        Text(
                                          '${data.shareCount}',
                                          style: TextStyle(
                                              color: Colors.white, fontSize: 20),
                                        ),
                                        CircleAnimation(
                                            child: buildMusicAlbum('profile photo'))
                                      ],
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
        }
      ),
    );
  }
}
