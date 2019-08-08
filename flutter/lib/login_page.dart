import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'config.dart';
import 'session.dart';
import 'news_feed.dart';


class LoginPage extends StatefulWidget {
  static String tag = 'login-page';

  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autovalidate = false;
  String _name;
  String _pass;

  @override
  Widget build(BuildContext context) {
    final username = TextFormField(
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value.isEmpty) {
          return 'Username is required';
        } else
          return null;
      },
      onSaved: (String val) {
        _name = val;
      },
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Username',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final password = TextFormField(
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value.isEmpty) {
          return 'Password is required';
        } else
          return null;
      },
      onSaved: (String val) {
        _pass = val;
      },
      autofocus: false,
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    void _validateInputs(BuildContext scaffoldContext) {
      if (_formKey.currentState.validate()) {
        _formKey.currentState.save();
        Session s = new Session();
        Future<String> response = s.post(urlendpoint + "UserLogin",
            {'email_id': _name.trim(), 'password': _pass});
        response.then((body) {
          bool status = json.decode(body)['status'];
          if (status) {
            Navigator.of(context).pushReplacementNamed(NewsfeedPage.tag);
          } else {
            Scaffold.of(scaffoldContext).showSnackBar(SnackBar(
              content: Text('Login Failed'),
              duration: new Duration(seconds: 2),
              backgroundColor: const Color.fromRGBO(66, 165, 245, 1.0),
            ));
          }
        });
      } else {
        setState(() {
          _autovalidate = true;
        });
      }
    }

    Widget loginButton(BuildContext scaffoldContext) {
      return new Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: Material(
          borderRadius: BorderRadius.circular(30.0),
          shadowColor: Colors.lightBlueAccent.shade200,
          child: MaterialButton(
            minWidth: 200.0,
            height: 42.0,
            onPressed: () {
              _validateInputs(scaffoldContext);
            },
            color: Colors.lightBlueAccent,
            child: Text('Log In', style: TextStyle(color: Colors.white)),
          ),
        ),
      );
    }

    return new Scaffold(
        backgroundColor: Colors.white,
        appBar: new AppBar(
          title: Text('Infact'),
        ),
        body: new Builder(builder: (BuildContext scaffoldContext) {
          return new Center(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Container(
                  padding: const EdgeInsets.all(40.0),
                  child: new Form(
                    key: _formKey,
                    autovalidate: _autovalidate,
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        username,
                        SizedBox(height: 8.0),
                        password,
                        SizedBox(height: 24.0),
                        loginButton(scaffoldContext),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        })
    );
  }
}