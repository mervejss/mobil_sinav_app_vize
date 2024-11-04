import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/question.dart';
import '../services/question_service.dart';

class ScoreScreen extends StatelessWidget {
  final QuestionService _questionService = QuestionService();
  final String userId = 'currentUserId'; // Kullanıcı ID'si oturum açmış kullanıcıya göre değiştirilmeli

  Future<List<Map<String, dynamic>>> _fetchResults() async {
    final questions = await _questionService.getQuestions();
    final userAnswersSnapshot = await FirebaseFirestore.instance
        .collection('answers')
        .doc(userId)
        .collection('userAnswers')
        .get();

    Map<String, List<String>> userAnswers = {
      for (var doc in userAnswersSnapshot.docs)
        doc.id: List<String>.from(doc.data()['answers']),
    };

    return questions.map((question) {
      return {
        'question': question,
        'userAnswer': userAnswers[question.id] ?? []
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sınav Sonuçları'),
        backgroundColor: Color(0xFF6650A4),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchResults(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Bir hata oluştu: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Henüz cevaplanmış soru yok.'));
          }

          final results = snapshot.data!;
          return ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              final question = results[index]['question'] as Question;
              final userAnswer = results[index]['userAnswer'] as List<String>;
              final correctAnswer = question.correctAnswer.split(',');

              final correctAnswersSet = correctAnswer.map((e) => e.trim()).toSet();
              final userAnswersSet = userAnswer.map((e) => e.trim()).toSet();

// Kullanıcının doğru cevabı tam olarak kontrol ediliyor
              bool isUserCorrect = correctAnswersSet.difference(userAnswersSet).isEmpty &&
                  userAnswersSet.difference(correctAnswersSet).isEmpty;

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
                      Text(
                        question.questionText,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Column(
                        children: question.options.map((option) {
                          bool isCorrect = correctAnswersSet.contains(option.trim());
                          bool isUserAnswer = userAnswersSet.contains(option.trim());
                          return ListTile(
                            title: Text(
                              option,
                              style: TextStyle(
                                color: isCorrect && isUserAnswer
                                    ? Colors.green
                                    : (!isCorrect && isUserAnswer ? Colors.red : Colors.black),
                              ),
                            ),
                            leading: isCorrect && isUserAnswer
                                ? Icon(Icons.check, color: Colors.green)
                                : (!isCorrect && isUserAnswer
                                ? Icon(Icons.close, color: Colors.red)
                                : null),
                          );
                        }).toList(),
                      ),
                      if (!isUserCorrect)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            'Doğru Cevap: ${correctAnswer.join(", ")}',
                            style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
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
