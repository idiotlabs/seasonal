import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:seasonal/helpers/database.dart';
import 'package:seasonal/models/bookmark.dart';
import 'package:seasonal/prefs/bookdmark_sharedpreferences.dart';
import 'package:seasonal/repositories/food_repository.dart';

import '../config/constants.dart';
import '../models/food.dart';

class DetailScreen extends StatefulWidget {
  final int index;
  final Map<String, dynamic> food;

  const DetailScreen({super.key, required this.index, required this.food});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final BookmarkSharedPreferences bookmarkSharedPreferences = BookmarkSharedPreferences();
  final FoodRepository _foodRepository = FoodRepository();
  final _model = DatabaseHelper();

  late Future<Food> _foodData;

  bool isBookmark = false;

  Future<Food> _getFood() async {
    var foodId = widget.index;

    // select
    var food = await _foodRepository.select(await _model.database, foodId);

    if (food != null) {
      return food;
    }

    food = await _getFoodByApi(foodId);

    // insert
    _foodRepository.insert(await _model.database, food);

    return food;
  }

  Future<Food> _getFoodByApi(foodId) async  {
    var token = Constants.apiToken;

    var url = Uri.parse("${Constants.apiBaseUrl}/dev/goods/${foodId}");
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });

    return Food.fromJson(json.decode(response.body));
  }

  Future<void> _checkBookmark() async {
    int hasBookmark = await bookmarkSharedPreferences.hasBookmark(Bookmark(goodList: widget.food['id']));

    setState(() {
      isBookmark = hasBookmark >= 0;
    });
  }

  @override
  void initState() {
    log('detail_screen initState()');
    super.initState();

    _foodData = _getFood();

    _checkBookmark();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Second Route'),
      // ),
      body: Center(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              pinned: true,
              title: Text('${widget.food['name']}',
                  style: const TextStyle(
                      // color: Colors.black,
                      // fontSize: 20,
                      // fontWeight: FontWeight.bold,
                  )),
              expandedHeight: 420.0,
              /*
              actions: <Widget>[
                IconButton(
                  icon: isBookmark ? const Icon(Icons.bookmark) : const Icon(Icons.bookmark_outline),
                  onPressed: () {
                    log('${widget.goods['id']}');

                    if (isBookmark) {
                      bookmarkSharedPreferences
                          .removeBookmark(Bookmark(goodList: widget.goods['id']));

                      setState(() {
                        isBookmark = false;
                      });
                    }
                    else {
                      bookmarkSharedPreferences
                          .addBookmark(Bookmark(goodList: widget.goods['id']));

                      setState(() {
                        isBookmark = true;
                      });
                    }
                  },
                ),
              ],
              */
              flexibleSpace: FlexibleSpaceBar(
                stretchModes: const <StretchMode>[
                  StretchMode.zoomBackground,
                  StretchMode.blurBackground,
                  StretchMode.fadeTitle,
                ],
                background: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    Image.network(
                      '${Constants.imageBaseUrl}/${widget.food['image']}',
                      fit: BoxFit.cover,
                    ),
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment(0.0, 0.8),
                          end: Alignment.center,
                          colors: <Color>[
                            Color(0x40000000),
                            Color(0x00000000),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverFillRemaining(
                hasScrollBody: false,
                child: Container(
                  padding: const EdgeInsets.all(25),
                  child: FutureBuilder(
                      future: _foodData,
                      builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                        var goods = snapshot.data ?? [];

                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return const Center(child: CircularProgressIndicator());
                          default:
                            return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                                child: Text('${goods.description}',
                                    style: const TextStyle(fontSize: 18.0))),
                          ],
                        );
                      }
                  }),
            ))
          ],
        ),
        // child: ElevatedButton(
        //   onPressed: () {
        //     Navigator.pop(context);
        //   },
        //   child: Text('Hello ${widget.index} Go back!'),
        // ),
      ),
    );
  }
}
