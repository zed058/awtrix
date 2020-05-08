import 'dart:convert';
import 'package:awtrix/entity/app.dart';
import 'package:awtrix/utils/config.dart';
import 'package:awtrix/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class AppStore extends StatefulWidget {
  @override
  _AppStoreState createState() => _AppStoreState();
}

class _AppStoreState extends State<AppStore> {
  WebSocketChannel _channel;
  List<App> _appItem = [];

  @override
  void initState() {
    super.initState();
    getApp();
  }

  //wss://awtrix.blueforcer.de/apps/ws
  Future<void> getApp() async {
    _channel = IOWebSocketChannel.connect("wss://awtrix.blueforcer.de/apps/ws");
    _channel.stream.listen((onData) {
      var data = onData.toString();
      var length = data.length;
      if (data.contains("#headline")) {
        data = data.substring(65, length - 3);
        data = removeSomeString(data);
        var document = parse(data);
        var smallTag = document.getElementsByTagName("small");
        var appCount = smallTag[0].innerHtml.toString().substring(1, 3);
        print(appCount);
        setState(() {});
      }
      if (data.contains("#applist")) {
        data = data.substring(64, length - 3);
        data = removeSomeString(data);
        // data = data.replaceAll(RegExp("<img.*\">"), "");
        // print(data);
        var document = parse(data);
        var mediaEle = document.body.getElementsByClassName("media");
        List<App> appList = List();
        for (var item in mediaEle) {
          var app = App();
          var mediaObjectEle = item.getElementsByClassName("media-object")[0];
          var image = mediaObjectEle.attributes['src'];
          app.img = image;
          var titleEle = item.getElementsByClassName("media-heading")[0];
          app.name = titleEle.innerHtml;
          // print(titleEle.innerHtml);
          appList.add(app);
        }
        setState(() {
          _appItem = appList;
        });
      }
    });
    // print(response);
  }

  @override
  Widget build(BuildContext context) {
    if (_appItem == null || _appItem.length == 0) {
      return Center(child: CircularProgressIndicator());
    }
    return ListView.builder(
      itemCount: _appItem.length,
      itemBuilder: (BuildContext ctx, int index) {
        return InkWell(
          onTap: () {},
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.all(16),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Image.memory(
                      base64.decode(
                        _appItem[index].img.split(",")[1],
                      ),
                      height: 64,
                      width: 64,
                      fit: BoxFit.fill,
                    ),
                    Expanded(
                      child: Container(
                        child: Text(
                          _appItem[index].name,
                          style: TextStyle(fontSize: 20),
                        ),
                        margin: EdgeInsets.all(8),
                      ),
                    ),
                    RaisedButton.icon(
                      icon: Icon(Icons.cloud_download),
                      label: Text("下载"),
                      onPressed: () {
                        downloadApp(_appItem[index].name);
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void downloadApp(String name) {
    name = name.split(" ")[0];
    _channel =
        IOWebSocketChannel.connect("ws://${Config.serverIp}:7000/appstore/ws");
    print("app name " + name);
    _channel.sink.add(
        '{"type":"event","event":"appsstore_click","params":{"which":1,"target":"DL$name","pageX":724,"pageY":444,"metaKey":false}}');
  }
}
