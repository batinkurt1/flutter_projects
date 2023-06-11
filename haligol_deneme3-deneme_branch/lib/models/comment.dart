import "package:cloud_firestore/cloud_firestore.dart";

class Comment {
  final String id;
  final double score;
  final String comment;
  final String authorId;
  final Timestamp timestamp;

  Comment({
    this.id,
    this.score,
    this.comment,
    this.authorId,
    this.timestamp,
  });

  factory Comment.fromDoc(DocumentSnapshot doc) {
    return Comment(
      id: doc.documentID,
      score: doc["score"],
      comment: doc["comment"],
      authorId: doc["authorId"],
      timestamp: doc["timestamp"],
    );
  }
}
