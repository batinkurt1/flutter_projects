import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:haligol_deneme3/models/user.dart';
import 'package:haligol_deneme3/models/user_data.dart';
import 'package:haligol_deneme3/screens/user_profile_screen.dart';
import 'package:provider/provider.dart';

class UserTile extends StatelessWidget {
  final User user;
  final String profileImageUrl;
  final String name;
  final String id;

  const UserTile({this.profileImageUrl, this.name, this.id, this.user});

  @override
  Widget build(BuildContext context) {
    if (name == null && profileImageUrl == null && id == null) {
      return GestureDetector(
        child: ListTile(
          leading: CircleAvatar(
            radius: 20.0,
            backgroundImage: user.profileImageUrl.isEmpty
                ? AssetImage("assets/images/user_placeholder.jpg")
                : CachedNetworkImageProvider(user.profileImageUrl),
          ),
          title: Text(
            user.name,
          ),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => UserProfileScreen(
                uid: user.id,
                currentUid: Provider.of<UserData>(context).currentUid,
              ),
            ),
          ),
        ),
      );
    } else {
      return GestureDetector(
        child: ListTile(
          leading: CircleAvatar(
            radius: 20.0,
            backgroundImage: profileImageUrl.isEmpty
                ? AssetImage("assets/images/user_placeholder.jpg")
                : CachedNetworkImageProvider(profileImageUrl),
          ),
          title: Text(
            name,
          ),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  UserProfileScreen(
                    uid: id,
                    currentUid: Provider
                        .of<UserData>(context)
                        .currentUid,
                  ),
            ),
          ),
        ),
      );
    }
  }
}
