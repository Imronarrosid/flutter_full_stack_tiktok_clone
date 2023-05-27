import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String username, profileImg, email, uid;
  User(
      {required this.username,
      this.profileImg='https://upload.wikimedia.org/wikipedia/commons/thumb/b/b5/Windows_10_Default_Profile_Picture.svg/2048px-Windows_10_Default_Profile_Picture.svg.png',
      required this.email,
      required this.uid});

  Map<String, dynamic> toJson() => {
        "username": username,
        "profileImg": profileImg,
        "email": email,
        "uid": uid,
      };
  static User fromSnap(DocumentSnapshot snapshot) {
    var snap = snapshot.data() as Map<String, dynamic>;
    return User(
        username: snap['username'],
        profileImg: snap['profileImg'],
        email: snap['email'],
        uid: snap['uid']);
  }
}
