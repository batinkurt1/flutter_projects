import 'package:flutter/material.dart';
import 'package:haligol_deneme3/models/player_message.dart';

class PlayerMessageTile extends StatelessWidget {
  final PlayerMessage message;
  final String currentUid;

  PlayerMessageTile({this.message, this.currentUid});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: currentUid == message.fromUid
          ? SizedBox.shrink()
          : Text(message.fromUserName),
      subtitle: Align(
          alignment: currentUid == message.fromUid ? Alignment.centerRight : Alignment.centerLeft,
          child: Text(message.message)),
    );
  }
}
