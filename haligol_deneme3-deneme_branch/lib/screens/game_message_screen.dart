import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haligol_deneme3/models/game.dart';
import 'package:haligol_deneme3/models/game_message.dart';
import 'package:haligol_deneme3/models/user.dart';
import 'package:haligol_deneme3/systems/DatabaseSystem.dart';
import 'package:haligol_deneme3/utilities/constants.dart';
import 'package:haligol_deneme3/widgets/game_message_tile.dart';

class GameMessageScreen extends StatefulWidget {
  final Game game;
  final User currentUser;
  final String currentUid;

  GameMessageScreen(
      {@required this.game,
      @required this.currentUid,
      @required this.currentUser});

  @override
  _GameMessageScreenState createState() => _GameMessageScreenState();
}

class _GameMessageScreenState extends State<GameMessageScreen> {
  bool _isWriting = false;
  bool _showToggleButtons = true;
  IconData _iconData = Icons.keyboard_arrow_down;

  TextEditingController _messageController;
  List<bool> _allOrTeam = List.generate(2, (index) => false);
  static const int _ALL = 0, _TEAM = 1;

  @override
  void initState() {
    if (mounted) {
      _messageController = TextEditingController();
      super.initState();
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
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
        child: Column(
          children: <Widget>[
            _showToggleButtons
                ? ToggleButtons(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 2.0, horizontal: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.people),
                      Text("Herkes")
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 2.0, horizontal: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[Icon(Icons.person), Text("Takım")],
                  ),
                ),
              ],
              isSelected: _allOrTeam,
              onPressed: (int index) {
                setState(() {
                  if (index == _ALL) {
                    _allOrTeam[_ALL] = true;
                    _allOrTeam[_TEAM] = false;
                  } else {
                    _allOrTeam[_ALL] = false;
                    _allOrTeam[_TEAM] = true;
                  }
                });
              },
              color: Colors.teal,
              selectedColor: Colors.white,
              fillColor: Colors.teal,
              borderRadius: BorderRadius.circular(30),
              borderWidth: 0.5,
              borderColor: Colors.teal,
            )
                : SizedBox.shrink(),
            Row(
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
                IconButton(
                  icon: Icon(_iconData),
                  onPressed: () {
                    if (_iconData == Icons.keyboard_arrow_down) {
                      setState(() {
                        _iconData = Icons.keyboard_arrow_up;
                        _showToggleButtons = false;
                      });
                    } else {
                      setState(() {
                        _iconData = Icons.keyboard_arrow_down;
                        _showToggleButtons = true;
                      });
                    }
                  },
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 4.0),
                  child: IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () {
                      if (_isWriting &&
                          (_allOrTeam[_ALL] || _allOrTeam[_TEAM])) {
                        userGamesRef
                            .document(widget.game.founderId)
                            .collection("userGames")
                            .document(widget.game.id)
                            .setData(
                          {"lastMessage": Timestamp.now()},
                          merge: true,
                        );

                        bool homeSees,
                            awaySees,
                            isInHomeSide = false;
                        if (widget.game.homeProfiles
                            .containsKey(widget.currentUid)) {
                          isInHomeSide = true;
                        }

                        if (_allOrTeam[_ALL]) {
                          homeSees = awaySees = true;
                        } else if (isInHomeSide && _allOrTeam[_TEAM]) {
                          homeSees = true;
                          awaySees = false;
                        } else {
                          homeSees = false;
                          awaySees = true;
                        }

                        DatabaseSystem.messageToGame(
                          roomId: widget.game.id,
                          fromUid: widget.currentUid,
                          fromUserName: widget.currentUser.name,
                          message: _messageController.text,
                          homeSees: homeSees,
                          awaySees: awaySees,
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
          widget.game.title,
          style: TextStyle(
            color: Colors.teal,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: DatabaseSystem.getGameRoomMessages(widget.game.id),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return SizedBox.shrink();
                }
                final List<GameMessage> messages = snapshot.data;
                if (messages.isEmpty) {
                  return SizedBox.shrink();
                }
                return ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (BuildContext context,
                        int index,) {
                      GameMessage message = messages[index];
                      return GameMessageTile(
                        message: message,
                        currentUid: widget.currentUid,
                        game: widget.game,
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
