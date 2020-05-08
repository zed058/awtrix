import 'package:awtrix/utils/config.dart';
import 'package:awtrix/utils/theame.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class DarwPage extends StatefulWidget {
  @override
  _DarwPageState createState() => _DarwPageState();
}

class _DarwPageState extends State<DarwPage> {
  // 初始化为黑色

  var colorArray = List<Color>.filled(64, Colors.black);
  var _currentColor = Colors.white;
  var _waitTimeController = TextEditingController();
  var _strTimeController = TextEditingController();
  FocusNode _contentFocusNode = FocusNode();

  var dio = Dio();
  @override
  void initState() {
    super.initState();
    _waitTimeController.text = "3000";
  }

  void changeColor(Color color, int index) {
    setState(() {
      colorArray[index] = color;
      _currentColor = color;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("定制图像文字"),
        backgroundColor: secondary,
      ),
      backgroundColor: primary,
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              margin: EdgeInsets.all(12),
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.white,
              ),
              child: ListView(
                children: <Widget>[
                  TextField(
                    keyboardType: TextInputType.number,
                    controller: _waitTimeController,
                    autofocus: false,
                    decoration: InputDecoration(
                      labelText: "显示时长(必填)",
                      hintText: "单位毫秒",
                    ),
                  ),
                  TextField(
                    controller: _strTimeController,
                    focusNode: _contentFocusNode,
                    autofocus: false,
                    decoration: InputDecoration(
                      labelText: "显示文字(选填)",
                      hintText: "只支持数字和英文，且最长为5",
                    ),
                  ),
                  SizedBox(height: 16),
                  Center(
                    child: Container(
                      height: 320,
                      width: 320,
                      child: GridView.custom(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 8, //横轴三个子widget
                          childAspectRatio: 1.0, //宽高比为1时，子widget
                        ),
                        childrenDelegate: SliverChildListDelegate(
                          List.generate(
                            64,
                            (index) {
                              return RaisedButton(
                                color: colorArray[index],
                                onPressed: () {
                                  changeColor(_currentColor, index);
                                },
                                onLongPress: () {
                                  changeColorFun(context, index);
                                  _contentFocusNode.unfocus();
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () => sendMessage(),
            child: Container(
              color: primaryButtonColor,
              margin: EdgeInsets.only(top: 10.0),
              height: MediaQuery.of(context).size.height * 0.1,
              child: Center(
                child: Text('发送图像文字', style: primaryButtonStyle),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void changeColorFun(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            height: 400,
            child: ColorPicker(
              pickerColor: colorArray[index],
              onColorChanged: (color) {
                changeColor(color, index);
              },
              enableLabel: true,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
        );
      },
    );
  }

  void sendMessage() {
    var drawJson = '{"repeat":2,"draw": [';
    for (int i = 0; i < colorArray.length; i++) {
      Color color = colorArray[i];
      if (color != Colors.black) {
        // 记录位置
        var postion1 = i ~/ 8;
        var postion2 = i % 8;
        int red = color.red;
        int green = color.green;
        int blue = color.blue;
        drawJson +=
            '{"type": "pixel","position": [$postion2,$postion1],"color": [$red,$green,$blue]},';
      }
    }
    if (_strTimeController.text.isNotEmpty) {
      drawJson +=
          '{"type": "text","string": "${_strTimeController.text}","position": [11,2],"color": [255,0,0]},';
    }
    drawJson +=
        '{"type": "show"},{"type": "wait","ms": ${_waitTimeController.text}},{"type": "exit"}]}';
    dio.post("http://${Config.serverIp}:7000/api/v3/draw",
        options: Options(contentType: "application/json"), data: drawJson);
  }
}
