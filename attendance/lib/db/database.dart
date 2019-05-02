import 'dart:async';
import 'dart:io';

import 'package:attendance/backend/user.dart';
import 'package:attendance/backend/scan.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';


/// provider of database.
class DBProvider {
  DBProvider._();

  static const String _userTableV2 = 
    'CREATE TABLE USER ('
    'id INTEGER PRIMARY KEY,'
    'nativeName TEXT'
    'phone TEXT'
    'apiSynced int'
    ')';
  static const String _scanTableV2 = 
    'CREATE TABLE Scan ('
    'id INTEGER PRIMARY KEY,'
    'key TEXT,'
    'classKey TEXT,'
    'admin TEXT,'
    'arrive TEXT,'
    'leave TEXT'
    ')';

  /// singelton instance
  static final DBProvider db = DBProvider._();

  Database _database;

  /// getter of instance
  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }
    // if _database is null we instantiate it
    return initDB();
  }

  /// databse initialization
  Future<Database> initDB() async {
    final Directory documentsDirectory =
      await getApplicationDocumentsDirectory();
    final String path = join(documentsDirectory.path, 'TestDB.db');
    return openDatabase(path, version: 2, onOpen: (Database db) {},
      onCreate: (Database db, int version) async {
        await db.execute(_scanTableV2);
        await _initUser(db);
      },
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        // upgrade from 1 to 2
        if(oldVersion==1 && newVersion==2) {
          await _initUser(db);
        }
      }
    );
  }

  Future<int> _initUser(Database db) async {
    await db.execute(_userTableV2);
    final int raw = await db.rawInsert(
      'INSERT Into USER (id,nativeName,phone,apiSynced)'
      ' VALUES (?,?,?,?,?)',
      <dynamic>[1, '', '', 0]
    );
    return raw;
  }

  /// insert new scan
  Future<int> newScan(Scan newScan) async {
    final Database db = await database;
    //get the biggest id in the table
    final List<Map<String, dynamic>> table =
      await db.rawQuery('SELECT MAX(id)+1 as id FROM Scan');
    final int id = table.first['id'];
    //insert to the table using the new id
    final List<dynamic> values = List<dynamic>(5)
    ..add(id)
    ..add(newScan.key)
    ..add(newScan.classKey)
    ..add(newScan.admin)
    ..add(newScan.arrive);
    final int raw = await db.rawInsert(
      'INSERT Into Scan (id,key,classKey,admin,arrive)'
      ' VALUES (?,?,?,?,?)',
      values
    );
    return raw;
  }

  /// get available scans
  Future<List<Scan>> getAllScans() async {
    final Database db = await database;
    final List<Map<String, dynamic>> res = await db.query('Scan');
    final List<Scan> list =
        res.isNotEmpty ?
          res.map((Map<String, dynamic>c) => Scan.fromMap(c)).toList()
          :
          <Scan>[];
    return list;
  }

  /// add leave time to a scan
  Future<int> updateScan(Scan scan) async {
    final Database db = await database;
    final List<dynamic> args = <dynamic>[scan.id];
    final int res = await db.update('Scan', scan.toMap(),
        where: 'id = ?', whereArgs: args);
    return res;
  }

  /// delete a scan
  Future<int> deleteScan(int id) async {
    final Database db = await database;
    final List<dynamic> args = <dynamic>[id];
    return db.delete('Scan', where: 'id = ?', whereArgs: args);
  }

  /// delete everything in scan table
  Future<int> deleteAllScans() async {
    final Database db = await database;
    return db.rawDelete('Delete * from Scan');
  }

  /// Save the user
  Future<int> saveUser(User user) async {
    final Database db = await database;
    final Map<String, dynamic> args = user.toMap();
    args['apiSynced'] = 0;
    final int res = await db.update('User', args,
        where: 'id = ?', whereArgs: <dynamic>[1]);
    return res;
  }

  /// mark user as synced with db
  Future<int> userIsSynced() async {
    final Database db = await database;
    return db.update('User', <String, dynamic>{'apiSynced':1},
        where: 'id = ?', whereArgs: <dynamic>[1]);
  }

}