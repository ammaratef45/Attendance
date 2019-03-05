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
    if (_database != null) return _database;
    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "TestDB.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
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

  newScan(Scan newScan) async {
    final db = await database;
    //get the biggest id in the table
    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM Scan");
    int id = table.first["id"];
    //insert to the table using the new id
    var raw = await db.rawInsert(
        "INSERT Into Scan (id,key,classKey,admin,arrive)"
        " VALUES (?,?,?,?,?)",
        [id, newScan.key, newScan.classKey, newScan.admin, newScan.arrive]);
    return raw;
  }

  Future<List<Scan>> getAllScans() async {
    final db = await database;
    var res = await db.query("Scan");
    List<Scan> list =
        res.isNotEmpty ? res.map((c) => Scan.fromMap(c)).toList() : [];
    return list;
  }

  addLeave(Scan scan) async {
    final db = await database;
    Scan edited = Scan(
        id: scan.id,
        key: scan.key,
        classKey: scan.classKey,
        admin: scan.admin,
        arrive: scan.arrive,
        leave: scan.leave);
    var res = await db.update("Scan", edited.toMap(),
        where: "id = ?", whereArgs: [scan.id]);
    return res;
  }

  deleteScan(int id) async {
    final db = await database;
    return db.delete("Scan", where: "id = ?", whereArgs: [id]);
  }

  deleteAll() async {
    final db = await database;
    db.rawDelete("Delete * from Scan");
  }
}