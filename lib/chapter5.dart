import 'package:flutter/material.dart';

void main() => runApp(ScffoldApp());

class ScffoldApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    ///构建Materia Desin 风格的应用程序
    return MaterialApp(
      ///Android应用程序中任务栏中显示应用的名称
      title: "scffold application",
      ///默认的首页面
      home: ScaffoldRoute(),
    );
  }
}


class ScaffoldRoute extends StatefulWidget {
  @override
  _ScaffoldRouteState createState() => _ScaffoldRouteState();
}

class _ScaffoldRouteState extends State<ScaffoldRoute> {
  int _selectedIndex = 1;
  int _counter = 1;
  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar( //导航栏
          centerTitle: true,
          title: Text("容器类组件"),
          leading: Builder(builder: (context) {
            return IconButton(
              icon: Icon(Icons.dashboard, color: Colors.white), //自定义图标
              onPressed: () {
                // 打开抽屉菜单
                Scaffold.of(context).openDrawer();
              },
            );
          }),
          actions: <Widget>[ //导航栏右侧菜单
            IconButton(
                icon: Icon(Icons.share),
                onPressed: () {}
            ),
          ],
        ),
        drawer: MyDrawer(), //抽屉
        bottomNavigationBar: BottomNavigationBar( // 底部导航
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home),label:'home'),
            BottomNavigationBarItem(icon: Icon(Icons.business),label:'business'),
            BottomNavigationBarItem(icon: Icon(Icons.school),label:'school'),
          ],
          currentIndex: _selectedIndex,
          fixedColor: Colors.blue,
          onTap: _onItemTapped,
        ),
        floatingActionButton: FloatingActionButton( //悬浮按钮
          onPressed: _incrementCounter,
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ),
        body: Center(
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '变换\n\n',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                color: Colors.black,
                child: Transform(
                  alignment: Alignment.topRight, //相对于坐标系原点的对齐方式
                  transform: Matrix4.skewY(0.3), //沿Y轴倾斜0.3弧度
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    color: Colors.deepOrange,
                    child: const Text('Apartment for rent!'),
                  ),
                ),
              ),
              Text(
                '\n容器组件',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20.0, left: 120.0),
                constraints: BoxConstraints.tightFor(width: 200.0, height: 150.0),//卡片大小
                decoration: BoxDecoration(  //背景装饰
                  gradient: RadialGradient( //背景径向渐变
                    colors: [Colors.red, Colors.orange],
                    center: Alignment.topLeft,
                    radius: .98,
                  ),
                  boxShadow: [
                    //卡片阴影
                    BoxShadow(
                      color: Colors.black54,
                      offset: Offset(2.0, 2.0),
                      blurRadius: 4.0,
                    )
                  ],
                ),
                transform: Matrix4.rotationZ(.2),//卡片倾斜变换
                alignment: Alignment.center, //卡片内文字居中
                child: Text(
                  //卡片文字
                  "5.20", style: TextStyle(color: Colors.white, fontSize: 40.0),
                ),
              ),
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.headline4,
              ),
            ],
          ),
        )
    );
  }
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  void _onAdd(){
  }
}

class MyDrawer extends StatelessWidget {
  const MyDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: MediaQuery.removePadding(
        context: context,
        //移除抽屉菜单顶部默认留白
        removeTop: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 38.0),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ClipOval(
                      child: Image(
                        image: NetworkImage(
                            "https://avatars2.githubusercontent.com/u/20411648?s=460&v=4"),
                        width: 80.0,
                      ),
                    ),
                  ),
                  Text(
                    "Wendux",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            Expanded(
              child: ListView(
                children: <Widget>[
                  ListTile(
                    leading: const Icon(Icons.add),
                    title: const Text('Add account'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.settings),
                    title: const Text('Manage accounts'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}