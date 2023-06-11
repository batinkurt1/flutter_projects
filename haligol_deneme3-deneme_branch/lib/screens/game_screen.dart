import 'package:flutter/material.dart';
import 'package:haligol_deneme3/models/game.dart';
import 'package:haligol_deneme3/models/user_data.dart';
import 'package:haligol_deneme3/styles/text_styles.dart';
import 'package:haligol_deneme3/utilities/constants.dart';
import 'package:haligol_deneme3/widgets/user_tile.dart';
import 'package:provider/provider.dart';

import 'application_screen.dart';

class GameScreen extends StatefulWidget {
  final String gameId;
  final String uid;
  final String currentUid;

  GameScreen({this.gameId, this.uid, this.currentUid});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  Game _game;

  _buildUsers(Game game) {
    final homeIds = game.homeProfiles.keys.toList();
    final awayIds = game.awayProfiles.keys.toList();

    List<UserTile> homeWidget = [];
    List<UserTile> awayWidget = [];

    for (var id in homeIds) {
      homeWidget.add(UserTile(
          id: id,
          name: game.homeNames[id],
          profileImageUrl: game.homeProfiles[id]));
    }
    for (var id in awayIds) {
      awayWidget.add(UserTile(
          id: id,
          name: game.awayNames[id],
          profileImageUrl: game.awayProfiles[id]));
    }

    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 20.0, 20.0, 0.0),
              child: Text(
                "Takım büyüklüğü: ${_game.teamCapacity}",
                style: TextStyles.mainStyle(
                    fontSize: 16.0, fontWeight: FontWeight.w400),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 20.0, 20.0, 0.0),
              child: Text(
                "Ev Sahibi",
                style: TextStyles.mainStyle(
                    fontSize: 16.0, fontWeight: FontWeight.w600),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 5.0, 20.0, 0.0),
              child: Text(
                "Bulunan oyuncu sayısı: ${_game.homeSize}",
                style: TextStyles.mainStyle(
                    fontSize: 16.0, fontWeight: FontWeight.w600),
              ),
            ),
            Flexible(
              fit: FlexFit.loose,
              child: ListView(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                children: homeWidget,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 20.0, 20.0, 0.0),
              child: Text(
                "Misafir",
                style: TextStyles.mainStyle(
                    fontSize: 16.0, fontWeight: FontWeight.w600),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 5.0, 20.0, 0.0),
              child: Text(
                "Bulunan oyuncu sayısı: ${_game.awaySize}",
                style: TextStyles.mainStyle(
                    fontSize: 16.0, fontWeight: FontWeight.w600),
              ),
            ),
            Flexible(
              fit: FlexFit.loose,
              child: ListView(
                scrollDirection: Axis.vertical,
                children: awayWidget,
              ),
            ),
            Container(
              padding: EdgeInsets.only(right: 10.0),
              child: Column(
                children: <Widget>[
                  widget.currentUid == widget.uid
                      ? SizedBox.shrink()
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "BAŞVUR",
                            style: TextStyles.mainStyle(
                                fontWeight: FontWeight.w600, fontSize: 16.0),
                          ),
                        ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      widget.currentUid == widget.uid
                          ? SizedBox.shrink()
                          : Container(
                              child: FlatButton(
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ApplicationScreen(
                                      game: _game,
                                      side: Game.HOME,
                                      currentUserId:
                                          Provider.of<UserData>(context)
                                              .currentUid,
                                    ),
                                  ),
                                ),
                                color: Colors.teal,
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Ev Sahibi',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                            ),
                      widget.currentUid == widget.uid
                          ? SizedBox.shrink()
                          : Container(
                              child: FlatButton(
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ApplicationScreen(
                                      game: _game,
                                      side: Game.AWAY,
                                      currentUserId:
                                          Provider.of<UserData>(context)
                                              .currentUid,
                                    ),
                                  ),
                                ),
                                color: Colors.teal,
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Misafir',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                            ),
                      widget.currentUid == widget.uid
                          ? SizedBox.shrink()
                          : Container(
                              child: FlatButton(
                                onPressed: () {},
                                color: Colors.teal,
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Kulüp Olarak Misafir',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                            ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Maç',
          style: TextStyle(
              color: TextStyles.mainColor,
              fontSize: 32.0,
              fontWeight: FontWeight.w400),
        ),
      ),
      body: FutureBuilder(
        future: userGamesRef
            .document(widget.uid)
            .collection("userGames")
            .document(widget.gameId)
            .get(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            _game = Game.fromDoc(snapshot.data);
            return _buildUsers(_game);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
