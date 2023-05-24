import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/controller/comment_controller.dart';

class CommentScreeen extends StatelessWidget {
  final String id;
  CommentScreeen({super.key, required this.id});

  final TextEditingController _commentConteoller = TextEditingController();
  final CommentController commentController = Get.put(CommentController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    commentController.updatePostId(id);
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
            width: size.width,
            height: size.height,
            child: Column(
              children: [
                Expanded(child: Obx(() {

                  return ListView.builder(
                    itemCount: commentController.comments.length,
                    itemBuilder: (context, index) {
                  final comment = commentController.comments[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.black,
                        backgroundImage: NetworkImage(comment.profileImg),
                      ),
                      title: Row(
                        children: [
                          Text(
                            comment.username,
                            style: const TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                          ),
                          Text(comment.comment)
                        ],
                      ),
                      subtitle: Row(
                        children: [
                          Text(
                          comment.datePublished,
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            comment.likes.length.toString(),
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                      trailing: Icon(Icons.favorite_border_outlined),
                    );
                  });
                })),
                const Divider(),
                ListTile(
                  title: TextFormField(
                    controller: _commentConteoller,
                    decoration: InputDecoration(
                      labelText: 'Comment',
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
                    child: Text('Kirim'),
                    onPressed: () =>
                        commentController.postComment(_commentConteoller.text),
                  ),
                )
              ],
            )),
      ),
    );
  }
}
