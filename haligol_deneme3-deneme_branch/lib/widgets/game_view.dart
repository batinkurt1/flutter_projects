import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:haligol_deneme3/models/club.dart';
import 'package:haligol_deneme3/models/game.dart';
import 'package:haligol_deneme3/models/user.dart';
import 'package:haligol_deneme3/screens/club_profile_screen.dart';
import 'package:haligol_deneme3/screens/game_screen.dart';
import 'package:haligol_deneme3/screens/user_profile_screen.dart';
import 'package:haligol_deneme3/styles/text_styles.dart';
import 'package:haligol_deneme3/utilities/fixture_format.dart';

class GameView extends StatelessWidget {
  final String currentUserId;
  final Game game;
  final User user;
  final Club club;

  GameView({this.currentUserId, this.game, this.user, this.club});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => club == null
                      ? UserProfileScreen(
                          currentUid: currentUserId,
                          uid: game.founderId,
                        )
                      : ClubProfileScreen(
                          currentUid: currentUserId,
                        ),
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                      radius: 18.0,
                      backgroundColor: Colors.teal[100],
                      backgroundImage: club == null
                          ? user.profileImageUrl.isEmpty
                          ? AssetImage("assets/images/user_placeholder.jpg")
                          : CachedNetworkImageProvider(user.profileImageUrl)
                          : club.clubLogoUrl.isEmpty
                          ? AssetImage("assets/images/club_placeholder.jpg")
                          : CachedNetworkImageProvider(club.clubLogoUrl)),
                  SizedBox(
                    width: 8.0,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        club == null ? user.name : club.name,
                        style: TextStyles.mainStyle(
                            fontSize: 14.0, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        game.city + " / " + game.field,
                        style: TextStyles.mainStyle(),
                      ),
                    ],
                  ),
                  Spacer(),
                  Text(
                    FixtureFormat.getGameTimestamp(game.timestamp),
                    style: TextStyles.mainStyle(),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blueGrey[200],
                  Colors.blueGrey[100],
                ],
              ),
              borderRadius: BorderRadius.circular(15.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.blueGrey[50],
                  offset: Offset(1.0, 1.0),
                ),
              ],
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text(
                        game.title,
                        style: TextStyles.mainStyle(fontSize: 14.0),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        game.info,
                        style: TextStyles.mainStyle(fontSize: 14.0),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        FixtureFormat.getGameDate(game.startTime.toDate()),
                        style: TextStyles.mainStyle(fontSize: 14.0),
                      ),
                      Spacer(),
                      Text(
                        FixtureFormat.getGameDate(game.endTime.toDate()),
                        style: TextStyles.mainStyle(fontSize: 14.0),
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Text(
                        "Ev Sahibi: " + game.homeSize.toString(),
                        style: TextStyles.mainStyle(fontSize: 14),
                      ),
                      Text(
                        "Deplasman: " + game.awaySize.toString(),
                        style: TextStyles.mainStyle(fontSize: 14),
                      ),
                      Text(
                        "Takım Büyüklüğü: " + game.teamCapacity.toString(),
                        style: TextStyles.mainStyle(fontSize: 14),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.arrow_upward),
            onPressed: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => GameScreen(
                    currentUid: currentUserId,
                    gameId: game.id,
                    uid: game.founderId,
                  ),
                ),
              )
            },
          ),
        ],
      ),
    );
  }
}
