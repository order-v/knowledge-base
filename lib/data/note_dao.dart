import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/note.dart';

/// 数据访问层（Dao）：只负责和数据库打交道。
///
/// 对应你 JavaWeb 实验里的 Dao 层：
/// 建连接、写 SQL、把结果转成对象，不掺界面逻辑。
class NoteDao {
  static Database? _database;

  /// 打开数据库（第一次会建表）。用 static 缓存，避免重复打开。
  static Future<Database> get _db async {
    final cached = _database;
    if (cached != null) return cached;

    final dbPath = join(await getDatabasesPath(), 'knowledge_base.db');
    final db = await openDatabase(
      dbPath,
      version: 1,
      onCreate: (database, version) async {
        await database.execute('''
          CREATE TABLE note(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            content TEXT NOT NULL,
            createdAt INTEGER NOT NULL
          )
        ''');
      },
    );
    _database = db;
    return db;
  }

  /// 新增一条笔记，返回数据库生成的主键。
  Future<int> insert(Note note) async {
    final db = await _db;
    return db.insert('note', note.toMap());
  }

  /// 按创建时间倒序取出全部笔记。
  Future<List<Note>> listAll() async {
    final db = await _db;
    final rows = await db.query('note', orderBy: 'createdAt DESC');
    return rows.map(Note.fromMap).toList();
  }

  /// 关键词搜索：标题或内容包含关键词。
  Future<List<Note>> search(String keyword) async {
    final kw = keyword.trim();
    if (kw.isEmpty) return listAll();

    final db = await _db;
    final like = '%$kw%';
    final rows = await db.query(
      'note',
      where: 'title LIKE ? OR content LIKE ?',
      whereArgs: [like, like],
      orderBy: 'createdAt DESC',
    );
    return rows.map(Note.fromMap).toList();
  }

  /// 按 id 删除。
  Future<void> delete(int id) async {
    final db = await _db;
    await db.delete('note', where: 'id = ?', whereArgs: [id]);
  }
}
