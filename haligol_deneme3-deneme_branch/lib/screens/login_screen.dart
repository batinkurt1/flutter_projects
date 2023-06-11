import 'package:flutter/material.dart';
import 'package:haligol_deneme3/screens/signup_screen.dart';
import 'package:haligol_deneme3/systems/AuthSystem.dart';

class LoginScreen extends StatefulWidget {
  static final String id = "login_screen";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email, _password;

  _submit() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      AuthSystem.login(_email, _password);
      // LOGIN USER w/EMAIL
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
                "Halıgol",
                style: Theme.of(context)
                    .textTheme
                    .headline4
                    .copyWith(color: Theme.of(context).primaryColor),
              ),
              Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30.0,
                        vertical: 10.0,
                      ),
                      child: TextFormField(
                        decoration: InputDecoration(
                            labelText: 'E-posta',
                            labelStyle: Theme.of(context)
                                .textTheme
                                .overline
                                .copyWith(fontWeight: FontWeight.bold)),
                        validator: (input) => !input.contains('@')
                            ? 'Lütfen geçerli bir e-posta giriniz'
                            : null,
                        onSaved: (input) => _email = input.trim(),
                        keyboardType: TextInputType.emailAddress,
                        cursorColor: Theme.of(context).primaryColor,
                        style: Theme.of(context)
                            .textTheme
                            .overline
                            .copyWith(fontSize: 18),
                        textCapitalization: TextCapitalization.none,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30.0,
                        vertical: 10.0,
                      ),
                      child: TextFormField(
                        decoration: InputDecoration(
                            labelText: 'Şifre',
                            labelStyle: Theme.of(context)
                                .textTheme
                                .overline
                                .copyWith(fontWeight: FontWeight.bold)),
                        validator: (input) => input.length < 6
                            ? 'Şifreniz en az 6 karakter olmalıdır'
                            : null,
                        onSaved: (input) => _password = input,
                        obscureText: true,
                        autocorrect: false,
                        textCapitalization: TextCapitalization.none,
                        cursorColor: Theme.of(context).primaryColor,
                        style: Theme.of(context)
                            .textTheme
                            .overline
                            .copyWith(fontSize: 18),
                      ),
                    ),
                    const SizedBox(height: 15.0),
                    Container(
                      width: 250.0,
                      child: FlatButton(
                        onPressed: _submit,
                        color: Theme.of(context).primaryColor,
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          'Giriş Yap',
                          style: Theme.of(context).textTheme.overline.copyWith(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15.0),
                    Container(
                      width: 250.0,
                      child: FlatButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, SignupScreen.id),
                        color: Theme.of(context).primaryColor,
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          'Kayıt Ol',
                          style: Theme.of(context).textTheme.overline.copyWith(
                              color: Colors.white, fontWeight: FontWeight.bold),
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
