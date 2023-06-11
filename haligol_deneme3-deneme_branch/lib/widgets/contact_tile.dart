import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:haligol_deneme3/models/contact.dart';
import 'package:haligol_deneme3/models/user.dart';
import 'package:haligol_deneme3/screens/player_message_screen.dart';
import 'package:haligol_deneme3/systems/DatabaseSystem.dart';

class ContactTile extends StatelessWidget {
  final Contact contact;
  final String currentUid;
  final String roomId;

  ContactTile({this.contact, this.currentUid, this.roomId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([
        DatabaseSystem.getUserWithId(contact.id),
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
              backgroundImage: contact.profileImageUrl.isEmpty
                  ? AssetImage("assets/images/user_placeholder.jpg")
                  : CachedNetworkImageProvider(contact.profileImageUrl),
            ),
            title: Text(
              contact.name,
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
