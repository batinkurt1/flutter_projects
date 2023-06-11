import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class Shipment extends StatefulWidget {
  @override
  _ShipmentState createState() => _ShipmentState();
}

class _ShipmentState extends State<Shipment> {
  void _selectPage() {
    setState(() {
      Navigator.of(context).pushReplacementNamed("/");
    });
  }

  var _vehicles = ["Motor Kurye", "Araba", "Bisiklet Kurye"];
  var _weights = [1, 5, 10, 20];
  List<bool> _selections = [true, false, false];
  List<bool> _selections2 = [true, false];
  List<bool> _selections3 = [true, false, false, false];
  bool _isUrgent = true;
  var _pickuptime = "";
  var _arrivaltime = "";
  var _transferdate = "";
  var _vehicle = "Motor Kurye";
  var _pickupaddress = "";
  var _finaladress = "";
  var _contents = "";
  var _weight = 1;
  var _isTool=true;

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
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Kurye Aracı Seçiniz:",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ToggleButtons(
                    children: <Widget>[
                      Padding(
                          child: Row(
                            children: [
                              Icon(Icons.motorcycle),
                              Text(" Motor Kurye"),
                            ],
                          ),
                          padding: EdgeInsets.all(5)),
                      Padding(
                        child: Row(
                          children: [
                            Icon(Icons.directions_car),
                            Text(" Araba Kurye"),
                          ],
                        ),
                        padding: EdgeInsets.all(5),
                      ),
                      Padding(
                          child: Row(
                            children: [
                              Icon(Icons.directions_bike),
                              Text(" Bisiklet Kurye"),
                            ],
                          ),
                          padding: EdgeInsets.all(5))
                    ],
                    borderRadius: BorderRadius.circular(20),
                    onPressed: (int index) {
                      setState(() {
                        for (int buttonIndex = 0;
                            buttonIndex < _selections.length;
                            buttonIndex++) {
                          if (buttonIndex == index) {
                            _selections[buttonIndex] = true;
                            _vehicle = _vehicles[index];
                          } else {
                            _selections[buttonIndex] = false;
                          }
                        }
                      });
                    },
                    isSelected: _selections,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Teslim Zamanını Belirleyiniz:",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ToggleButtons(
                    children: <Widget>[
                      Padding(
                          child: Text("En kısa sürede"),
                          padding: EdgeInsets.all(5)),
                      Padding(
                        child: Text("Bir zaman belirle"),
                        padding: EdgeInsets.all(5),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(20),
                    onPressed: (int index) {
                      setState(() {
                        for (int buttonIndex = 0;
                            buttonIndex < _selections2.length;
                            buttonIndex++) {
                          if (buttonIndex == index) {
                            _selections2[buttonIndex] = true;
                          } else {
                            _selections2[buttonIndex] = false;
                          }
                          _selections2[0]
                              ? _isUrgent = true
                              : _isUrgent = false;
                        }
                      });
                    },
                    isSelected: _selections2,
                  ),
                ),
                _selections2[0]
                    ? SizedBox()
                    : Column(
                        children: [
                          ElevatedButton(
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ))),
                            onPressed: () {
                              DatePicker.showDatePicker(context,
                                  theme: DatePickerTheme(
                                      backgroundColor: Colors.white),
                                  showTitleActions: true,
                                  minTime: DateTime(2022, 5, 14),
                                  maxTime: DateTime(2022, 12, 31),
                                  onConfirm: (date) {
                                _transferdate = date.toString().split(" ")[0];
                              },
                                  currentTime: DateTime.now(),
                                  locale: LocaleType.tr);
                            },
                            child: Text(
                              "Tarih Seçiniz",
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ))),
                                    onPressed: () {
                                      DatePicker.showTimePicker(context,
                                          theme: DatePickerTheme(
                                              backgroundColor: Colors.white),
                                          showTitleActions: true,
                                          showSecondsColumn: false,
                                          onConfirm: (stime) {
                                        _pickuptime =
                                            stime.toString().split(" ")[1];
                                      },
                                          currentTime: DateTime.now(),
                                          locale: LocaleType.tr);
                                    },
                                    child: Text(
                                      "Alış Saati",
                                    ),
                                  ),
                                )
                              ]),
                              Column(children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ))),
                                    onPressed: () {
                                      DatePicker.showTimePicker(context,
                                          theme: DatePickerTheme(
                                              backgroundColor: Colors.white),
                                          showTitleActions: true,
                                          showSecondsColumn: false,
                                          onConfirm: (etime) {
                                        _arrivaltime =
                                            etime.toString().split(" ")[1];
                                      },
                                          currentTime: DateTime.now(),
                                          locale: LocaleType.tr);
                                    },
                                    child: Text(
                                      "Varış Saati",
                                    ),
                                  ),
                                )
                              ])
                            ],
                          ),
                        ],
                      ),
                Text("Çıkış ve Varış Konumlarını Belirleyiniz:",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ))),
                          onPressed: () {
                            setState(() {
                              Navigator.of(context).pushNamed("/google_map");
                              _finaladress = "";
                            });
                          },
                          child: Text("Çıkış Konumu")),
                      ElevatedButton(
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ))),
                        onPressed: () {
                          setState(() {
                            Navigator.of(context).pushNamed("/google_map");
                            _pickupaddress = "";
                          });
                        },
                        child: Text("Varış Konumu"),
                      )
                    ],
                  ),
                ),
                Column(
                  children: [
                    Text("Teslimat Paketinin İçeriğini Giriniz:",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2,
                      child: TextField(
                        onChanged: (item) {
                          _contents = item;
                        },
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 20, 8, 20),
                  child: Column(
                    children: [
                      Text("Teslimat Paketinin Ağırlığını Seçiniz:",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                ToggleButtons(
                  children: <Widget>[
                    Padding(child: Text("max 1kg"), padding: EdgeInsets.all(5)),
                    Padding(
                      child: Text("max 5kg"),
                      padding: EdgeInsets.all(5),
                    ),
                    Padding(
                        child: Text("max 10kg"), padding: EdgeInsets.all(5)),
                    Padding(child: Text("max 20kg"), padding: EdgeInsets.all(5))
                  ],
                  borderRadius: BorderRadius.circular(20),
                  onPressed: (int index) {
                    setState(() {
                      for (int buttonIndex = 0;
                          buttonIndex < _selections3.length;
                          buttonIndex++) {
                        if (buttonIndex == index) {
                          _selections3[buttonIndex] = true;
                          _weight = _weights[index];
                        } else {
                          _selections3[buttonIndex] = false;
                        }
                      }
                    });
                  },
                  isSelected: _selections3,
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 12),
                Container(alignment: Alignment.centerRight,padding: EdgeInsets.fromLTRB(0, 0, 10, 5),
                  child: ElevatedButton(onPressed: (){
                    showDialog(
              context: context,
              builder: (BuildContext context) => _buildPopupDialog(context),
            );
                  }, child: Icon(Icons.check)),
                )
              ],
            ),
          ],
        )
        //ElevatedButton(child:Text("Go back"),onPressed: _selectPage,)
        );
  }
}


Widget _buildPopupDialog(BuildContext context) {
  var _isTool=false;
  return new AlertDialog(
    title: Text('Teslimat Emriniz Başarıyla Oluşturulmuştur'),
    content: new Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        
        _isTool ?Text("Teslimat Ücretiniz: ${25} TL") : Text("Teslimat Ücretiniz: ${60.11} TL"),
      ],
    ),
    actions: <Widget>[
       TextButton(
        onPressed: () {
          Navigator.of(context).pushReplacementNamed("/");
        },
        child: Icon(Icons.check),
      ),
    ],
  );
}