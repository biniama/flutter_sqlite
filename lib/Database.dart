import 'dart:async';
import 'dart:io';

import 'package:flutter_sqlite/SettingModel.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();

  static Database _database;

  Future<Database> get database async {
    if (_database != null)
    return _database;

    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "beyaDB.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE Setting ("
          "id INTEGER PRIMARY KEY,"
          "property TEXT,"
          "value TEXT,"
          "expired BIT"
          ")");
    });
  }

  createSetting(Setting setting) async {
    final db = await database;
    //get the biggest id in the table
    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM Setting");
    int id = table.first["id"];
    //insert to the table using the new id
    var raw = await db.rawInsert(
        "INSERT Into Setting (id, property, value, expired)"
        " VALUES (?,?,?,?)",
        [id, setting.property, setting.value, setting.expired]);
    return raw;
  }

  getSetting(int id) async {
    final db = await database;
    var res = await db.query("Setting", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? Setting.fromJson(res.first) : null;
  }

  Future<List<Setting>> getAllSettings() async {
    final db = await database;
    var res = await db.query("Setting");
    List<Setting> list =
        res.isNotEmpty ? res.map((c) => Setting.fromJson(c)).toList() : [];
    return list;
  }

  Future<List<Setting>> getExpiredSettings() async {
    final db = await database;

    print("works");
    // var res = await db.rawQuery("SELECT * FROM Setting WHERE expired=1");
    var res = await db.query("Setting", where: "expired = ? ", whereArgs: [1]);

    List<Setting> list =
        res.isNotEmpty ? res.map((c) => Setting.fromJson(c)).toList() : [];
    return list;
  }


  updateSetting(Setting updatedSetting) async {
    final db = await database;
    var res = await db.update("Setting", updatedSetting.toJson(),
        where: "id = ?", whereArgs: [updatedSetting.id]);
    return res;
  }

  expireOrUnexpire(Setting setting) async {
    final db = await database;
    Setting expired = Setting(
        id: setting.id,
        property: setting.property,
        value: setting.value,
        expired: !setting.expired);
    var res = await db.update("Setting", expired.toJson(),
        where: "id = ?", whereArgs: [setting.id]);
    return res;
  }

  deleteSetting(int id) async {
    final db = await database;
    db.delete("Setting", where: "id = ?", whereArgs: [id]);
  }

  deleteAllSettings() async {
    final db = await database;
    db.rawDelete("Delete * from Setting");
  }
}