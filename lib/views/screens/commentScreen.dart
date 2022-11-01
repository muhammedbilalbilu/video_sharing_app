// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';

import '../../controllers/commedcontroller.dart';

class CommentsScreen extends StatelessWidget {
  String id;
  CommentsScreen({
    Key? key,
    required this.id,
  }) : super(key: key);

  final TextEditingController Controller = TextEditingController();
  CommentController commentController = CommentController();

  @override
  Widget build(BuildContext context) {
    commentController.updatePostid(id);
    final Size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
          child: SizedBox(
        width: Size.width,
        height: Size.height,
        child: Column(
          children: [
            Expanded(child: Obx(() {
              return ListView.builder(
                  itemCount: commentController.Comments.length,
                  itemBuilder: (context, index) {
                    final comment = commentController.Comments[index];
                    return Expanded(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.black,
                          backgroundImage: NetworkImage(comment.profilePhoto),
                        ),
                        title: Row(
                          children: [
                            Text(
                              comment.username,
                              style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.red,
                                  fontWeight: FontWeight.w700),
                            ),
                            Text(
                              comment.comment,
                              style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                        subtitle: Row(
                          children: [
                            const Text(
                              'data',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.white),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              " ${comment.likes.length.toString()} likes",
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.white),
                            )
                          ],
                        ),
                        trailing: InkWell(
                          onTap: () {},
                          child: const Icon(
                            Icons.favorite,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    );
                  });
            })),
            const Divider(),
            ListTile(
              title: TextFormField(
                controller: Controller,
                style: const TextStyle(fontSize: 16, color: Colors.white),
                decoration: const InputDecoration(
                    labelText: 'Comment',
                    labelStyle: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.red)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.red))),
              ),
              trailing: TextButton(
                  onPressed: () =>
                      commentController.postComment(Controller.text),
                  child: const Text(
                    'Send',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  )),
            ),
          ],
        ),
      )),
    );
  }
}
