import 'package:homework_sql/models/contacts_model.dart';
import 'package:sqflite/sqflite.dart';

class ContactsController {
  ContactsController._singleton();

  static final ContactsController _contactsController =
      ContactsController._singleton();

  factory ContactsController() {
    return _contactsController;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = "$databasePath/contacts.db";
    return await openDatabase(path, version: 1, onCreate: _createDatabase);
  }

  Future<void> _createDatabase(Database db, int versrion) async {
    return await db.execute("""
  CREATE TABLE contacts(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    phone_number TEXT NOT NULL
  )
""");
  }

  Database? _database;
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  Future<void> addContacts(String contactName, String phoneNumber) async {
    await _database!
        .insert("contacts", {"name": contactName, "phone_number": phoneNumber});
  }

  Future<List<Map<String, dynamic>>> viewContacts() async {
    database;
    return await _database!.query("contacts");
  }

  Future<void> editContacts(
    String name,
    String number,
  ) async {
    await _database!.update("contacts", {"name": name, "phone_number": number},
        where: "id=?", whereArgs: [2]);
  }

  Future<void> deleteContacts(String id) async {
    await _database!.delete("contacts", where: "id=?", whereArgs: [2]);
  }
}
