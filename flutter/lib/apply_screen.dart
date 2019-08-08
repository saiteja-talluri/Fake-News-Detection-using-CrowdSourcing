import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'config.dart';
import 'session.dart';
import 'package:flutter/cupertino.dart';
import 'package:timeago/timeago.dart';

class ApplyScreen extends StatefulWidget {
  ApplyScreen({Key key}) : super(key: key);

  @override
  _ApplyScreenState createState() => new _ApplyScreenState();
}

class _ApplyScreenState extends State<ApplyScreen> {

  var isVolunteer = false;
  var isApplication = false;
  var isLoading = true;
  TimeAgo ta = new TimeAgo();
  var postData=[];
  String _sop;
  String _tags;


  Future getVal() async {
    Session s = new Session();
    var volunteersData = await s.get(urlendpoint + "getVolunteer");
    Map<String,dynamic> volunteers = json.decode(volunteersData);
    print("Volunteers :  " + volunteers.toString());

    if(this.mounted) {
      this.setState(() {
        isVolunteer = volunteers["isVolunteer"];
        isLoading = false;
        if(!isVolunteer)
          isApplication = volunteers["isApplication"];
        postData=[volunteers];
      });
    }
    return "Success!";
  }

  _hasArticle(article) {
    return false;
  }

  pushArticle(article) {

  }

  _onBookmarkTap(article) {


    Scaffold.of(context).showSnackBar(new SnackBar(
      content: new Text('Article removed'),
      backgroundColor: Colors.grey[600],
    ));



    Scaffold.of(context).showSnackBar(new SnackBar(
      content: new Text('Article saved'),
      backgroundColor: Colors.grey[600],
    ));
    pushArticle(article);

    this.getVal();
  }

  _onLikeTap(article) {

  }

  @override
  void initState() {
    super.initState();
    this.getVal();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autovalidate = false;
  List _selectedCategorys = List();
  List<String> _categories = <String>['','Technology', 'Movies', 'Sports', 'Art', 'Politics', 'Life Style', 'Bussiness', 'Crime', 'Mythology','International'];

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

  void _onCategorySelected(bool selected, index) {
    if (selected == true) {
      setState(() {
        _selectedCategorys.add(index);
      });
    } else {
      setState(() {
        _selectedCategorys.remove(index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    final heading = new Text('Volunteer Application',
        style: new TextStyle(fontFamily:"VT323",fontSize:32,fontWeight: FontWeight.bold));

    final sop = TextFormField(
      keyboardType: TextInputType.multiline,
      validator: (value) {
        if (value.isEmpty) {
          return 'SOP is required';
        } else
          return null;
      },
      onSaved: (String val) {
        _sop = val;
      },
      autofocus: false,
      maxLines: 4,
      decoration: InputDecoration(
        icon: const Icon(Icons.description),
        hintText: '\nStatement of Purpose',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(22.0)),
      ),
    );

    final postTags = TextFormField(
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value.isEmpty) {
          return 'Expertise Tags are required';
        } else
          return null;
      },
      onSaved: (String val) {
        _tags = val;
      },
      autofocus: false,
      decoration: InputDecoration(
        icon: const Icon(Icons.view_headline),
        hintText: 'Expertise Tags',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );


    void _validateInputs(BuildContext scaffoldContext) {
      if (_formKey.currentState.validate()) {
        _formKey.currentState.save();
        Session s = new Session();
        Future<String> response = s.post(urlendpoint + "volunteer_add_application",
            {'sop': _sop.trim(),'tags':_tags.trim()});
        response.then((body) {
          bool status = true; //json.decode(body)['status'];
          if (status) {
            this.setState(() {
              this.getVal();
            });
          }
          else {
            Scaffold.of(scaffoldContext).showSnackBar(SnackBar(
              content: Text('Submit Failed, Try Again'),
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
            minWidth: 130.0,
            height: 40.0,
            onPressed: () {
              _validateInputs(scaffoldContext);
            },
            color: Colors.lightBlueAccent,
            child: Text('Apply', style: TextStyle(color: Colors.white)),
          ),
        ),
      );
    }

    final beforeApplying = new Builder(builder: (BuildContext scaffoldContext) {
      return new Center(
        child: new ListView(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Container(
              padding: const EdgeInsets.all(40.0),
              child: new Form(
                key: _formKey,
                autovalidate: _autovalidate,
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    heading,
                    SizedBox(height: 50.0),
                    sop,
                    SizedBox(height: 10.0),
                    postTags,
                    SizedBox(height: 10.0),
                    loginButton(scaffoldContext),
                  ],
                ),
              ),
            )
          ],
        ),
      );
    });


    final afterApplying = new Builder(builder: (BuildContext scaffoldContext) {
      return new Center(
        child: new ListView(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Container(
              padding: const EdgeInsets.all(40.0),
              child: new Text('You already applied for the post of volunteer and the admins are looking into it.',
                style: new TextStyle(fontFamily:"VT323",fontSize:20,fontStyle:FontStyle.italic)),
            )
          ]
        )
      );
    });


    final afterBecoming = new Builder(builder: (BuildContext scaffoldContext) {
      return new ListView(children: <Widget>[
        new Expanded(
          child: postData[0]["post_available"]
              ? new ListView.builder(
            itemCount: !postData[0]["post_available"] ? 0 : 1,
            padding: new EdgeInsets.all(8.0),
            itemBuilder: (BuildContext context, int index) {
              return new Card(
                elevation: 1.7,
                child: new Padding(
                  padding: new EdgeInsets.all(10.0),
                  child: new ListView(
                    children: [
                      new Row(
                        children: <Widget>[
                          new Padding(
                            padding: new EdgeInsets.only(left: 4.0),
                            child: new Text(
                              timeAgo(DateTime.parse(postData[index]["created_timestamp"])),
                              style: new TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                          new Padding(
                            padding: new EdgeInsets.all(5.0),
                            child: new Text(
                              postData[index]["author_name"],
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
                                      postData[index]["title"],
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
                                      postData[index]["body"],
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
                          new ListView(
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
                                    urlendpoint + "getPostImage?post_id=" + postData[index]["post_id"].toString(),
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
                                        child: buildButtonColumn(
                                            Icons.favorite_border)),
                                    onTap: () {
                                      _onLikeTap(postData[index]);
                                    },
                                  ),
                                  new GestureDetector(
                                    child: new Padding(
                                        padding:
                                        new EdgeInsets.all(5.0),
                                        child: _hasArticle(
                                            postData[index])
                                            ? buildButtonColumn(
                                            Icons.bookmark)
                                            : buildButtonColumn(Icons
                                            .bookmark_border)),
                                    onTap: () {
                                      _onBookmarkTap(postData[index]);
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
                  child: new ListView(
                    shrinkWrap: true,
//                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      new Icon(Icons.chrome_reader_mode,
                          color: Colors.grey, size: 60.0),
                      new Text(
                        "No articles to verify",
                        style: new TextStyle(
                            fontSize: 24.0, color: Colors.grey),
                      ),
                    ],
                  ),
              ),
            )
          ]
        );
      }
    );

    final loading = new Builder(builder: (BuildContext scaffoldContext) {
      return const Center(child: const CircularProgressIndicator());
    });

    Builder getBody(){
      if(isLoading){
        return loading;
      }
      else if(!isVolunteer && !isApplication){
        return beforeApplying;
      }
      else if(!isVolunteer){
        return afterApplying;
      }
      else{
        return afterBecoming;
      }
    }


    return new Scaffold(
        backgroundColor: Colors.grey[200],
        resizeToAvoidBottomPadding:false,
        body:getBody()
    );
  }
}

