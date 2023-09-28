import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Database? _database;
  static final _dbName = 'DBook.db';
  static final _userTableName = 'user';
  static final _bookTableName = 'book';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    final path = await getDatabasesPath();
    final dbPath = join(path, _dbName);
    return await openDatabase(
      dbPath,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE $_userTableName (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            email TEXT,
            password TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE $_bookTableName (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            author TEXT,
            image TEXT,
            publication_date TEXT,
            genre TEXT,
            description TEXT
          )
        ''');
      },
    );
  }

  Future<void> addBook(String title, String author, String image, String publicationDate, String genre, String description) async {
    final db = await database;
    await db.insert(
      _bookTableName,
      {
        'title': title,
        'author': author,
        'image': image,
        'publication_date': publicationDate,
        'genre': genre,
        'description': description,
        // Anda dapat menambahkan kolom lain sesuai dengan data buku yang Anda miliki
      },
      conflictAlgorithm: ConflictAlgorithm.replace, // Jika ada konflik, ganti data yang sudah ada
    );
  }

  Future<List<Map<String, dynamic>>> getBooks() async {
    final db = await database;
    return await db.query(_bookTableName);
  }

  Future<bool> loginUser(String email, String password) async {
    final db = await database;
    final result = await db.query(
      _userTableName,
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    return result.isNotEmpty;
  }

  Future<void> addUser(String email, String password) async {
    final db = await database;
    await db.insert(
      _userTableName,
      {
        'email': email,
        'password': password,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

}
