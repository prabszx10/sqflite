import 'package:project_data_keuangan/models/dataModel.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class Helper {
  static Database _db;
  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDatabase();
    return _db;
  }

  initDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'dataPengeluaran12.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db
        .execute('CREATE TABLE data (id INTEGER PRIMARY KEY, name TEXT, nominal TEXT, category TEXT, date TEXT )');
  }

  Future<Data> add(Data data) async {
    var dbClient = await db;
    data.id = await dbClient.insert('data', data.toMap());
    print('Added');
    return data;
  }

  Future<List<Data>> getData() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query('data', columns: ['id', 'name','nominal','category','date']);
    List<Data> datas = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        datas.add(Data.fromMap(maps[i]));
      }
    }
    return datas;
  }

  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient.delete(
      'data',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> update(Data data) async {
    var dbClient = await db;
    return await dbClient.update(
      'data',
      data.toMap(),
      where: 'id = ?',
      whereArgs: [data.id],
    );
  }

  Future drop() async{
    var dbClient = await db;
    var drop = await dbClient.rawDelete('DROP TABLE data');
    return drop;
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}