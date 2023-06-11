import "package:flutter/material.dart";
import 'package:app/screens/analyst_main.dart';
import 'package:app/screens/customer_main.dart';

class MainBody extends StatefulWidget {
  @override
  _MainBodyState createState() => _MainBodyState();
}

class _MainBodyState extends State<MainBody> {
  List<bool> _selections = [false, true];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Drawer(),
        appBar: AppBar(
          backgroundColor: Colors.green[100],
          title: Text(
            "Gönder | Hemen Gelsin",
            style: TextStyle(color: Colors.black, fontSize: 16),
          ),
          actions: <Widget>[
            Padding(
              child: ToggleButtons(
                children: <Widget>[
                  Padding(child: Text("Kurye"), padding: EdgeInsets.all(5)),
                  Padding(
                    child: Text("Müşteri"),
                    padding: EdgeInsets.all(5),
                  ),
                ],
                borderRadius: BorderRadius.circular(20),
                onPressed: (int index) {
                  setState(() {
                    for (int buttonIndex = 0;
                        buttonIndex < _selections.length;
                        buttonIndex++) {
                      if (buttonIndex == index) {
                        _selections[buttonIndex] = true;
                      } else {
                        _selections[buttonIndex] = false;
                      }
                    }
                  });
                },
                isSelected: _selections,
              ),
              padding: EdgeInsets.fromLTRB(3, 5, 3, 5),
            ),
          ],
        ),
        backgroundColor: Colors.cyan[100],
        body: _selections[0]
            ? Center(child: AnalystMain())
            : Center(child: CustomerMain()));
  }
}
