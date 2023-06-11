import 'package:flutter/material.dart';

class AllShipments extends StatefulWidget {
  @override
  State<AllShipments> createState() => _AllShipmentsState();
}

class _AllShipmentsState extends State<AllShipments> {
  void _selectPage() {
    setState(() {
      Navigator.of(context).pushReplacementNamed("/");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Drawer(),
        appBar: AppBar(
            backgroundColor: Colors.green[100],
            title: Text(
              "Gönder | Hemen Gelsin",
              style: TextStyle(color: Colors.black, fontSize: 16),
            )),
        backgroundColor: Colors.cyan[100],
        body: ListView(
            children: [ElevatedCardExample(),ElevatedCardExample2()],
        ));

    //ElevatedButton(
    //child: Text("Go back"),
    //onPressed: _selectPage,
    //));
  }
}

class ElevatedCardExample extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Card(
        child: SizedBox(
          width: 300,
          height: 100,
          child: Center(child: Text('Sipariş #1')),
        ),
      ),
    );
  }
}
class ElevatedCardExample2 extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Card(
        child: SizedBox(
          width: 300,
          height: 100,
          child: Center(child: Text('Sipariş #2')),
        ),
      ),
    );
  }
}