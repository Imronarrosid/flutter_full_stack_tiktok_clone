import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/constans.dart';
import 'package:tiktok_clone/model/video.dart';
import 'package:video_compress/video_compress.dart';

class UploadVideoController extends GetxController {
 _compressVideo(String videoPath) async {
      
      //Get id
      var allDocs = await firestore.collection('video').get();
      int len = allDocs.docs.length;
    // final comress = compressor.LightCompressor();
    // dynamic response = comress.compressVideo(path: videoPath, videoQuality: compressor.VideoQuality.medium, android: compressor.AndroidConfig(isSharedStorage: true, saveAt: compressor.SaveAt.Movies), ios: compressor.IOSConfig(saveInGallery: true), video: compressor.Video(videoName: 'video$len'),);
    var comressedVideo = await VideoCompress.compressVideo(videoPath,
        quality: VideoQuality.MediumQuality,
        includeAudio: true);
    return comressedVideo != null ? comressedVideo.file:File(videoPath);
    // return response;
  }

  _getThumnaile(String path) async {
    final thumnail = await VideoCompress.getFileThumbnail(path);
    return thumnail;
  }

  _uploadToStorage(String id, File videoFile) async {
    Reference ref = firebaseStorage.ref().child('videos').child(id);

    UploadTask uploadTask = ref.putFile(videoFile);
    TaskSnapshot snapshot = await uploadTask;
    String downloaUrl = await snapshot.ref.getDownloadURL();
    return downloaUrl;
  }

  _uploadThumnailesToStorage(String id, String videoPath) async {
    Reference ref = firebaseStorage.ref().child('thumnailes').child(id);

    UploadTask uploadTask = ref.putFile(await _getThumnaile(videoPath));
    TaskSnapshot snapshot = await uploadTask;
    if(snapshot.state == TaskState.success){
      Get.snackbar('Upload vidio berhasil', '');
    }
    String downloaUrl = await snapshot.ref.getDownloadURL();
    return downloaUrl;
  }

  //Upload video
  uploapVideo(String songName, String caption, String videoPath,File videoFile) async {
    try {
          Get.back();
          Get.back();
      String uid = firebaseAuth.currentUser!.uid;
      DocumentSnapshot userDoc =
          await firestore.collection('user').doc(uid).get();
      //Get id
      var allDocs = await firestore.collection('videos').get();
      int len = allDocs.docs.length; 
      String videoUrl = await _uploadToStorage("video $len", await _compressVideo(videoPath));
      String thumnail =
          await _uploadThumnailesToStorage("video $len", videoPath);
      
      Video video = Video(
          username:  (userDoc.data()! as Map<String , dynamic>)['username'],
          uid: uid,
          id: "video$len",
          songName: songName,
          caption: caption,
          thumnail: thumnail,
          videoUrl: videoUrl,
          profileImg:  (userDoc.data()! as Map<String , dynamic>)['profileImg'],
          likes: [],
          commentCount: 0,
          shareCount: 0);

          await firestore.collection('videos').doc('video$len').set(video.toJson());
    } catch (e) {
      Get.snackbar('Upload video error', e.toString());
    }
  }
}
