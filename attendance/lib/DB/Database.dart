import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../model/scan_model.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }
    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  Future<Database> initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "TestDB.db");
    return await openDatabase(path, version: 1, onOpen: (Database db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE Scan ("
          "id INTEGER PRIMARY KEY,"
          "key TEXT,"
          "classKey TEXT,"
          "admin TEXT,"
          "arrive TEXT,"
          "leave TEXT"
          ")");
    });
  }

  Future<int> newScan(Scan newScan) async {
    final Database db = await database;
    //get the biggest id in the table
    List<Map<String, dynamic>> table = await db.rawQuery("SELECT MAX(id)+1 as id FROM Scan");
    int id = table.first["id"];
    //insert to the table using the new id
    List<dynamic> values = List<dynamic>(5);
    values.add(id);
    values.add(newScan.key);
    values.add(newScan.classKey);
    values.add(newScan.admin);
    values.add(newScan.arrive);
    int raw = await db.rawInsert(
        "INSERT Into Scan (id,key,classKey,admin,arrive)"
        " VALUES (?,?,?,?,?)",
        values);
    return raw;
  }

  Future<List<Scan>> getAllScans() async {
    final Database db = await database;
    List<Map<String, dynamic>> res = await db.query("Scan");
    List<Scan> list =
        res.isNotEmpty ? res.map((Map<String, dynamic>c) => Scan.fromMap(c)).toList() : List<Scan>();
    return list;
  }

  Future<int> addLeave(Scan scan) async {
    final Database db = await database;
    Scan edited = Scan(
        id: scan.id,
        key: scan.key,
        classKey: scan.classKey,
        admin: scan.admin,
        arrive: scan.arrive,
        leave: scan.leave);
    List<dynamic> args = List<dynamic>(1);
    args.add(scan.id);
    int res = await db.update("Scan", edited.toMap(),
        where: "id = ?", whereArgs: args);
    return res;
  }

  Future<int> deleteScan(int id) async {
    final Database db = await database;
    List<dynamic> args = List<dynamic>();
    return db.delete("Scan", where: "id = ?", whereArgs: args);
  }

  Future<int> deleteAll() async {
    final Database db = await database;
    return db.rawDelete("Delete * from Scan");
  }
}