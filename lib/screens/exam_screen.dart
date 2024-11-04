import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/question.dart';
import '../services/question_service.dart';

class ExamScreen extends StatelessWidget {
  final QuestionService _questionService = QuestionService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sınav Ekranı'),
        backgroundColor: Color(0xFF6650A4),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              // KAYDET butonuna tıklanınca yapılacak işlemler
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Question>>(
        future: _questionService.getQuestions(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Bir hata oluştu: ${snapshot.error}')); // Hata mesajını göster
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Henüz soru yok.'));
          }

          final questions = snapshot.data!;
          return ListView.builder(
            itemCount: questions.length,
            itemBuilder: (context, index) {
              final question = questions[index];
              return QuestionCard(question: question);
            },
          );
        },
      ),

    );
  }
}

class QuestionCard extends StatefulWidget {
  final Question question;

  QuestionCard({required this.question});

  @override
  _QuestionCardState createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard> {
  List<String> selectedAnswers = [];

  @override
  Widget build(BuildContext context) {
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
              widget.question.questionText,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            if (widget.question.isMultipleChoice)
              Text(
                widget.question.isMultiAnswer
                    ? 'Birden çok cevap seçilebilir'
                    : 'Tek cevap seçilebilir',
                style: TextStyle(color: Colors.grey[600]),
              ),
            SizedBox(height: 10),
            if (widget.question.isMultipleChoice)
              ...widget.question.options.map((option) => CheckboxListTile(
                title: Text(option),
                value: selectedAnswers.contains(option),
                onChanged: widget.question.isMultiAnswer
                    ? (bool? value) {
                  setState(() {
                    if (value == true) {
                      selectedAnswers.add(option);
                    } else {
                      selectedAnswers.remove(option);
                    }
                  });
                }
                    : (bool? value) {
                  setState(() {
                    selectedAnswers = value == true ? [option] : [];
                  });
                },
              )),
            if (widget.question.isOpenEnded)
              TextField(
                onChanged: (value) {
                  setState(() {
                    selectedAnswers = [value];
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Cevabınızı girin',
                  border: OutlineInputBorder(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
