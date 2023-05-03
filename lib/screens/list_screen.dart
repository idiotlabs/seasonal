import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../config/constants.dart';
import '../widgets/home_listview_widget.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  late Future<List> _goodData;

  Future<List> getGoods() async {
    // List<Good> goods = await DatabaseHelper().getGoods();
    //
    // return [];

    var token = Constants.apiToken;

    var url = Uri.parse("${Constants.apiBaseUrl}/dev/goods");
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });

    return json.decode(response.body);
  }

  @override
  void initState() {
    super.initState();

    _goodData = getGoods();
  }

  @override
  Widget build(BuildContext context) {
    const title = '제철음식';

    // 처음 시작할때 API가 느리면 listview에 아무것도 나오지 않음
    // - FutureBuilder 사용 추가
    return Scaffold(
        appBar: AppBar(
          title: const Text(title),
          centerTitle: true,
          elevation: 1,
          shadowColor: Theme.of(context).shadowColor,
          // leading: IconButton(
          //   onPressed: () {},
          //   icon: const Icon(Icons.menu),
          // ),
        ),
        body: FutureBuilder(
            future: _goodData,
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              var goods = snapshot.data ?? [];

              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const Center(child: CircularProgressIndicator());
                default:
                  return HomeListViewWidget(goods: goods);
              }
            }
        )
    );
  }
}
