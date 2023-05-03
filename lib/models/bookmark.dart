class Bookmark {
  int goodList;

  Bookmark({required this.goodList});

  Map<String, dynamic> toJson() {
    return {'goodList': goodList};
  }

  static Bookmark fromJson(Map<String, dynamic> json) {
    return Bookmark(goodList: json['goodList']);
  }
}
