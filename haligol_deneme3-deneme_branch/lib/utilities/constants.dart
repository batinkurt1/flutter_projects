import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

final firestore = Firestore.instance;
final storageRef = FirebaseStorage.instance.ref();

final usersRef = firestore.collection("users");

final statusRef = firestore.collection("status");
final postsRef = firestore.collection("posts");
final clubsRef = firestore.collection("clubs");

final userGamesRef = firestore.collection("userGames");
final clubGamesRef = firestore.collection("clubGames");

final feedsRef = firestore.collection("feeds");

final followersRef = firestore.collection("followers");
final followingRef = firestore.collection("following");

final userCommentsRef = firestore.collection("userComments");
final clubCommentsRef = firestore.collection("clubComments");

final appsPendingRef = firestore
    .collection("appsPending"); // this collection is for the game founder
final appsAnsweredRef =
    firestore.collection("appsAnswered"); // this is for the applicant
final comActivitiesRef = firestore.collection("comActivities");

final likesRef = firestore.collection("likes");
final postCommentsRef = firestore.collection('postComments');
final postActivitiesRef = firestore.collection("postActivities");

final playerRoomsRef = firestore.collection("playerRooms");
final playerMessagesRef = firestore.collection("playerMessages");

final gameRoomsRef = firestore.collection("gameRooms");
final gameMessagesRef = firestore.collection("gameMessages");

final clubRoomsRef = firestore.collection("clubRooms");
final clubMessagesRef = firestore.collection("clubMessages");


final List<String> cities = ["Adana", "Adıyaman"];

final List<String> fields = [
  "01_Halısaha 1",
  "01_Halısaha 2",
  "01_Halısaha 3",
  "01_Halısaha 4",
  "02_Halısaha 1",
  "02_Halısaha 2"
];
