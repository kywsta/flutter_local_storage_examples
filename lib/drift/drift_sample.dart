import 'package:flutter/material.dart';
import 'package:flutter_local_storage_examples/drift/drift_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database = AppDatabase();

  await database
      .into(database.todoItems)
      .insert(
        TodoItemsCompanion.insert(
          title: 'Sample note',
          content: 'This is a sample note',
        ),
      );

  List<TodoItem> allItems = await database.select(database.todoItems).get();

  print('items in database: $allItems');

  List<TodoItem> item = await (database.select(database.todoItems)..where((table) => table.id.equals(2))).get();
  print('item with id 2: $item');
}
