import 'package:cloud_firestore/cloud_firestore.dart';

class PostComment {
  final String id;
  final String comment;
  final String authorId;
  final Timestamp timestamp;

  PostComment({
    this.id,
    this.comment,
    this.authorId,
    this.timestamp,
  });

  factory PostComment.fromDoc(DocumentSnapshot doc) {
    return PostComment(
      id: doc.documentID,
      comment: doc['comment'],
      authorId: doc['authorId'],
      timestamp: doc['timestamp'],
    );
  }
}
