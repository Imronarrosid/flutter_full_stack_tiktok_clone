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
  final TextEditingController _searchController =TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: TextFormField(
              controller: _searchController,
              decoration: InputDecoration(
                filled: false,
                hintText: 'Cari',
                hintStyle: TextStyle(
                  fontSize: 18,
                  color: Colors.black38
                ),
                
              ),
              onFieldSubmitted: (value)=> searchController.searchUser(value!) ,
            ),
          ),
          body: searchController.searcheduser.isEmpty ? const Center(
            child: Text('Cari  user!',style: TextStyle(
              fontSize: 25,
              color: Colors.black,
              fontWeight: FontWeight.bold
            ),),
          ): ListView.builder(
            itemCount: searchController.searcheduser.length,
            itemBuilder: (_,index){
              User user = searchController.searcheduser[index];
              return InkWell(
                onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (_)=>ProfileScreen(uid: user.uid))),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(user.profileImg),
                  ),
                  title: Text(user.username,style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black,

                  ),),

                ),
              );
          }),
          

        );
      }
    );
  }
}