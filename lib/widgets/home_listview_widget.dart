import 'package:flutter/material.dart';

import '../config/constants.dart';
import '../screens/detail_screen.dart';

class HomeListViewWidget extends StatelessWidget {
  const HomeListViewWidget({
    super.key,
    required this.goods,
  });

  final List goods;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(5),
      itemCount: goods.length,
      itemBuilder: (context, index) => InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    DetailScreen(index: goods[index]['id'], goods: goods[index])),
          );
        },
        child: Container(
          height: 105,
          margin: const EdgeInsets.all(5.0),
          padding: const EdgeInsets.all(15),
          // color: Colors.amber[colorCodes[index]],
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Image.asset('assets/busa.png', width: 75, height: 75),
                Image.network(
                    '${Constants.imageBaseUrl}/${goods[index]['image']}', width: 75, height: 75),
                const SizedBox(width: 10),
                Expanded(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                      Text(
                        '${goods[index]['name']} ♪',
                        style: const TextStyle(
                            fontSize: 24.0, fontWeight: FontWeight.bold),
                      ),
                      Row(children: <Widget>[
                        // container 12개 필요한데 for를 쓸 수 없나?
                        // - 네네 for문을 {} 안에 감싸면 안돼서
                        // - for 밑에 딱 하나의 선언문만 들어갈 수 있어요
                        // - 그래서 여러개 하고 싶으면 따로 메서드로 뺴서 그 메서드를 호출해야해요
                        for (int i = 1; i <= 12; i++)
                          Container(
                            margin: const EdgeInsets.only(right: 2.0),
                            height: 20,
                            width: 20,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border:
                                  Border.all(width: 0.5, color: Colors.green),
                              color: (goods[index]['month_list'].contains(i))
                                  ? Colors.green
                                  : Colors.transparent,
                            ),
                            child: Center(
                                child: Text('$i',
                                    style: TextStyle(
                                        fontSize: 12.0,
                                        color: (goods[index]['month_list']
                                                .contains(i))
                                            ? Colors.white
                                            : Colors.black,
                                        fontWeight: (goods[index]['month_list']
                                                .contains(i))
                                            ? FontWeight.bold
                                            : FontWeight.normal))),
                          ),
                      ]),
                    ])),
              ]),
        ),
      ),
      separatorBuilder: (context, index) =>
          const Divider(height: 0, color: Colors.green),
    );
  }
}
