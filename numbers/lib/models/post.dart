import 'package:cloud_firestore/cloud_firestore.dart';

// Model for Post - Contact(name, number, relation, uid, photoUrl, postId, datePublished)
class Post {
  final String name;
  final String number;
  final String relation;
  final String uid;
  final String photoUrl;
  final String postId;
  final datePublished;

  const Post({
    required this.name,
    required this.number,
    required this.relation,
    required this.uid,
    required this.photoUrl,
    required this.postId,
    required this.datePublished,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'number': number,
        'relation': relation,
        'uid': uid,
        'profImage': photoUrl,
        'postId': postId,
        'datePublished': datePublished,
      };

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Post(
      name: snapshot['name'],
      number: snapshot['number'],
      relation: snapshot['relation'],
      uid: snapshot['uid'],
      photoUrl: snapshot['pphotoUrl'],
      postId: snapshot['postId'],
      datePublished: snapshot['datePublished'],
    );
  }
}
