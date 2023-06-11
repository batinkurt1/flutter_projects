const functions = require('firebase-functions');

const admin = require('firebase-admin');
admin.initializeApp();

const db = admin.firestore();

const STATUS_PLAYED = 2;
const STATUS_BEING_PLAYED = 1;
const STATUS_TO_BE_PLAYED = 0;

exports.onApplyGame = functions.region('europe-west3').firestore.document("/appsPending/{uid}/gameApplications/{gameId}").onCreate( async (snapshot, context) => {
    const uid = context.params.uid;
    const gameId = context.params.gameId;
    const increment = admin.firestore.FieldValue.increment(1);

    const appliedGameRef = admin.firestore().collection("games").doc(uid).collection("userGames").document(gameId);
    appliedGameRef.update({appliedCount: increment});
});

exports.onFollowUser = functions.region('europe-west3').firestore
  .document('/followers/{uid}/userFollowers/{followerId}')
  .onCreate(async (snapshot, context) => {
    console.log(snapshot.data());
    const uid = context.params.uid;
    const followerId = context.params.followerId;
    const followedUserGamesRef = admin
      .firestore()
      .collection('games')
      .doc(uid)
      .collection('userGames');
    const userFeedRef = admin
      .firestore()
      .collection('feeds')
      .doc(followerId)
      .collection('userFeed');
    const followedUserGamesSnapshot = await followedUserGamesRef.get();
    followedUserGamesSnapshot.forEach(doc => {
      if (doc.exists) {
        userFeedRef.doc(doc.id).set(doc.data());
      }
    });
  });

exports.handleToBePlayedGame = functions.region('europe-west3').pubsub.schedule('1 1 1 1 1').timeZone('Europe/Istanbul').onRun(
    async () => {
        const now = admin.firestore.Timestamp.fromDate(new Date());
        const statusRef = db.collection("status").where("status", "==", STATUS_TO_BE_PLAYED).where("startTime", "<", now);
        return statusRef.get()
            .then(querySnapshot => {
                if( querySnapshot.empty) {
                    console.log("querySnapshot is empty!");
                    return null;
                } else {
                    console.log("successful!");
                    const promises = [];
                    querySnapshot.forEach( doc => {
                        promises.push(doc.ref.update({status: STATUS_BEING_PLAYED}));
                    });
                    return Promise.all(promises);
                }
            });
        }
    );

exports.handleBeingPlayedGame = functions.region('europe-west3').pubsub.schedule('1 1 1 1 1').timeZone('Europe/Istanbul').onRun(
    async () => {
        const now = admin.firestore.Timestamp.fromDate(new Date());
        const statusRef = db.collection("status").where("status", "==", STATUS_BEING_PLAYED).where("endTime", "<", now);
        return statusRef.get()
            .then(querySnapshot => {
                if( querySnapshot.empty) {
                    console.log("querySnapshot is empty!");
                    return null;
                } else {
                    console.log("successful!");
                    const promises = [];
                    querySnapshot.forEach( doc => {
                        promises.push(doc.ref.update({status: STATUS_PLAYED}));
                    });
                    return Promise.all(promises);
                }
            });
        }
    );

exports.onUnfollowUser = functions.region('europe-west3').firestore
  .document('/followers/{uid}/userFollowers/{followerId}')
  .onDelete(async (snapshot, context) => {
    const uid = context.params.uid;
    const followerId = context.params.followerId;
    const userFeedRef = admin
      .firestore()
      .collection('feeds')
      .doc(followerId)
      .collection('userFeed')
      .where('authorId', '==', uid);
    const userGamesSnapshot = await userFeedRef.get();
    userGamesSnapshot.forEach(doc => {
      if (doc.exists) {
        doc.ref.delete();
      }
    });
  });

exports.onUploadGame = functions.region('europe-west3').firestore
  .document('/games/{uid}/userGames/{gameId}')
  .onCreate(async (snapshot, context) => {

    const uid = context.params.uid;
    const gameId = context.params.gameId;
    const userFollowersRef = admin
      .firestore()
      .collection('followers')
      .doc(uid)
      .collection('userFollowers');
    const userFollowersSnapshot = await userFollowersRef.get();
    userFollowersSnapshot.forEach(doc => {
      admin
        .firestore()
        .collection('feeds')
        .doc(doc.id)
        .collection('feedGames')
        .doc(gameId)
        .set(snapshot.data());
    });
  });

  exports.onUploadPost = functions.region('europe-west3').firestore
    .document('/posts/{uid}/userPosts/postId}')
    .onCreate(async (snapshot, context) => {

    const uid = context.params.uid;
    const postId = context.params.postId;
    const userFollowersRef = admin
      .firestore()
      .collection('followers')
      .doc(uid)
      .collection('userFollowers');
    const userFollowersSnapshot = await userFollowersRef.get();
    userFollowersSnapshot.forEach(doc => {
      admin
        .firestore()
        .collection('feeds')
        .doc(doc.id)
        .collection('feedPosts')
        .doc(postId)
        .set(snapshot.data());
    });
  });