import 'package:flutter/material.dart';
import 'package:flutter_local_storage_examples/sqflite/sqflite_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SqfliteDatabaseHelper.insertNote({
    'title': 'Sample Note',
    'content': 'This is a sample note',
    'createdAt': DateTime.now().toIso8601String(),
  });

  List<Map<String, dynamic>> allNotes =
      await SqfliteDatabaseHelper.getAllNotes();
  print(allNotes);
}
