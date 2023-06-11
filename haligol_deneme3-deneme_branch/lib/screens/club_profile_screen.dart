import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:haligol_deneme3/models/club.dart';
import 'package:haligol_deneme3/models/comment.dart';
import 'package:haligol_deneme3/models/game.dart';
import 'package:haligol_deneme3/models/user.dart';
import 'package:haligol_deneme3/systems/DatabaseSystem.dart';
import 'package:haligol_deneme3/widgets/comment_view.dart';
import 'package:haligol_deneme3/widgets/game_view.dart';

class ClubProfileScreen extends StatefulWidget {
  final String clubId;
  final String currentUid;

  ClubProfileScreen({this.clubId, this.currentUid});

  @override
  _ClubProfileScreenState createState() => _ClubProfileScreenState();
}

class _ClubProfileScreenState extends State<ClubProfileScreen> {
  static const int DISP_GAMES = 0, DISP_PROFILES = 1, DISP_COMMENTS = 2;
  int raterCount = 0;
  int playedGames = 0;

  List<Game> _games = [];
  List<Comment> _comments = [];

  int _displayBetween = 0;
  Club _profileClub;

  @override
  void initState() {
    if (mounted) {
      super.initState();
      _setupGames();
      _setupComments();
      _setupProfileClub();
    }
  }

  _setupGames() async {
    List<Game> games = await DatabaseSystem.getClubGames(widget.clubId);
    setState(() {
      _games = games;
    });
  }

  _setupComments() async {
    List<Comment> comment = await DatabaseSystem.getUserComments(widget.clubId);
    setState(() {
      _comments = comment;
    });
  }

  _setupProfileClub() async {
    Club profileClub = await DatabaseSystem.getClubWithId(widget.clubId);

    setState(() {
      _profileClub = profileClub;
    });
  }

  _buildToggleButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.list),
          iconSize: 30.0,
          color: _displayBetween == DISP_GAMES
              ? Theme.of(context).primaryColor
              : Colors.grey[200],
          onPressed: () => setState(() {
            _displayBetween = DISP_GAMES;
          }),
        ),
        IconButton(
          icon: Icon(Icons.comment),
          iconSize: 30.0,
          color: _displayBetween == DISP_PROFILES
              ? Theme.of(context).primaryColor
              : Colors.grey[200],
          onPressed: () => setState(() {
            _displayBetween = DISP_PROFILES;
          }),
        ),
        IconButton(
          icon: Icon(Icons.crop_square),
          iconSize: 30.0,
          color: _displayBetween == DISP_COMMENTS
              ? Theme.of(context).primaryColor
              : Colors.grey[200],
          onPressed: () => setState(() {
            _displayBetween = DISP_COMMENTS;
          }),
        ),
      ],
    );
  }

  _displayButton(Club club) {
    if (club.founderId == widget.currentUid) {
      return Container(
        width: 200.0,
        child: FlatButton(
          onPressed: () {},
          color: Colors.teal,
          textColor: Colors.white,
          child: Text(
            'Kulübü Düzenle',
            style: TextStyle(fontSize: 18.0),
          ),
        ),
      );
    } else if (club.squadIds.containsKey(widget.currentUid)) {
      return Container(
        width: 200.0,
        child: FlatButton(
          onPressed: () {},
          color: Colors.teal,
          textColor: Colors.white,
          child: Text(
            'Kulüpten Ayrıl',
            style: TextStyle(fontSize: 18.0),
          ),
        ),
      );
    } else {
      return Container(
        width: 200.0,
        child: FlatButton(
          onPressed: () {},
          color: Colors.teal,
          textColor: Colors.white,
          child: Text(
            'Kulübe Başvur',
            style: TextStyle(fontSize: 18.0),
          ),
        ),
      );
    }
  }

  _buildDisplayGamesOrComments() {
    if (_displayBetween == DISP_GAMES) {
      List<GameView> gameViews = [];

      _games.forEach((Game game) {
        gameViews.add(
          GameView(
            currentUserId: widget.currentUid,
            game: game,
            club: _profileClub,
          ),
        );
      });

      return Column(
        children: gameViews,
      );
    } else if (_displayBetween == DISP_PROFILES) {
      List<Widget> commentViews = [];
      _comments.forEach((Comment comment) {
        commentViews.add(
          FutureBuilder(
            future: DatabaseSystem.getUserWithId(comment.authorId),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              User user = User.fromDoc(snapshot.data as DocumentSnapshot);

              return CommentView(
                comment: comment,
                currentUserId: widget.currentUid,
                user: user,
              );
            },
          ),
        );
      });
      return Column(
        children: commentViews,
      );
    } else {}
  }

  _buildProfileInfo(Club club, double rating, int raters) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(15.0, 30.0, 15.0, 0.0),
          child: Row(
            children: <Widget>[
              CircleAvatar(
                radius: 45.0,
                backgroundColor: Colors.teal[100],
                backgroundImage: club.clubLogoUrl.isEmpty
                    ? AssetImage("assets/images/user_placeholder.jpg")
                    : CachedNetworkImageProvider(club.clubLogoUrl),
              ),
              Expanded(
                child: Column(
                  children: <Widget>[
                    Text(
                      club.playedGames.toString(),
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Maç',
                      style: TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                club.name,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5.0),
              Container(
                padding: EdgeInsets.only(bottom: 5.0),
                child: Text(
                  club.info,
                  style: TextStyle(fontSize: 14.0),
                ),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Text(
                          raters.toString(),
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Oylayanlar',
                          style: TextStyle(color: Colors.black54),
                        ),
                      ],
                    ),
                    _displayButton(club),
                  ],
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
              Divider(),
            ],
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Halıgol',
          style: TextStyle(
            color: Colors.teal,
            fontFamily: "Neo Sans",
            fontSize: 32.0,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: () async {
          _setupGames();
          _setupComments();
          _setupProfileClub();
        },
        child: FutureBuilder(
          future: Future.wait([
            DatabaseSystem.getClubWithId(widget.clubId),
            DatabaseSystem.handleClubRating(widget.clubId),
          ]),
          builder:
              (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            Club club = Club.fromDoc(snapshot.data[0] as DocumentSnapshot);
            Map<String, double> rate = snapshot.data[1];

            double rating = rate["rating"];
            int raters = rate["raters"].toInt();

            return ListView(
              children: <Widget>[
                _buildProfileInfo(club, rating, raters),
                _buildToggleButtons(),
                _buildDisplayGamesOrComments(),
              ],
            );
          },
        ),
      ),
    );
  }
}
