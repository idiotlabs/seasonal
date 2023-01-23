import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter View',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // variable to call and store future list of posts
  // Future<List> goodsFuture = getGoods();

  // function to fetch data from api and return future list of posts
  getGoods() async {
    var url = Uri.parse("https://3u553ufx3k.execute-api.ap-northeast-2.amazonaws.com/dev/goods");
    final response = await http.get(url, headers: {"Content-Type": "application/json"});
    log(response.body);
    // final List body = json.decode(response.body);

    // return body.map((e) => Post.fromJson(e)).toList();
  }

  @override
  void initState() {
    super.initState();

    getGoods();
  }

  @override
  Widget build(BuildContext context) {
    const title = 'Basic List';

    final List<String> entries = <String>['A', 'B', 'C', 'A', 'B', 'C', 'A', 'B', 'C'];
    final List<int> colorCodes = <int>[600, 500, 100, 100, 100, 100, 100, 100, 100];

    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(title),
        ),
        body: ListView.builder(
            padding: const EdgeInsets.all(5),
            itemCount: entries.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                height: 105,
                margin: const EdgeInsets.all(5.0),
                padding: const EdgeInsets.all(15),
                // color: Colors.amber[colorCodes[index]],
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset('assets/busa.png', width: 75, height: 75),
                      const SizedBox(width: 10),
                      Expanded(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const Text(
                                  '부사',
                                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                                ),
                                Row(children: <Widget>[
                                  // container 12개 필요한데 for를 쓸 수 없나?
                                  // - 네네 for문을 {} 안에 감싸면 안돼서
                                  // - for 밑에 딱 하나의 선언문만 들어갈 수 있어요
                                  // - 그래서 여러개 하고 싶으면 따로 메서드로 뺴서 그 메서드를 호출해야해요
                                  for (int i = 0; i < 12; i++)
                                    Container(
                                      margin: const EdgeInsets.only(right: 2.0),
                                      height: 20,
                                      width: 20,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(width: 1, color: Colors.red),
                                        color: (i > 9) ? Colors.red : Colors.transparent,
                                      ),
                                      child: Center(
                                        // text에 const가 붙고 안붙고는 어떤 차이가 있을까?
                                          child: Text(
                                              '$i',
                                              style: TextStyle(
                                                  fontSize: 12.0,
                                                  color: (i > 9) ? Colors.white : Colors.black,
                                                  fontWeight: (i > 9) ? FontWeight.bold : FontWeight.normal
                                              )
                                          )
                                      ),
                                    ),
                                ]),
                              ])),
                      Text('>'),
                    ]),
              );
            }),
      ),
    );
  }
}