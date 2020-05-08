import 'dart:io';

import 'package:awtrix/pages/about.dart';
import 'package:awtrix/pages/app_store.dart';
import 'package:awtrix/pages/home.dart';
import 'package:awtrix/pages/my_apps.dart';
import 'package:awtrix/utils/config.dart';
import 'package:awtrix/utils/theame.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart'
    show debugDefaultTargetPlatformOverride;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void _setTargetPlatformForDesktop() {
  if (Platform.isLinux || Platform.isWindows) {
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  }
}

void main() {
  _setTargetPlatformForDesktop();
  runApp(new MyApp());
  if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle =
        SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AWTRIX',
      debugShowCheckedModeBanner: false,
      home: MyHomePage(title: 'AWTRIX'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Widget> _pageItems = [Home(), MyApps(), AppStore(), About()];
  int _currentIndex = 0;
  void changePage(int index) {
    setState(() {
      _currentIndex = index;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return main();
  }

  Widget main() {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: _pageItems[_currentIndex],
      backgroundColor: secondary,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: secondary),
              accountName: Text("服务器地址"),
              accountEmail: Text('http://${Config.serverIp}'),
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('images/logo.png'),
              ),
            ),
            ListTile(
              title: Text("主页"),
              subtitle: Text("控制你的AWTRIX"),
              onTap: () {
                changePage(0);
              },
            ),
            ListTile(
              title: Text("我的应用"),
              subtitle: Text("您下载的应用"),
              onTap: () {
                changePage(1);
              },
            ),
            ListTile(
              title: Text("应用商店"),
              subtitle: Text("安装新应用"),
              onTap: () {
                changePage(2);
              },
            ),
            ListTile(
              title: Text("设置/关于"),
              onTap: () {
                changePage(3);
              },
            ),
          ],
        ),
      ),
    );
  }
}
