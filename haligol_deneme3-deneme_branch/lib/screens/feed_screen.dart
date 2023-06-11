import 'package:flutter/material.dart';
import 'package:haligol_deneme3/models/post.dart';
import 'package:haligol_deneme3/models/user.dart';
import 'package:haligol_deneme3/models/game.dart';
import 'package:haligol_deneme3/styles/text_styles.dart';
import 'package:haligol_deneme3/widgets/game_view.dart';
import 'package:haligol_deneme3/systems/DatabaseSystem.dart';
import 'package:haligol_deneme3/widgets/post_view.dart';

import 'chat_screen.dart';

class FeedScreen extends StatefulWidget {
  static final String id = "feed_screen";
  final String currentUid;

  FeedScreen({this.currentUid});

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
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
            icon: Icon(Icons.chat_bubble, color: TextStyles.mainColor,),
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ChatScreen(
                          currentUid: widget.currentUid,
                        ))),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: DatabaseSystem.getUserFeed(widget.currentUid),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return SizedBox.shrink();
          }
          final List<Feed> feeds = snapshot.data;
          if (feeds.isEmpty) {
            return SizedBox.shrink();
          }
          return ListView.builder(
              itemCount: feeds.length,
              itemBuilder: (
                BuildContext context,
                int index,
              ) {
                Feed feed = feeds[index];
                return FutureBuilder(
                  future: (feed is Post)
                      ? DatabaseSystem.getUserWithId(feed.authorId)
                      : DatabaseSystem.getUserWithId((feed as Game).founderId),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) {
                      return SizedBox.shrink();
                    }
                    User author = snapshot.data;
                    if (feed is Post) {
                      return PostView(
                        author: author,
                        post: feed,
                        currentUserId: widget.currentUid,
                      );
                    } else if (feed is Game) {
                      return GameView(
                        currentUserId: widget.currentUid,
                        game: feed,
                        user: author,
                      );
                    }
                    return SizedBox.shrink();
                  },
                );
              });
        },
      ),
    );
  }
}
