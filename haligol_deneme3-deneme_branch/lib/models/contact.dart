import 'package:cloud_firestore/cloud_firestore.dart';

class Contact {
  final String id;
  final String name;
  final String profileImageUrl;

  Contact({
    this.id,
    this.name,
    this.profileImageUrl,
  });

  factory Contact.fromDoc(DocumentSnapshot doc){
    return Contact(
      id: doc.documentID,
      name: doc['name'],
      profileImageUrl: doc['profileImageUrl'],
    );
  }
}
