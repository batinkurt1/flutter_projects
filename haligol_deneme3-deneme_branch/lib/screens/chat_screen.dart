import 'package:flutter/material.dart';
import 'package:haligol_deneme3/screens/player_chat_screen.dart';

import 'club_chat_screen.dart';
import 'game_chat_screen.dart';

class ChatScreen extends StatefulWidget {
  final String currentUid;

  ChatScreen({@required this.currentUid});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    if (mounted) {
      _tabController = TabController(vsync: this, length: 3, initialIndex: 1);
      super.initState();
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: SafeArea(
          child: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  title: Text("Sohbet"),
                  floating: true,
                  actions: <Widget>[
                    IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {},
                    ),
                  ],
                ),
              ];
            },
            body: Column(
              children: <Widget>[
                TabBar(
                  controller: _tabController,
                  labelColor: Colors.teal,
                  tabs: <Widget>[
                    Tab(text: "Maç"),
                    Tab(text: "Kulüp"),
                    Tab(text: "Oyuncu"),
                  ],
                ),
                Expanded(
                  child: Container(
                    color: Colors.grey,
                    child: TabBarView(
                      controller: _tabController,
                      children: <Widget>[
                        GameChatScreen(
                          currentUid: widget.currentUid,
                        ),
                        ClubChatScreen(),
                        PlayerChatScreen(
                          currentUid: widget.currentUid,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
