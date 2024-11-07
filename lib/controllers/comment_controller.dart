import 'package:app_tiktok/constants.dart';
import 'package:app_tiktok/models/comment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class CommentController extends GetxController {
  Rx<List<Comment>> _comments = Rx<List<Comment>>([]);
  List<Comment> get comments => _comments.value;

  String _postId = '';

  updatePostId(String id) {
    _postId = id;
    getComment();
  }

  getComment() async {
    _comments.bindStream(
      firestore
          .collection('videos')
          .doc(_postId)
          .collection('comments')
          .snapshots()
          .map(
        (QuerySnapshot query) {
          List<Comment> retValue = [];
          for (var element in query.docs) {
            retValue.add(Comment.fromSnap(element));
          }

          return retValue;
        },
      ),
    );
  }

  postComment(String commentText) async {
    try {
      var userDoc = await firestore
          .collection('users')
          .doc(authController.user.uid)
          .get();
      var allDocs = await firestore
          .collection('videos')
          .doc(_postId)
          .collection('comments')
          .get();

      int len = allDocs.docs.length;

      Comment comment = Comment(
        username: (userDoc.data() as dynamic)['name'],
        comment: commentText.trim(),
        datePublished: DateTime.now(),
        likes: [],
        profilePhoto: (userDoc.data() as dynamic)['profilePhoto'],
        uid: authController.user.uid,
        id: 'Comment $len',
      );

      await firestore
          .collection('videos')
          .doc(_postId)
          .collection('comments')
          .doc('Comment $len')
          .set(comment.toJson());

      DocumentSnapshot doc =
          await firestore.collection('videos').doc(_postId).get();
      await firestore.collection('videos').doc(_postId).update(
          {'commentCount': (doc.data()! as dynamic)['commentCount'] + 1});
    } catch (e) {
      Get.snackbar('Lỗi đăng bình luận', e.toString());
    }
  }

  likeComment(String id) async {
    var uid = authController.user.uid;
    DocumentSnapshot snapshot = await firestore
        .collection('videos')
        .doc(_postId)
        .collection('comments')
        .doc(id)
        .get();
    if ((snapshot.data() as dynamic)['likes'].contains(uid)) {
      await firestore
          .collection('videos')
          .doc(_postId)
          .collection('comments')
          .doc(id)
          .update({
        'likes': FieldValue.arrayRemove([uid])
      });
    } else {
      await firestore
          .collection('videos')
          .doc(_postId)
          .collection('comments')
          .doc(id)
          .update({
        'likes': FieldValue.arrayUnion([uid])
      });
    }
  }
}
