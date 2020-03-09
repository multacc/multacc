import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


class DatabaseInterface {
  // final String dbName;

  DatabaseInterface();

  void initializeDatabase() async {

    final databaseContacts = openDatabase(
      join(await getDatabasesPath(), 'contacts_database.db'),
      // When the database is first created, create a table to store dogs.
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE contacts(user_id TEXT PRIMARY KEY, name TEXT, multacc_id TEXT)",
        );
      },
      
      // version: 1,
    );

    final databaseItems = openDatabase(
      join(await getDatabasesPath(), 'items_database.db'),
      
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE items(item_id TEXT PRIMARY KEY, type TEXT, data TEXT, user_id TEXT)",
        );
      },
      
      // version: 1,
    );
    
  }
  
}

