import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqlDb {
  static Database? _db;
  Future<Database?> get db async {
    if (_db == null) {
      _db = await initialDb();
      return _db;
    } else {
      return _db;
    }
  }

  initialDb() async {
    String databasepath = await getDatabasesPath();
    String path = join(databasepath, 'weal.db');
    Database mydb = await openDatabase(path, onCreate: _onCreate, version: 5);
    return mydb;
  }

  _onUpgrade(Database db, int oldversion, int newVersion) async {
    print("onUpgrade ================================");
    await db.execute("ALTER TAPLE notes ADD COLUMN color TEXT");
  }

  _onCreate(Database db, int version) async {
    Batch batch = db.batch();
    batch.execute('''
     CREATE TABLE notes (
     id    INTEGER NOT NULL PRIMARY KEY AUTOINCREAMENT  ,
     note  TEXT NOT NULL,
     title  TEXT NOT NULL,
     color  TEXT NOT NULL
     )
     ''');
    batch.commit();
    print("Create DATABASE AND TAPLE =======================");
  }

  readData(String sql) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.rawQuery(sql);
    return response;
  }

  insertData(String sql) async {
    Database? mydb = await db;
    int? response;
    await mydb!.transaction((txn) async{
      response = await txn.rawInsert(sql);
    });
    
    // rawInsert(sql)
    return response;
  }

  updateData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawUpdate(sql);
    return response;
  }

  deleteData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawDelete(sql);
    return response;
  }

  mydeleteDatabase() async {
    String databasepath = await getDatabasesPath();
    String path = join(databasepath, "wael.db");
    await deleteDatabase(path);
  }
}
