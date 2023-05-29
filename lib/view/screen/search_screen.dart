import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/constans.dart';
import 'package:tiktok_clone/controller/search_controller.dart';
import 'package:tiktok_clone/model/user.dart';
import 'package:tiktok_clone/view/screen/profile_screen.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({super.key});

  final SearchUserController searchController = Get.put(SearchUserController());
  final TextEditingController _searchController = TextEditingController();

  Future<bool> _checkVerified(String uid) async {
    final userData = await firestore.collection('user').doc(uid).get();
    var data = userData.data();
    if (data!.containsKey('isVerified') && userData['isVerified'] == true) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: TextFormField(
            controller: _searchController,
            decoration: InputDecoration(
              filled: false,
              hintText: 'Cari',
              hintStyle: TextStyle(fontSize: 18, color: Colors.black38),
            ),
            onFieldSubmitted: (value) => searchController.searchUser(value!),
          ),
        ),
        body: searchController.searcheduser.isEmpty
            ? const Center(
                child: Text(
                  'Cari  user!',
                  style: TextStyle(
                      fontSize: 25,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              )
            : ListView.builder(
                itemCount: searchController.searcheduser.length,
                itemBuilder: (_, index) {
                  User user = searchController.searcheduser[index];
                  return InkWell(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ProfileScreen(uid: user.uid))),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(user.profileImg),
                      ),
                      title: FutureBuilder(
                          future: _checkVerified(user.uid),
                          initialData: false,
                          builder: (_, AsyncSnapshot<bool> snapshot) {
                            bool isVerified = snapshot.data!;
                            return snapshot.hasData? Row(
                              children: [
                                Text(
                                  user.username,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                                ),
                                isVerified ? Image.asset(
                                  'assets/images/blue_check.png',
                                  fit: BoxFit.cover,
                                  width: 15,
                                  height: 15,
                                ):Container(height:15),
                              ],
                            ): Container(height: 15,);
                          }),
                    ),
                  );
                }),
      );
    });
  }
}
