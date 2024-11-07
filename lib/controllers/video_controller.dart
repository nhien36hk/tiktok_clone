import 'package:app_tiktok/constants.dart';
import 'package:app_tiktok/models/video.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class VideoController extends GetxController {
  Rx<List<Video>> _listVideo = Rx<List<Video>>([]);
  List<Video> get listVideo => _listVideo.value;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    _listVideo.bindStream(
      firestore.collection('videos').snapshots().map((QuerySnapshot query){
        List<Video> retValue = [];
        for(var element in query.docs){
          retValue.add(Video.fromSnap(element));
        }

        return retValue;
      })
    );
  }

  likeVideo(String id) async {
    DocumentSnapshot snap = await firestore.collection('videos').doc(id).get();
    var uid = authController.user.uid;
    if ((snap.data()! as dynamic)['likes'].contains(uid)) {
      await firestore.collection('videos').doc(id).update({
        'likes' : FieldValue.arrayRemove([uid])
      });
    }else{
      await firestore.collection('videos').doc(id).update({
        'likes' : FieldValue.arrayUnion([uid])
      });
    }
  }
}
