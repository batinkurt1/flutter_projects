import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:haligol_deneme3/models/answered_application.dart';
import 'package:haligol_deneme3/models/user.dart';
import 'package:haligol_deneme3/models/user_data.dart';
import 'package:haligol_deneme3/screens/user_profile_screen.dart';
import 'package:haligol_deneme3/systems/DatabaseSystem.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AnsweredAppTile extends StatelessWidget {
  final AnsweredApplication application;

  AnsweredAppTile(this.application);

  @override
  Widget build(BuildContext context) {
    final String currentUid = Provider.of<UserData>(context).currentUid;

    return FutureBuilder(
      future: currentUid == application.authorId
          ? DatabaseSystem.getUserWithId(application.userId)
          : DatabaseSystem.getUserWithId(application.authorId),
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
          title: Text(currentUid == application.authorId
              ? "${user.name} maça katılma isteğini kabul etti."
              : "${user.name} maçına katıldı."),
          subtitle: Text(
              DateFormat.yMd().add_jm().format(application.timestamp.toDate())),
          onTap: () async {
            String currentUid = Provider.of<UserData>(context, listen: false).currentUid;
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => UserProfileScreen(
                          currentUid: currentUid,
                          uid: user.id,
                        )));
          },
        );
      },
    );
  }
}
