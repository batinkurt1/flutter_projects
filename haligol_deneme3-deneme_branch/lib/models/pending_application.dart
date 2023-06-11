import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:haligol_deneme3/models/answered_application.dart';

class PendingApplication implements Activity{
  final String id;
  final String authorId;
  final String gameId;
  final String userId;
  final String message;
  final Timestamp timestamp;
  final int side;


  PendingApplication({
    this.id,
    this.authorId,
    this.gameId,
    this.userId,
    this.message,
    this.timestamp,
    this.side,
  });

  factory PendingApplication.fromDoc(DocumentSnapshot doc) {
    return PendingApplication(
      id: doc.documentID,
      authorId: doc["authorId"],
      gameId: doc["gameId"],
      userId: doc["userId"],
      message: doc["message"],
      timestamp: doc["timestamp"],
      side: doc["side"],
    );
  }
}
