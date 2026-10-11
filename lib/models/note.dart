/// 数据模型：一条笔记。
///
/// 对应你 JavaWeb 实验里的 JavaBean：
/// 只有属性 + 构造方法 + 与数据库互转的方法，不含业务逻辑。
class Note {
  final int? id; // 数据库主键；还没存进数据库时为 null
  final String title;
  final String content;
  final DateTime createdAt;

  const Note({
    this.id,
    required this.title,
    required this.content,
    required this.createdAt,
  });

  /// 把对象转成数据库的一行（新增时不需要 id，数据库自动生成）。
  Map<String, Object?> toMap() => {
        'title': title,
        'content': content,
        'createdAt': createdAt.millisecondsSinceEpoch,
      };

  /// 把数据库的一行还原成对象。
  factory Note.fromMap(Map<String, Object?> map) => Note(
        id: map['id'] as int?,
        title: map['title'] as String,
        content: map['content'] as String,
        createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      );
}
