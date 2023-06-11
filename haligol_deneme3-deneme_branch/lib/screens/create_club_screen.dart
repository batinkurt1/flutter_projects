import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:haligol_deneme3/models/club.dart';
import 'package:haligol_deneme3/models/user.dart';
import 'package:haligol_deneme3/systems/DatabaseSystem.dart';
import 'package:haligol_deneme3/systems/StorageSystem.dart';
import 'package:haligol_deneme3/utilities/constants.dart';
import 'package:image_picker/image_picker.dart';

class CreateClubScreen extends StatefulWidget {
  final String currentUid;

  CreateClubScreen({this.currentUid});

  @override
  _CreateClubScreenState createState() => _CreateClubScreenState();
}

class _CreateClubScreenState extends State<CreateClubScreen> {
  File _image;
  String _name, _clubLogoUrl, _motto, _city, _info;
  User _user;

  final int maxLines = 5;
  final int maxCharacters = 256;

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

  _handleImage(ImageSource source) async {
    Navigator.pop(context);
    final _picker = ImagePicker();
    final imageFile = await _picker.getImage(source: source);
    if (imageFile != null) {
      //final _file = await _cropImage(File(imageFile.path));
      setState(() {
        _image = File(imageFile.path);
      });
    }
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
          Text(
            text,
            style: TextStyle(fontSize: 14.0, color: Colors.white),
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

  bool _isSubmissionOkay() {
    if ((_name == null ||
        _image == null ||
        _clubLogoUrl == null ||
        _motto == null ||
        _city == null)) {
      _showToast("Lütfen doldurmadığınız yerleri doldurunuz.");
      return false;
    }
    if (_name.length < 8) {
      _showToast("Kulüp isminin daha uzun olması gerekmektedir.");
      return false;
    }
    if (_motto.length < 8) {
      _showToast("Sloganın daha uzun olması gerekmektedir.");
      return false;
    }
    if (_info.length < 32) {
      _showToast("Bilginin daha uzun olması gerekmektedir.");
      return false;
    }
    return true;
  }

  _submit() async {
    if (!_isSubmissionOkay()) {
      return;
    } else {
      String imageUrl = await StorageSystem.uploadLogo(_image);
      Map<String, bool> squadIds = {widget.currentUid: true};
      Club club = Club(
        name: _name,
        clubLogoUrl: imageUrl,
        motto: _motto,
        city: _city,
        info: _info,
        squadSize: 1,
        squadIds: squadIds,
        raters: 0,
        rating: 0,
        playedGames: 0,
        timestamp: Timestamp.now(),
        founderId: widget.currentUid,
      );

      DatabaseSystem.createClub(club);
      _showToast("Kulüp oluşturma başarılı!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Kulüp Oluştur',
          style: TextStyle(
            color: Colors.teal,
            fontSize: 18.0,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0.0),
                child: TextFormField(
                  maxLength: 48,
                  decoration: InputDecoration(labelText: 'Kulüp adı'),
                  onChanged: (input) => _name = input.trim(),
                  cursorColor: Colors.teal,
                  style: TextStyle(
                    color: Colors.teal,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0.0),
                child: TextFormField(
                  maxLength: 48,
                  decoration: InputDecoration(labelText: 'Slogan'),
                  onChanged: (input) => _name = input.trim(),
                  cursorColor: Colors.teal,
                  style: TextStyle(
                    color: Colors.teal,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(right: 10.0),
                child: FlatButton(
                  onPressed: () => _handleImage(ImageSource.gallery),
                  color: Colors.teal,
                  padding: EdgeInsets.all(12.0),
                  child: Text(
                    'Amblem ekle',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: Center(
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
                    },
                    value: _city,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(20, 10, 20, 0),
                height: maxLines * 32.0,
                child: TextFormField(
                  maxLines: maxLines,
                  maxLength: maxCharacters,
                  decoration: InputDecoration(hintText: "Ayrıntılı Bilgi"),
                  onChanged: (input) => _info = input,
                  cursorColor: Colors.teal,
                  style: TextStyle(
                    color: Colors.teal,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(right: 10.0),
                child: FlatButton(
                  onPressed: _submit,
                  color: Colors.teal,
                  padding: EdgeInsets.all(12.0),
                  child: Text(
                    'Kulübü Oluştur',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Oluşturulan maça gitmemeniz veyahut maçın oluşturulmasının spam olduğunun anlaşılması durumunda hesabınız kapatılabilir.",
                      style: TextStyle(
                        color: Colors.teal,
                        backgroundColor: Colors.teal[50],
                        fontWeight: FontWeight.w500,
                        fontSize: 16.0,
                      ),
                    ),
                    SizedBox(
                      height: 40.0,
                    ),
                    Text(
                      "KULLANICI SÖZLEŞMESİ",
                      style: TextStyle(
                        backgroundColor: Colors.teal[50],
                        color: Colors.teal,
                        fontWeight: FontWeight.w900,
                        fontSize: 20.0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
