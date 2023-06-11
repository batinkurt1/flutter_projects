import 'package:flutter/material.dart';
import 'package:haligol_deneme3/systems/AuthSystem.dart';

class SignupScreen extends StatefulWidget {
  static final String id = 'signup_screen';

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name, _email, _password;

  _submit() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      // LOGIN / ONLY EMAIL FOR NOW
      AuthSystem.signUp(context, _name, _email, _password);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'Halıgol',
                style: TextStyle(
                  fontFamily: 'Neo Sans',
                  fontSize: 48.0,
                  color: Colors.teal,
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 30.0,
                        vertical: 10.0,
                      ),
                      child: TextFormField(
                        decoration: InputDecoration(labelText: 'Adınız'),
                        validator: (input) =>
                            (input.trim().isEmpty && !input.contains(' '))
                                ? 'Geçerli bir ad giriniz'
                                : null,
                        onSaved: (input) => _name = input,
                        cursorColor: Colors.teal,
                        textCapitalization: TextCapitalization.words,
                        style: TextStyle(
                          color: Colors.teal,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 30.0,
                        vertical: 10.0,
                      ),
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(labelText: 'E-posta'),
                        validator: (input) =>
                            !input.contains('@') && !input.contains('.com')
                                ? 'Lütfen geçerli bir e-posta giriniz'
                                : null,
                        onSaved: (input) => _email = input.trim(),
                        cursorColor: Colors.teal,
                        style: TextStyle(
                          color: Colors.teal,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 30.0,
                        vertical: 10.0,
                      ),
                      child: TextFormField(
                        decoration: InputDecoration(labelText: 'Şifre'),
                        validator: (input) => input.length < 6
                            ? 'Şifreniz en az 6 karakter olmalıdır'
                            : null,
                        onSaved: (input) => _password = input,
                        obscureText: true,
                        autocorrect: false,
                        textCapitalization: TextCapitalization.none,
                        cursorColor: Colors.teal,
                        style: TextStyle(
                          color: Colors.teal,
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Container(
                      width: 250.0,
                      child: FlatButton(
                        onPressed: () {
                          _submit();
                          FocusScope.of(context).unfocus();
                        },
                        color: Colors.teal,
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          'Kayıt ol',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Container(
                      width: 250.0,
                      child: FlatButton(
                        onPressed: () => Navigator.pop(context),
                        color: Colors.teal,
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          'Giriş Yap\'a geri dön',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                          ),
                        ),
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
