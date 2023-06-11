import 'package:flutter/material.dart';
import 'package:haligol_deneme3/models/answered_application.dart';
import 'package:haligol_deneme3/models/comment_activity.dart';
import 'package:haligol_deneme3/models/pending_application.dart';
import 'package:haligol_deneme3/models/post_activity.dart';
import 'package:haligol_deneme3/systems/DatabaseSystem.dart';
import 'package:haligol_deneme3/widgets/answered_app_tile.dart';
import 'package:haligol_deneme3/widgets/pending_app_tile.dart';

class ActivityScreen extends StatefulWidget {
  final String currentUserId;

  ActivityScreen({this.currentUserId});

  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  List<PendingApplication> _pendingActs = [];
  List<AnsweredApplication> _answeredActs = [];
  List<PostActivity> _postActs = [];

  // ignore: unused_field
  List<CommentActivity> _commentActs = [];

  @override
  void initState() {
    if (mounted) {
      super.initState();
      _setupAppActivities();
      _setupCommentActivities();
      _setupPostActivities();
    }
  }

  _setupPostActivities() async {
    List<PostActivity> postActs =
        await DatabaseSystem.getPostActivities(widget.currentUserId);
    if (mounted) {
      setState(() {
        _postActs = postActs;
      });
    }
  }

  _setupAppActivities() async {
    List<PendingApplication> pendingActivities =
        await DatabaseSystem.getPendingApplications(widget.currentUserId);
    List<AnsweredApplication> answeredActivities =
        await DatabaseSystem.getAnsweredApplications(widget.currentUserId);

    if (mounted) {
      setState(() {
        _pendingActs = pendingActivities;
        _answeredActs = answeredActivities;
      });
    }
  }

  _setupCommentActivities() async {
    List<CommentActivity> commentActivities =
        await DatabaseSystem.getCommentActivities(widget.currentUserId);
    if (mounted) {
      setState(() {
        _commentActs = commentActivities;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Activity> _acts = [];
    _acts.addAll(_pendingActs);
    _acts.addAll(_answeredActs);
    _acts.addAll(_postActs);

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
      body: RefreshIndicator(
        onRefresh: () async {
          _setupAppActivities();
        },
        child: ListView.builder(
            itemCount: _acts.length,
            itemBuilder: (BuildContext context, int index) {
              Activity activity = _acts[index];
              if (activity is AnsweredApplication) {
                return AnsweredAppTile(activity);
              } else if (activity is PendingApplication) {
                return PendingAppTile(application: activity);
              } else {
                return SizedBox.shrink();
              }
            }),
      ),
    );
  }
}
