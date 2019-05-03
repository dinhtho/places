import 'package:flutter/material.dart';
import 'package:places/map.dart';


class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body:Map()
     // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}