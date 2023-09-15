import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:numbers/models/post.dart';
import 'package:numbers/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Upload Contact to Firestore

  Future<String> uploadContact(
    Uint8List? file, {
    required String name,
    required String number,
    required String relation,
    required String uid,
  }) async {
    String res = "Some error occured";
    try {
      String photoUrl = file != null
          ? await StorageMethods().uploadImageTostorage('posts', file, true)
          : "";

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

  // Update Contact in Firestore

  Future<String> updateContact(Uint8List? file,
      {required String name,
      required String number,
      required String relation,
      required String uid,
      required String postId}) async {
    String res = "Some error occured";

    try {
      String photoUrl = file != null
          ? await StorageMethods().uploadImageTostorage('posts', file, true)
          : "";

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

  // Delete Contact from Firestore
  Future<String> deletePost({required String postId}) async {
    try {
      await _firestore.collection('posts').doc(postId).delete();
      return "Deleted";
    } catch (err) {
      print(err.toString());
      return "Some error occured";
    }
  }
}
