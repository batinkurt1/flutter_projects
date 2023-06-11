import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:haligol_deneme3/models/comment_activity.dart';
import 'package:haligol_deneme3/models/user.dart';
import 'package:haligol_deneme3/models/user_data.dart';
import 'package:haligol_deneme3/screens/user_profile_screen.dart';
import 'package:haligol_deneme3/systems/DatabaseSystem.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CommentActTile extends StatelessWidget {
  final CommentActivity _comAct;

  CommentActTile(this._comAct);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: DatabaseSystem.getUserWithId(_comAct.authorId),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return SizedBox.shrink();
          }
          User user = snapshot.data;
          return ListTile(
            leading: CircleAvatar(
              radius: 20.0,
              backgroundColor: Colors.blueGrey,
              backgroundImage: user.profileImageUrl.isEmpty
                  ? AssetImage("assets/images/user_placeholder.jpg")
                  : CachedNetworkImageProvider(user.profileImageUrl),
            ),
            title:
                Text("${user.name} profiline yorum yaptı: ${_comAct.comment}"),
            subtitle: Text(
                DateFormat.yMd().add_jm().format(_comAct.timestamp.toDate())),
            onTap: () async {
              String currentUid = Provider.of<UserData>(context).currentUid;
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => UserProfileScreen(
                            currentUid: currentUid,
                            uid: _comAct.authorId,
                          )));
            },
          );
        });
  }
}
