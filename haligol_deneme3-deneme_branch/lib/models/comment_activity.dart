import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:haligol_deneme3/models/answered_application.dart';

class CommentActivity implements Activity{
  final String id;
  final String authorId;
  final String userId;
  final String comment;
  final double score;
  final Timestamp timestamp;

  CommentActivity({
    this.id,
    this.authorId,
    this.userId,
    this.score,
    this.comment,
    this.timestamp,
  });

  factory CommentActivity.fromDoc(DocumentSnapshot doc) {
    return CommentActivity(
      id: doc.documentID,
      authorId: doc["authorId"],
      userId: doc["userId"],
      score: doc["score"],
      comment: doc["comment"],
      timestamp: doc["timestamp"],
    );
  }
}

