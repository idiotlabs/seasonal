import 'dart:convert';
import 'package:seasonal/models/bookmark.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookmarkSharedPreferences {
  static const String _key = 'bookmarks';

  Future<List<Bookmark>> getBookmarks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? json = prefs.getString(_key);
    if (json != null) {
      List<dynamic> list = jsonDecode(json);
      return list.map((e) => Bookmark.fromJson(e)).toList();
    }
    return [];
  }

  Future<int> hasBookmark(Bookmark bookmark) async {
    List<Bookmark> bookmarks = await getBookmarks();
    return bookmarks.indexWhere((e) => e.goodList == bookmark.goodList);

    // final prefs = await SharedPreferences.getInstance();
    // return prefs.containsKey(id);
  }

  Future<void> addBookmark(Bookmark bookmark) async {
    List<Bookmark> bookmarks = await getBookmarks();
    bookmarks.add(bookmark);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_key, jsonEncode(bookmarks.map((e) => e.toJson()).toList()));
  }

  Future<void> removeBookmark(Bookmark bookmark) async {
    List<Bookmark> bookmarks = await getBookmarks();
    bookmarks.removeWhere((e) => e.goodList == bookmark.goodList);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_key, jsonEncode(bookmarks.map((e) => e.toJson()).toList()));
  }
}