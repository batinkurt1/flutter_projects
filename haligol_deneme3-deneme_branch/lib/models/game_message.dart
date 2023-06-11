import 'package:cloud_firestore/cloud_firestore.dart';

class GameMessage {
  final String id;
  final String fromUid;
  final String fromUserName;
  final String message;
  final Timestamp sentAt;
  final bool homeSees;
  final bool awaySees;

  GameMessage(
      {this.id,
      this.fromUid,
      this.message,
      this.fromUserName,
      this.sentAt,
      this.awaySees,
      this.homeSees});

  factory GameMessage.fromDoc(DocumentSnapshot doc) {
    return GameMessage(
      id: doc.documentID,
      fromUid: doc["fromUid"],
      fromUserName: doc["fromUserName"],
      message: doc["message"],
      sentAt: doc["sentAt"],
      homeSees: doc["homeSees"],
      awaySees: doc["awaySees"],
    );
  }
}
