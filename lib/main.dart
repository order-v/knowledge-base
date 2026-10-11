import 'package:flutter/material.dart';

import 'data/note_dao.dart';
import 'pages/note_list_page.dart';

void main() {
  // Flutter 的标准启动流程：
  // 1) ensureInitialized：让插件（这里是数据库）在 runApp 前可用
  // 2) initPlatform：桌面端切换数据库实现，手机端是空操作
  // 3) runApp：把根组件挂到屏幕上
  WidgetsFlutterBinding.ensureInitialized();
  NoteDao.initPlatform();
  runApp(const KnowledgeBaseApp());
}

/// 根组件：只负责全局设置（标题、主题、首页）。
class KnowledgeBaseApp extends StatelessWidget {
  const KnowledgeBaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '知识库',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.teal),
      home: const NoteListPage(),
    );
  }
}