import 'package:app_tiktok/controllers/auth_controller.dart';
import 'package:app_tiktok/views/screens/add_video_screen.dart';
import 'package:app_tiktok/views/screens/profile_screen.dart';
import 'package:app_tiktok/views/screens/search_screen.dart';
import 'package:app_tiktok/views/screens/video_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

// Pages
List pages = [
  VideoScreen(),
  SearchScreen(),
  AddVideoScreen(),
  Text('Messages Screen'),
  ProfileScreen(uid: authController.user.uid),
];

// COLORS
const backgroundColor = Colors.black;
var buttonColor = Colors.red[400];
const borderColor = Colors.grey;

// FIREBASE
var firebaseAuth = FirebaseAuth.instance;
var firebaseStorage = FirebaseStorage.instance;
var firestore = FirebaseFirestore.instance;

// CONTROLLER
var authController = AuthController.instance;
