import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String name;
  String email;
  String profilePhoto;
  String uid;

  User({
    required this.email,
    required this.name,
    required this.uid,
    required this.profilePhoto,
  });

  Map<String, dynamic> toJson() => {
        'email': email,
        'name': name,
        'uid': uid,
        'profilePhoto': profilePhoto,
      };

  static User fromSnap(DocumentSnapshot snap) {
    var snapShot = snap.data() as Map<String, dynamic>;
    return User(
      email: snapShot['email'],
      name: snapShot['name'],
      uid: snapShot['uid'],
      profilePhoto: snapShot['profilePhoto'],
    );
  }
}
