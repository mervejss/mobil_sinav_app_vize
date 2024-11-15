import 'package:cloud_firestore/cloud_firestore.dart';  // Firebase Firestore paketini import ediyoruz.
import '../models/question.dart';  // Question modelini import ediyoruz.

class QuestionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;  // Firestore instance'ını başlatıyoruz.

  // Soru ekleme fonksiyonu
  Future<void> addQuestion(Question question) async {
    // 'questions' koleksiyonuna yeni bir soru ekliyoruz. 'question.toMap()' ile Question modelini Map formatına dönüştürüyoruz.
    await _firestore.collection('questions').add(question.toMap());
  }

  // Soruları çekme fonksiyonu
  Future<List<Question>> getQuestions() async {
    // Firestore'dan 'questions' koleksiyonundaki tüm belgeleri çekiyoruz.
    final snapshot = await _firestore.collection('questions').get();

    if (snapshot.docs.isEmpty) {
      // Eğer hiç soru yoksa boş bir liste döndürüyoruz.
      return [];
    }

    // Her bir belgeyi 'Question' modeline dönüştürüp listeye ekliyoruz.
    return snapshot.docs.map((doc) {
      return Question.fromMap(doc.id, doc.data() as Map<String, dynamic>);
    }).toList();
  }

  // Kullanıcı cevaplarını saklama ya da güncelleme fonksiyonu
  Future<void> saveOrUpdateAnswer(String userId, String questionId, List<String> answers) async {
    // 'answers' koleksiyonunda kullanıcıya ait bir belge oluşturuyoruz. Belgeyi kullanıcı ID'si ve soru ID'si ile eşliyoruz.
    final answerDoc = _firestore
        .collection('answers')
        .doc(userId) // Kullanıcı ID'sini belirliyoruz.
        .collection('userAnswers')
        .doc(questionId); // Her soru için ayrı bir belge oluşturuyoruz.

    final snapshot = await answerDoc.get();  // Belgenin var olup olmadığını kontrol ediyoruz.

    if (snapshot.exists) {
      // Eğer belge zaten mevcutsa, cevapları ve güncellenme zamanını güncelliyoruz.
      await answerDoc.update({
        'answers': answers,  // Yeni cevapları ekliyoruz.
        'updatedAt': FieldValue.serverTimestamp(),  // Güncelleme zamanını ekliyoruz.
      });
    } else {
      // Eğer belge yoksa, yeni bir belge ekliyoruz.
      await answerDoc.set({
        'questionId': questionId,  // Soru ID'sini ekliyoruz.
        'answers': answers,  // Cevapları ekliyoruz.
        'createdAt': FieldValue.serverTimestamp(),  // Oluşturulma zamanını ekliyoruz.
        'updatedAt': FieldValue.serverTimestamp(),  // Güncelleme zamanını ekliyoruz.
      });
    }
  }

  // Kullanıcı cevaplarını ve puanını saklama ya da güncelleme fonksiyonu
  Future<void> saveOrUpdateAnswerWithScore(String userId, String questionId, List<String> answers, double score) async {
    // Cevapları ve puanı saklamak için aynı yapıyı kullanıyoruz, ancak bu kez cevaplarla birlikte puan da ekliyoruz.
    final answerDoc = _firestore
        .collection('answers')
        .doc(userId) // Kullanıcı ID'sini belirliyoruz.
        .collection('userAnswers')
        .doc(questionId); // Soru ID'sini belirliyoruz.

    final snapshot = await answerDoc.get();  // Belgenin var olup olmadığını kontrol ediyoruz.

    if (snapshot.exists) {
      // Eğer belge varsa, cevapları, puanı ve güncellenme zamanını güncelliyoruz.
      await answerDoc.update({
        'answers': answers,  // Yeni cevapları ekliyoruz.
        'score': score,  // Puanı ekliyoruz.
        'updatedAt': FieldValue.serverTimestamp(),  // Güncellenme zamanını ekliyoruz.
      });
    } else {
      // Eğer belge yoksa, yeni bir belge oluşturuyoruz.
      await answerDoc.set({
        'questionId': questionId,  // Soru ID'sini ekliyoruz.
        'answers': answers,  // Cevapları ekliyoruz.
        'score': score,  // Puanı ekliyoruz.
        'createdAt': FieldValue.serverTimestamp(),  // Oluşturulma zamanını ekliyoruz.
        'updatedAt': FieldValue.serverTimestamp(),  // Güncellenme zamanını ekliyoruz.
      });
    }
  }

  // Soru güncelleme fonksiyonu
  Future<void> updateQuestion(Question question) async {
    // 'questions' koleksiyonunda, verilen 'question.id' ile eşleşen belgeyi buluyoruz ve içeriğini güncelliyoruz.
    await _firestore.collection('questions').doc(question.id).update({
      'questionText': question.questionText,  // Sorunun metnini güncelliyoruz.
      'options': question.options,  // Seçenekleri güncelliyoruz.
      'correctAnswer': question.correctAnswer,  // Doğru cevabı güncelliyoruz.
      'isMultipleChoice': question.isMultipleChoice,  // Çoktan seçmeli olup olmadığını güncelliyoruz.
      'isMultiAnswer': question.isMultiAnswer,  // Çoklu cevaba izin verilip verilmediğini güncelliyoruz.
      'isOpenEnded': question.isOpenEnded,  // Açık uçlu soru olup olmadığını güncelliyoruz.
      'point': question.point,  // Sorunun puanını güncelliyoruz.
    });
  }
}
