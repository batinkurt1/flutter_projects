import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:haligol_deneme3/models/comment.dart';
import 'package:haligol_deneme3/models/game.dart';
import 'package:haligol_deneme3/models/post.dart';
import 'package:haligol_deneme3/models/user.dart';
import 'package:haligol_deneme3/models/user_data.dart';
import 'package:haligol_deneme3/screens/settings_screen.dart';
import 'package:haligol_deneme3/systems/DatabaseSystem.dart';
import 'package:haligol_deneme3/utilities/constants.dart';
import 'package:haligol_deneme3/widgets/comment_view.dart';
import 'package:haligol_deneme3/widgets/game_view.dart';
import 'package:haligol_deneme3/widgets/post_view.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

import 'edit_profile_screen.dart';

class UserProfileScreen extends StatefulWidget {
  final String uid;
  final String currentUid;

  UserProfileScreen({this.uid, this.currentUid});

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  static const int DISP_GAMES = 0, DISP_COMMENTS = 1, DISP_POSTS = 2;

  bool isFollowing = false;
  int followerCount = 0;
  int followingCount = 0;
  int raterCount = 0;
  int playedGames = 0;

  List<Game> _games = [];
  List<Comment> _comments = [];
  List<Post> _posts = [];

  int _displayBetween = 0;
  User _profileUser;

  @override
  void initState() {
    if (mounted) {
      super.initState();
      _setupFollowers();
      _setupIsFollowing();
      _setupFollowing();
      _setupPlayedGames();
      _setupGames();
      _setupComments();
      _setupProfileUser();
      _setupPosts();
    }
  }

  _setupGames() async {
    List<Game> games = await DatabaseSystem.getUserGames(widget.uid);
    setState(() {
      _games = games;
    });
  }

  _setupPosts() async {
    List<Post> posts = await DatabaseSystem.getUserPosts(widget.uid);
    setState(() {
      _posts = posts;
    });
  }

  _setupComments() async {
    List<Comment> comment = await DatabaseSystem.getUserComments(widget.uid);
    setState(() {
      _comments = comment;
    });
  }

  _setupIsFollowing() async {
    bool isFollowingUser = await DatabaseSystem.isFollowingUser(
      currentUid: widget.currentUid,
      uid: widget.uid,
    );
    setState(() {
      isFollowing = isFollowingUser;
    });
  }

  _setupProfileUser() async {
    User profileUser = await DatabaseSystem.getUserWithId(widget.uid);
    setState(() {
      _profileUser = profileUser;
    });
  }

  _followOrUnfollow() {
    if (isFollowing) {
      _unfollowUser();
    } else {
      _followUser();
    }
  }

  _unfollowUser() {
    DatabaseSystem.unfollowUser(
      currentUserId: widget.currentUid,
      userId: widget.uid,
    );
    setState(() {
      isFollowing = false;
      --followerCount;
    });
  }

  _followUser() {
    DatabaseSystem.followUser(
      currentUserId: widget.currentUid,
      userId: widget.uid,
    );
    setState(() {
      isFollowing = true;
      ++followerCount;
    });
  }

  _setupFollowers() async {
    int userFollowerCount = await DatabaseSystem.numFollowers(widget.uid);
    setState(() {
      followerCount = userFollowerCount;
    });
  }

  _setupFollowing() async {
    int userFollowingCount = await DatabaseSystem.numFollowing(widget.uid);
    setState(() {
      followingCount = userFollowingCount;
    });
  }


  _setupPlayedGames() async {
    int playedGamesCount = await DatabaseSystem.numPlayedGames(widget.uid);
    setState(() {
      playedGames = playedGamesCount;
    });
  }

  _displayButton(User user) {
    return user.id == Provider
        .of<UserData>(context)
        .currentUid
        ? Container(
      width: 200.0,
      child: FlatButton(
        onPressed: () =>
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    EditProfileScreen(
                      user: user,
                      updateUser: (User updateUser) {
                        // ignore: unused_local_variable
                        User updatedUser = User(
                            id: updateUser.id,
                            name: updateUser.name,
                            email: user.email,
                            profileImageUrl: updateUser.profileImageUrl,
                            bio: updateUser.bio,
                            playedGames: updateUser.playedGames);
                        setState(() => _profileUser = updateUser);
                      },
                    ),
              ),
            ),
        color: Colors.teal,
        textColor: Colors.white,
        child: Text(
          'Profili Düzenle',
          style: TextStyle(fontSize: 18.0),
        ),
      ),
    )
        : Container(
      width: 200.0,
      child: FlatButton(
        onPressed: _followOrUnfollow,
        color: isFollowing ? Colors.grey[200] : Colors.teal,
        textColor: isFollowing ? Colors.black : Colors.white,
        child: Text(
          isFollowing ? 'Takibi Bırak' : 'Takip Et',
          style: TextStyle(fontSize: 18.0),
        ),
      ),
    );
  }

  _buildToggleButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.list),
          iconSize: 30.0,
          color: _displayBetween == DISP_GAMES
              ? Theme
              .of(context)
              .primaryColor
              : Colors.grey[200],
          onPressed: () =>
              setState(() {
                _displayBetween = DISP_GAMES;
              }),
        ),
        IconButton(
          icon: Icon(Icons.comment),
          iconSize: 30.0,
          color: _displayBetween == DISP_COMMENTS
              ? Theme
              .of(context)
              .primaryColor
              : Colors.grey[200],
          onPressed: () =>
              setState(() {
                _displayBetween = DISP_COMMENTS;
              }),
        ),
        IconButton(
          icon: Icon(Icons.crop_square),
          iconSize: 30.0,
          color: _displayBetween == DISP_POSTS
              ? Theme
              .of(context)
              .primaryColor
              : Colors.grey[200],
          onPressed: () =>
              setState(() {
                _displayBetween = DISP_POSTS;
              }),
        ),
      ],
    );
  }

  _buildDisplayGamesOrComments() {
    if (_displayBetween == DISP_GAMES) {
      List<GameView> gameViews = [];

      _games.forEach((Game game) {
        gameViews.add(
          GameView(
            currentUserId: widget.currentUid,
            game: game,
            user: _profileUser,
          ),
        );
      });

      return Column(
        children: gameViews,
      );
    } else if (_displayBetween == DISP_COMMENTS) {
      List<Widget> commentViews = [];
      _comments.forEach((Comment comment) {
        commentViews.add(
          FutureBuilder(
            future: usersRef.document(comment.authorId).get(),
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
    } else {
      List<PostView> postViews = [];
      _posts.forEach((Post post) {
        postViews.add(
          PostView(
            currentUserId: widget.currentUid,
            post: post,
            author: _profileUser,
          ),
        );
      });

      return Column(
        children: postViews,
      );
    }
  }

  _buildProfileInfo(User user, double rating, int raters) {
    final width = MediaQuery
        .of(context)
        .size
        .width;
    double _displayRating = rating * 100;
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(15.0, 30.0, 15.0, 0.0),
          child: Row(
            children: <Widget>[
              CircleAvatar(
                radius: 45.0,
                backgroundColor: Colors.teal[100],
                backgroundImage: user.profileImageUrl.isEmpty
                    ? AssetImage("assets/images/user_placeholder.jpg")
                    : CachedNetworkImageProvider(user.profileImageUrl),
              ),
              Expanded(
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Text(
                              user.playedGames.toString(),
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
                        Column(
                          children: <Widget>[
                            Text(
                              followerCount.toString(),
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'Takipçi',
                              style: TextStyle(color: Colors.black54),
                            ),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Text(
                              followingCount.toString(),
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'Takip',
                              style: TextStyle(color: Colors.black54),
                            ),
                          ],
                        ),
                      ],
                    ),
                    _displayButton(user)
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
                user.name,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5.0),
              Container(
                padding: EdgeInsets.only(bottom: 5.0),
                child: Text(
                  user.bio,
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
                        LinearPercentIndicator(
                          width: width * 0.3,
                          lineHeight: 10.0,
                          percent: rating,
                          progressColor: Colors.teal,
                        ),
                        SizedBox(),
                        Text(
                          "%" + _displayRating.toStringAsFixed(0),
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18.0,
                          ),
                        ),
                      ],
                    ),
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
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () =>
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SettingsScreen(),
                  ),
                ),
            color: Colors.black,
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: () async {
          _setupFollowers();
          _setupIsFollowing();
          _setupFollowing();
          _setupPlayedGames();
          _setupGames();
          _setupComments();
          _setupProfileUser();
          _setupPosts();
        },
        child: FutureBuilder(
          future: Future.wait([
            usersRef.document(widget.uid).get(),
            DatabaseSystem.handleUserRating(widget.uid),
          ]),
          builder:
              (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                User user = User.fromDoc(snapshot.data[0] as DocumentSnapshot);
                Map<String, double> rate = snapshot.data[1];

                double rating = rate["rating"];
                int raters = rate["raters"].toInt();

                return ListView(
                  children: <Widget>[
                    _buildProfileInfo(user, rating, raters),
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
