import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/question.dart';

class QuestionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Soru ekleme fonksiyonu
  Future<void> addQuestion(Question question) async {
    await _firestore.collection('questions').add(question.toMap());
  }

  // Soruları çekme fonksiyonu
  Future<List<Question>> getQuestions() async {
    final snapshot = await _firestore.collection('questions').get();
    if (snapshot.docs.isEmpty) {
      return []; // Eğer belgeler yoksa boş liste döndür
    }
    return snapshot.docs.map((doc) {
      return Question.fromMap(doc.id, doc.data() as Map<String, dynamic>);
    }).toList();
  }

}
