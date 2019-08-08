import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'config.dart';
import 'login_page.dart';
import 'session.dart';
import 'homefeed_screen.dart' as HomeFeedScreen;
import 'addpost_screen.dart' as AddPostScreen;
import 'categories_screen.dart' as CategoriesScreen;
import 'apply_screen.dart' as ApplyScreen;
import 'bookmarks_screen.dart' as BookmarkScreen;

class NewsfeedPage extends StatefulWidget {
  static String tag = 'newsfeed-page';

  @override
  _NewsfeedPageState createState() => new _NewsfeedPageState();
}

class _NewsfeedPageState extends State<NewsfeedPage>
    with SingleTickerProviderStateMixin {
  TabController controller;

  @override
  void initState() {
    super.initState();
    controller = new TabController(vsync: this, length: 5);
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  Column buildButtonColumn(IconData icon) {
    Color color = Theme
        .of(context)
        .primaryColor;
    return new Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        new Icon(icon, color: color),
      ],
    );
  }

  void _onLogout() {
    Session s = new Session();
    Future<String> response = s.get(urlendpoint + "Logout");
    response.then((body) {
      print("Logout Body:  " + body);
      bool status = json.decode(body)['status'];
      if (status) {
        Navigator.of(context).pushReplacementNamed(LoginPage.tag);
      }
    });
  }

  void _onRefresh() {
    this.setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Infact"),
          centerTitle: true,
          leading: new IconButton(
              tooltip: 'Refresh',
              icon: const Icon(Icons.autorenew, color: Colors.white),
              onPressed: () {
                _onRefresh();
              }),
          actions: <Widget>[
            new IconButton(
                tooltip: 'Logout',
                icon: const Icon(Icons.exit_to_app, color: Colors.white),
                onPressed: () {
                  _onLogout();
                })
          ],
        ),
        bottomNavigationBar: new Material(
            color: Colors.blue[600],
            child: new TabBar(controller: controller, tabs: <Tab>[
              new Tab(icon: new Icon(Icons.view_headline, size: 30.0)),
              new Tab(icon: new Icon(Icons.create, size: 30.0)),
              new Tab(icon: new Icon(Icons.person_add, size: 30.0)),
              new Tab(icon: new Icon(Icons.explore, size: 30.0)),
              new Tab(icon: new Icon(Icons.bookmark, size: 30.0)),
            ])),
        body: new TabBarView(controller: controller, children: <Widget>[
          new HomeFeedScreen.HomeFeedScreen(),
          new AddPostScreen.AddPostScreen(),
          new ApplyScreen.ApplyScreen(),
          new CategoriesScreen.CategoriesScreen(),
          new BookmarkScreen.BookmarksScreen(),
        ]));
  }
}