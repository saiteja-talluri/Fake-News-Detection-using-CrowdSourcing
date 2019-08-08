import 'package:flutter/material.dart';
import 'login_page.dart';
import 'news_feed.dart';


void main() => runApp(new InfactApp());

class InfactApp extends StatelessWidget {
  final routes = <String, WidgetBuilder>{
    LoginPage.tag: (context) => LoginPage(),
    NewsfeedPage.tag: (context) => NewsfeedPage(),
  };

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Infact',
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new LoginPage(),
      routes: routes,
    );  }
}
