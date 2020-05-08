import 'dart:async';
import 'package:awtrix/pages/draw.dart';
import 'package:awtrix/utils/config.dart';
import 'package:awtrix/utils/theame.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var dio = Dio();
  int height = 50;
  double maxHeight = 200;
  double minHeight = 20;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                margin: EdgeInsets.all(10.0),
                height: MediaQuery.of(context).size.height * 0.25,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0), color: primary),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      child: Icon(
                        Icons.lightbulb_outline,
                        size: 100,
                        color: Colors.yellow,
                      ),
                      onTap: () => controller('{"power": true}'),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text('屏幕开', style: headlines)
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                margin: EdgeInsets.all(10.0),
                height: MediaQuery.of(context).size.height * 0.25,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0), color: primary),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      child: Icon(
                        Icons.lightbulb_outline,
                        size: 100,
                        color: Colors.grey,
                      ),
                      onTap: () => controller('{"power": false}'),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text('屏幕关', style: headlines)
                  ],
                ),
              ),
            )
          ],
        ),
        Expanded(
          flex: 1,
          child: Container(
            margin: EdgeInsets.all(10.0),
            height: MediaQuery.of(context).size.height * 0.25,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0), color: primary),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("亮度: $height", style: boldNumber),
                ),
                Slider(
                  value: height.toDouble(),
                  min: minHeight,
                  max: maxHeight,
                  activeColor: Colors.orangeAccent,
                  inactiveColor: Colors.black,
                  onChanged: (double newValue) {
                    setState(() {
                      height = newValue.round();
                    });
                    brightness(newValue.round());
                  },
                  semanticFormatterCallback: (double newValue) {
                    return '$newValue.round()';
                  },
                ),
              ],
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                margin: EdgeInsets.all(10.0),
                height: 100,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0), color: primary),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('切换APP', style: headlines),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          height: 40.0,
                          width: 40.0,
                          margin: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Colors.orangeAccent),
                          child: InkWell(
                            onTap: () => controller('{"app":"back"}'),
                            child: Center(
                              child: Icon(Icons.arrow_back_ios),
                            ),
                          ),
                        ),
                        Container(
                          height: 40.0,
                          width: 40.0,
                          margin: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Colors.orangeAccent),
                          child: InkWell(
                            onTap: () => controller('{"app":"next"}'),
                            child: Center(
                              child: Icon(Icons.arrow_forward_ios),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                margin: EdgeInsets.all(10.0),
                height: 100,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0), color: primary),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('动画 / 时间', style: headlines),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          height: 40.0,
                          width: 40.0,
                          margin: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Colors.orangeAccent),
                          child: InkWell(
                            onTap: () =>
                                controller('{"showAnimation":"random"}'),
                            child: Center(
                              child: Icon(Icons.refresh),
                            ),
                          ),
                        ),
                        Container(
                          height: 40.0,
                          width: 40.0,
                          margin: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Colors.orangeAccent),
                          child: InkWell(
                            onTap: () => controller('{"switchTo":"Time"}'),
                            child: Center(
                              child: Icon(Icons.timer),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        InkWell(
          onTap: () => Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => DarwPage(),
            ),
          ),
          child: Container(
            color: primaryButtonColor,
            margin: EdgeInsets.only(top: 10.0),
            height: MediaQuery.of(context).size.height * 0.1,
            child: Center(
              child: Text('定制文字', style: primaryButtonStyle),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> controller(String command) async {
    await dio.post("http://${Config.serverIp}:7000/api/v3/basics",
        data: command, options: Options(contentType: "application/json"));
  }

  Future<void> brightness(int value) async {
    await dio.post("http://${Config.serverIp}:7000/api/v3/settings",
        data: {"Brightness": value},
        options: Options(contentType: "application/json"));
  }
}
