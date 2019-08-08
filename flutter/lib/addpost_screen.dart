import 'dart:async';
import 'dart:convert';
import 'news_feed.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'config.dart';
import 'session.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';

class AddPostScreen extends StatefulWidget {
  AddPostScreen({Key key}) : super(key: key);

  @override
  _AddPostScreenState createState() => new _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autovalidate = false;
  String _title;
  String _text;
  String _tags;
  File sampleImage;

  Future getImage() async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      sampleImage = tempImage;
    });
  }

  @override
  void initState() {
    super.initState();
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

    final heading = new Text('Write your own article !',
                      style: new TextStyle(fontFamily:"VT323",fontSize:32,fontWeight: FontWeight.bold));

    final postTitle = TextFormField(
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value.isEmpty) {
          return 'Title is required';
        } else
          return null;
      },
      onSaved: (String val) {
        _title = val;
      },
      autofocus: false,
      decoration: InputDecoration(
        icon: const Icon(Icons.subject),
        hintText: 'Post Title',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(22.0)),
      ),
    );

    final postText = TextFormField(
      keyboardType: TextInputType.multiline,
      validator: (value) {
        if (value.isEmpty) {
          return 'Body is required';
        } else
          return null;
      },
      onSaved: (String val) {
        _text = val;
      },
      autofocus: false,
      maxLines: 3,
      decoration: InputDecoration(
        icon: const Icon(Icons.description),
        hintText: '\nPost Text',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final postTags = TextFormField(
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value.isEmpty) {
          return 'Tags are required';
        } else
          return null;
      },
      onSaved: (String val) {
        _tags = val;
      },
      autofocus: false,
      decoration: InputDecoration(
        icon: const Icon(Icons.view_headline),
        hintText: 'Post Tags',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    void _validateInputs(BuildContext scaffoldContext) {
      if (_formKey.currentState.validate()) {
        _formKey.currentState.save();
        Options options= new Options(
            baseUrl:urlendpoint,
            connectTimeout:5000,
            receiveTimeout:3000,
            contentType: ContentType.parse("application/x-www-form-urlencoded"));
        Dio dio = new Dio(options);
        FormData formData = new FormData.from({'post-title': _title.trim(), 'post-body': _text, 'values':_tags.trim(),'file-upload':sampleImage});
        Future<Response> response = dio.post("addPost", data:formData);
//        Session s = new Session();
//        Future<String> response = s.post(urlendpoint + "addPost",
//            {'post-title': _title.trim(), 'post-body': _text, 'values':_tags.trim(),"file-upload":sampleImage.toString()});
        response.then((body) {
          bool status = json.decode(body.data)['status'];
          if (status) {
            Navigator.of(context).pushReplacementNamed(NewsfeedPage.tag);
          } else {
            Scaffold.of(scaffoldContext).showSnackBar(SnackBar(
              content: Text('Upload Failed, Try Again'),
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
          borderRadius: BorderRadius.circular(25.0),
          shadowColor: Colors.lightBlueAccent.shade200,
          child: MaterialButton(
            minWidth: 130.0,
            height: 40.0,
            onPressed: () {
              _validateInputs(scaffoldContext);
            },
            color: Colors.lightBlueAccent,
            child: Text('Post', style: TextStyle(color: Colors.white)),
          ),
        ),
      );
    }

    final imageButton = new MaterialButton(
      padding: const EdgeInsets.all(20.0),
      onPressed: getImage,
      minWidth: 130.0,
      height: 20.0,
      child: new Icon(Icons.add_a_photo),
    );

    return new Scaffold(
      backgroundColor: Colors.grey[200],
      resizeToAvoidBottomPadding:false,
      body: new Builder(builder: (BuildContext scaffoldContext) {
          return new Center(
            child: new ListView(
              shrinkWrap: true,
//              mainAxisAlignment: MainAxisAlignment.center,
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
                        postTitle,
                        SizedBox(height: 10.0),
                        postText,
                        SizedBox(height: 10.0),
                        postTags,
                        SizedBox(height: 10.0),
                        imageButton,
                        SizedBox(height: 5.0),
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