import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:haligol_deneme3/models/player_message.dart';
import 'package:haligol_deneme3/models/user.dart';
import 'package:haligol_deneme3/systems/DatabaseSystem.dart';
import 'package:haligol_deneme3/utilities/constants.dart';
import 'package:haligol_deneme3/widgets/player_message_tile.dart';

class PlayerMessageScreen extends StatefulWidget {
  final User toUser;
  final User fromUser;
  final String roomId;

  PlayerMessageScreen(
      {@required this.toUser, @required this.fromUser, @required this.roomId});

  @override
  _PlayerMessageScreenState createState() => _PlayerMessageScreenState();
}

class _PlayerMessageScreenState extends State<PlayerMessageScreen> {
  String newRoomId;
  bool _isWriting = false;
  TextEditingController _messageController;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    if (mounted) {
      _messageController = TextEditingController();
      super.initState();
      newRoomId = widget.roomId;

      var fromRooms = widget.fromUser.playerRooms;
      var toRooms = widget.toUser.playerRooms;

      if (widget.roomId == "noRoomId") {
        if (fromRooms != null) {
          for (var key in fromRooms.keys) {
            if (toRooms != null) {
              if (toRooms.containsKey(key)) {
                newRoomId = key;
              }
            }
          }
        }
        if (newRoomId == widget.roomId) {
          newRoomId = playerMessagesRef.document().documentID;
        }
      }
    }
  }

  _buildMessageTF() {
    return IconTheme(
      data: IconThemeData(
        color: _isWriting
            ? Theme.of(context).accentColor
            : Theme.of(context).disabledColor,
      ),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 10.0,
            ),
            Expanded(
              child: TextField(
                controller: _messageController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: 'Bir mesaj gönder',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                  filled: true,
                  contentPadding: EdgeInsets.all(16),
                ),
                onChanged: (message) {
                  setState(() {
                    _isWriting = message.isNotEmpty;
                  });
                },
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                icon: Icon(Icons.send),
                onPressed: () {
                  if (_isWriting) {
                    if (widget.roomId == "noRoomId") {
                      var fromRooms = widget.fromUser.playerRooms;
                      var toRooms = widget.toUser.playerRooms;
                      if (fromRooms == null) {
                        fromRooms = Map<String, bool>();
                      }
                      fromRooms[newRoomId] = true;
                      usersRef.document(widget.fromUser.id).setData(
                        {"playerRooms": fromRooms},
                        merge: true,
                      );

                      if (toRooms == null) {
                        toRooms = Map<String, bool>();
                      }

                      toRooms[newRoomId] = true;
                      usersRef
                          .document(widget.toUser.id)
                          .setData({"playerRooms": toRooms}, merge: true);
                    }

                    playerRoomsRef
                        .document(widget.toUser.id)
                        .collection("userRooms")
                        .document(newRoomId)
                        .setData({
                      "name": widget.fromUser.name,
                      "profileImageUrl": widget.fromUser.profileImageUrl,
                      "lastMessage": Timestamp.now(),
                      "userId": widget.fromUser.id,
                    }, merge: true);

                    playerRoomsRef
                        .document(widget.fromUser.id)
                        .collection("userRooms")
                        .document(newRoomId)
                        .setData({
                      "name": widget.toUser.name,
                      "profileImageUrl": widget.toUser.profileImageUrl,
                      "lastMessage": Timestamp.now(),
                      "userId": widget.toUser.id
                    }, merge: true);

                    DatabaseSystem.messageToUser(
                      fromUserId: widget.fromUser.id,
                      fromUserName: widget.fromUser.name,
                      messageText: _messageController.text,
                      roomId: newRoomId,
                    );

                    _messageController.clear();
                    setState(() {
                      _isWriting = false;
                    });
                  }
                },
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
        leading: Padding(
          padding: const EdgeInsets.all(6.0),
          child: CircleAvatar(
            radius: 10.0,
            backgroundColor: Colors.grey,
            backgroundImage: widget.toUser.profileImageUrl.isEmpty
                ? AssetImage('assets/images/user_placeholder.jpg')
                : CachedNetworkImageProvider(widget.toUser.profileImageUrl),
          ),
        ),
        backgroundColor: Colors.white,
        title: Text(
          widget.toUser.name,
          style: TextStyle(
            color: Colors.teal,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: DatabaseSystem.getPlayerRoomMessages(newRoomId),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return SizedBox.shrink();
                }
                final List<PlayerMessage> messages = snapshot.data;
                if (messages.isEmpty) {
                  return SizedBox.shrink();
                }
                return ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (
                      BuildContext context,
                      int index,
                    ) {
                      PlayerMessage message = messages[index];
                      return PlayerMessageTile(
                        message: message,
                        currentUid: widget.fromUser.id,
                      );
                    });
              },
            ),
          ),
          _buildMessageTF(),
        ],
      ),
    );
  }
}
