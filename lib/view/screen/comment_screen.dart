import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/constans.dart';
import 'package:tiktok_clone/controller/comment_controller.dart';
import 'package:timeago/timeago.dart' as tago;

class CommentScreeen extends StatelessWidget {
  final String id;
  CommentScreeen({super.key, required this.id});

  final TextEditingController _commentConteoller = TextEditingController();
  final CommentController commentController = Get.put(CommentController());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
    final size = MediaQuery.of(context).size;
    commentController.updatePostId(id);
    tago.setLocaleMessages('id', tago.IdMessages());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        title: const Text('Komentar'),
      ),
      body: Container(
        width: size.width,
        color: Colors.white,
        child: Obx(() {
          return ListView.builder(
              shrinkWrap: true,
              itemCount: commentController.comments.length,
              itemBuilder: (context, index) {
                final comment = commentController.comments[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.black,
                    backgroundImage: NetworkImage(comment.profileImg),
                  ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FutureBuilder(
                          future: _checkVerified(comment.uid),
                          initialData: false,
                          builder: (_, AsyncSnapshot<bool> snapshot) {
                            bool isVerified = snapshot.data!;
                            return snapshot.hasData
                                ? Row(
                                    children: [
                                      Text(
                                        comment.username,
                                        style: const TextStyle(
                                            fontSize: 20,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      isVerified
                                          ? Image.asset(
                                              'assets/images/blue_check.png',
                                              fit: BoxFit.cover,
                                              width: 15,
                                              height: 15,
                                            )
                                          : Container(
                                              height: 15,
                                            )
                                    ],
                                  )
                                : Container(
                                    height: 20,
                                  );
                          }),
                      Text(
                        comment.comment,
                        style: const TextStyle(height: 0.5),
                      )
                    ],
                  ),
                  subtitle: Row(
                    children: [
                      Text(
                        tago
                            .format(
                                DateTime.parse(
                                    comment.datePublished.toDate().toString()),
                                locale: 'id')
                            .toString(),
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                  trailing: Column(
                    children: [
                      InkWell(
                          onTap: () =>
                              commentController.likeComment(comment.id),
                          child: comment.likes.contains(authController.user.uid)
                              ? const Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                )
                              : const Icon(Icons.favorite_border_outlined)),
                      Text(
                        comment.likes.length.toString(),
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                );
              });
        }),
      ),
      persistentFooterButtons: [
        Container(
          margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 5),
          child: Form(
            key: _formKey,
            child: ListTile(
              title: TextFormField(
                autocorrect: true,
                autofocus: true,
                textCapitalization: TextCapitalization.sentences,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tidak boleh kosong';
                  }
                  return null;
                },
                controller: _commentConteoller,
                decoration: const InputDecoration(
                  hintText: 'Tulis komentar',
                  labelStyle: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.w700),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
              ),
              trailing: TextButton(
                  child: const Text('Kirim'),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      commentController.postComment(_commentConteoller.text);
                      _commentConteoller.clear();
                    }
                  }),
            ),
          ),
        )
      ],
    );
  }
}
