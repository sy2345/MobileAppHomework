import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blueGrey,
      ),
      home: const MyHomePage(title: 'flutter的冒险之旅'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
   //定义controller
  TextEditingController _unameController = TextEditingController();
  TextEditingController _pwdController = TextEditingController();
  GlobalKey _formKey = GlobalKey<FormState>();

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
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              '20191060099 宋颖',
              style: TextStyle(
                color: Colors.red,
                fontSize: 25.0,
                height:2,
                fontWeight: FontWeight.bold,
                fontFamily: "Helvetica",
              ),
            ),
            Text(
              'You have pushed the button this many times:\n',
              style: TextStyle(
                fontSize: 18.0,
                height:2,
                fontFamily: "New Roman",
              ),
            ),
            Image(
              image: NetworkImage(
                  "https://avatars2.githubusercontent.com/u/20411648?s=460&v=4"),
              width: 100.0,
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            TextFormField(
              autofocus: true,
              controller: _unameController,
              decoration: InputDecoration(
                labelText: "用户名",
                hintText: "用户名或邮箱",
                icon: Icon(Icons.person),
              ),
              // 校验用户名
              validator: (v) {
                return v!.trim().isNotEmpty ? null : "用户名不能为空";
              },
            ),
            TextFormField(
              controller: _pwdController,
              decoration: InputDecoration(
                labelText: "密码",
                hintText: "您的登录密码",
                icon: Icon(Icons.lock),
              ),
              obscureText: true,
              //校验密码
              validator: (v) {
                return v!.trim().length > 5 ? null : "密码不能少于6位";
              },
            ),
            // 登录按钮
            Padding(
              padding: const EdgeInsets.only(top: 28.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: ElevatedButton(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text("登录"),
                      ),
                      onPressed: () {
                        // 通过_formKey.currentState 获取FormState后，
                        // 调用validate()方法校验用户名密码是否合法，校验
                        // 通过后再提交数据。
                        if ((_formKey.currentState as FormState).validate()) {
                          //验证通过提交数据
                        }
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}