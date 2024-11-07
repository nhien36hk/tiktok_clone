import 'package:app_tiktok/constants.dart';
import 'package:app_tiktok/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class SearchUserController extends GetxController{
  Rx<List<User>> _searchedUsers = Rx<List<User>>([]);
  List<User> get searchedUsers => _searchedUsers.value;

  searchUser(String typedUser) async {
    _searchedUsers.bindStream(
      firestore
          .collection('users')
          .where('name', isGreaterThanOrEqualTo: typedUser)
          .snapshots()
          .map((QuerySnapshot query) {
            List<User> retValue = [];
            for(var element in query.docs){
              retValue.add(User.fromSnap(element));
            }

            return retValue;
          }),
    );
  }
}