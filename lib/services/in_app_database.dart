import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBprovider {
  DBprovider._();
  static final DBprovider db = DBprovider._();
  static Database? _dataBase;

  Future<Database?> get database async => _dataBase ??= await initDB();

  initDB() async {
    return await openDatabase(join(await getDatabasesPath(), 'chat.db'),
        onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE messages(message text,sender text,receiver text,groupid text,date text)
            ''');
    }, version: 1);
  }

  newMessage(
      {required String message,
      required String sender,
      required String receiver,
      required String sentAt,
      required String groupid}) async {
    final db = await database;

    db?.rawInsert('''
    INSERT INTO messages(message,sender,receiver,groupid,date) 
    VALUES ('$message','$sender','$receiver','$groupid','$sentAt')
    ''');
  }

  getMessages({required groupid}) async {
    final db = await database;
    var messages = db?.query('messages', where: 'groupid = $groupid');

    return messages;
  }

  getGroups() async {
    final db = await database;
    var groups = db?.query('''
    SELECT groupid FROM messages
    ''');
    return groups;
  }
}
