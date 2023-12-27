import 'package:chasier/database/pengaturanQuery.dart';
import 'package:chasier/database/tempQuery.dart';
import 'package:sqflite/sqflite.dart' as sqlite;
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart' as path;

class DBHelper {
  static DBHelper _dbHelper = DBHelper._singleton();

  factory DBHelper() {
    return _dbHelper;
  }

  DBHelper._singleton();

  //baris terakhir singleton

  final tables = [
    TempQuery.CREATE_TABLE,
    PengaturanQuery.CREATE_TABLE
  ]; // membuat daftar table yang akan dibuat

  Future<Database> openDB() async {
    final dbPath = await sqlite.getDatabasesPath();
    return sqlite.openDatabase(path.join(dbPath, 'biztro.db'),
        onCreate: (db, version) {
      tables.forEach((table) async {
        await db.execute(table).then((value) {
          print("Berhasil ");
        }).catchError((err) {
          print("errornya ${err.toString()}");
        });
      });
      print('Table Created');
    }, version: 1);
  }

  insert(String table, Map<String, dynamic> data) async {
    final db = await openDB();
    var result = await db.insert(table, data,
        conflictAlgorithm: ConflictAlgorithm.replace);
    return result;
  }

  Future<List> getData(String tableName) async {
    final db = await openDB();
    var result = await db.query(tableName);
    return result.toList();
  }

  remove(String table, String field, int id) async {
    final db = await openDB();
    var result =
        await db.delete(table, where: '$field = ?', whereArgs: ['$id']);
    return result;
  }

  empty(String table) async {
    final db = await openDB();
    var result = await db.delete(table);
    return result;
  }

  Future<List> tempData(int id) async {
    final db = await openDB();
    var result = await db.query("temp",
        columns: ['qty'], where: 'menu_id = ?', whereArgs: ['$id']);
    return result.toList();
  }

  Future<List> rawData(String sql) async {
    final db = await openDB();
    var result = await db.rawQuery(sql);
    return result.toList();
  }
}
