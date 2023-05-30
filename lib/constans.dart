import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:tiktok_clone/controller/auth_controller.dart';
import 'package:tiktok_clone/view/screen/add_video_screen.dart';
import 'package:tiktok_clone/view/screen/message_screen.dart';
import 'package:tiktok_clone/view/screen/profile_screen.dart';
import 'package:tiktok_clone/view/screen/shop_screen.dart';
import 'package:tiktok_clone/view/screen/video_screen.dart';

//PAGES
List<Widget> pages = [
  const VideoScreen(),
  const ShopScreen(),
  const AddVideoScreen(),
  const MessageScreen(),
  ProfileScreen(uid: firebaseAuth.currentUser!.uid)
];

//COLOR
Color borderColor = Colors.black26;
Color borderColorFocus = Colors.lightBlue;

//FIREBASE
var firebaseAuth = FirebaseAuth.instance;
var firebaseStorage = FirebaseStorage.instance;
var firestore = FirebaseFirestore.instance;

//CONTROLLER
var authController = AuthController.instance;
