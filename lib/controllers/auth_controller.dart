import 'dart:io';

import 'package:app_tiktok/constants.dart';
import 'package:app_tiktok/models/user.dart' as model;
import 'package:app_tiktok/views/screens/home_screen.dart';
import 'package:app_tiktok/views/screens/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();

  late Rx<File?> _pickedImage;
  late Rx<User?> _user;

  File? get profilePhoto => _pickedImage.value;
  User get user => _user.value!;

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    _user = Rx<User?>(firebaseAuth.currentUser);
    _user.bindStream(firebaseAuth.authStateChanges());
    ever(_user, _getInitialSreen);
  }

  _getInitialSreen(User? user) {
    if (user == null) {
      Get.offAll(() => LoginScreen());
    } else {
      Get.offAll(() => HomeScreen());
    }
  }

  void pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      Get.snackbar('Ảnh đại diện', 'Bạn đã chọn ảnh thành công!');
      _pickedImage = Rx<File?>(File(pickedImage!.path));
    } else {
      Get.snackbar('Ảnh đại diện', 'Bạn cần chọn ảnh đại diện của bạn!');
    }
  }

  Future<String> _uploadToStorage(File image) async {
    Reference ref = firebaseStorage
        .ref()
        .child('profilePics')
        .child(firebaseAuth.currentUser!.uid);
    UploadTask uploadTask = ref.putFile(image);
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl.toString();
  }

  void registerUser(
      String name, String email, String password, File image) async {
    try {
      if (name.isNotEmpty &&
          password.isNotEmpty &&
          image != null &&
          email.isNotEmpty) {
        UserCredential cred = await firebaseAuth.createUserWithEmailAndPassword(
            email: email, password: password);
        String downloadUrl = await _uploadToStorage(image);
        model.User user = model.User(
          email: email,
          name: name,
          uid: cred.user!.uid,
          profilePhoto: downloadUrl,
        );
        await firestore
            .collection('users')
            .doc(cred.user!.uid)
            .set(user.toJson());
      } else {
        Get.snackbar('Lỗi tạo tài khoản', 'Bạn phải điền đầy đủ thông tin!');
      }
    } catch (e) {
      Get.snackbar('Lỗi tạo tài khoản', e.toString());
    }
  }

  void loginUser(String email, String password) async {
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        Get.snackbar('Lỗi đăng nhập', 'Vui lòng nhập đầy đủ thông tin!');
      }
    } catch (e) {
      Get.snackbar('Lỗi đăng nhập', e.toString());
    }
  }

  void signOut() async {
    await firebaseAuth.signOut();
  }
}
