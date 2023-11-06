import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart'; 
import 'dart:io' as io;

import 'package:todo/database%20and%20model/flu_model.dart';

class Helper {
  static Database? _db;

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDatabase();
    return _db;
  }

  initDatabase() async {
    io.Directory documentDirectory = await getApplicationCacheDirectory();
    String path = join(documentDirectory.path, 'todo.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
      "CREATE TABLE todo (id INTEGER PRIMARY KEY AUTOINCREMENT, work TEXT NOT NULL, description TEXT NOT NULL)"
    );
  }

  Future<DataModel> insert(DataModel dbmodel) async {
    var dbClient = await db;
    await dbClient!.insert('todo', dbmodel.toMap());
    return dbmodel;
  }

  Future<List<DataModel>> getNOteList() async{
    var dbClient = await db;
    final List<Map<String, Object?>> querryResult = await dbClient!.query("todo");
    return querryResult.map((e) => DataModel.fromMap(e)).toList();
  }

  Future<int> delete(int id) async{
    var dbClient = await db;
    return await dbClient!.delete(
      'todo',
      where: 'id=?',
      whereArgs: [id]
    );
  }

  Future<int> update(DataModel dataModel) async{
    var dbClient = await db;
    return await dbClient!.update(
      'todo',
      dataModel.toMap(),
      where: 'id=?',
      whereArgs: [dataModel.id]
    );
  }
}
