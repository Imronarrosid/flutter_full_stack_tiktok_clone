import 'package:cloud_firestore/cloud_firestore.dart';

class Video {
  final String username,
      uid,
      id,
      songName,
      caption,
      thumnail,
      videoUrl,
      profileImg;
  final List likes;
  final int commentCount, shareCount;
  Video({
    required this.username,
    required this.uid,
    required this.id,
    required this.songName,
    required this.caption,
    required this.thumnail,
    required this.videoUrl,
    required this.profileImg,
    required this.likes,
    required this.commentCount,
    required this.shareCount,
  });

  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "profileImg": profileImg,
        "id": id,
        "likes": likes,
        "commentCount": commentCount,
        "songName": songName,
        "caption": caption,
        "videoUrl": videoUrl,
        "thumnail": thumnail
      };
  static Video fromSnap(DocumentSnapshot snapshot) {
    var snap = snapshot.data() as Map<String, dynamic>;

    return Video(
        username: snap["username"],
        uid: snap["uid"],
        id: snap["id"],
        songName: snap["songName"],
        caption: snap["caption"],
        thumnail: snap["thumnail"],
        videoUrl: snap["videoUrl"],
        profileImg: snap["profileImg"],
        likes: snap["likes"],
        commentCount: snap["commentCount"],
        shareCount: snap["shareCount"]);
  }
}
