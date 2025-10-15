import 'package:pocketbase/pocketbase.dart';

class PbService {
  final PocketBase pb = PocketBase('http://127.0.0.1:8090'); 

  Future<void> init() async {
    try {
      await pb.admins.authWithPassword('admin@gmail.com', 'en12345678');
    } catch (e) {
    }
  }

  Future<void> addQuestion(String category, String question) async {
    try {
      await pb.collection('questions').create(body: {
        'category': category,
        'text': question,
        'favorite': false,
      });
      print('✅ เพิ่มคำถามใหม่สำเร็จ');
    } catch (e) {
      print('❌ เพิ่มคำถามล้มเหลว: $e');
      rethrow;
    }
  }

  Future<List<RecordModel>> getQuestionsByCategory(String category) async {
    try {
      final result = await pb.collection('questions').getFullList(
        batch: 50,
        filter: 'category="$category"',
        sort: '-created',
      );
      return result;
    } catch (e) {
      print('❌ ดึงคำถามล้มเหลว: $e');
      rethrow;
    }
  }

  Future<List<RecordModel>> getQuestions(String category) async {
    try {
      final result = await pb.collection('questions').getFullList(
        batch: 50,
        filter: category == 'ทั้งหมด' ? null : 'category="$category"',
        sort: '-created',
      );
      return result;
    } catch (e) {
      print('❌ ดึงคำถามทั้งหมดล้มเหลว: $e');
      rethrow;
    }
  }

  // ✅ อัปเดตคำถาม
  Future<void> updateQuestion(String id, String newText) async {
    try {
      await pb.collection('questions').update(id, body: {
        'text': newText,
      });
      print('✅ อัปเดตคำถามสำเร็จ');
    } catch (e) {
      print('❌ อัปเดตคำถามล้มเหลว: $e');
      rethrow;
    }
  }

  // ✅ ลบคำถาม
  Future<void> deleteQuestion(String id) async {
    try {
      await pb.collection('questions').delete(id);
      print('🗑️ ลบคำถามสำเร็จ');
    } catch (e) {
      print('❌ ลบคำถามล้มเหลว: $e');
      rethrow;
    }
  }
}
