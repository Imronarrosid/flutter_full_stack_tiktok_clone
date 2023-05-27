import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/constans.dart';

class ProfileController extends GetxController {
  final Rx<Map<String, dynamic>> _user = Rx<Map<String, dynamic>>({});

  Map<String, dynamic> get user => _user.value;

  Rx<String> _uid = "".obs;
  updateUserId(String id) {
    _uid.value = id;
    print('test print id $id');
    print('test print user $user');
    print('test print _user ${_user.value}');
    getUserData();
  }

  Future<void> getUserData() async {
    List<String> thumbnails = [];
    var myVideos = await firestore
        .collection('videos')
        .where('uid', isEqualTo: _uid.value)
        .get();
    print(' test print myVideos $myVideos');

    for (var i = 0; i < myVideos.docs.length; i++) {
      thumbnails.add((myVideos.docs[i].data() as dynamic)['thumnail']);
    }
    DocumentSnapshot userDoc =
        await firestore.collection('user').doc(_uid.value).get();
    final userData = userDoc.data()! as dynamic;
    String username = userData['username'];
    String profileImg = userData['profileImg'];
    int likes = 0;
    int followers = 0;
    int following = 0;
    bool isFollowing = false;

    for (var item in myVideos.docs) {
      likes += (item.data()['likes'] as List).length;
    }
    var followerDoc = await firestore
        .collection('user')
        .doc(_uid.value)
        .collection('followers')
        .get();
    var followingDoc = await firestore
        .collection('user')
        .doc(_uid.value)
        .collection('following')
        .get();

    followers = followerDoc.docs.length;
    following = followingDoc.docs.length;

    await firestore
        .collection('user')
        .doc(_uid.value)
        .collection('followers')
        .doc(authController.user.uid)
        .get()
        .then((value) {
      if (value.exists) {
        isFollowing = true;
      } else {
        isFollowing = false;
      }
    });

    _user.value = {
      'followers': followers.toString(),
      'following': following.toString(),
      'isFollowing': isFollowing,
      'likes': likes.toString(),
      'profileImg': profileImg,
      'username': username,
      'thumnails': thumbnails,
    };
    update();
  }

  followUser() async {
    var doc = await firestore
        .collection('user')
        .doc(_uid.value)
        .collection('followers')
        .doc(authController.user.uid)
        .get();
        if (!doc.exists) {
          await firestore
        .collection('user')
        .doc(_uid.value)
        .collection('followers')
        .doc(authController.user.uid)
        .set({});
          await firestore
        .collection('user')
        .doc(authController.user.uid)
        .collection('following')
        .doc(authController.user.uid)
        .set({});
        _user.value.update('followers', (value) => (int.parse(value)+1).toString(),);
        }else{
              await firestore
        .collection('user')
        .doc(authController.user.uid)
        .collection('following')
        .doc(authController.user.uid)
        .delete();
          await firestore
        .collection('user')
        .doc(_uid.value)
        .collection('followers')
        .doc(authController.user.uid)
        .delete();
        _user.value.update('followers', (value) => (int.parse(value)-1).toString());
        }
      _user.value.update('isFollowing', (value) => !value);
      update();
  }

}
