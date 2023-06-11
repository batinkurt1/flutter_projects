import 'package:cloud_firestore/cloud_firestore.dart';

class Club {
  final String id;
  final String name;
  final String clubLogoUrl;
  final String motto;
  final String city;
  final String info;
  final String founderId;

  final Map squadIds;

  final int playedGames;
  final int rating;
  final int raters;
  final int squadSize;

  final Timestamp timestamp;

  final Timestamp lastMessage;

  Club({
    this.id,
    this.name,
    this.clubLogoUrl,
    this.motto,
    this.city,
    this.info,
    this.squadSize,
    this.squadIds,
    this.founderId,
    this.playedGames,
    this.rating,
    this.raters,
    this.timestamp,
    this.lastMessage,
  });

  factory Club.fromDoc(DocumentSnapshot doc) {
    return Club(
      id: doc.documentID,
      name: doc['name'],
        clubLogoUrl: doc['clobLogoUrl'],
        motto: doc['motto'],
        info: doc['info'],
        city: doc['city'],
        squadSize: doc['squadSize'],
        squadIds: doc['squadIds'],
        playedGames: doc['playedGames'],
        rating: doc['rating'],
        raters: doc['raters'],
        timestamp: doc['timestamp'],
        lastMessage: doc['lastMessage']);
  }
}
