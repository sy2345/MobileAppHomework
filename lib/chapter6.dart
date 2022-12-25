import 'package:flutter/material.dart';
import 'dart:ui';

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
          "SingleChildScrollView_demo": (context) =>SingleChildScrollViewTestRoute(),
          "ScrollNotificationTestRoute_demo": (context) =>ScrollNotificationTestRoute(),
          "AnimatedListRoute_demo": (context) => AnimatedListRoute(),
          "TabbarView_demo": (context) => TabBarViewComponent(title:"TabbarView"),
          "/": (context) => MyHomePage(title: '可滚动组件'), //注册首页路由
        });
  }
}

class SingleChildScrollViewTestRoute extends StatelessWidget {
  String str = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("SingleChildScrollView_demo"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
                child: SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  ///动态创建一个List<Widget>
                  children: str
                      .split("")
                      //每一个字母都用一个Text显示,字体为原来的两倍
                      .map((c) => Text(
                            c,
                            textScaleFactor: 2.0,
                          ))
                      .toList(),
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }
}

class ScrollNotificationTestRoute extends StatefulWidget {
  @override
  _ScrollNotificationTestRouteState createState() =>
      _ScrollNotificationTestRouteState();
}

class _ScrollNotificationTestRouteState
    extends State<ScrollNotificationTestRoute> {
  String _progress = "0%"; //保存进度百分比

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("ScrollNotificationTestRoute_demo"),
        ),
        body: Center(
          child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification notification) {
              double progress = notification.metrics.pixels /
                  notification.metrics.maxScrollExtent;
              //重新构建
              setState(() {
                _progress = "${(progress * 100).toInt()}%";
              });
              print("BottomEdge: ${notification.metrics.extentAfter == 0}");
              return false;
              //return true; //放开此行注释后，进度条将失效
            },
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                ListView.builder(
                  itemCount: 100,
                  itemExtent: 50.0,
                  itemBuilder: (context, index) =>
                      ListTile(title: Text("$index")),
                ),
                CircleAvatar(
                  //显示进度百分比
                  radius: 30.0,
                  child: Text(_progress),
                  backgroundColor: Colors.black54,
                )
              ],
            ),
          ),
        ));
  }
}

class AnimatedListRoute extends StatefulWidget {
  const AnimatedListRoute({Key? key}) : super(key: key);

  @override
  _AnimatedListRouteState createState() => _AnimatedListRouteState();
}

class _AnimatedListRouteState extends State<AnimatedListRoute> {
  var data = <String>[];
  int counter = 5;

  final globalKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    for (var i = 0; i < counter; i++) {
      data.add('${i + 1}');
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        centerTitle: true,
        title: Text("AnimatedListRoute_demo"),
       ),
    body:Stack(
      children: [
        AnimatedList(
          key: globalKey,
          initialItemCount: data.length,
          itemBuilder: (
              BuildContext context,
              int index,
              Animation<double> animation,
              ) {
            //添加列表项时会执行渐显动画
            return FadeTransition(
              opacity: animation,
              child: buildItem(context, index),
            );
          },
        ),
        buildAddBtn(),
      ],
    ));
  }

  // 创建一个 “+” 按钮，点击后会向列表中插入一项
  Widget buildAddBtn() {
    return Positioned(
      child: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          // 添加一个列表项
          data.add('${++counter}');
          // 告诉列表项有新添加的列表项
          globalKey.currentState!.insertItem(data.length - 1);
          print('添加 $counter');
        },
      ),
      bottom: 30,
      left: 0,
      right: 0,
    );
  }

  // 构建列表项
  Widget buildItem(context, index) {
    String char = data[index];
    return ListTile(
      //数字不会重复，所以作为Key
      key: ValueKey(char),
      title: Text(char),
      trailing: IconButton(
        icon: Icon(Icons.delete),
        // 点击时删除
        onPressed: () => onDelete(context, index),
      ),
    );
  }

  void onDelete(context, index) {
    // 待实现
    setState(() {
      globalKey.currentState!.removeItem(
        index,
            (context, animation) {
          // 删除过程执行的是反向动画，animation.value 会从1变为0
          var item = buildItem(context, index);
          print('删除 ${data[index]}');
          data.removeAt(index);
          // 删除动画是一个合成动画：渐隐 + 缩小列表项告诉
          return FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              //让透明度变化的更快一些
              curve: const Interval(0.5, 1.0),
            ),
            // 不断缩小列表项的高度
            child: SizeTransition(
              sizeFactor: animation,
              axisAlignment: 0.0,
              child: item,
            ),
          );
        },
        duration: Duration(milliseconds: 200), // 动画时间为 200 ms
      );
    });
  }
}

class TabBarViewComponent extends StatefulWidget {
  const TabBarViewComponent({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<TabBarViewComponent> createState() {
    return TabBarViewState();
  }
}

class TabBarViewState extends State<TabBarViewComponent>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  List tabs = ["热门", "推荐", "图片", "科技", "手机"];

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
        bottom: TabBar(
          controller: tabController,
          tabs: tabs.map((e) => Tab(text: e)).toList(),
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: tabs.map((e) {
          return AutomaticKeepAlive(
            child: Container(
              alignment: Alignment.center,
              child: Text(e, textScaleFactor: 5),
            ),
          );
        }).toList(),
      ),
    );
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
        centerTitle: true,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(
              child: Text("SingleChildScrollView_demo"),
              onPressed: () {
                //导航到新路由
                Navigator.pushNamed(context, "SingleChildScrollView_demo");
              },
            ),
            TextButton(
              child: Text("滚动监听及控制"),
              onPressed: () {
                //导航到新路由
                Navigator.pushNamed(
                    context, "ScrollNotificationTestRoute_demo");
              },
            ),
            TextButton(
              child: Text("AnimatedListRoute"),
              onPressed: () {
                //导航到新路由
                Navigator.pushNamed(context, "AnimatedListRoute_demo");
              },
            ),
            TextButton(
              child: Text("TabbarView"),
              onPressed: () {
                //导航到新路由
                Navigator.pushNamed(
                    context, "TabbarView_demo");
              },
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
