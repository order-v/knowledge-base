import 'package:flutter_test/flutter_test.dart';
import 'package:knowledge_base/models/note.dart';

void main() {
  test('Note 与数据库 Map 可以互相转换', () {
    final note = Note(
      title: '测试标题',
      content: '测试内容',
      createdAt: DateTime.fromMillisecondsSinceEpoch(1700000000000),
    );

    final map = note.toMap();
    expect(map['title'], '测试标题');
    expect(map['content'], '测试内容');
    expect(map['createdAt'], 1700000000000);

    final restored = Note.fromMap({'id': 7, ...map});
    expect(restored.id, 7);
    expect(restored.title, '测试标题');
    expect(restored.content, '测试内容');
    expect(restored.createdAt.millisecondsSinceEpoch, 1700000000000);
  });
}
