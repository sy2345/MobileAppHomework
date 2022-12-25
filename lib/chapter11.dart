import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:dio/dio.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes:{
        "通过HttpClient发起HTTP请求":(context) => HttpTestRoute(),
        "使用WebSockets":(context) => WebSocketRoute(),
        "通过dio发起请求":(context) => FutureBuilderRoute(),
      } ,
      home:MyHomePage(title:'文件操作与网络请求'),
    );
  }
}

class HttpTestRoute extends StatefulWidget {
  @override
  _HttpTestRouteState createState() => _HttpTestRouteState();
}
class _HttpTestRouteState extends State<HttpTestRoute> {
  bool _loading = false;
  String _text = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("通过HttpClient发起HTTP请求"),
        ),
        body:SingleChildScrollView(
         child: Column(
          children: <Widget>[
          ElevatedButton(
            child: Text("从github中获取城市信息"),
            onPressed: _loading ? null : request,
          ),
          Container(
            width: MediaQuery.of(context).size.width - 50.0,
            child: Text(_text.replaceAll(RegExp(r"\s"), "")),
          )
        ],
      ),
    ));
  }

  request() async {
    setState(() {
      _loading = true;
      _text = "正在请求...";
    });
    try {
      //创建一个HttpClient
      HttpClient httpClient = HttpClient();
      //打开Http连接
      HttpClientRequest request =
      await httpClient.getUrl(
          Uri.parse("https://raw.githubusercontent.com/sy2345/china-city/master/city.txt"));
      //使用iPhone的UA
      request.headers.add(
        "user-agent",
        "Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.30 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1",
      );
      //等待连接服务器（会将请求信息发送给服务器）
      HttpClientResponse response = await request.close();
      //读取响应内容
      _text = await response.transform(utf8.decoder).join();
      //输出响应头
      print(response.headers);

      //关闭client后，通过该client发起的所有请求都会中止。
      httpClient.close();
    } catch (e) {
      _text = "请求失败：$e";
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }
}

class FutureBuilderRoute extends StatefulWidget {
  @override
  _FutureBuilderRouteState createState() => _FutureBuilderRouteState();
}
class _FutureBuilderRouteState extends State<FutureBuilderRoute> {
  Dio _dio = Dio();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("通过dio发起请求"),
        ),
      body: Center(
        child: Container(
          alignment: Alignment.center,
          child: FutureBuilder(
            future: _dio.get("https://api.github.com/orgs/flutterchina/repos"),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              //请求完成
              if (snapshot.connectionState == ConnectionState.done) {
                Response response = snapshot.data;
                //发生错误
                if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }
                //请求成功，通过项目信息构建用于显示项目名称的ListView
                return ListView(
                  children: response.data.map<Widget>((e) =>
                      ListTile(title: Text(e["full_name"]))
                  ).toList(),
                );
              }
              //请求未完成时弹出loading
              return CircularProgressIndicator();
            }
      ),
    )));
  }
}

class WebSocketRoute extends StatefulWidget {
  @override
  _WebSocketRouteState createState() => _WebSocketRouteState();
}
class _WebSocketRouteState extends State<WebSocketRoute> {
  TextEditingController _controller = TextEditingController();
  late IOWebSocketChannel channel;
  String _text = "";
  @override
  void initState() {
    //创建websocket连接
    channel = IOWebSocketChannel.connect('ws://http://echo.websocket.org');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("WebSocket(内容回显)"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Form(
              child: TextFormField(
                controller: _controller,
                decoration: InputDecoration(labelText: 'Send a message'),
              ),
            ),
            StreamBuilder(
              stream: channel.stream,
              builder: (context, snapshot) {
                //网络不通会走到这
                if (snapshot.hasError) {
                  _text = "网络不通...";
                } else if (snapshot.hasData) {
                  _text = "echo: "+snapshot.data.toString();
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: Text(_text),
                );
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _sendMessage,
        tooltip: 'Send message',
        child: Icon(Icons.send),
      ),
    );
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      channel.sink.add(_controller.text);
    }
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
      ),
      body: Center(
          child: Column(
            children: <Widget>[
              TextButton(
                child: Text("通过HttpClient发起HTTP请求", style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                ),),
                onPressed: () {
                  //导航到新路由
                  Navigator.pushNamed(context, "通过HttpClient发起HTTP请求");
                },
              ),
              TextButton(
                child: Text("使用WebSockets", style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                ),),
                onPressed: () {
                  //导航到新路由
                  Navigator.pushNamed(context, "使用WebSockets");
                },
              ),
              TextButton(
                child: Text("通过dio发起请求", style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                ),),
                onPressed: () {
                  //导航到新路由
                  Navigator.pushNamed(context, "通过dio发起请求");
                },
              ),
            ],
          )
      ),
    );
  }
}