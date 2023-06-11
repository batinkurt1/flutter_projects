import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haligol_deneme3/models/user_data.dart';
import 'package:haligol_deneme3/screens/activity_screen.dart';
import 'package:haligol_deneme3/screens/feed_screen.dart';
import 'package:haligol_deneme3/screens/search_screen.dart';
import 'package:haligol_deneme3/screens/user_profile_screen.dart';
import 'package:provider/provider.dart';

import 'create_document_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  PageController _pageController;

  @override
  void initState() {
    if (mounted) {
      super.initState();
      _pageController = PageController();
    }
  }

  @override
  void dispose() {
    // called super.dispose() first.
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String currentUid = Provider.of<UserData>(context).currentUid;

    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: <Widget>[
          //will add cards around these screens.
          FeedScreen(
            currentUid: currentUid,
          ),
          SearchScreen(),
          CreateDocumentScreen(
            currentUid: currentUid,
          ),
          ActivityScreen(
            currentUserId: currentUid,
          ),
          UserProfileScreen(uid: currentUid, currentUid: currentUid),
        ],
        onPageChanged: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
          _pageController.animateToPage(index,
              duration: Duration(milliseconds: 175), curve: Curves.easeIn);
        },
        activeColor: Theme.of(context).primaryColor,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              size: 28.0,
            ),
            title: FittedBox(
              fit: BoxFit.contain,
              child: Text(
                "Ana Sayfa",
                style: Theme.of(context).textTheme.overline.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
              size: 28.0,
            ),
            title: FittedBox(
              fit: BoxFit.contain,
              child: Text(
                "Arama",
                style: Theme.of(context).textTheme.overline.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add_circle,
              size: 28.0,
            ),
            title: FittedBox(
              fit: BoxFit.contain,
              child: Text(
                "Yeni Maç",
                style: Theme.of(context).textTheme.overline.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.notifications,
              size: 28.0,
            ),
            title: FittedBox(
              fit: BoxFit.contain,
              child: Text(
                "Hareketler",
                style: Theme.of(context).textTheme.overline.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              size: 28.0,
            ),
            title: FittedBox(
              fit: BoxFit.contain,
              child: Text(
                "Profil",
                style: Theme.of(context).textTheme.overline.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
