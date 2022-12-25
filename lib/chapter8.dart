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
      routes:{
        "拖动与滑动":(context) => _Drag(),
        "自定义通知":(context) => NotificationRoute(),
      } ,
      home: MyHomePage(title: '事件处理与通知'),
    );
  }
}

class _Drag extends StatefulWidget {
  @override
  _DragState createState() => _DragState();
}
class _DragState extends State<_Drag> with SingleTickerProviderStateMixin {
  double _top = 0.0; //距顶部的偏移
  double _left = 0.0;//距左边的偏移

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        centerTitle: true,
        title: Text("拖动与滑动"),
    ),
      body:Stack(
      children: <Widget>[
        Positioned(
          top: _top,
          left: _left,
          child: GestureDetector(
            child: CircleAvatar(child: Text("A")),
            //手指按下时会触发此回调
            onPanDown: (DragDownDetails e) {
              //打印手指按下的位置(相对于屏幕)
              print("用户手指按下：${e.globalPosition}");
            },
            //手指滑动时会触发此回调
            onPanUpdate: (DragUpdateDetails e) {
              //用户手指滑动时，更新偏移，重新构建
              setState(() {
                _left += e.delta.dx;
                _top += e.delta.dy;
              });
            },
            onPanEnd: (DragEndDetails e){
              //打印滑动结束时在x、y轴上的速度
              print(e.velocity);
            },
          ),
        )
      ],
    ));
  }
}

class NotificationRoute extends StatefulWidget {
  @override
  NotificationRouteState createState() {
    return NotificationRouteState();
  }
}
class NotificationRouteState extends State<NotificationRoute> {
  String _msg="";
  @override
  Widget build(BuildContext context) {
    //监听通知
    return Scaffold(
        appBar: AppBar(
         centerTitle: true,
         title: Text("自定义通知"),
    ),
     body:NotificationListener<MyNotification>(
      onNotification: (notification) {
        setState(() {
          _msg+=notification.msg+"  ";
        });
        return true;
      },
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
//           ElevatedButton(
//           onPressed: () => MyNotification("Hi").dispatch(context),
//           child: Text("Send Notification"),
//          ),
            Builder(
              builder: (context) {
                return ElevatedButton(
                  //按钮点击时分发通知
                  onPressed: () => MyNotification("Hi").dispatch(context),
                  child: Text("Send Notification"),
                );
              },
            ),
            Text(_msg)
          ],
        ),
      ),
    ));
  }
}
class MyNotification extends Notification {
  MyNotification(this.msg);
  final String msg;
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
        centerTitle: true,
        title:Text(widget.title),
      ),
      body: Center(
          child: Column(
            children: <Widget>[
              TextButton(
                child: Text("拖动、滑动",style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                ),),
                onPressed: () {
                  //导航到新路由
                  Navigator.pushNamed(context, "拖动与滑动");
                },
              ),
              TextButton(
                child: Text("自定义通知",style:TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                ),),
                onPressed: () {
                  //导航到新路由
                  Navigator.pushNamed(context, "自定义通知");
                },
              ),
            ],
          )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}