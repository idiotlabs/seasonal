import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:seasonal/models/bookmark.dart';
import 'package:seasonal/prefs/bookdmark_sharedpreferences.dart';

import '../config/constants.dart';

class DetailScreen extends StatefulWidget {
  final int index;
  final Map<String, dynamic> goods;

  const DetailScreen({super.key, required this.index, required this.goods});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class Good {
  final int id;
  final String name;
  final String description;
  final String image;
  final List months;

  const Good({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.months,
  });

  factory Good.fromJson(Map<String, dynamic> json) {
    return Good(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      image: json['image'],
      months: json['months'],
    );
  }
}

class _DetailScreenState extends State<DetailScreen> {
  late Future<Good> _goodData;
  final BookmarkSharedPreferences bookmarkSharedPreferences = BookmarkSharedPreferences();
  bool isBookmark = false;

  Future<Good> getGoodOne() async {
    var token = Constants.apiToken;

    var url = Uri.parse("${Constants.apiBaseUrl}/dev/goods/${widget.index}");
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });

    return Good.fromJson(json.decode(response.body));
  }

  Future<void> _checkBookmark() async {
    int hasBookmark = await bookmarkSharedPreferences.hasBookmark(Bookmark(goodList: widget.goods['id']));

    setState(() {
      isBookmark = hasBookmark >= 0;
    });
  }

  @override
  void initState() {
    super.initState();

    _goodData = getGoodOne();
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
              title: Text('${widget.goods['name']}',
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
                      '${Constants.imageBaseUrl}/${widget.goods['image']}',
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
                      future: _goodData,
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
