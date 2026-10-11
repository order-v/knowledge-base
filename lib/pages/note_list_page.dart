import 'package:flutter/material.dart';

import '../data/note_dao.dart';
import '../models/note.dart';
import 'note_edit_page.dart';

/// 首页：显示笔记列表，顶部可搜索，右下角 + 新建。
///
/// 在 Flutter 里，一个页面（Widget）同时承担"视图 + 控制"两部分：
/// 界面用 build 描述，业务动作（增删查）写成方法。
class NoteListPage extends StatefulWidget {
  const NoteListPage({super.key});

  @override
  State<NoteListPage> createState() => _NoteListPageState();
}

class _NoteListPageState extends State<NoteListPage> {
  final NoteDao _dao = NoteDao();
  final TextEditingController _searchController = TextEditingController();

  List<Note> _notes = const [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// 从数据库读数据，然后刷新界面。
  Future<void> _load() async {
    setState(() => _loading = true);
    final notes = await _dao.search(_searchController.text);
    if (!mounted) return;
    setState(() {
      _notes = notes;
      _loading = false;
    });
  }

  Future<void> _openEditPage() async {
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => const NoteEditPage()),
    );
    if (saved ?? false) {
      await _load();
    }
  }

  Future<void> _delete(Note note) async {
    final id = note.id;
    if (id == null) return;
    await _dao.delete(id);
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('知识库'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
            child: TextField(
              controller: _searchController,
              onSubmitted: (_) => _load(),
              decoration: InputDecoration(
                hintText: '搜索标题或内容，回车确认',
                prefixIcon: const Icon(Icons.search),
                isDense: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ),
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: _openEditPage,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_notes.isEmpty) {
      return const Center(child: Text('还没有笔记，点右下角 + 新建一条'));
    }
    return ListView.separated(
      itemCount: _notes.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final note = _notes[index];
        return ListTile(
          title: Text(
            note.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            note.content,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _delete(note),
          ),
        );
      },
    );
  }
}
