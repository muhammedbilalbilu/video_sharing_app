import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/state_manager.dart';

import 'package:video_sharing_app/constants.dart';

import '../models/user.dart';

class SearchController extends GetxController {
  final Rx<List<User>> _searcheduser = Rx<List<User>>([]);
  List<User> get searcheduser => _searcheduser.value;

  searchUser(String typedUser) async {
    _searcheduser.bindStream(firebaseFirestore
        .collection('users')
        .where('name', isGreaterThanOrEqualTo: typedUser)
        .snapshots()
        .map((QuerySnapshot query) {
      List<User> reVal = [];
      for (var elem in query.docs) {
        reVal..add(User.fromSnap(elem));
      }
      return reVal;
    }));
  }
}
