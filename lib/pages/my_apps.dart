import 'dart:convert';

import 'package:awtrix/entity/app.dart';
import 'package:awtrix/utils/config.dart';
import 'package:awtrix/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class MyApps extends StatefulWidget {
  @override
  _MyAppsState createState() => _MyAppsState();
}

class _MyAppsState extends State<MyApps> {
  WebSocketChannel _channel;
  List<App> _apps = [];

  @override
  void initState() {
    super.initState();
    getHomeHtml();
  }

  void getHomeHtml() {
    List<App> appList = List();
    _channel =
        IOWebSocketChannel.connect("ws://${Config.serverIp}:7000/myapps/ws");
    var stream = _channel.stream;
    stream.listen((onData) {
      if (onData.toString().contains("#appsdiv")) {
        var size = onData.toString().length;
        var data = onData.toString().substring(63, size - 4);
        data = removeSomeString(data);
        var document = parse(data);
        var body = document.getElementsByClassName("media-left");

        for (var item in body) {
          var app = App();
          var name = item.attributes['id'];

          for (var child in item.children) {
            if (child.attributes.containsKey('src')) {
              app.name = name;
              app.img = child.attributes['src'];
              appList.add(app);
              break;
            }
          }
        }
      }
      setState(() {
        _apps = appList;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_apps == null || _apps.length == 0) {
      return Center(child: CircularProgressIndicator());
    }
    return ListView.builder(
      itemCount: _apps.length,
      itemBuilder: (BuildContext ctx, int index) {
        return InkWell(
          onTap: () {},
          child: Container(
            padding: EdgeInsets.all(8),
            color: Colors.white,
            child: Row(
              children: <Widget>[
                Image.memory(
                  base64.decode(
                    _apps[index].img.split(",")[1],
                  ),
                  height: 64,
                  width: 64,
                  fit: BoxFit.fill,
                ),
                Expanded(
                  child: Container(
                    child: Text(
                      _apps[index].name,
                      style: TextStyle(fontSize: 20),
                    ),
                    margin: EdgeInsets.all(8),
                  ),
                ),
                Row(
                  children: <Widget>[
                    RaisedButton.icon(
                      icon: Icon(
                        Icons.delete_outline,
                        color: Colors.white,
                      ),
                      color: Colors.red,
                      label: Text(
                        "删除",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        print("disable");
                      },
                    ),
                  ],
                ),
                Divider()
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _channel.sink.close();
  }

  void disable(String message) {
    print("message =>" + message);
    _channel.sink.add(
        '''{"type":"event","event":"appsdiv_click","params":{"which":1,"target":"Disable$message","pageX":690,"pageY":228,"metaKey":false}}''');
  }
}
