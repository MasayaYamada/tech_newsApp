import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:technewsapp/saved_newsdata.dart';

class DatabaseHelper {

  static final _databaseName = "savednews.db";
  static final _databaseVersion = 1;

  static final table = 'savednews_table';

  static final columnId = 'id';
  static final columnTitle = 'title';
  static final columnUrl = 'url';
  static final columnUrlToImage = 'urlToImage';

  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId TEXT NOT NULL PRIMARY KEY,
            $columnTitle TEXT NOT NULL,
            $columnUrl TEXT NOT NULL,
            $columnUrlToImage TEXT NOT NULL
          )
          ''');
  }

  // Helper methods

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<int> insert(SavedNews savedNews) async {
    Database db = await instance.database;
    return await db.insert(table, {'id': savedNews.id, 'title': savedNews.title, 'url': savedNews.url, 'urlToImage': savedNews.urlToImage});
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }


}