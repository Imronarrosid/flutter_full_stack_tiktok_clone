import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/constans.dart';
import 'package:tiktok_clone/model/comment.dart';

class CommentController extends GetxController {
  final Rx<List<Comment>> _comments = Rx<List<Comment>>([]);
  List<Comment> get comments => _comments.value;

  String _postId = '';
  updatePostId(String id) {
    _postId = id;
    getComment();
  }

  getComment() async {
    _comments.bindStream(firestore.collection('videos').doc(_postId).collection('comments').snapshots().map((QuerySnapshot query){
      List<Comment> retValue=[];

      for (var element in query.docs) {
        retValue.add(Comment.fromSnap(element)) ;
      }
      return retValue;
    }));
  }
  postComment(String commentText) async {
    try {
    if (commentText.isNotEmpty) {
      DocumentSnapshot userDoc =
          await firestore.collection('user').doc(authController.user.uid).get();
      var allDocs = await firestore
          .collection('videos')
          .doc(_postId)
          .collection('comments')
          .get();
      int len = allDocs.docs.length;

      Comment comment = Comment(
          username: (userDoc.data()! as dynamic)['username'],
          comment: commentText.trim(),
          likes: [],
          profileImg: (userDoc.data()! as dynamic)['profileImg'],
          uid: authController.user.uid,
          id: 'Comment $len',
          datePublished: DateTime.now());

          await firestore.collection('videos').doc(_postId).collection('comments').doc('Comment $len').set(comment.toJson());

          DocumentSnapshot doc = await firestore.collection('videos').doc(_postId).get();

          await firestore.collection('videos').doc(_postId).update({
            'commentCount':(doc.data() as dynamic)['commentCount']+1, 
          }); 
    }
      
    } catch (e) {

      Get.snackbar('Komentar error', e.toString());
      
    }
  }
}
