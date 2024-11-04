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

  Future<void> saveOrUpdateAnswer(String userId, String questionId, List<String> answers) async {
    final answerDoc = _firestore
        .collection('answers')
        .doc(userId) // Kullanıcı ID'si ile cevapları saklayacağız
        .collection('userAnswers')
        .doc(questionId); // Her soru için ayrı belge

    final snapshot = await answerDoc.get();
    if (snapshot.exists) {
      // Güncelleme
      await answerDoc.update({
        'answers': answers,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } else {
      // Yeni ekleme
      await answerDoc.set({
        'questionId': questionId,
        'answers': answers,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }
  }
}
