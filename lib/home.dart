import 'package:flutter/material.dart';
import 'data/questions.dart';
import 'question_page.dart';
import 'widgets/category_card.dart';

class IceBreakerHome extends StatelessWidget {
  const IceBreakerHome({super.key});

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
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                        '💡 เลือกหมวดที่ชอบแล้วสุ่มคำถามได้เลย!',
                        style: TextStyle(fontSize: 14, color: Colors.black87),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Expanded(
                      child: GridView.builder(
                        itemCount: categoryIcons.length,
                        gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: cross,
                          crossAxisSpacing: 18,
                          mainAxisSpacing: 18,
                          childAspectRatio: 0.65,
                        ),
                        itemBuilder: (context, i) {
                          final cat = categoryIcons.keys.elementAt(i);
                          return CategoryCard(
                            color: categoryColors[cat]!,
                            icon: categoryIcons[cat]!,
                            title: cat,
                            description: categoryDesc[cat]!,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => QuestionPage(
                                    category: cat,
                                    questions: questions[cat]!,
                                    icon: categoryIcons[cat]!,
                                    color: categoryColors[cat]!,
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
