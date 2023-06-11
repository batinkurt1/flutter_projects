import 'package:flutter/material.dart';
import 'package:haligol_deneme3/models/chat_user.dart';
import 'package:haligol_deneme3/systems/DatabaseSystem.dart';
import 'package:haligol_deneme3/widgets/chat_user_tile.dart';

import 'contacts_screen.dart';

class PlayerChatScreen extends StatefulWidget {
  final String currentUid;

  PlayerChatScreen({this.currentUid});

  @override
  _PlayerChatScreenState createState() => _PlayerChatScreenState();
}

class _PlayerChatScreenState extends State<PlayerChatScreen> with AutomaticKeepAliveClientMixin<PlayerChatScreen> {

  @override
  bool get wantKeepAlive => true;

  ListView _buildChatUsers(List<ChatUser> chatUsers) {
    List<ChatUserTile> chatTiles = [];
    chatUsers.forEach((chatUser) {
      ChatUserTile chatTile = ChatUserTile(
        chatUser: chatUser,
        currentUid: widget.currentUid,
        roomId: chatUser.roomId,
      );
      chatTiles.add(chatTile);
    });

    return ListView(
      children: chatTiles,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.message),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ContactsScreen(
                currentUid: widget.currentUid,
              ),
            ),
          ),
        ),
        body: FutureBuilder(
            future: DatabaseSystem.getUserRooms(widget.currentUid),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return SizedBox.shrink();
              }
              List<ChatUser> chatUsers = snapshot.data;
              return _buildChatUsers(chatUsers);
            }));
  }
}
