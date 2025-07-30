import 'package:hive_ce/hive.dart';

class Note extends HiveObject {
  String id;
  String title;
  String content;
  DateTime createdAt;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
  });

  @override
  String toString() {
    return 'Note(id: $id, title: $title, content: $content, createdAt: ${createdAt.millisecondsSinceEpoch})';
  }
}
