import 'package:cloud_firestore/cloud_firestore.dart';

class ChatUser {
  final String roomId;
  final String userId;
  final String name;
  final String profileImageUrl;

  ChatUser({this.name, this.roomId, this.userId, this.profileImageUrl});

  factory ChatUser.fromDoc(DocumentSnapshot doc) {
    return ChatUser(
      roomId: doc.documentID,
      userId: doc["userId"],
      name: doc["name"],
      profileImageUrl: doc["profileImageUrl"],
    );
  }
}
