import 'package:flutter/material.dart';

class About extends StatefulWidget {
  About({Key key}) : super(key: key);

  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListView(
        children: <Widget>[
          ListTile(
            title: Text("作者"),
            subtitle: Text("微信: zed058"),
          ),
          ListTile(
            title: Text("联系方式"),
            subtitle: Text("877058128@qq.com"),
          ),
          ListTile(
            title: Text("版本"),
            subtitle: Text("1.0.0"),
          ),
        ],
      ),
    );
  }
}
