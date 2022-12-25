import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
        routes: {
          "主题测试": (context) =>ThemeTestRoute(),
          "对话框详解": (context) =>DialogWidget(title: '对话框详解',),
          "/": (context) => MyHomePage(title: '功能型组件'), //注册首页路由
        }
    );
  }
}

class NavBar extends StatelessWidget {
  final String title;
  final Color color; //背景颜色

  NavBar({
    Key? key,
    required this.color,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minHeight: 52,
        minWidth: double.infinity,
      ),
      decoration: BoxDecoration(
        color: color,
        boxShadow: [
          //阴影
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 3),
            blurRadius: 3,
          ),
        ],
      ),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          //根据背景色亮度来确定Title颜色
          color: color.computeLuminance() < 0.5 ? Colors.white : Colors.black,
        ),
      ),
      alignment: Alignment.center,
    );
  }
}
class ThemeTestRoute extends StatefulWidget {
  @override
  _ThemeTestRouteState createState() => _ThemeTestRouteState();
}
class _ThemeTestRouteState extends State<ThemeTestRoute> {
  var _themeColor = Colors.teal; //当前路由主题色

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Theme(
      data: ThemeData(
          primarySwatch: _themeColor, //用于导航栏、FloatingActionButton的背景色等
          iconTheme: IconThemeData(color: _themeColor) //用于Icon颜色
      ),
      child: Scaffold(
        appBar: AppBar(centerTitle:true,title: Text("主题测试")),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //第一行Icon使用主题中的iconTheme
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.favorite),
                  Icon(Icons.airport_shuttle),
                  Text("  颜色跟随主题")
                ]
            ),
            //为第二行Icon自定义颜色（固定为黑色)
            Theme(
              data: themeData.copyWith(
                iconTheme: themeData.iconTheme.copyWith(
                    color: Colors.black
                ),
              ),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.favorite),
                    Icon(Icons.airport_shuttle),
                    Text("  颜色固定黑色")
                  ]
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () =>  //切换主题
            setState(() =>
            _themeColor =
            _themeColor == Colors.teal ? Colors.blue : Colors.teal
            ),
            child: Icon(Icons.palette)
        ),
      ),
    );
  }
}

class DialogWidget extends StatefulWidget {
  const DialogWidget({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<DialogWidget> createState() {
    return DialogState();
  }
}
class DialogState extends State<DialogWidget> {
  //确认弹窗
  void confirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("提示"),
          content: const Text("确定要进行当前操作么？"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("取消"),
            ),
            TextButton(
              child: const Text("确定"),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }

  //列表弹窗
  void listDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text("请选择"),
          children: <Widget>[
            SimpleDialogOption(
              child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 5), child: Text("香蕉")),
              onPressed: () {
                Navigator.pop(context, 1);
              },
            ),
            SimpleDialogOption(
              child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 5), child: Text("大鸭梨")),
              onPressed: () {
                Navigator.pop(context, 2);
              },
            ),
          ],
        );
      },
    );
  }

  //带选择框弹窗
  checkDialog(BuildContext context, bool checked) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("提示"),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text("确定要进行当前操作么？"),
              Row(
                children: <Widget>[
                  const Text("是否删除"),
                  StatefulBuilder(builder: (context, setState) {
                    return Checkbox(
                        value: checked,
                        onChanged: (bool? value) {
                          setState(() {
                            checked = !checked;
                          });
                        });
                  })
                ],
              )
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("取消"),
            ),
            TextButton(
              child: const Text("确定"),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }

  //底部弹窗
  bottomDialog(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return ListView.builder(
              itemCount: 20,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text("${index + 1}"),
                  onTap: () {
                    Navigator.of(context).pop(index);
                  },
                );
              });
        });
  }

  //日历选择窗
  calendarDialog(BuildContext context) {
    var date = DateTime.now();
    showDatePicker(
      context: context,
      initialDate: date,
      firstDate: date,
      lastDate: date.add(const Duration(days: 30)),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool checked = false; //默认不选中
    return Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                child: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text("确认弹窗"),
                ),
                onPressed: () {
                  confirmDialog(context);
                },
              ),
              ElevatedButton(
                child: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text("列表弹窗"),
                ),
                onPressed: () {
                  listDialog(context);
                },
              ),
              ElevatedButton(
                child: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text("带选择框弹窗"),
                ),
                onPressed: () {
                  checkDialog(context, checked);
                },
              ),
              ElevatedButton(
                child: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text("底部弹窗"),
                ),
                onPressed: () {
                  bottomDialog(context);
                },
              ),
              ElevatedButton(
                child: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text("日历选择弹窗"),
                ),
                onPressed: () {
                  calendarDialog(context);
                },
              ),
            ],
          ),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle:true,
        title: Text(widget.title),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //背景为蓝色，则title自动为白色
            NavBar(color: Colors.blue, title: "标题"),
            //背景为白色，则title自动为黑色
            NavBar(color: Colors.white, title: "标题"),
            TextButton(
              child: Text("主题测试"),
              onPressed: () {
                //导航到新路由
                Navigator.pushNamed(
                    context, "主题测试");
              }
            ),
            TextButton(
              child: Text("对话框详解"),
              onPressed: () {
                //导航到新路由
                Navigator.pushNamed(
                    context, "对话框详解");
              }
            ),

          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.

    );
  }
}