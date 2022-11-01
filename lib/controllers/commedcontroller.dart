import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/state_manager.dart';

import '../constants.dart';
import '../models/comment.dart';

class CommentController extends GetxController {
  final Rx<List<Comment>> _Comment = Rx<List<Comment>>([]);

  List<Comment> get Comments => _Comment.value;
  String _postid = "";
  updatePostid(String id) {
    _postid = id;
    getComment();
  }

  //

  getComment() async {
    _Comment.bindStream(firebaseFirestore
        .collection('videos')
        .doc(_postid)
        .collection('Comments')
        .snapshots()
        .map((QuerySnapshot query) {
      List<Comment> retValue = [];
      for (var element in query.docs) {
        retValue.add(Comment.fromSnap(element));
      }
      return retValue;
    }));
  }

  //

  postComment(String commentText) async {
    try {
      if (commentText.isNotEmpty) {
        DocumentSnapshot userDoc = await firebaseFirestore
            .collection("users")
            .doc(authController.user.uid)
            .get();
        var allDocs = await firebaseFirestore
            .collection('videos')
            .doc(_postid)
            .collection('Comments')
            .get();
        int len = allDocs.docs.length;
        Comment comment = Comment(
            username: (userDoc.data()! as dynamic)['name'],
            comment: commentText.trim(),
            datePublished: DateTime.now(),
            likes: [],
            profilePhoto: (userDoc.data()! as dynamic)['profilePhoto'],
            uid: (userDoc.data()! as dynamic)['uid'],
            id: 'Comment$len');

        await firebaseFirestore
            .collection('videos')
            .doc(_postid)
            .collection('Comments')
            .doc('Comments$len')
            .set(comment.toJson());

        DocumentSnapshot doc =
            await firebaseFirestore.collection('videos').doc(_postid).get();
        firebaseFirestore.collection('videos').doc(_postid).update(
            {'commentCount': (doc.data()! as dynamic)['commentCount'] + 1});
      }
    } catch (err) {
      Get.snackbar(
        'Error the Account',
        err.toString(),
      );
    }
  }
}
