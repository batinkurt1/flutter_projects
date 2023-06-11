import 'package:flutter/material.dart';
import 'package:haligol_deneme3/models/contact.dart';
import 'package:haligol_deneme3/systems/DatabaseSystem.dart';
import 'package:haligol_deneme3/widgets/contact_tile.dart';
import 'player_message_screen.dart';

class ContactsScreen extends StatefulWidget {
  final String currentUid;

  ContactsScreen({this.currentUid});

  @override
  _ContactsScreenState createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {

  ListView _buildContacts(List<Contact> contacts) {
    List<ContactTile> contactTiles = [];
    contacts.forEach((contact) {
      ContactTile contactTile = ContactTile(
        contact: contact, currentUid: widget.currentUid, roomId: "noRoomId",
      );
      contactTiles.add(contactTile);
    });

    return ListView(
      children: contactTiles,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Mesaj Gönder',
          style: TextStyle(
            color: Colors.teal,
          ),
        ),
      ),
      body: FutureBuilder(
        future: DatabaseSystem.getUserContacts(widget.currentUid),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container(
              alignment: FractionalOffset.center,
              child: CircularProgressIndicator(),
            );
          }
          List<Contact> contacts = snapshot.data;
          return _buildContacts(contacts);
        },
      ),
    );
  }
}
