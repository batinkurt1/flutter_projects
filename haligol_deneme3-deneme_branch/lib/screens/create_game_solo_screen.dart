import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:haligol_deneme3/models/game.dart';
import 'package:haligol_deneme3/models/user.dart';
import 'package:haligol_deneme3/models/user_data.dart';
import 'package:haligol_deneme3/systems/DatabaseSystem.dart';
import 'package:haligol_deneme3/utilities/constants.dart';
import 'package:haligol_deneme3/utilities/fixture_format.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class CreateGameScreen extends StatefulWidget {
  final String currentUid;

  CreateGameScreen({this.currentUid});

  @override
  _CreateGameScreenState createState() => _CreateGameScreenState();
}

class _CreateGameScreenState extends State<CreateGameScreen> {
  String _title, _info, _city, _field;
  User _user;
  int _teamCapacity;
  List<String> fieldList = [];
  bool _boxcheck = false;

  FlutterToast _flutterToast;

  @override
  void initState() {
    if (mounted) {
      super.initState();
      _flutterToast = FlutterToast(context);
      _setupUser();
    }
  }

  _setupUser() async {
    User user = await DatabaseSystem.getUserWithId(widget.currentUid);
    setState(() {
      _user = user;
    });
  }

  _showToast(String text) {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.teal[300],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.7,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Text(
                text,
                style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );

    _flutterToast.showToast(
      child: toast,
      gravity: ToastGravity.CENTER,
      toastDuration: Duration(seconds: 3),
    );
  }

  void _showbottomsheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (buildercontext) {
          return const Padding(
            child: Text("Örnek ayrıntılı bilgi koyulacak."),
            padding: EdgeInsets.fromLTRB(30, 30, 50, 150),
          );
        });
  }

  final int maxLines = 5;
  final int maxCharacters = 256;

  DateTime _date;
  TimeOfDay _startTime;
  TimeOfDay _endTime;

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        locale: const Locale("tr"),
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2021));

    if (picked != null) {
      setState(() {
        _date = picked;
      });
    }
  }

  Future<Null> _selectStartTime(BuildContext context) async {
    final TimeOfDay picked =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());

    if (picked != null) {
      setState(() {
        _startTime = picked;
      });
    }
  }

  Future<Null> _selectEndTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
        context: context,
        initialTime: _startTime != null
            ? _startTime.replacing(hour: _startTime.hour + 1)
            : TimeOfDay.now());

    if (picked != null) {
      setState(() {
        _endTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Icon(Icons.album, color: Theme.of(context).primaryColor),
        title: Text(
          'Yeni Maç',
          style: Theme.of(context).textTheme.overline.copyWith(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder(
          future: DatabaseSystem.getUserWithId(widget.currentUid),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return SizedBox.shrink();
            }
            User user = snapshot.data;
            return SingleChildScrollView(
              child: Container(
                //resulted in overflowed pixels at the bottom.
                //height: MediaQuery.of(context).size.height,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                      child: TextFormField(
                        maxLength: 48,
                        decoration: InputDecoration(labelText: 'Başlık'),
                        onChanged: (input) => _title = input.trim(),
                        cursorColor: Theme.of(context).primaryColor,
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 10.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: FlatButton(
                              onPressed: () {
                                _selectDate(context);
                              },
                              color: Theme.of(context).primaryColor,
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Tarih',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: FlatButton(
                              onPressed: () {
                                _selectStartTime(context);
                              },
                              color: Theme.of(context).primaryColor,
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Başlama Zamanı',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            child: FlatButton(
                              onPressed: () {
                                _selectEndTime(context);
                              },
                              color: Theme.of(context).primaryColor,
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Bitiş Zamanı',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 10.0,
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _date != null
                                  ? Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Seçilen tarih: ${DateFormat.yMMMEd('tr_TR').format(_date)}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .overline,
                                      ),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Tarih seçiniz.",
                                        style: Theme.of(context)
                                            .textTheme
                                            .overline,
                                      ),
                                    ),
                              _startTime != null
                                  ? Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Seçilen başlama zamanı: ${_startTime.format(context)}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .overline,
                                      ),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Başlama zamanı seçiniz.",
                                        style: Theme.of(context)
                                            .textTheme
                                            .overline,
                                      ),
                                    ),
                              _endTime != null
                                  ? Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Seçilen bitiş zamanı: ${_endTime.format(context)}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .overline,
                                      ),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Bitiş zamanı seçiniz.",
                                        style: Theme.of(context)
                                            .textTheme
                                            .overline,
                                      ),
                                    ),
                            ],
                          ),
                        )),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      child: Column(
                        children: <Widget>[
                          Center(
                            child: DropdownButton<String>(
                              isExpanded: true,
                              hint: Text("Şehir"),
                              items: cities.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String newValue) {
                                setState(() {
                                  _city = newValue;
                                });
                                fieldList.clear();
                                _field = null;
                                for (int i = 0; i < fields.length; ++i) {
                                  if (int.parse(fields[i].substring(0, 2)) ==
                                      cities.indexOf(_city) + 1) {
                                    fieldList.add(fields[i].substring(3));
                                  }
                                }
                              },
                              value: _city,
                            ),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Center(
                            child: DropdownButton<String>(
                              isExpanded: true,
                              hint: Text("Halısaha"),
                              items: fieldList.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String newValue) {
                                setState(() {
                                  _field = newValue;
                                });
                              },
                              value: _field,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      child: Center(
                        child: DropdownButton<int>(
                          isExpanded: true,
                          focusColor: Theme.of(context).primaryColor,
                          hint: Text("Takım Büyüklüğü"),
                          items: [
                            4,
                            5,
                            6,
                          ].map((int value) {
                            return DropdownMenuItem<int>(
                              value: value,
                              child: Text(value.toString()),
                            );
                          }).toList(),
                          onChanged: (int newValue) {
                            setState(() {
                              _teamCapacity = newValue;
                            });
                          },
                          value: _teamCapacity,
                        ),
                      ),
                    ),
                    Align(
                        alignment: Alignment.bottomLeft,
                        child: FlatButton(
                          child: Text(
                            "Örnek ayrıntılı bilgi için tıklayınız.",
                          ),
                          onPressed: () {
                            _showbottomsheet(context);
                          },
                        )),
                    Container(
                      margin: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                      height: maxLines * 32.0,
                      child: TextFormField(
                        maxLines: maxLines,
                        maxLength: maxCharacters,
                        decoration:
                            const InputDecoration(hintText: "Ayrıntılı Bilgi"),
                        onChanged: (input) => _info = input,
                        cursorColor: Theme.of(context).primaryColor,
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        FlatButton(
                          child: Text(
                            "Kullanıcı Sözleşmesi",
                            style: Theme.of(context)
                                .textTheme
                                .overline
                                .copyWith(
                                    fontSize: 16,
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold),
                          ),
                          onPressed: () => {},
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                  "Kullanıcı sözleşmesini okudum ve kabul ediyorum.",
                                  style: TextStyle(
                                      fontFamily: Theme.of(context)
                                          .textTheme
                                          .overline
                                          .fontFamily)),
                              Checkbox(
                                  value: _boxcheck,
                                  onChanged: (bool value) {
                                    setState(() {
                                      _boxcheck = value;
                                    });
                                  }),
                            ],
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: FlatButton(
                        onPressed: () {
                          _submit(user);
                          Navigator.pop(context);
                        },
                        color: Theme.of(context).primaryColor,
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          'Maçı Oluştur',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "Not: Oluşturulan maça gitmemeniz veyahut maçın oluşturulmasının spam olduğunun anlaşılması durumunda hesabınız kapatılabilir.",
                        style: Theme.of(context).textTheme.overline.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                              backgroundColor: Colors.white,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  bool _isSubmissionOkay() {
    if ((_title == null ||
        _info == null ||
        _field == null ||
        _city == null ||
        _teamCapacity == null)) {
      _showToast("Lütfen doldurmadığınız yerleri doldurunuz.");
      return false;
    }
    if (_title.length < 8) {
      _showToast("Başlığınızın daha uzun olması gerekmektedir.");
      return false;
    }
    if (_info.length < 32) {
      _showToast("Bilginizin daha uzun olması gerekmektedir.");
      return false;
    }
    if (!_boxcheck) {
      _showToast(
        "Kullanıcı sözleşmesini kabul etmeniz gerekmektedir.",
      );
      return false;
    }
    return true;
  }

   _submit(User thisUser) async {
    if (!_isSubmissionOkay()) {
      return ;
    } else {
      DateTime startTime = DateTime(_date.year, _date.month, _date.day,
          _startTime.hour, _startTime.minute);
      DateTime endTime;
      if (_startTime.hour - _endTime.hour > 0) {
        endTime = DateTime(_date.year, _date.month, _date.day + 1,
            _endTime.hour, _endTime.minute);
      } else {
        endTime = DateTime(
            _date.year, _date.month, _date.day, _endTime.hour, _endTime.minute);
      }

      if (endTime.isBefore(startTime)) {
        _showToast("Bitiş saati, başlama saatinden geç olmalıdır.");
        return;
      }

      Map<String, String> homeNames = {widget.currentUid: _user.name};
      Map<String, String> awayNames = {};

      Map<String, String> homeProfiles = {
        widget.currentUid: _user.profileImageUrl
      };
      Map<String, String> awayProfiles = {};

      print(widget.currentUid + _user.name);
      print(widget.currentUid + _user.profileImageUrl);

      Game game = Game(
        title: _title,
        info: _info,
        teamCapacity: _teamCapacity,
        city: _city,
        field: _field,
        homeSize: 1,
        awaySize: 0,
        founderId: Provider.of<UserData>(context, listen: false).currentUid,
        homeNames: homeNames,
        awayNames: awayNames,
        homeProfiles: homeProfiles,
        awayProfiles: awayProfiles,
        startTime: Timestamp.fromDate(startTime),
        endTime: Timestamp.fromDate(endTime),
        timestamp: Timestamp.now(),
        lastMessage: Timestamp.now(),
      );

      DatabaseSystem.createUserGame(game: game, thisUser: thisUser);

      _showToast("Maç oluşturma başarılı!");

      print(FixtureFormat.getGameTimestamp(Timestamp.fromDate(startTime)));
      print(FixtureFormat.getGameTimestamp(Timestamp.fromDate(endTime)));
    }

    setState(() {
      _title = null;
      _info = null;
      _field = null;
      _city = null;
      _teamCapacity = null;
      _date = DateTime.now();
      _startTime = TimeOfDay.now();
      _endTime = TimeOfDay.now();
    });
    return ;
  }
}
