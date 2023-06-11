import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:haligol_deneme3/models/club.dart';


class ClubTile extends StatelessWidget {
  final Club club;

  const ClubTile(this.club);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: ListTile(
        leading: CircleAvatar(
          radius: 20.0,
          backgroundImage: club.clubLogoUrl.isEmpty
              ? AssetImage("assets/images/club_placeholder.jpg")
              : CachedNetworkImageProvider(club.clubLogoUrl),
        ),
        title: Text(
         club.name,
        ),
      ),
    );
  }
}
