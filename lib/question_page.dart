import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:share_plus/share_plus.dart';
import '../services/pb_service.dart';
import '../models/question.dart'; // ✅ เพิ่ม import โมเดล
import 'package:pocketbase/pocketbase.dart';

// ===============================
// 🎯 หน้าหมวดคำถามหลัก (QuestionPage)
// ===============================
class QuestionPage extends StatefulWidget {
  final String category;
  final List<String> questions;
  final IconData icon;
  final Color color;

  const QuestionPage({
    super.key,
    required this.category,
    required this.questions,
    required this.icon,
    required this.color,
  });

  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  final _box = GetStorage();
  final _rnd = Random();
  final pb = PbService();
  List<String> _questions = [];
  String? _currentQuestion;

  List<String> get _favorites =>
      List<String>.from(_box.read('favorite_questions') ?? []);

  @override
  void initState() {
    super.initState();
    _loadFromPocketBase();
  }

  // ✅ โหลดคำถามจาก PocketBase
  Future<void> _loadFromPocketBase() async {
    await pb.init();
    final records = await pb.getQuestions(widget.category);
    setState(() {
      _questions = records.map((r) => r.data['text'] as String).toList();
      if (_questions.isNotEmpty) {
        _currentQuestion = _pickRandom();
      }
    });
  }

  // ✅ สุ่มคำถาม
  String _pickRandom() {
    return _questions[_rnd.nextInt(_questions.length)];
  }

  void _shuffle() {
    setState(() {
      _currentQuestion = _pickRandom();
    });
  }

  // ✅ จัดการรายการโปรด (Favorites)
  void _toggleFavorite(String question) {
    final favs = _favorites;
    if (favs.contains(question)) {
      favs.remove(question);
    } else {
      favs.add(question);
    }
    _box.write('favorite_questions', favs);
    setState(() {});
  }

  bool _isFav(String question) => _favorites.contains(question);

  // ✅ แชร์คำถาม
  void _share(String question) async {
    await Share.share('IceBreaker: $question');
  }

  // ✅ แสดงรายการโปรด
  void _showFavorites() {
    final favs = _favorites;
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.6,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        builder: (ctx, scroll) => Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Text('คำถามที่ชอบ',
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              if (favs.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('ยังไม่มีรายการโปรด'),
                )
              else
                Expanded(
                  child: ListView.separated(
                    controller: scroll,
                    itemCount: favs.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (_, i) => ListTile(
                      title: Text(favs[i]),
                      trailing: IconButton(
                        icon: const Icon(Icons.share),
                        onPressed: () => _share(favs[i]),
                        tooltip: 'แชร์',
                      ),
                      onTap: () {
                        setState(() {
                          _currentQuestion = favs[i];
                        });
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // ✅ เปิดหน้าแก้ไขคำถาม
  void _openEditor() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditQuestionsPage(
          category: widget.category,
          color: widget.color,
        ),
      ),
    ).then((_) => _loadFromPocketBase());
  }

  @override
  Widget build(BuildContext context) {
    final question = _currentQuestion ?? 'ไม่มีคำถาม!';

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category),
        backgroundColor: widget.color,
        actions: [
          IconButton(
            onPressed: _showFavorites,
            icon: const Icon(Icons.favorite),
            tooltip: 'รายการโปรด',
          ),
          IconButton(
            onPressed: _openEditor,
            icon: const Icon(Icons.edit),
            tooltip: 'แก้ไขคำถาม',
          ),
        ],
      ),
      body: _questions.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Expanded(
                    child: Center(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 600),
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                          final rotateAnim =
                              Tween(begin: pi, end: 0.0).animate(animation);
                          return AnimatedBuilder(
                            animation: rotateAnim,
                            child: child,
                            builder: (context, child) {
                              final isUnder = (child!.key != ValueKey(question));
                              var tilt = (animation.value - 0.5).abs() - 0.5;
                              tilt *= isUnder ? -0.003 : 0.003;
                              final value = isUnder
                                  ? min(rotateAnim.value, pi / 2)
                                  : rotateAnim.value;
                              return Transform(
                                transform: Matrix4.rotationY(value)
                                  ..setEntry(3, 0, tilt),
                                alignment: Alignment.center,
                                child: child,
                              );
                            },
                          );
                        },
                        child: Container(
                          key: ValueKey(question),
                          width: 250,
                          height: 350,
                          padding: const EdgeInsets.only(
                              top: 40, left: 8, right: 8, bottom: 8),
                          decoration: BoxDecoration(
                            color: widget.color.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(28),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 20,
                                spreadRadius: -5,
                                color: Colors.black.withOpacity(0.2),
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Center(
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  padding: const EdgeInsets.all(16),
                                  width: 250,
                                  height: 300,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Center(
                                    child: Text(
                                      question,
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w400,
                                            height: 1.4,
                                            fontSize: 14,
                                            color: Colors.black87,
                                          ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: -24,
                                left: 0,
                                right: 0,
                                child: CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Colors.white,
                                  child: Icon(
                                    widget.icon,
                                    color: widget.color,
                                    size: 30,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton.filledTonal(
                        onPressed: _shuffle,
                        icon: const Icon(Icons.casino),
                        tooltip: 'สุ่มคำถาม',
                        style: IconButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: widget.color,
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton.filled(
                        onPressed: () => _toggleFavorite(question),
                        icon: Icon(
                          _isFav(question)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: Colors.white,
                        ),
                        style: IconButton.styleFrom(
                          backgroundColor: widget.color,
                        ),
                        tooltip: _isFav(question)
                            ? 'เอาออกจากโปรด'
                            : 'บันทึกเป็นโปรด',
                      ),
                      const SizedBox(width: 8),
                      IconButton.outlined(
                        onPressed: () => _share(question),
                        icon: const Icon(Icons.share),
                        style: IconButton.styleFrom(
                          foregroundColor: widget.color,
                          side: BorderSide(color: widget.color),
                        ),
                        tooltip: 'แชร์คำถาม',
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }
}

// ===============================
// 🛠️ หน้าแก้ไขคำถาม (EditQuestionsPage)
// ===============================
class EditQuestionsPage extends StatefulWidget {
  final String category;
  final Color color;

  const EditQuestionsPage({
    super.key,
    required this.category,
    required this.color,
  });

  @override
  State<EditQuestionsPage> createState() => _EditQuestionsPageState();
}

class _EditQuestionsPageState extends State<EditQuestionsPage> {
  final pb = PbService();
  List<Question> _records = []; // ✅ ใช้ Question model

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    await pb.init();
    final data = await pb.getQuestions(widget.category);
    setState(() {
      _records = data.map((r) => Question.fromRecord(r.data)).toList();
    });
  }

  void _addQuestion() async {
    final controller = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('เพิ่มคำถาม'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'พิมพ์คำถามใหม่'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('ยกเลิก')),
          TextButton(onPressed: () => Navigator.pop(context, controller.text), child: const Text('บันทึก')),
        ],
      ),
    );
    if (result != null && result.trim().isNotEmpty) {
      await pb.addQuestion(widget.category, result.trim());
      _loadQuestions();
    }
  }

  void _editQuestion(Question record) async {
    final controller = TextEditingController(text: record.text);
    final result = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('แก้ไขคำถาม'),
        content: TextField(controller: controller),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('ยกเลิก')),
          TextButton(onPressed: () => Navigator.pop(context, controller.text), child: const Text('บันทึก')),
        ],
      ),
    );
    if (result != null && result.trim().isNotEmpty) {
      await pb.updateQuestion(record.id, result.trim());
      _loadQuestions();
    }
  }

  void _deleteQuestion(Question record) async {
    await pb.deleteQuestion(record.id);
    _loadQuestions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('แก้ไขคำถาม (${widget.category})'),
        backgroundColor: widget.color,
      ),
      body: _records.isEmpty
          ? const Center(child: Text('ยังไม่มีคำถามในหมวดนี้'))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _records.length,
              itemBuilder: (_, i) {
                final record = _records[i];
                return Card(
                  color: Colors.white,
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: Colors.grey.shade700, width: 1),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    child: Row(
                      children: [
                        Expanded(child: Text(record.text)),
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _editQuestion(record),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteQuestion(record),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addQuestion,
        backgroundColor: widget.color,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}
