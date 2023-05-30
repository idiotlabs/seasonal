import 'dart:developer';

import 'package:sqflite/sqflite.dart';

import '../models/food.dart';

class FoodRepository
{
  Future<Food?> select(database, id) async {
    try {
      List<Map<String, dynamic>> results =
          await database.query('Food', where: 'id = ?', whereArgs: [id]);

      // check empty
      if (results.isNotEmpty) {
        return Food.fromJson(results.first);
      }
    }  catch (e) {
    }

    return null;
  }

  Future<void> insert(Database database, Food food) async {
    try {
      await database.insert(
        'Food',
        {
          'id': food.id,
          'name': food.name,
          'description': food.description,
          'image': food.image,
        },
        // food.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
    }
  }
}