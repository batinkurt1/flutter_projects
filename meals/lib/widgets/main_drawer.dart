import "package:flutter/material.dart";

class MainDrawer extends StatelessWidget {
  Widget _listTileBuilder(String title, IconData icon, Function tapHandler) {
    return ListTile(
        onTap: tapHandler,
        leading: Icon(
          icon,
          size: 26,
        ),
        title: Text(title,
            style: TextStyle(
                fontFamily: "RobotoCondensed",
                fontSize: 24,
                fontWeight: FontWeight.bold)));
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
      children: [
        Container(
          color: Theme.of(context).accentColor,
          height: 120,
          width: double.infinity,
          padding: EdgeInsets.all(20),
          alignment: Alignment.centerLeft,
          child: Text("Cooking Up!",
              style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 30,
                  color: Theme.of(context).primaryColor)),
        ),
        SizedBox(height: 20),
        _listTileBuilder("Meals", Icons.restaurant, () {
          Navigator.of(context).pushReplacementNamed("/");
        }),
        _listTileBuilder("Filters", Icons.settings, () {
          Navigator.of(context).pushReplacementNamed("/filters");
        }),
      ],
    ));
  }
}
