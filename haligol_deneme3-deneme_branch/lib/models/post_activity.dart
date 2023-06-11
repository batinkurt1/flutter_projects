import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:haligol_deneme3/models/answered_application.dart';

class PostActivity implements Activity{
  final String id;
  final String fromUserId;
  final String postId;
  final String postImageUrl;
  final String comment;
  final Timestamp timestamp;

  PostActivity({
    this.id,
    this.fromUserId,
    this.postId,
    this.postImageUrl,
    this.comment,
    this.timestamp,
  });

  factory PostActivity.fromDoc(DocumentSnapshot doc) {
    return PostActivity(
      id: doc.documentID,
      fromUserId: doc['fromUserId'],
      postId: doc['postId'],
      postImageUrl: doc['postImageUrl'],
      comment: doc['comment'],
      timestamp: doc['timestamp'],
    );
  }
}