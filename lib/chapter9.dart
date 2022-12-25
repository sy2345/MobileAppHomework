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
        "Hero动画":(context) => HeroAnimationRouteA(),
        "交织动画":(context) => StaggerRoute(),
      } ,
      home: MyHomePage(title: '动画'),
    );
  }
}

class HeroAnimationRouteA extends StatelessWidget {
  const HeroAnimationRouteA({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Hero动画"),
        ),
        body:Container(
           alignment: Alignment.topCenter,
             child: Column(
                 children: <Widget>[
                   InkWell(
                      child: Hero(
                        tag: "avatar", //唯一标记，前后两个路由页Hero的tag必须相同
                        child: ClipOval(
                          child: Image(image: NetworkImage("https://avatars2.githubusercontent.com/u/20411648?s=460&v=4"),
                            width: 50.0,
                          ),
                        ),
                      ),
                          onTap: () {
                         //打开B路由
                        Navigator.push(context, PageRouteBuilder(
                        pageBuilder: (
                            BuildContext context,
                            animation,
                            secondaryAnimation,
                            ) {
                          return FadeTransition(
                            opacity: animation,
                            child: Scaffold(
                              appBar: AppBar(
                                title: const Text("原图"),
                              ),
                              body: HeroAnimationRouteB(),
                            ),
                          );
                        },
                      ));
                    },
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text("点击头像"),
          )
        ],
      ),
    ));
  }
}
class HeroAnimationRouteB extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:Center(
            child: Hero(
              tag: "avatar", //唯一标记，前后两个路由页Hero的tag必须相同
              child: Image(image: NetworkImage("https://avatars2.githubusercontent.com/u/20411648?s=460&v=4")),
      ),
    ));
  }
}

class StaggerAnimation extends StatelessWidget {
  StaggerAnimation({
    Key? key,
    required this.controller,
  }) : super(key: key) {
    //高度动画
    height = Tween<double>(
      begin: .0,
      end: 300.0,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(
          0.0, 0.6, //间隔，前60%的动画时间
          curve: Curves.ease,
        ),
      ),
    );

    color = ColorTween(
      begin: Colors.green,
      end: Colors.red,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(
          0.0, 0.6, //间隔，前60%的动画时间
          curve: Curves.ease,
        ),
      ),
    );

    padding = Tween<EdgeInsets>(
      begin: const EdgeInsets.only(left: .0),
      end: const EdgeInsets.only(left: 100.0),
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(
          0.6, 1.0, //间隔，后40%的动画时间
          curve: Curves.ease,
        ),
      ),
    );
  }

  late final Animation<double> controller;
  late final Animation<double> height;
  late final Animation<EdgeInsets> padding;
  late final Animation<Color?> color;

  Widget _buildAnimation(BuildContext context, child) {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: padding.value,
      child: Container(
        color: color.value,
        width: 50.0,
        height: height.value,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      builder: _buildAnimation,
      animation: controller,
    );
  }
}
class StaggerRoute extends StatefulWidget {
  @override
  _StaggerRouteState createState() => _StaggerRouteState();
}
class _StaggerRouteState extends State<StaggerRoute>with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
  }

  _playAnimation() async {
    try {
      //先正向执行动画
      await _controller.forward().orCancel;
      //再反向执行动画
      await _controller.reverse().orCancel;
    } on TickerCanceled {
      // the animation got canceled, probably because we were disposed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("交织动画"),
        ),
        body: Center(
          child: Column(
             children: [
             ElevatedButton(
                onPressed: () => _playAnimation(),
                child: Text("start animation"),
          ),
            Container(
              width: 300.0,
              height: 300.0,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.1),
                border: Border.all(
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
            //调用我们定义的交错动画Widget
             child: StaggerAnimation(controller: _controller),
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
        centerTitle: true,
        title:Text(widget.title),
      ),
      body: Center(
          child: Column(
            children: <Widget>[
              TextButton(
                child: Text("Hero动画",style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                ),),
                onPressed: () {
                  //导航到新路由
                  Navigator.pushNamed(context, "Hero动画");
                },
              ),
              TextButton(
                child: Text("交织动画",style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                ),),
                onPressed: () {
                  //导航到新路由
                  Navigator.pushNamed(context, "交织动画");
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