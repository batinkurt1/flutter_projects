import 'package:flutter/material.dart';
import 'package:haligol_deneme3/models/game.dart';
import 'package:haligol_deneme3/systems/DatabaseSystem.dart';
import 'package:haligol_deneme3/widgets/chat_game_tile.dart';

class GameChatScreen extends StatefulWidget {
  final String currentUid;

  GameChatScreen({@required this.currentUid});

  @override
  _GameChatScreenState createState() => _GameChatScreenState();
}

class _GameChatScreenState extends State<GameChatScreen>
    with AutomaticKeepAliveClientMixin<GameChatScreen> {
  @override
  bool get wantKeepAlive => true;

  ListView _buildChatGames(List<Game> games) {
    List<ChatGameTile> chatTiles = [];
    games.forEach((game) {
      ChatGameTile chatTile = ChatGameTile(
        game: game,
        currentUid: widget.currentUid,
      );
      chatTiles.add(chatTile);
    });

    return ListView(
      children: chatTiles,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: RefreshIndicator(
        child: FutureBuilder(
          future: DatabaseSystem.getGameRooms(widget.currentUid),
          builder: (context, snapshot) {
            if( !snapshot.hasData){
              return SizedBox.shrink();
            }
            List<Game> games = snapshot.data;
            return _buildChatGames(games);
          },
        ),
        onRefresh: () => DatabaseSystem.getGameRooms(widget.currentUid),
      ),
    );
  }
}
