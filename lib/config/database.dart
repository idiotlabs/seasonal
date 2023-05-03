// import 'dart:async';
// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';
//
// class DatabaseHelper {
//   static late DatabaseHelper _databaseHelper;
//   // static final DatabaseHelper _databaseHelper = DatabaseHelper._internal();
//   static late Database _database;
//
//   DatabaseHelper._createInstance();
//
//   factory DatabaseHelper() {
//     _databaseHelper ??= DatabaseHelper._createInstance();
//
//     return _databaseHelper;
//   }
//
//   Future<Database> get database async {
//     if (_database == null) {
//       _database = await initializeDatabase();
//     }
//     return _database;
//   }
//
//   Future<Database> initializeDatabase() async {
//     String databasesPath = await getDatabasesPath();
//     String path = join(databasesPath, 'seasonal.db');
//
//     var database = await openDatabase(
//       path,
//       version: 1,
//       onCreate: _createDb,
//     );
//     return database;
//   }
//
//   void _createDb(Database db, int newVersion) async {
//     await db.execute(
//       // 'CREATE TABLE $userTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colName TEXT, $colEmail TEXT)');
//       "CREATE TABLE dogs(id INTEGER PRIMARY KEY, name TEXT, age INTEGER)",
//     );
//   }
//
//   Future<List<Good>> getGoods() async {
//     Database db = await this.database;
//     var result = await db.query('users');
//     List<User> users = [];
//     for (Map<String, dynamic> map in result) {
//       users.add(User.fromMap(map));
//     }
//     return users;
//   }
// }