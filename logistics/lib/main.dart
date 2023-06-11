import 'package:app/screens/google_maps.dart';
import 'package:flutter/material.dart';
import 'package:app/screens/all_shipments.dart';
import 'package:app/screens/start_new_shipment.dart';


import './screens/main_body.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Gönder",
      theme: ThemeData(
        primarySwatch: Colors.pink,
        accentColor: Colors.amber,
        canvasColor: Color.fromRGBO(255, 254, 229, 1),
        fontFamily: "Raleway",
        textTheme: ThemeData.light().textTheme.copyWith(
            bodyText1: TextStyle(color: Color.fromRGBO(20, 51, 51, 1)),
            bodyText2: TextStyle(color: Color.fromRGBO(20, 51, 51, 1)),
            headline6: TextStyle(
                fontSize: 20,
                fontFamily: "RobotoCondensed",
                fontWeight: FontWeight.bold)),
      ),
      //home: Scaffold(
      //appBar: AppBar(
      //backgroundColor: Colors.green[100],
      //title: Text("Gönder | Hemen gelsin"),
      //),
      //backgroundColor: Colors.cyan[100],
      //floatingActionButton: Text("floatingActionButton"),
      //endDrawer: Text("endDrawer")},
      routes: {
        "/": (context) => MainBody(),
        "/shipment": (context) => Shipment(),
        "/allshipments": (context) => AllShipments(),
        "/google_map":(context)=>MapGoogle(),
        //"/filters": (context) => FiltersScreen(_setFilters, _filters),
      },
    );
  }
}
