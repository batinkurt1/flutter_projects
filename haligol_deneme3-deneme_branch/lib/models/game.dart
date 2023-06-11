import 'package:cloud_firestore/cloud_firestore.dart';
import 'post.dart';

class Game implements Feed{
  static const int HOME = 0, AWAY = 1;

  static const int TO_BE_PLAYED = 0, BEING_PLAYED = 1, PLAYED = 2;

  final String id;
  final String title;
  final String info;

  final int teamCapacity;
  final int homeSize;
  final int awaySize;

  final Map homeNames; // players' ids : players' names
  final Map awayNames; // name won't be updatable so this map is cool

  final Map homeProfiles; // players' ids : players' profile pictures , not going to update profile pictures
  final Map awayProfiles; // for the time being but may do it in later updates

  final String founderId;

  final String city;
  final String field;

  final Timestamp startTime;
  final Timestamp endTime;
  final Timestamp timestamp;
  final Timestamp lastMessage;

  final int appliedCount;

  Game({
    this.id,
    this.title,
    this.info,
    this.teamCapacity,
    this.homeSize,
    this.awaySize,
    this.homeProfiles,
    this.awayProfiles,
    this.homeNames,
    this.awayNames,
    this.founderId,
    this.city,
    this.field,
    this.startTime,
    this.endTime,
    this.timestamp,
    this.lastMessage,
    this.appliedCount = 0,
  });

  factory Game.fromDoc(DocumentSnapshot doc) {
    return Game(
      id: doc.documentID,
      title: doc['title'],
      info: doc['info'],
      teamCapacity: doc['teamCapacity'],
      homeSize: doc['homeSize'],
      awaySize: doc['awaySize'],
      homeNames: doc['homeNames'],
      awayNames: doc['awayNames'],
      homeProfiles: doc['homeProfiles'],
      awayProfiles: doc['awayProfiles'],
      founderId: doc['founderId'],
      city: doc['city'],
      field: doc['field'],
      startTime: doc['startTime'],
      endTime: doc['endTime'],
      timestamp: doc['timestamp'],
      lastMessage: doc['lastMessage'],
      appliedCount: doc["appliedCount"],
    );
  }
}
