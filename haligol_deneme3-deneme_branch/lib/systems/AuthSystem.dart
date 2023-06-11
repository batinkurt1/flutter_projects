import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:haligol_deneme3/models/user_data.dart';
import 'package:provider/provider.dart';

class AuthSystem {

  static final _auth = FirebaseAuth.instance;
  static final _firestore = Firestore.instance;

  static void signUp( BuildContext context, String name, String email, String password) async {
    try{
      AuthResult authResult = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser firebaseUser = authResult.user;
      if( firebaseUser != null){
        _firestore..collection('/users').document(firebaseUser.uid).setData({
          'name': name,
          'email': email,
          'profileImageUrl': '',
          'rating': 0,
          'raters': 0,
          'bio' : '',
          'playedGames': 0,
          'level': 1,
          'playerRooms': {},
          'clubRooms': {},
          'gameRooms': {},
          'gameFounderIds': {},
        });
        Provider.of<UserData>(context, listen: false).currentUid = firebaseUser.uid;
        Navigator.pop(context);
      }
    } on PlatformException catch (e) {
      String message = "Lütfen e-posta ve şifrenizi kontrol ediniz!";
      if(e.message != null){
        message = e.message;
      }
      Scaffold.of(context).showSnackBar( SnackBar( content: Text(message), backgroundColor: Theme.of(context).primaryColor));
    } catch (e){
      print(e);
    }
  }

  static void logout(){
    _auth.signOut();
  }

  static void login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      print(e);
    }
  }

}