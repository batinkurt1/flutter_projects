import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:haligol_deneme3/models/club.dart';
import 'package:haligol_deneme3/models/user.dart';
import 'package:haligol_deneme3/systems/DatabaseSystem.dart';
import 'package:haligol_deneme3/widgets/club_tile.dart';
import 'package:haligol_deneme3/widgets/user_tile.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with AutomaticKeepAliveClientMixin<SearchScreen> {
  Future<QuerySnapshot> _users, _clubs;

  static const USER = 0;
  static const CLUB = 1;

  @override
  bool get wantKeepAlive => true;

  _submit(String searchName) async {
    Future<QuerySnapshot> users = DatabaseSystem.searchUsers(searchName);
    Future<QuerySnapshot> clubs = DatabaseSystem.searchClubs(searchName);

    setState(() {
      _users = users;
      _clubs = clubs;
    });
  }

  ListView _buildSearchResults(
      List<DocumentSnapshot> documents, int searchType) {
    if (searchType == USER) {
      List<UserTile> userTiles = [];
      documents.forEach((DocumentSnapshot doc) {
        User user = User.fromDoc(doc);
        UserTile searchTile = UserTile(
          user: user,
        );
        userTiles.add(searchTile);
      });

      return ListView(
        children: userTiles,
      );
    }
    List<ClubTile> clubTiles = [];
    documents.forEach((DocumentSnapshot doc) {
      Club club = Club.fromDoc(doc);
      ClubTile searchTile = ClubTile(club);
      clubTiles.add(searchTile);
    });

    return ListView(
      children: clubTiles,
    );
  }

  _buildSearchField() {
    return AppBar(
      backgroundColor: Colors.white,
      title: Form(
        child: TextFormField(
          decoration: InputDecoration(
              labelText: "Ara",
              labelStyle: Theme.of(context)
                  .textTheme
                  .overline
                  .copyWith(fontWeight: FontWeight.bold)),
          onFieldSubmitted: _submit,
        ),
      ),
      bottom: TabBar(
        labelColor: Theme.of(context).primaryColor,
        labelStyle: Theme.of(context)
            .textTheme
            .overline
            .copyWith(fontWeight: FontWeight.bold, fontSize: 16),
        tabs: <Widget>[
          Tab(
            text: "Oyuncu",
          ),
          Tab(
            text: "Kulüp",
          ),
          //Tab(text: "Maç"),
          //Tab(text: "Etkinlik")
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: _buildSearchField(),
        body: TabBarView(
          children: <Widget>[
            _users == null
                ? SizedBox.shrink()
                : FutureBuilder<QuerySnapshot>(
                    future: _users,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return _buildSearchResults(
                            snapshot.data.documents, USER);
                      }
                      return Container(
                        alignment: FractionalOffset.center,
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
            _clubs == null
                ? SizedBox.shrink()
                : FutureBuilder<QuerySnapshot>(
                    future: _clubs,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return _buildSearchResults(
                            snapshot.data.documents, CLUB);
                      }
                      return Container(
                        alignment: FractionalOffset.center,
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
