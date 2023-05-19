import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String username, profileImg, email, uid;
  User(
      {required this.username,
      this.profileImg='assets/images/default_profilr_pic.jpg',
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
        username: snap['usernsme'],
        profileImg: snap['profileImg'],
        email: snap['email'],
        uid: snap['uid']);
  }
}
