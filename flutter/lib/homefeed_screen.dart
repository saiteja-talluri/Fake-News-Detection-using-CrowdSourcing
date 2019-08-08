import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:timeago/timeago.dart';
import 'config.dart';
import 'session.dart';

class HomeFeedScreen extends StatefulWidget {
  HomeFeedScreen({Key key}) : super(key: key);

  @override
  _HomeFeedScreenState createState() => new _HomeFeedScreenState();
}

class _HomeFeedScreenState extends State<HomeFeedScreen> {

  var data;
  var limit = 10
  ;
  TimeAgo ta = new TimeAgo();

  final TextEditingController _controller = new TextEditingController();

  Future getData() async {
    Session s = new Session();
    var articlesData = await s.post(urlendpoint + "getPosts", {"limit": limit.toString()});
    Map<String,dynamic> articles = json.decode(articlesData);
    print("Articles :  " + articles["data"].toString());

    if(this.mounted) {
      this.setState(() {
        data = articles["data"];
      });
    }
    return "Success!";
  }

  _hasArticle(id, article) {
    return false;
  }

  pushArticle(article) {
//    Session s = new Session();
//    var articlesData = await s.post(urlendpoint + "", {"limit": limit.toString()});

  }

  _onBookmarkTap(id,article) {


      Scaffold.of(context).showSnackBar(new SnackBar(
        content: new Text('Article removed'),
        backgroundColor: Colors.grey[600],
      ));



      Scaffold.of(context).showSnackBar(new SnackBar(
        content: new Text('Article saved'),
        backgroundColor: Colors.grey[600],
      ));
      pushArticle(article);

      this.getData();
  }

  _onLikeTap(article) {

  }

  void handleTextInputSubmit(var input) {
    if (input != '') {

    }
  }

  @override
  void initState() {
    super.initState();
    this.getData();
  }

  Column buildButtonColumn(IconData icon) {
    Color color = Theme.of(context).primaryColor;
    return new Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        new Icon(icon, color: color),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.grey[200],
      body: new Column(children: <Widget>[
        new Padding(
          padding: new EdgeInsets.all(0.0),
          child: new PhysicalModel(
            color: Colors.white,
            elevation: 3.0,
            child: new TextField(
              controller: _controller,
              onSubmitted: handleTextInputSubmit,
              decoration: new InputDecoration(
                  hintText: 'Finding an Article?', icon: new Icon(Icons.search)),
            ),
          ),
        ),
        new Expanded(
          child: data == null
              ? const Center(child: const CircularProgressIndicator())
              : data.length != 0
              ? new ListView.builder(
            itemCount: data == null ? 0 : data.length,
            padding: new EdgeInsets.all(8.0),
            itemBuilder: (BuildContext context, int index) {
              return new Card(
                elevation: 1.7,
                child: new Padding(
                  padding: new EdgeInsets.all(10.0),
                  child: new Column(
                    children: [
                      new Row(
                        children: <Widget>[
                          new Padding(
                            padding: new EdgeInsets.only(left: 4.0),
                            child: new Text(
                              timeAgo(DateTime.parse(data[index]["created_timestamp"])),
                              style: new TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                          new Padding(
                            padding: new EdgeInsets.all(5.0),
                            child: new Text(
                              data[index]["author_name"],
                              style: new TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[700],
                              ),
                            ),
                          ),
                        ],
                      ),
                      new Row(
                        children: [
                          new Expanded(
                            child: new GestureDetector(
                              child: new Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  new Padding(
                                    padding: new EdgeInsets.only(
                                        left: 4.0,
                                        right: 8.0,
                                        bottom: 8.0,
                                        top: 8.0),
                                    child: new Text(
                                      data[index]["title"],
                                      style: new TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  new Padding(
                                    padding: new EdgeInsets.only(
                                        left: 4.0,
                                        right: 4.0,
                                        bottom: 4.0),
                                    child: new Text(
                                      data[index]["body"],
                                      style: new TextStyle(
                                        color: Colors.grey[500],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () {

                              },
                            ),
                          ),
                          new Column(
                            children: <Widget>[
                              new Padding(
                                padding:
                                new EdgeInsets.only(top: 8.0),
                                child: new SizedBox(
                                  height: 100.0,
                                  width: 100.0,
                                  child:
//                                  new Image.asset("assets/icon/icon.jpg"),
                                  new Image.network(
                                    urlendpoint + "getPostImage?post_id=" + data[index]["post_id"].toString(),
                                    headers: {
                                      "Content-Type": "image/jpg"
                                    },
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              new Row(
                                children: <Widget>[
                                  new GestureDetector(
                                    child: new Padding(
                                        padding:
                                        new EdgeInsets.all(5.0),
                                        child: _hasArticle(1,
                                        data[index])
                                        ? buildButtonColumn(
                                        Icons.favorite)
                                            : buildButtonColumn(Icons.favorite_border)),
                                    onTap: () {
                                      _onLikeTap(data[index]);
                                    },
                                  ),
                                  new GestureDetector(
                                    child: new Padding(
                                        padding:
                                        new EdgeInsets.all(5.0),
                                        child: _hasArticle(2,
                                            data[index])
                                            ? buildButtonColumn(
                                            Icons.bookmark)
                                            : buildButtonColumn(Icons
                                            .bookmark_border)),
                                    onTap: () {
                                      _onBookmarkTap(index,data[index]);
                                    },
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      )
                    ],
                  ), ////
                ),
              );
            },
          )
              : new Center(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                new Icon(Icons.chrome_reader_mode,
                    color: Colors.grey, size: 60.0),
                new Text(
                  "No articles saved",
                  style: new TextStyle(
                      fontSize: 24.0, color: Colors.grey),
                ),
              ],
            ),
          ),
        )
      ]),
    );
  }
}
