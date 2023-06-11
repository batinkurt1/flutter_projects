import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:haligol_deneme3/models/answered_application.dart';
import 'package:haligol_deneme3/models/chat_user.dart';
import 'package:haligol_deneme3/models/club.dart';
import 'package:haligol_deneme3/models/comment.dart';
import 'package:haligol_deneme3/models/comment_activity.dart';
import 'package:haligol_deneme3/models/contact.dart';
import 'package:haligol_deneme3/models/game.dart';
import 'package:haligol_deneme3/models/game_message.dart';
import 'package:haligol_deneme3/models/pending_application.dart';
import 'package:haligol_deneme3/models/player_message.dart';
import 'package:haligol_deneme3/models/post.dart';
import 'package:haligol_deneme3/models/post_activity.dart';
import 'package:haligol_deneme3/models/user.dart';
import 'package:haligol_deneme3/utilities/constants.dart';
import 'package:rxdart/rxdart.dart';

class DatabaseSystem {
  static void updateUser(User user) {
    usersRef.document(user.id).updateData({
      'name': user.name,
      'profileImageUrl': user.profileImageUrl,
      'bio': user.bio,
    });
  }

  static void updateGame(Game game) {
    userGamesRef
        .document(game.founderId)
        .collection("userGames")
        .document(game.id)
        .updateData({
      "homeSize": game.homeSize,
      "awaySize": game.awaySize,
      "homeNames": game.homeNames,
      "awayNames": game.awayNames,
      "homeProfiles": game.homeProfiles,
      "awayProfiles": game.awayProfiles,
    });
  }

  static void createUserGame({@required Game game, @required User thisUser}) {
    final String roomId = gameMessagesRef.document().documentID;

    userGamesRef
        .document(game.founderId)
        .collection('userGames')
        .document(roomId)
        .setData({
      'founderId': game.founderId,
      'title': game.title,
      'info': game.info,
      'homeNames': game.homeNames,
      'awayNames': game.awayNames,
      'teamCapacity': game.teamCapacity,
      'homeSize': game.homeSize,
      'homeProfiles': game.homeProfiles,
      'awayProfiles': game.awayProfiles,
      'city': game.city,
      'field': game.field,
      'awaySize': game.awaySize,
      'timestamp': game.timestamp,
      'startTime': game.startTime,
      'endTime': game.endTime,
      'lastMessage': game.lastMessage,
    });

    var fromGameRooms = thisUser.gameRooms;
    if (fromGameRooms == null) {
      fromGameRooms = Map<String, bool>();
    }
    fromGameRooms[roomId] = true;

    var gameFounderIds = thisUser.gameFounderIds;
    if (gameFounderIds == null) {
      gameFounderIds = Map<String, String>();
    }
    gameFounderIds[roomId] = thisUser.id;

    usersRef.document(thisUser.id).setData(
      {"gameRooms": fromGameRooms, "gameFounderIds": gameFounderIds},
      merge: true,
    );

    gameRoomsRef
        .document(thisUser.id)
        .collection("gameRooms")
        .document(roomId)
        .collection("gameUsers")
        .document(thisUser.id)
        .setData({
      "name": thisUser.name,
      "profileImageUrl": thisUser.profileImageUrl,
    });

    statusRef.document(game.id).setData({
      "startTime": game.startTime,
      "endTime": game.endTime,
      "status": Game.TO_BE_PLAYED,
    });
  }

  static void createClub(Club club) async {
    final String roomId = clubMessagesRef
        .document()
        .documentID;

    clubsRef.document(roomId).setData({
      'name': club.name,
      'clubLogoUrl': club.clubLogoUrl,
      'motto': club.motto,
      'city': club.city,
      'info': club.info,
      'founderId': club.founderId,
      'squadIds': club.squadIds,
      'playedGames': club.playedGames,
      'rating': club.rating,
      'raters': club.raters,
      'squadSize': club.squadSize,
      'timestamp': club.timestamp,
    });

    User founder = await DatabaseSystem.getUserWithId(club.founderId);
    if (founder.clubNames == null) {
      founder.clubNames = Map<String, String>();
      founder.clubFounderIds = Map<String, String>();
      founder.clubRooms = Map<String, bool>();
    }

    founder.clubNames[roomId] = club.name;
    founder.clubFounderIds[roomId] = club.founderId;
    founder.clubRooms[roomId] = true;

    usersRef.document(club.founderId).setData({
      "clubNames": founder.clubNames,
      "clubFounderIds": founder.clubFounderIds,
      "clubRooms": founder.clubRooms,
    }, merge: true);

    clubRoomsRef
        .document(club.founderId)
        .collection("clubRooms")
        .document(roomId)
        .collection("clubUsers")
        .document(club.founderId)
        .setData({
      "name": founder.name,
      "profileImageUrl": founder.profileImageUrl,
    });
  }

  static void createPost(Post post) {
    postsRef.document(post.authorId).collection("userPosts").add({
      "imageUrl": post.imageUrl,
      "caption": post.caption,
      "likeCount": post.likeCount,
      "authorId": post.authorId,
      "timestamp": post.timestamp,
    });
  }

  static Future<List<Post>> getUserPosts(String userId) async {
    QuerySnapshot postQuerySnapshot = await postsRef
        .document(userId)
        .collection("userPosts")
        .orderBy("timestamp", descending: true)
        .getDocuments();
    List<Post> posts =
        postQuerySnapshot.documents.map((doc) => Post.fromDoc(doc)).toList();
    return posts;
  }

  static Future<Post> getUserPost(String userId, String postId) async {
    DocumentSnapshot postDocSnapshot = await postsRef
        .document(userId)
        .collection("userPosts")
        .document(postId)
        .get();
    return Post.fromDoc(postDocSnapshot);
  }

  static void likePost({String currentUserId, Post post}) {
    DocumentReference postRef = postsRef
        .document(post.authorId)
        .collection("userPosts")
        .document(post.id);
    postRef.get().then((doc) {
      int likes = doc.data["likeCount"];
      postRef.updateData({"likeCount": likes + 1});
      likesRef
          .document(post.id)
          .collection("postLikes")
          .document(currentUserId)
          .setData({});
    });

    addPostActivity(
      currentUserId: currentUserId,
      post: post,
      comment: null,
    );
  }

  static void unlikePost({String currentUserId, Post post}) {
    DocumentReference postRef = postsRef
        .document(post.authorId)
        .collection('userPosts')
        .document(post.id);

    postRef.get().then((doc) {
      int likes = doc.data['likeCount'];
      postRef.updateData({'likeCount': likes - 1});
      likesRef
          .document(post.id)
          .collection('postLikes')
          .document(currentUserId)
          .get()
          .then((doc) {
        if (doc.exists) {
          doc.reference.delete();
        }
      });
    });
  }

  static Future<bool> didLikePost({String currentUserId, Post post}) async {
    DocumentSnapshot userDoc = await likesRef
        .document(post.id)
        .collection('postLikes')
        .document(currentUserId)
        .get();
    return userDoc.exists;
  }

  static void commentOnPost({String currentUserId, Post post, String comment}) {
    postCommentsRef.document(post.id).collection('postComments').add({
      'comment': comment,
      'authorId': currentUserId,
      'timestamp': Timestamp.fromDate(DateTime.now()),
    });

    addPostActivity(
      currentUserId: currentUserId,
      post: post,
      comment: comment,
    );
  }

  static Future<QuerySnapshot> searchUsers(String name) {
    print(name);
    Future<QuerySnapshot> users = usersRef
        .where("name", isGreaterThanOrEqualTo: name.toUpperCase())
        .orderBy("name", descending: true)
        .getDocuments();
    return users;
  }

  static Future<QuerySnapshot> searchClubs(String name) {
    Future<QuerySnapshot> clubs = clubsRef
        .where("name", isGreaterThanOrEqualTo: name.toUpperCase())
        .getDocuments();
    return clubs;
  }

  static Future<QuerySnapshot> searchGames(String caption) {
    Future<QuerySnapshot> games = userGamesRef
        .where("caption", isGreaterThanOrEqualTo: caption)
        .getDocuments();
    return games;
  }

  static Future<List<PendingApplication>> getPendingApplications(
      String userId) async {
    QuerySnapshot pendingAppsSnapshot = await appsPendingRef
        .document(userId)
        .collection("gameApplications")
        .orderBy("timestamp", descending: true)
        .getDocuments();

    List<PendingApplication> pendingApps = pendingAppsSnapshot.documents
        .map((doc) => PendingApplication.fromDoc(doc))
        .toList();
    return pendingApps;
  }

  static Future<List<AnsweredApplication>> getAnsweredApplications(
      String userId) async {
    QuerySnapshot appliedAppsSnapshot = await appsAnsweredRef
        .document(userId)
        .collection("applied")
        .orderBy("timestamp", descending: true)
        .getDocuments();
    QuerySnapshot answeredByAppsSnapshot = await appsAnsweredRef
        .document(userId)
        .collection("answered")
        .orderBy("timestamp", descending: true)
        .getDocuments();

    List<AnsweredApplication> appliedList = appliedAppsSnapshot.documents
        .map((doc) => AnsweredApplication.fromDoc(doc))
        .toList();
    List<AnsweredApplication> answeredByList = answeredByAppsSnapshot.documents
        .map((doc) => AnsweredApplication.fromDoc(doc))
        .toList();

    appliedList.addAll(answeredByList);
    appliedList.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    return appliedList;
  }

  static Future<String> applyToGame(
      {String currentUserId, String message, Game game, int side}) async {
    Game _game = await DatabaseSystem.getGameWithId(game.id, game.founderId);

    if ((_game.awaySize >= _game.teamCapacity && side == Game.AWAY) ||
        (_game.homeSize >= _game.teamCapacity && side == Game.HOME)) {
      return "Game is full!";
    } else if (_game.awayNames.containsKey(currentUserId) ||
        _game.homeNames.containsKey(currentUserId)) {
      return "Already in game!";
    }

    appsPendingRef
        .document(game.founderId)
        .collection("gameApplications")
        .document(currentUserId)
        .setData({
      "userId": game.founderId,
      "gameId": game.id,
      "authorId": currentUserId,
      "side": side,
      "timestamp": Timestamp.now(),
      "message": message,
    });
    return "Successful!";
  }

  static void updateApplication(
      {PendingApplication application,
      final bool accepted,
      User applicant}) async {
    print(applicant.name + " " + applicant.id);

    appsPendingRef
        .document(application.userId)
        .collection("gameApplications")
        .document(application.authorId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    appsAnsweredRef
        .document(application.authorId)
        .collection("applied")
        .document(application.userId)
        .setData({
      "authorId": application.authorId,
      "userId": application.userId,
      "gameId": application.gameId,
      "timestamp": Timestamp.now(),
      "accepted": accepted,
    });
    appsAnsweredRef
        .document(application.userId)
        .collection("answered")
        .document(application.authorId)
        .setData({
      "authorId": application.authorId,
      "userId": application.userId,
      "gameId": application.gameId,
      "timestamp": Timestamp.now(),
      "accepted": accepted,
    });
    if (accepted) {
      Game newGame, oldGame;

      DocumentSnapshot doc = await userGamesRef
          .document(application.userId)
          .collection("userGames")
          .document(application.gameId)
          .get();

      if (doc.exists) {
        oldGame = Game.fromDoc(doc);
      } else {
        oldGame = Game();
      }

      if ((oldGame.awaySize >= oldGame.teamCapacity &&
              application.side == Game.AWAY) ||
          (oldGame.homeSize >= oldGame.teamCapacity &&
              application.side == Game.HOME)) {
        return;
      } else if (oldGame.awayNames.containsKey(application.authorId) ||
          oldGame.homeNames.containsKey(application.authorId)) {
        return;
      }

      // if users game rooms is null, initialize it
      var userGameRooms = applicant.gameRooms;
      if (userGameRooms == null) {
        userGameRooms = Map<String, bool>();
      }

      // add the game roomId to the user game room id map
      var userGameFounderIds = applicant.gameFounderIds;
      if (userGameFounderIds == null) {
        userGameFounderIds = Map<String, String>();
      }

      userGameFounderIds[oldGame.id] = application.userId;

      userGameRooms[oldGame.id] = true;
      usersRef.document(applicant.id).setData(
          {"gameRooms": userGameRooms, "gameFounderIds": userGameFounderIds},
          merge: true);

      // add the user to the his/her own game room reference
      gameRoomsRef
          .document(application.authorId)
          .collection("gameRooms")
          .document(oldGame.id)
          .collection("gameUsers")
          .document(application.authorId)
          .setData({
        "name": applicant.name,
        "profileImageUrl": applicant.profileImageUrl,
      });

      for (var i in oldGame.homeProfiles.keys) {
        gameRoomsRef
            .document(i)
            .collection("gameRooms")
            .document(oldGame.id)
            .collection("gameUsers")
            .document(application.authorId)
            .setData({
          "name": applicant.name,
          "profileImageUrl": applicant.profileImageUrl,
        });

        gameRoomsRef
            .document(application.authorId)
            .collection("gameRooms")
            .document(oldGame.id)
            .collection("gameUsers")
            .document(i)
            .setData({
          "name": oldGame.homeNames[i],
          "profileImageUrl": oldGame.homeProfiles[i],
        });
      }

      for (var i in oldGame.awayProfiles.keys) {
        gameRoomsRef
            .document(i)
            .collection("gameRooms")
            .document(oldGame.id)
            .collection("gameUsers")
            .document(application.authorId)
            .setData({
          "name": applicant.name,
          "profileImageUrl": applicant.profileImageUrl,
        });

        gameRoomsRef
            .document(application.authorId)
            .collection("gameRooms")
            .document(oldGame.id)
            .collection("gameUsers")
            .document(i)
            .setData({
          "name": oldGame.awayNames[i],
          "profileImageUrl": oldGame.awayProfiles[i],
        });
      }

      gameRoomsRef
          .document(application.authorId)
          .collection("gameRooms")
          .document(oldGame.id)
          .collection("gameUsers")
          .document(application.authorId)
          .setData({
        "name": applicant.name,
        "profileImageUrl": applicant.profileImageUrl,
      });

      if (application.side == Game.HOME) {
        Map<String, String> _oldHomeNames =
            Map<String, String>.from(oldGame.homeNames);
        Map<String, String> _oldHomeProfiles =
            Map<String, String>.from(oldGame.homeProfiles);

        Map<String, String> _homeNames =
            Map<String, String>.from(_oldHomeNames);
        Map<String, String> _homeProfiles =
            Map<String, String>.from(_oldHomeProfiles);

        _homeNames[application.authorId] = applicant.name;
        _homeProfiles[application.authorId] = applicant.profileImageUrl;

        newGame = Game(
          id: oldGame.id,
          title: oldGame.title,
          info: oldGame.info,
          teamCapacity: oldGame.teamCapacity,
          city: oldGame.city,
          field: oldGame.field,
          homeSize: oldGame.homeSize + 1,
          awaySize: oldGame.awaySize,
          founderId: oldGame.founderId,
          homeNames: _homeNames,
          awayNames: oldGame.awayNames,
          homeProfiles: _homeProfiles,
          awayProfiles: oldGame.awayProfiles,
          startTime: oldGame.startTime,
          endTime: oldGame.endTime,
          timestamp: oldGame.timestamp,
        );

        DatabaseSystem.updateGame(newGame);
      } else {
        Map<String, String> _oldAwayNames =
            Map<String, String>.from(oldGame.awayNames);
        Map<String, String> _oldAwayProfiles =
            Map<String, String>.from(oldGame.awayProfiles);

        Map<String, String> _awayNames =
            Map<String, String>.from(_oldAwayNames);
        Map<String, String> _awayProfiles =
            Map<String, String>.from(_oldAwayProfiles);

        _awayNames[application.authorId] = applicant.name;
        _awayProfiles[application.authorId] = applicant.profileImageUrl;

        newGame = Game(
          id: oldGame.id,
          title: oldGame.title,
          info: oldGame.info,
          teamCapacity: oldGame.teamCapacity,
          city: oldGame.city,
          field: oldGame.field,
          homeSize: oldGame.homeSize,
          awaySize: oldGame.awaySize + 1,
          founderId: oldGame.founderId,
          homeNames: _awayNames,
          awayNames: oldGame.awayNames,
          homeProfiles: _awayProfiles,
          awayProfiles: oldGame.awayProfiles,
          startTime: oldGame.startTime,
          endTime: oldGame.endTime,
          timestamp: oldGame.timestamp,
        );

        DatabaseSystem.updateGame(newGame);
      }
    }
  }

  static void followUser({String currentUserId, String userId}) async {
    User currentUser = await DatabaseSystem.getUserWithId(currentUserId);
    User user = await DatabaseSystem.getUserWithId(userId);

    followingRef
        .document(currentUserId)
        .collection('userFollowing')
        .document(userId)
        .setData({'name': user.name, 'profileImageUrl': user.profileImageUrl});

    followersRef
        .document(userId)
        .collection('userFollowers')
        .document(currentUserId)
        .setData(
      {
        'name': currentUser.name,
        'profileImageUrl': currentUser.profileImageUrl
      },
    );
  }

  static Future<List<Contact>> getUserContacts(String currentUserId) async {
    QuerySnapshot userContactsSnapshot = await followingRef
        .document(currentUserId)
        .collection("userFollowing")
        .orderBy("name", descending: false)
        .getDocuments();

    List<Contact> contacts = userContactsSnapshot.documents
        .map((doc) => Contact.fromDoc(doc))
        .toList();
    return contacts;
  }

  static void unfollowUser({String currentUserId, String userId}) {
    // Remove user from current user's following collection
    followingRef
        .document(currentUserId)
        .collection('userFollowing')
        .document(userId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    // Remove current user from user's followers collection
    followersRef
        .document(userId)
        .collection('userFollowers')
        .document(currentUserId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
  }

  static Future<bool> isFollowingUser({String currentUid, String uid}) async {
    DocumentSnapshot followingDoc = await followersRef
        .document(uid)
        .collection('userFollowers')
        .document(currentUid)
        .get();
    return followingDoc.exists;
  }

  static Future<int> numPlayedGames(String uid) async {
    DocumentSnapshot userDocSnapshot = await usersRef.document(uid).get();
    if (userDocSnapshot.exists) {
      User user = User.fromDoc(userDocSnapshot);
      return user.playedGames;
    }
    return 0;
  }

  static Future<int> numFollowing(String userId) async {
    QuerySnapshot followingSnapshot = await followingRef
        .document(userId)
        .collection('userFollowing')
        .getDocuments();
    return followingSnapshot.documents.length;
  }

  static Future<int> numFollowers(String userId) async {
    QuerySnapshot followersSnapshot = await followersRef
        .document(userId)
        .collection('userFollowers')
        .getDocuments();
    return followersSnapshot.documents.length;
  }

  static Future<Map<String, double>> handleUserRating(String userId) async {
    QuerySnapshot commentsSnapshot = await userCommentsRef
        .document(userId)
        .collection("userComments")
        .getDocuments();

    int raters = commentsSnapshot.documents.length;

    double totalRating = 0;

    for (var i in commentsSnapshot.documents) {
      totalRating += i.data["score"] as int;
    }
    Map<String, double> rate = Map<String, double>();

    rate["rating"] = raters == 0 ? 0.0 : totalRating / raters / 5.0;
    rate["raters"] = raters.toDouble();
    return rate;
  }

  static Future<Map<String, double>> handleClubRating(String clubId) async {
    QuerySnapshot commentsSnapshot = await clubCommentsRef
        .document(clubId)
        .collection("clubComments")
        .getDocuments();

    int raters = commentsSnapshot.documents.length;

    double totalRating = 0;

    for (var i in commentsSnapshot.documents) {
      totalRating += i.data["score"] as int;
    }
    Map<String, double> rate = Map<String, double>();

    rate["rating"] = raters == 0 ? 0.0 : totalRating / raters / 5.0;
    rate["raters"] = raters.toDouble();
    return rate;
  }

  static Stream<List<Game>> getFeedGames(String uid) {
    return feedsRef
        .document(uid)
        .collection("feedGames")
        .orderBy("timestamp", descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.documents.map((doc) => Game.fromDoc(doc)).toList());
  }

  static Stream<List<Feed>> getUserFeed(String uid) {
    Stream<List<Feed>> feedGames = DatabaseSystem.getFeedGames(uid);
    Stream<List<Feed>> feedPosts = DatabaseSystem.getFeedPosts(uid);
    return Rx.merge([feedGames, feedPosts]);
  }

  static Stream<List<Post>> getFeedPosts(String uid) {
    return feedsRef
        .document(uid)
        .collection("feedPosts")
        .orderBy("timestamp", descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.documents.map((doc) => Post.fromDoc(doc)).toList());
  }

  static Stream<List<PlayerMessage>> getPlayerRoomMessages(String roomId) {
    return playerMessagesRef
        .document(roomId)
        .collection("roomMessages")
        .orderBy("sentAt", descending: false)
        .snapshots()
        .map((snapshot) => snapshot.documents
            .map((doc) => PlayerMessage.fromDoc(doc))
            .toList());
  }

  static Future<List<ChatUser>> getUserRooms(String uid) async {
    QuerySnapshot userRoomsSnapshot = await playerRoomsRef
        .document(uid)
        .collection("userRooms")
        .orderBy("lastMessage", descending: true)
        .getDocuments();

    List<ChatUser> users = userRoomsSnapshot.documents
        .map((doc) => ChatUser.fromDoc(doc))
        .toList();
    return users;
  }

  static Future<List<Game>> getGameRooms(String uid) async {
    User user = await DatabaseSystem.getUserWithId(uid);
    List<Game> gameList = [];

    for (var gameId in user.gameRooms.keys) {
      if (user.gameFounderIds.containsKey(gameId)) {
        var founderId = user.gameFounderIds[gameId];
        Game game = await DatabaseSystem.getGameWithId(gameId, founderId);
        gameList.add(game);
      }
    }

    gameList.sort((a, b) => a.lastMessage.compareTo(b.lastMessage));
    return gameList;
  }

  static Future<List<Game>> getUserGames(String uid) async {
    QuerySnapshot userGamesSnapshot = await userGamesRef
        .document(uid)
        .collection("userGames")
        .orderBy("timestamp", descending: true)
        .getDocuments();

    List<Game> games =
    userGamesSnapshot.documents.map((doc) => Game.fromDoc(doc)).toList();
    return games;
  }

  static Future<List<Game>> getClubGames(String id) async {
    QuerySnapshot clubGamesSnapshot = await clubGamesRef
        .document(id)
        .collection("clubGames")
        .orderBy("timestamp", descending: true)
        .getDocuments();

    List<Game> games =
    clubGamesSnapshot.documents.map((doc) => Game.fromDoc(doc)).toList();
    return games;
  }

  static Future<User> getUserWithId(String uid) async {
    DocumentSnapshot userDocSnapshot = await usersRef.document(uid).get();
    if (userDocSnapshot.exists) {
      return User.fromDoc(userDocSnapshot);
    }
    return User();
  }

  static Future<Club> getClubWithId(String id) async {
    DocumentSnapshot clubDocSnapshot = await clubsRef.document(id).get();
    if (clubDocSnapshot.exists) {
      return Club.fromDoc(clubDocSnapshot);
    }
    return Club();
  }

  static Stream<List<GameMessage>> getGameRoomMessages(String roomId) {
    return gameMessagesRef
        .document(roomId)
        .collection("roomMessages")
        .orderBy("sentAt", descending: false)
        .snapshots()
        .map((snapshot) =>
        snapshot.documents.map((doc) => GameMessage.fromDoc(doc)).toList());
  }

  static Future<Game> getGameWithId(String gameId, String founderId) async {
    DocumentSnapshot gameDocSnapshot = await userGamesRef
        .document(founderId)
        .collection("userGames")
        .document(gameId)
        .get();
    if (gameDocSnapshot.exists) {
      return Game.fromDoc(gameDocSnapshot);
    }
    return Game();
  }

  static Future<List<Comment>> getUserComments(String uid) async {
    QuerySnapshot userCommentsSnapshot = await userCommentsRef
        .document(uid)
        .collection("usersComments")
        .orderBy("timestamp", descending: true)
        .getDocuments();
    List<Comment> comments = userCommentsSnapshot.documents
        .map((doc) => Comment.fromDoc(doc))
        .toList();
    return comments;
  }

  static Future<List<Comment>> getClubComments(String id) async {
    QuerySnapshot clubCommentsSnapshot = await clubCommentsRef
        .document(id)
        .collection("usersComments")
        .orderBy("timestamp", descending: true)
        .getDocuments();

    List<Comment> comments = clubCommentsSnapshot.documents
        .map((doc) => Comment.fromDoc(doc))
        .toList();
    return comments;
  }

  static Future<List<CommentActivity>> getCommentActivities(
      String userId) async {
    QuerySnapshot userComActSnapshot = await comActivitiesRef
        .document(userId)
        .collection("userComments")
        .orderBy("timestamp", descending: true)
        .getDocuments();
    List<CommentActivity> comAct = userComActSnapshot.documents
        .map((doc) => CommentActivity.fromDoc(doc))
        .toList();
    return comAct;
  }

  static void commentOnUser(
      {String currentUserId, String userId, String comment, double score}) {
    userCommentsRef
        .document(userId)
        .collection("userComments")
        .document(currentUserId)
        .setData({
      "comment": comment,
      "authorId": currentUserId,
      "timestamp": Timestamp.now(),
      "score": score,
    });
  }

  static void messageToGame({
    @required String roomId,
    @required String fromUid,
    @required String fromUserName,
    @required String message,
    @required bool homeSees,
    @required bool awaySees,
  }) {
    gameMessagesRef.document(roomId).collection("roomMessages").add({
      "fromUid": fromUid,
      "fromUserName": fromUserName,
      "message": message,
      "sentAt": Timestamp.now(),
      "homeSees": homeSees,
      "awaySees": awaySees,
    });
  }

  static void messageToUser(
      {@required String roomId,
      @required String fromUserId,
      @required String fromUserName,
      @required String messageText}) {
    playerMessagesRef.document(roomId).collection("roomMessages").add({
      "fromUid": fromUserId,
      "fromUserName": fromUserName,
      "message": messageText,
      "sentAt": Timestamp.now()
    });
  }

  static void addCommentActivity(
      {String currentUserId, String userId, String comment, double score}) {
    comActivitiesRef
        .document(userId)
        .collection("userComments")
        .document(currentUserId)
        .setData({
      "userId": userId,
      "authorId": currentUserId,
      "comment": comment,
      "score": score,
      "timestamp": Timestamp.now(),
    });
  }

  static addPostActivity({String currentUserId, Post post, String comment}) {
    if (currentUserId != post.authorId) {
      postActivitiesRef
          .document(post.authorId)
          .collection("userActivities")
          .add({
        "authorId": currentUserId,
        "postId": post.id,
        "postImageUrl": post.imageUrl,
        "comment": comment,
        "timestamp": Timestamp.now()
      });
    }
  }

  static Future<List<PostActivity>> getPostActivities(String userId) async {
    QuerySnapshot postActsSnapshot = await postActivitiesRef
        .document(userId)
        .collection("userActivities")
        .orderBy("timestamp", descending: true)
        .getDocuments();
    List<PostActivity> postActs = postActsSnapshot.documents
        .map((doc) => PostActivity.fromDoc(doc))
        .toList();
    return postActs;
  }
}
