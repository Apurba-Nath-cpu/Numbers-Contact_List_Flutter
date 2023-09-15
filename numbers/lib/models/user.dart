import 'package:cloud_firestore/cloud_firestore.dart';

// Model for User - Contact(email, uid, username, photoUrl)
class User {
  final String email;
  final String uid;
  final String username;
  final String photoUrl;

  const User({
    required this.email,
    required this.uid,
    required this.username,
    required this.photoUrl,
  });

  Map<String, dynamic> toJson() => {
        'username': username,
        'uid': uid,
        'email': email,
        'photoUrl': photoUrl,
      };

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    print(snapshot);
    print("kk100");
    return User(
      email: snapshot['email'],
      uid: snapshot['uid'],
      username: snapshot['username'],
      photoUrl: snapshot['photoUrl'],
    );
  }
}
