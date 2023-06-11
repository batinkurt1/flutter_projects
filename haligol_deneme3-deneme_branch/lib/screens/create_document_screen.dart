import 'package:flutter/material.dart';
import 'package:haligol_deneme3/models/user.dart';
import 'package:haligol_deneme3/systems/DatabaseSystem.dart';

import 'create_club_screen.dart';
import 'create_game_solo_screen.dart';
import 'create_post_screen.dart';

class CreateDocumentScreen extends StatelessWidget {
  final String currentUid;

  CreateDocumentScreen({this.currentUid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Yeni Gönderi',
          style: TextStyle(
            color: Colors.teal,
            fontSize: 18.0,
          ),
        ),
      ),
      body: FutureBuilder(
          future: DatabaseSystem.getUserWithId(currentUid),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return SizedBox.shrink();
            }
            User author = snapshot.data;
            return Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(right: 10.0),
                    child: FlatButton(
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => CreateGameScreen(
                                    currentUid: currentUid,
                                  ))),
                      color: Colors.teal,
                      padding: EdgeInsets.all(12.0),
                      child: Text(
                        'Maç Oluştur (Tek)',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(right: 10.0),
                    child: FlatButton(
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => CreateGameScreen(
                                    currentUid: currentUid,
                                  ))),
                      color: Colors.teal,
                      padding: EdgeInsets.all(12.0),
                      child: Text(
                        'Maç Oluştur (Kulüp)',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(right: 10.0),
                    child: FlatButton(
                      onPressed: () {
                        if (author.level > User.LEVEL_CONSTRAINT) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CreateClubScreen(
                                currentUid: currentUid,
                              ),
                            ),
                          );
                        }
                      },
                      color: Colors.teal,
                      padding: EdgeInsets.all(12.0),
                      child: Text(
                        'Kulüp Oluştur',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(right: 10.0),
                    child: FlatButton(
                      onPressed: () {
                        if (author.level >= User.LEVEL_CONSTRAINT) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => CreatePostScreen()));
                        }
                      },
                      color: Colors.teal,
                      padding: EdgeInsets.all(12.0),
                      child: Text(
                        'Gönderi Oluştur',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
