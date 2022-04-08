import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:path/path.dart';

class DbInit {
  static Database? _db;
  static String databaseName = "AppDb";
  static String todoItemsTable = "todo_items";
  static String name = "todo_name";
  static String index = "id";
  static String description = "description";

  static Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await init();
    return _db;
  }

  static init() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = join(dir.path, databaseName);
    var db = await openDatabase(
      path,
      version: 1,
      onCreate: _onCreateTable,
    );
    return db;
  }

  static _onCreateTable(Database db, int version) async {
    String createTodoTableQuery =
        "CREATE TABLE $todoItemsTable ($index TEXT PRIMARY KEY, $name TEXT, $description TEXT)";
    await db.execute(createTodoTableQuery);
  }
}
