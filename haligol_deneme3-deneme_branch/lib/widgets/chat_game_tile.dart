import 'package:flutter/material.dart';
import 'package:haligol_deneme3/models/game.dart';
import 'package:haligol_deneme3/models/user.dart';
import 'package:haligol_deneme3/screens/game_message_screen.dart';
import 'package:haligol_deneme3/systems/DatabaseSystem.dart';
import 'package:haligol_deneme3/utilities/fixture_format.dart';

class ChatGameTile extends StatelessWidget {
  final Game game;
  final String currentUid;

  ChatGameTile({@required this.game, @required this.currentUid});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: DatabaseSystem.getUserWithId(currentUid),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return SizedBox.shrink();
          }
          User currentUser = snapshot.data;
          return GestureDetector(
            child: ListTile(
              title: Text(
                game.title,
              ),
              subtitle: Row(
                children: <Widget>[
                  Text(FixtureFormat.getGameTimestamp(game.startTime)),
                  Spacer(),
                  Text(FixtureFormat.getGameTimestamp(game.endTime)),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => GameMessageScreen(
                      game: game,
                      currentUid: currentUid,
                      currentUser: currentUser,
                    ),
                  ),
                );
              },
            ),
          );
        });
  }
}
