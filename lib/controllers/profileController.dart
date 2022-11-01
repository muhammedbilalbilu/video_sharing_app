import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/state_manager.dart';

import 'package:video_sharing_app/constants.dart';

class ProfileController extends GetxController {
  final Rx<Map<String, dynamic>> _user = Rx<Map<String, dynamic>>({});
  Map<String, dynamic> get user => _user.value;
  final Rx<String> _uid = ''.obs;

  updateUid(String uid) {
    _uid.value = uid;
    getUserData();
  }

  getUserData() async {
    List<String> thumbnails = [];
    var myVideo = await firebaseFirestore
        .collection('videos')
        .where('uid', isEqualTo: _uid.value)
        .get();
    for (int i = 0; i < myVideo.docs.length; i++) {
      thumbnails.add((myVideo.docs[i].data() as dynamic)['thumbnail']);
    }

    //
    DocumentSnapshot userDoc =
        await firebaseFirestore.collection('users').doc(_uid.value).get();
    final Userdata = userDoc.data()! as dynamic;
    String name = Userdata['name'];
    String profilePhoto = Userdata['profilePhoto'];
    int likes = 0;
    int followers = 0;
    int following = 0;
    bool isFollowing = false;

    for (var item in myVideo.docs) {
      likes += (item.data()['likes'] as List).length;
    }
    var followerDoc = await firebaseFirestore
        .collection('users')
        .doc(_uid.value)
        .collection('followers')
        .get();
    var followingDoc = await firebaseFirestore
        .collection('users')
        .doc(_uid.value)
        .collection('following')
        .get();
    followers = followerDoc.docs.length;
    following = followingDoc.docs.length;

    firebaseFirestore
        .collection('users')
        .doc(_uid.value)
        .collection('followers')
        .doc(authController.user.uid)
        .get()
        .then((value) {
      if (value.exists) {
        isFollowing = true;
      } else {
        isFollowing = false;
      }
    });

    _user.value = {
      'followers': followers.toString(),
      'following': following.toString(),
      'isFollowing': isFollowing,
      'likes': likes.toString(),
      'profilePhoto': profilePhoto,
      'name': name,
      'thumbnails': thumbnails,
    };
    update();
  }

  followUser() async {
    var doc = await firebaseFirestore
        .collection('users')
        .doc(_uid.value)
        .collection('followers')
        .doc(authController.user.uid)
        .get();
    if (!doc.exists) {
      await firebaseFirestore
          .collection('users')
          .doc(_uid.value)
          .collection('followers')
          .doc(authController.user.uid)
          .set({});
      await firebaseFirestore
          .collection('users')
          .doc(authController.user.uid)
          .collection('followers')
          .doc(_uid.value)
          .set({});
      _user.value
          .update('followers', (value) => (int.parse(value) + 1).toString());
    } else {
      await firebaseFirestore
          .collection('users')
          .doc(_uid.value)
          .collection('followers')
          .doc(authController.user.uid)
          .delete();
      await firebaseFirestore
          .collection('users')
          .doc(authController.user.uid)
          .collection('followers')
          .doc(_uid.value)
          .delete();
      _user.value
          .update('followers', (value) => (int.parse(value) - 1).toString());
    }
    _user.value.update('isFollowing', (value) => !value);
    update();
  }
}
