import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:haligol_deneme3/models/chat_user.dart';
import 'package:haligol_deneme3/models/player_message.dart';
import 'package:haligol_deneme3/models/user.dart';
import 'package:haligol_deneme3/screens/player_message_screen.dart';
import 'package:haligol_deneme3/systems/DatabaseSystem.dart';

class ChatUserTile extends StatelessWidget {
  final ChatUser chatUser;
  final String currentUid;
  final String roomId;

  ChatUserTile({@required this.chatUser, @required this.currentUid, @required this.roomId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([
        DatabaseSystem.getUserWithId(chatUser.userId),
        DatabaseSystem.getUserWithId(currentUid)
      ]),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SizedBox.shrink();
        }
        User toUser = snapshot.data[0];
        User fromUser = snapshot.data[1];
        return GestureDetector(
          child: ListTile(
            leading: CircleAvatar(
              radius: 20.0,
              backgroundImage: chatUser.profileImageUrl.isEmpty
                  ? AssetImage("assets/images/user_placeholder.jpg")
                  : CachedNetworkImageProvider(chatUser.profileImageUrl),
            ),
            title: Text(
              chatUser.name,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PlayerMessageScreen(
                    fromUser: fromUser,
                    toUser: toUser,
                    roomId: roomId,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
