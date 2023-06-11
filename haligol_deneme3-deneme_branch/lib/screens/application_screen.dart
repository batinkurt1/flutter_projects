import 'package:flutter/material.dart';
import 'package:haligol_deneme3/models/game.dart';
import 'package:haligol_deneme3/models/user.dart';
import 'package:haligol_deneme3/styles/text_styles.dart';
import 'package:haligol_deneme3/systems/DatabaseSystem.dart';

class ApplicationScreen extends StatefulWidget {
  final String currentUserId;
  final Game game;
  final int side;

  ApplicationScreen({this.currentUserId, this.game, this.side});

  @override
  _ApplicationScreenState createState() => _ApplicationScreenState();
}

class _ApplicationScreenState extends State<ApplicationScreen> {
  Game _game;
  User _user;
  TextEditingController _messageController;
  String _message = "";
  final int maxLines = 5;
  final int maxCharacters = 256;

  _submit() async {
    DatabaseSystem.applyToGame(
        currentUserId: widget.currentUserId,
        message: _message,
        game: widget.game,
        side: widget.side);
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Başvur',
          style: TextStyle(
              color: Colors.teal, fontSize: 32.0, fontWeight: FontWeight.w400),
        ),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
            future: DatabaseSystem.getUserWithId(widget.currentUserId),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              _user = snapshot.data;
              return Container(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 10.0),
                      child: TextField(
                        maxLines: maxLines,
                        maxLength: maxCharacters,
                        cursorColor: Colors.teal,
                        controller: _messageController,
                        style: TextStyles.mainStyle(
                          fontSize: 18.0,
                        ),
                        decoration: InputDecoration(
                            labelText: "Maç liderine başvuru mesajı"),
                        onChanged: (input) => _message = input,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(right: 10.0),
                      child: FlatButton(
                        onPressed: _submit,
                        color: Colors.teal,
                        padding: EdgeInsets.all(12.0),
                        child: Text(
                          "Yolla",
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
      ),
    );
  }
}
