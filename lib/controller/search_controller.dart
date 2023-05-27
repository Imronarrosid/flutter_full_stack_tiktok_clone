import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/constans.dart';
import 'package:tiktok_clone/model/user.dart';

class SearchUserController extends GetxController{
  final Rx<List<User>> _searchedUser = Rx<List<User>>([]);

  List<User> get searcheduser => _searchedUser.value;

  searchUser(String searchText) async{
    _searchedUser.bindStream(
      firestore.collection('user').where('username',isLessThanOrEqualTo: searchText.toLowerCase() ).snapshots().map((QuerySnapshot query) {
        List<User> retVal=[];
        for (var element in query.docs) {
            retVal.add(User.fromSnap(element)) ;          
        }
        return retVal;
      })
    );
  }
}