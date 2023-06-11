import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:haligol_deneme3/models/comment.dart';
import 'package:haligol_deneme3/models/user.dart';
import 'package:haligol_deneme3/screens/user_profile_screen.dart';
import 'package:haligol_deneme3/widgets/rating_view.dart';

class CommentView extends StatelessWidget {
  final String currentUserId;
  final User user;
  final Comment comment;

  CommentView({this.currentUserId, this.comment, this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => UserProfileScreen(
                  currentUid: currentUserId,
                  uid: comment.authorId,
                ),
              ),
            );
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 20.0,
                  backgroundColor: Colors.teal[100],
                  backgroundImage: user.profileImageUrl.isEmpty
                      ? AssetImage("assets/images/user_placeholder.jpg")
                      : CachedNetworkImageProvider(user.profileImageUrl),
                ),
                SizedBox(
                  width: 8.0,
                ),
                Text(
                  user.name,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                RatingView(
                  score: comment.score,
                  onScoreChanged: null,
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
                Colors.teal,
                Colors.teal[300],
              ],
            ),
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: [
              BoxShadow(
                color: Colors.teal[200],
                offset: Offset(3.0, 3.0),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(comment.comment),
              Text(comment.timestamp.toString()),
            ],
          ),
        ),
      ],
    );
  }
}
