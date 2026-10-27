import 'package:sqflite/sqflite.dart';

/// Helper SQLite local (protótipo). Estrutura preparada para evoluir para PostgreSQL/AWS.
class AppDatabase {
  Database? _db;

  Future<Database> get db async => _db ??= await _open();

  Future<Database> _open() async {
    final dir = await getDatabasesPath();
    final path = '$dir/bpsee.db';
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, v) async {
        await db.execute('''
          CREATE TABLE analises(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            variedade TEXT NOT NULL,
            modo TEXT NOT NULL,
            data TEXT NOT NULL,
            imagem_path TEXT,
            resultado TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<int> insertAnalise(Map<String, dynamic> m) async {
    final db = await this.db;
    return db.insert('analises', m);
  }

  Future<List<Map<String, dynamic>>> listAnalises() async {
    final db = await this.db;
    return db.query('analises', orderBy: 'data DESC');
  }

  Future<int> deleteAnalise(int id) async {
    final db = await this.db;
    return db.delete('analises', where: 'id = ?', whereArgs: [id]);
  }
}
