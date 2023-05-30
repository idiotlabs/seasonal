import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:path/path.dart';

import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    return await initDB();
  }

  initDB() async {
    String path = join(await getDatabasesPath(), 'seasonal.db');

    return await openDatabase(
        path,
        version: 1,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade
    );
  }

  FutureOr<void> _onCreate(Database db, int version) {
    String sql = '''
      CREATE TABLE Food(
        id INTEGER PRIMARY KEY,
        name TEXT,
        description TEXT,
        image TEXT,
        months TEXT)
      ''';

    db.execute(sql);
  }

  FutureOr<void> _onUpgrade(Database db, int oldVersion, int newVersion) {}
}