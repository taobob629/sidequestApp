import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/db_model.dart';

class DBHelper {

  factory DBHelper(int uid) {
    return DBHelper.init(uid);
  }

  DBHelper.init(int uid){
    this.uid = uid;
  }

  late int uid;

  static Database? _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await initDb();
    return _db!;
  }

  initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, '$uid-wy.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate, onUpgrade: _onUpgrade);
    return db;
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
    _db = null;
    return;
  }

  void _onCreate(Database db, int newVersion) async {
    await db.execute('CREATE TABLE PayRecord(orderId TEXT PRIMARY KEY, tranId TEXT, createTime INTEGER)');
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion){

  }

  Future<int> insertPayRecord(PayRecord payRecord) async {
    var dbClient = await db;
    var result = await dbClient.insert("PayRecord", payRecord.toJson());
    return result;
  }

  Future<List<PayRecord>> selectPayRecords() async {
    var dbClient = await db;
    var result = await dbClient.query(
      "PayRecord",
      columns: ["orderId", "tranId", "createTime"],
      orderBy: 'createTime asc',
    );
    List<PayRecord> list = [];
    result.forEach((item) => list.add(PayRecord.fromJson(item)));
    return list;
  }

  Future<void> deletePayRecord(String orderId) async {
    var dbClient = await db;
    await dbClient.delete(
      "PayRecord",
      where: 'orderId = ?',
      whereArgs: [orderId]
    );
  }
}