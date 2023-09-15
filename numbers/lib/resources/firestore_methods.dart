import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:numbers/models/post.dart';
import 'package:numbers/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

// import '../models/post.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //upload post

  Future<String> uploadContact(
    Uint8List? file, {
    required String name,
    required String number,
    required String relation,
    required String uid,
  }) async {
    String res = "Some error occured";
    try {
      String photoUrl = file != null ?
      await StorageMethods()
          .uploadImageTostorage('posts', file, true) : "";

      if (kDebugMode) {
        print("Photo URL: $photoUrl");
      }

      String postId = const Uuid().v1();

      Post post = Post(
        name: name,
        number: number,
        relation: relation,
        uid: uid,
        photoUrl: photoUrl,
        postId: postId,
        datePublished: DateTime.now(),
      );

      _firestore.collection('posts').doc(postId).set(post.toJson());

      res = "success";
    } catch (err) {
      res = err.toString();
    }

    return res;
  }

  // update post

  Future<String> updateContact(
      Uint8List? file, {
        required String name,
        required String number,
        required String relation,
        required String uid,
        required String postId
      }) async {
    String res = "Some error occured";
    // if(kDebugMode){
    print("hi");
      print('PostId: $postId');
    // }
    try {
      String photoUrl = file != null ?
      await StorageMethods()
          .uploadImageTostorage('posts', file, true) : "";

      if (kDebugMode) {
        print("Photo URL: $photoUrl");
      }

      Post post = Post(
        name: name,
        number: number,
        relation: relation,
        uid: uid,
        photoUrl: photoUrl,
        postId: postId,
        datePublished: DateTime.now(),
      );

      _firestore.collection('posts').doc(postId).set(post.toJson());

      res = "success";
    } catch (err) {
      res = err.toString();
    }

    return res;
  }

  // Future<void> likePost(String postId, String uid, List likes) async {
  //   if (likes.contains(uid)) {
  //     await _firestore.collection('posts').doc(postId).update({
  //       'likes': FieldValue.arrayRemove([uid]),
  //     });
  //   } else {
  //     await _firestore.collection('posts').doc(postId).update({
  //       'likes': FieldValue.arrayUnion([uid]),
  //     });
  //   }
  // }

  // Future<void> commentOnPost(String postId, String uid, String name,
  //     String comment, String profilePic) async {
  //   try {
  //     if (comment.isNotEmpty) {
  //       String commentId = const Uuid().v1();
  //       _firestore
  //           .collection('posts')
  //           .doc(postId)
  //           .collection('comments')
  //           .doc(commentId)
  //           .set({
  //         'profilePic': profilePic,
  //         'name': name,
  //         'uid': uid,
  //         'postId': postId,
  //         'text': comment,
  //         'commentId': commentId,
  //         'datePublished': DateTime.now(),
  //         'likes': [],
  //       });
  //     } else {
  //       print('Text is empty');
  //     }
  //   } catch (err) {
  //     print(err.toString());
  //   }
  // }

  // Future<void> likeComment(
  //     String postId, String uid, String commentId, List commentLikes) async {
  //   if (commentLikes.contains(uid)) {
  //     await _firestore
  //         .collection('posts')
  //         .doc(postId)
  //         .collection('comments')
  //         .doc(commentId)
  //         .update({
  //       'likes': FieldValue.arrayRemove([uid]),
  //     });
  //   } else {
  //     await _firestore
  //         .collection('posts')
  //         .doc(postId)
  //         .collection('comments')
  //         .doc(commentId)
  //         .update({
  //       'likes': FieldValue.arrayUnion([uid]),
  //     });
  //   }
  // }

  // Delete post
  Future<String> deletePost({required String postId}) async {
    try {
      await _firestore.collection('posts').doc(postId).delete();
      return "Deleted";

    } catch (err) {
      print(err.toString());
      return "Some error occured";
    }
  }

  // Future<void> followUser(
  //   String uid,
  //   String followId,
  // ) async {
  //   try {
  //     DocumentSnapshot snap =
  //         await _firestore.collection('users').doc(uid).get();
  //     List following = (snap.data()! as dynamic)['following'];
  //
  //     if (following.contains(followId)) {
  //       await _firestore.collection('users').doc(followId).update({
  //         'followers': FieldValue.arrayRemove([uid])
  //       });
  //       await _firestore.collection('users').doc(uid).update({
  //         'following': FieldValue.arrayRemove([followId])
  //       });
  //     } else {
  //       await _firestore.collection('users').doc(followId).update({
  //         'followers': FieldValue.arrayUnion([uid])
  //       });
  //       await _firestore.collection('users').doc(uid).update({
  //         'following': FieldValue.arrayUnion([followId])
  //       });
  //     }
  //   } catch (err) {
  //     print(err.toString());
  //   }
  // }
}
