import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:haligol_deneme3/models/game.dart';
import 'package:haligol_deneme3/models/pending_application.dart';
import 'package:haligol_deneme3/models/user.dart';
import 'package:haligol_deneme3/models/user_data.dart';
import 'package:haligol_deneme3/screens/user_profile_screen.dart';
import 'package:haligol_deneme3/systems/DatabaseSystem.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PendingAppTile extends StatefulWidget {
  final PendingApplication application;

  const PendingAppTile({Key key, this.application}) : super(key: key);

  @override
  _PendingAppTileState createState() => _PendingAppTileState();
}

class _PendingAppTileState extends State<PendingAppTile> {
  bool answered = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DatabaseSystem.getUserWithId(widget.application.authorId),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        User user = snapshot.data;
        return !answered
            ? Slidable(
                actionPane: SlidableDrawerActionPane(),
                actionExtentRatio: 0.25,
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 20.0,
                    backgroundColor: Colors.blueGrey,
                    backgroundImage: user.profileImageUrl.isEmpty
                        ? AssetImage("assets/images/user_placeholder.jpg")
                        : CachedNetworkImageProvider(user.profileImageUrl),
                  ),
                  title: Text(
                      "${user.name} maçına ${widget.application.side == Game.HOME ? "ev sahibi" : "misafir"} tarafında katılmak istiyor: ${widget.application.message}"),
                  subtitle: Text(DateFormat.yMd()
                      .add_jm()
                      .format(widget.application.timestamp.toDate())),
                  onTap: () async {
                    String currentUid =
                        Provider.of<UserData>(context, listen: false)
                            .currentUid;
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => UserProfileScreen(
                                  currentUid: currentUid,
                                  uid: widget.application.authorId,
                                )));
                  },
                ),
                actions: <Widget>[
                  IconSlideAction(
                      caption: "Kabul et",
                      color: Colors.green[500],
                      icon: Icons.check,
                      onTap: () {
                        DatabaseSystem.updateApplication(
                          application: widget.application,
                          accepted: true,
                          applicant: user,
                        );
                        setState(() {
                          answered = true;
                        });
                      }),
                ],
                secondaryActions: <Widget>[
                  IconSlideAction(
                      caption: "Reddet",
                      color: Colors.red,
                      icon: Icons.close,
                      onTap: () {
                        DatabaseSystem.updateApplication(
                          application: widget.application,
                          accepted: false,
                          applicant: user,
                        );
                        setState(() {
                          answered = true;
                        });
                      }),
                ],
              )
            : SizedBox.shrink();
      },
    );
  }
}
