import 'package:flutter/material.dart';
import 'package:haligol_deneme3/models/game.dart';
import 'package:haligol_deneme3/models/game_message.dart';

class GameMessageTile extends StatelessWidget {
  final GameMessage message;
  final Game game;
  final String currentUid;

  GameMessageTile(
      {@required this.message, @required this.currentUid, @required this.game});

  @override
  Widget build(BuildContext context) {
    final bool isInHomeSide = game.homeProfiles.containsKey(currentUid);
    if (message.homeSees && message.awaySees) {
      return ListTile(
        title: currentUid == message.fromUid
            ? SizedBox.shrink()
            : Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(message.fromUserName),
            Text(
              "Herkes",
              style: TextStyle(
                  fontWeight: FontWeight.w600, color: Colors.lightGreen),
            )
          ],
        ),
        subtitle: Align(
            alignment: currentUid == message.fromUid
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: Text(message.message)),
      );
    } else if (message.homeSees && isInHomeSide) {
      return ListTile(
        title: currentUid == message.fromUid
            ? SizedBox.shrink()
            : Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(message.fromUserName),
            Text(
              "Takım",
              style: TextStyle(
                  fontWeight: FontWeight.w600, color: Colors.red),
            )
          ],
        ),
        subtitle: Align(
            alignment: currentUid == message.fromUid
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: Text(message.message)),
      );
    } else if (message.awaySees && !isInHomeSide) {
      return ListTile(
        title: currentUid == message.fromUid
            ? SizedBox.shrink()
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(message.fromUserName),
                  Text(
                    "Takım",
                    style: TextStyle(
                        fontWeight: FontWeight.w600, color: Colors.red),
                  )
                ],
              ),
        subtitle: Align(
            alignment: currentUid == message.fromUid
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: Text(message.message)),
      );
    } else {
      return SizedBox.shrink();
    }
  }
}
