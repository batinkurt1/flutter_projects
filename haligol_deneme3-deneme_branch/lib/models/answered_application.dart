import 'package:cloud_firestore/cloud_firestore.dart';

abstract class Activity{

}

class AnsweredApplication implements Activity{
  final String id;
  final String authorId;
  final String gameId;
  final String userId;
  final Timestamp timestamp;
  final int side;
  final bool accepted;


  AnsweredApplication({
    this.id,
    this.authorId,
    this.gameId,
    this.userId,
    this.timestamp,
    this.side,
    this.accepted,
  });

  factory AnsweredApplication.fromDoc(DocumentSnapshot doc) {
    return AnsweredApplication(
      id: doc.documentID,
      authorId: doc["authorId"],
      gameId: doc["gameId"],
      userId: doc["userId"],
      timestamp: doc["timestamp"],
      side: doc["side"],
      accepted: doc["accepted"],
    );
  }
}
