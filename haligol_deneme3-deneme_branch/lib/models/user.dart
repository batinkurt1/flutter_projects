import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  static const int LEVEL_CONSTRAINT = 1;

  final String id;
  final String name;
  final String profileImageUrl;
  final String email;
  final String bio;

  Map playerRooms;
  Map gameRooms;
  Map clubRooms;

  Map clubNames; // {id: name}
  Map clubFounderIds;

  Map gameFounderIds;

  final int playedGames;
  final int level;
  final int rating;
  final int raters;

  User({
    this.id,
    this.name,
    this.profileImageUrl,
    this.email,
    this.bio,
    this.playerRooms,
    this.gameRooms,
    this.clubRooms,
    this.clubNames,
    this.clubFounderIds,
    this.gameFounderIds,
    this.playedGames,
    this.level,
    this.rating,
    this.raters,
  });

  factory User.fromDoc(DocumentSnapshot doc) {
    return User(
      id: doc.documentID,
      name: doc['name'],
      profileImageUrl: doc['profileImageUrl'],
      email: doc['email'],
      bio: doc['bio'] ?? '',
      playerRooms: doc['playerRooms'],
      gameRooms: doc['gameRooms'],
      clubRooms: doc['clubRooms'],
      clubNames: doc['clubNames'],
      clubFounderIds: doc['clubFounderIds'],
      gameFounderIds: doc['gameFounderIds'],
      playedGames: doc['playedGames'],
      level: doc['level'],
      rating: doc['ratingAvg'],
      raters: doc['raters'],
    );
  }
}
