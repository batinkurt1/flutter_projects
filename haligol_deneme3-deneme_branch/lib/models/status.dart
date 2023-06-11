import 'package:cloud_firestore/cloud_firestore.dart';

class Status {
  final String id;
  final Timestamp endTime;
  final Timestamp startTime;

  final int status;

  Status({
    this.id,
    this.endTime,
    this.startTime,
    this.status,
  });

  factory Status.fromDoc(DocumentSnapshot doc) {
    return Status(
      id: doc.documentID,
      endTime: doc['endTime'],
      startTime: doc['startTime'],
      status: doc['status'],
    );
  }
}
