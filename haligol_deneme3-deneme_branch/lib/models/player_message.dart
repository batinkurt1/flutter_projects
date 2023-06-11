import 'package:cloud_firestore/cloud_firestore.dart';

class PlayerMessage {
  final String id;
  final String fromUid;
  final String fromUserName;
  final String message;
  final Timestamp sentAt;

  PlayerMessage(
      {this.fromUid, this.fromUserName, this.message, this.sentAt, this.id});

  factory PlayerMessage.fromDoc(DocumentSnapshot doc) {
    return PlayerMessage(
      id: doc.documentID,
      fromUid: doc["fromUid"],
      fromUserName: doc["fromUserName"],
      message: doc["message"],
      sentAt: doc["sentAt"],
    );
  }
}
