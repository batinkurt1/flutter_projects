import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:haligol_deneme3/models/post.dart';
import 'package:haligol_deneme3/models/post_activity.dart';
import 'package:haligol_deneme3/models/user.dart';
import 'package:haligol_deneme3/screens/post_comments_screen.dart';
import 'package:haligol_deneme3/systems/DatabaseSystem.dart';
import 'package:intl/intl.dart';

class PostActivityTile extends StatelessWidget {
  final String currentUserId;
  final PostActivity postActivity;

  PostActivityTile({this.currentUserId, this.postActivity});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DatabaseSystem.getUserWithId(postActivity.fromUserId),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return SizedBox.shrink();
        }
        User user = snapshot.data;
        return ListTile(
          leading: CircleAvatar(
            radius: 15.0,
            backgroundColor: Colors.grey,
            backgroundImage: user.profileImageUrl.isEmpty
                ? AssetImage("assets/images/user_placeholder.jpg")
                : CachedNetworkImageProvider(user.profileImageUrl),
          ),
          title: postActivity.comment != null ? Text("${user.name} gönderine yorum yaptı: ${postActivity.comment}") : Text("${user.name} gönderini beğendi."),
          subtitle: Text(DateFormat.yMd().add_jm().format(postActivity.timestamp.toDate())),
          trailing: CachedNetworkImage(
            imageUrl: postActivity.postImageUrl,
            height: 40.0,
            width: 40.0,
            fit: BoxFit.cover,
          ),
          onTap: () async {
            Post post = await DatabaseSystem.getUserPost(currentUserId, postActivity.postId);
            Navigator.push(context, MaterialPageRoute(builder: (_) => PostCommentsScreen(post: post, likeCount: post.likeCount,)));
          },
        );

      },
    );
  }
}
