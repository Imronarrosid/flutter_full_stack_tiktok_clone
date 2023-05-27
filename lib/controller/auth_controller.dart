import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:tiktok_clone/constans.dart';
import 'package:tiktok_clone/model/user.dart' as model;
import 'package:tiktok_clone/view/screen/auth/login_screen.dart';
import 'package:tiktok_clone/view/screen/auth/signup_screen.dart';
import 'package:tiktok_clone/view/screen/home_screen.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();

  late Rx<User?> _user;

  User get user => _user.value!;

  @override
  void onReady() {
    super.onReady();
    _user = Rx<User?>(firebaseAuth.currentUser);
    _user.bindStream(firebaseAuth.authStateChanges());
    ever(_user, _setInitialScreen);
  }

  _setInitialScreen(User? user) {
    if (user == null) {
      Get.offAll(() => SignUpScreen());
    } else {
      Get.offAll(() => HomeScreen());
    }
  }

  //Register user
  void registerUser(String username, String email, String password) async {
    try {
      if (username.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
        //save user
        UserCredential usrCred = await firebaseAuth
            .createUserWithEmailAndPassword(email: email, password: password);

        model.User user = model.User(
            username: username, email: email, uid: usrCred.user!.uid);
        await firestore
            .collection('user')
            .doc(usrCred.user!.uid)
            .set(user.toJson());
      }
    } catch (e) {
      Get.snackbar('creating an account', e.toString());
    }
  }

  void signIn(String email, String password) async {
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password);
        print('LogIn Success');
      } else {
        Get.snackbar('LogIn error', 'Tolong isi semua');
      }
    } catch (e) {
      Get.snackbar('LogIn error', e.toString());
    }
  }

  void signOut()async{
    firebaseAuth.signOut();
  }
}
