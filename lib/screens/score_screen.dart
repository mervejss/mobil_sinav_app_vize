import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/question.dart';
import '../services/question_service.dart';

// Sınav sonuçlarını gösteren ekran için StatelessWidget sınıfı
class ScoreScreen extends StatelessWidget {
  // QuestionService, soru verilerini almak ve işlemek için kullanılır.
  final QuestionService _questionService = QuestionService();

  // Kullanıcı ID'si, oturum açmış kullanıcıya göre değiştirilmeli
  final String userId = 'currentUserId';

  // Kullanıcının sonuçlarını ve doğru/yanlış cevapları almak için veritabanından sorgu yapar
  Future<List<Map<String, dynamic>>> _fetchResults() async {
    // Soruları almak için QuestionService kullanıyoruz
    final questions = await _questionService.getQuestions();

    // Kullanıcının cevaplarını almak için Firestore'dan 'answers' koleksiyonundan sorgu yapılır
    final userAnswersSnapshot = await FirebaseFirestore.instance
        .collection('answers')
        .doc(userId)
        .collection('userAnswers')
        .get();

    // Kullanıcı cevaplarını Map şeklinde hazırlıyoruz
    Map<String, List<String>> userAnswers = {
      for (var doc in userAnswersSnapshot.docs)
        doc.id: List<String>.from(doc.data()['answers']),
    };

    // Sonuçları saklayacağımız listeyi oluşturuyoruz
    List<Map<String, dynamic>> results = [];

    // Her bir soru için, kullanıcının cevabını ve doğru cevabını karşılaştırıp puan hesaplıyoruz
    for (var question in questions) {
      final userAnswer = userAnswers[question.id] ?? [];
      final correctAnswer = question.correctAnswer.split(',');

      // Doğru cevapları ve kullanıcı cevaplarını set'e çeviriyoruz
      final correctAnswersSet = correctAnswer.map((e) => e.trim()).toSet();
      final userAnswersSet = userAnswer.map((e) => e.trim()).toSet();

      // 1 doğru seçeneğin puanını hesaplıyoruz (doğru seçenek sayısına göre)
      double pointPerCorrectAnswer = question.point / correctAnswersSet.length;

      // Kullanıcının doğru cevap sayısını hesaplıyoruz
      int userCorrectCount = userAnswersSet.intersection(correctAnswersSet).length;

      // Kullanıcının toplam puanını hesaplıyoruz
      double userScore = userCorrectCount * pointPerCorrectAnswer;

      // Kullanıcı puanını Firestore'da saklıyoruz
      await _questionService.saveOrUpdateAnswerWithScore(userId, question.id, userAnswer, userScore);

      // Sonuçları listeye ekliyoruz
      results.add({
        'question': question,
        'userAnswer': userAnswer,
        'userScore': userScore,
      });
    }

    // Hesaplanan sonuçları döndürüyoruz
    return results;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Uygulama çubuğunda 'Sınav Sonuçları' başlığını gösteriyoruz
      appBar: AppBar(
        title: Text('Sınav Sonuçları'),
        backgroundColor: Color(0xFF6650A4),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        // Sonuçları beklerken kullanıcının cevaplarını almak için FutureBuilder kullanıyoruz
        future: _fetchResults(),
        builder: (context, snapshot) {
          // Veri yükleniyor ise bir yükleniyor göstergesi (CircularProgressIndicator) gösteriyoruz
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          // Eğer bir hata oluşursa, hatayı ekranda gösteriyoruz
          if (snapshot.hasError) {
            return Center(child: Text('Bir hata oluştu: ${snapshot.error}'));
          }
          // Eğer veri yoksa, henüz cevaplanmamış soru yok mesajını gösteriyoruz
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Henüz cevaplanmış soru yok.'));
          }

          // Veriler başarıyla alındıysa, sonuçları listeliyoruz
          final results = snapshot.data!;
          return ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              // Her bir soru ve sonuçları alıyoruz
              final question = results[index]['question'] as Question;
              final userAnswer = results[index]['userAnswer'] as List<String>;
              final correctAnswer = question.correctAnswer.split(',');
              final userScore = results[index]['userScore'] as double;

              // Doğru ve kullanıcı cevaplarını set'e çeviriyoruz
              final correctAnswersSet = correctAnswer.map((e) => e.trim()).toSet();
              final userAnswersSet = userAnswer.map((e) => e.trim()).toSet();

              // Kullanıcının doğru cevabını tam olarak kontrol ediyoruz
              bool isUserCorrect = correctAnswersSet.difference(userAnswersSet).isEmpty &&
                  userAnswersSet.difference(correctAnswersSet).isEmpty;

              // Sonuçları kart şeklinde gösteriyoruz
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: Color(0xFF6650A4), width: 2),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Sorunun metnini başlık olarak gösteriyoruz
                      Text(
                        question.questionText,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      // Seçenekleri listeliyoruz
                      Column(
                        children: question.options.map((option) {
                          bool isCorrect = correctAnswersSet.contains(option.trim());
                          bool isUserAnswer = userAnswersSet.contains(option.trim());

                          return ListTile(
                            title: Text(
                              option,
                              style: TextStyle(
                                color: isCorrect && isUserAnswer
                                    ? Colors.green  // Kullanıcı doğru cevabı işaretlediyse yeşil
                                    : (!isCorrect && isUserAnswer ? Colors.red : Colors.black),
                              ),
                            ),
                            leading: Icon(
                              // Eğer seçenek doğru ve kullanıcı doğru cevap verdiyse yeşil tik, yanlış cevap verdiğinde kırmızı çarpı, doğru cevaba pasif radio button ekle
                              isCorrect && isUserAnswer
                                  ? Icons.check
                                  : (!isCorrect && isUserAnswer
                                  ? Icons.close
                                  : Icons.radio_button_unchecked), // Pasif radio button
                              color: isCorrect && isUserAnswer
                                  ? Colors.green
                                  : (!isCorrect && isUserAnswer
                                  ? Colors.red
                                  : Colors.grey), // Pasif renk için gri
                            ),
                          );
                        }).toList(),
                      ),
                      // Kullanıcı doğru cevabı veremediyse doğru cevabı gösteriyoruz
                      if (!isUserCorrect)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            'Doğru Cevap: ${correctAnswer.join(", ")}',
                            style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                          ),
                        ),
                      // Kullanıcının puanını gösteriyoruz
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Puanınız: ${userScore.toStringAsFixed(2)}',
                          style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
