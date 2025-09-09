import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:share_plus/share_plus.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(const IceBreakerApp());
}

class IceBreakerApp extends StatelessWidget {
  const IceBreakerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IceBreakerCard',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFFA7C7),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          foregroundColor: Colors.white,
          elevation: 4,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFD95C8C),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFFD95C8C),
            side: const BorderSide(color: Color(0xFFD95C8C)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontSize: 14, color: Colors.black87),
          titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        cardTheme: const CardThemeData(
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          margin: EdgeInsets.all(8),
          color: Colors.white,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const IceBreakerHome(),
    );
  }
}

/// การ์ดหมวดหมู่
class CategoryCard extends StatelessWidget {
  const CategoryCard({
    super.key,
    required this.color,
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  final Color color;
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Container(
          width: 100,
          height: 200,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                blurRadius: 10,
                spreadRadius: -2,
                color: Colors.black.withOpacity(0.15),
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Container(
                width: 200,
                height: 200,
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.7),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Icon(icon, color: color, size: 60),
              ),
              Text(
                description,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// หน้าเลือกหมวด
class IceBreakerHome extends StatefulWidget {
  const IceBreakerHome({super.key});
  @override
  State<IceBreakerHome> createState() => _IceBreakerHomeState();
}

class _IceBreakerHomeState extends State<IceBreakerHome> {
  final Map<String, IconData> _categoryIcons = {
    'ทั่วไป': Icons.grid_3x3,
    'ผ่อนคลาย': Icons.sentiment_satisfied_alt,
    'การงาน/เรียน': Icons.book,
    'ทัศนคติ/ความคิด': Icons.person,
  };

  final Map<String, Color> _categoryColors = {
    'ทั่วไป': Colors.lightBlue.shade300,
    'ผ่อนคลาย': Colors.orange.shade300,
    'การงาน/เรียน': Colors.teal.shade300,
    'ทัศนคติ/ความคิด': Colors.purple.shade300,
  };

  final Map<String, String> _categoryDesc = {
    'ทั่วไป': 'คำถามเบสิกสำหรับเริ่มสนทนา',
    'ผ่อนคลาย': 'คำถามสนุก ผ่อนคลาย เล่นกับเพื่อน',
    'การงาน/เรียน': 'เกี่ยวกับงานหรือการเรียน',
    'ทัศนคติ/ความคิด': 'ถามเพื่อสะท้อนตัวตน มุมมองความคิด',
  };

  final Map<String, List<String>> _questions = {
    'ทั่วไป': [
      'วันนี้คุณดีลกับความเครียดยังไง?',
      'อาหารจานโปรดคืออะไร แล้วทำไมถึงชอบ?',
      'ถ้าวันนี้หยุด 1 วัน คุณจะทำอะไรเป็นอย่างแรก?',
      'คอนเทนต์ที่เสพบ่อยที่สุดตอนนี้คืออะไร?',
      'สิ่งเล็ก ๆ ที่ทำให้คุณยิ้มวันนี้คืออะไร?',
    ],
    'การงาน/เรียน': [
      'ช่วงเวลาที่โฟกัสดีที่สุดของคุณคือกี่โมง?',
      'ถ้าได้เลือกสกิลใหม่ 1 อย่างสำหรับงาน/เรียน คุณจะเลือกอะไร?',
    ],
    'ผ่อนคลาย': [
      'หนัง/ซีรีส์เรื่องไหนที่คุณดูซ้ำได้ไม่เบื่อ?',
      'เพลงประจำช่วงนี้ของคุณคือเพลงอะไร?',
    ],
    'ทัศนคติ/ความคิด': [
      'ค่านิยม 3 อย่างที่บอกว่า “นี่แหละคุณ” คืออะไร?',
      'คำแนะนำที่มีค่าที่สุดที่เคยได้รับคืออะไร?',
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IceBreakerCard'),
        backgroundColor: Colors.pink.shade300,
      ),
      body: LayoutBuilder(
        builder: (_, c) {
          final isWide = c.maxWidth >= 1000;
          final cross = isWide ? 4 : (c.maxWidth >= 600 ? 3 : 2);

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1100),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'เลือกหมวดคำถาม',
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFE0F0),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        '💡 ถ้าคุณอยากทำความรู้กับใคร แต่ไม่รู้จะเริ่มยังไง แค่เลือกหมวดที่ชอบแล้วสุ่มคำถามกันเลย!',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                          height: 1.4,
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Expanded(
                      child: GridView.builder(
                        itemCount: _categoryIcons.length,
                        gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: cross,
                          crossAxisSpacing: 18,
                          mainAxisSpacing: 18,
                          childAspectRatio: 0.65,
                        ),
                        itemBuilder: (context, i) {
                          final cat = _categoryIcons.keys.elementAt(i);
                          return CategoryCard(
                            color: _categoryColors[cat]!,
                            icon: _categoryIcons[cat]!,
                            title: cat,
                            description: _categoryDesc[cat]!,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => QuestionPage(
                                    category: cat,
                                    questions: _questions[cat]!,
                                    icon: _categoryIcons[cat]!,
                                    color: _categoryColors[cat]!,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// หน้าคำถาม
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
  String? _currentQuestion;

  List<String> get _favorites =>
      List<String>.from(_box.read('favorite_questions') ?? []);

  @override
  void initState() {
    super.initState();
    _currentQuestion = _pickRandom();
  }

  String _pickRandom() {
    return widget.questions[_rnd.nextInt(widget.questions.length)];
  }

  void _shuffle() {
    setState(() {
      _currentQuestion = _pickRandom();
    });
  }

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

  void _share(String question) async {
    await Share.share('IceBreaker: $question');
  }

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
                  child: Text(
                      'ยังไม่มีรายการโปรด ลองกดรูปหัวใจที่คำถามที่ชอบดูสิ'),
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
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 600),
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    final rotateAnim = Tween(begin: pi, end: 0.0).animate(animation);
                    return AnimatedBuilder(
                      animation: rotateAnim,
                      child: child,
                      builder: (context, child) {
                        final isUnder = (child!.key != ValueKey(question));
                        var tilt = (animation.value - 0.5).abs() - 0.5;
                        tilt *= isUnder ? -0.003 : 0.003;
                        final value = isUnder ? min(rotateAnim.value, pi / 2) : rotateAnim.value;
                        return Transform(
                          transform: Matrix4.rotationY(value)..setEntry(3, 0, tilt),
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
                    padding: const EdgeInsets.only(top: 40, left: 8, right: 8, bottom: 8),
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
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
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
                    _isFav(question) ? Icons.favorite : Icons.favorite_border,
                    color: Colors.white,
                  ),
                  style: IconButton.styleFrom(
                    backgroundColor: widget.color,
                  ),
                  tooltip:
                      _isFav(question) ? 'เอาออกจากโปรด' : 'บันทึกเป็นโปรด',
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
