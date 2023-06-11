import 'package:flutter/material.dart';
import 'package:haligol_deneme3/systems/AuthSystem.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ayarlar"),
      ),
      body: Center(
        child: RaisedButton(
          child: Text("Çıkış yap"),
          onPressed: () {
            AuthSystem.logout();
            Navigator.popUntil(context, ModalRoute.withName("/"));
          },
        ),
      ),
    );
  }
}
