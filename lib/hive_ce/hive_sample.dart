import 'package:flutter_local_storage_examples/hive_ce/hive_model.dart';
import 'package:flutter_local_storage_examples/hive_ce/hive_registrar.g.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

void main() async {
  // 1. Initialize Hive
  await Hive.initFlutter();

  // 2. Register adapters
  Hive.registerAdapters();

  // 3. Open box
  final box = await Hive.openBox<Note>('notes');

  await box.add(Note(
    id: (box.length + 1).toString(),
    title: 'Sample Note',
    content: 'This is a sample note',
    createdAt: DateTime.now(),
  ));

  List<Note> allNotes = box.values.toList();
  print('all notes: $allNotes');
}