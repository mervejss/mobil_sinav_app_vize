import 'package:flutter/material.dart';
import 'package:mobil_sinav_app/models/question.dart';

class QuestionCard extends StatefulWidget {
  final Question question;

  QuestionCard({required this.question});

  @override
  _QuestionCardState createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard> {
  static List<_QuestionCardState> instances = [];
  List<String> selectedAnswers = [];

  @override
  void initState() {
    super.initState();
    instances.add(this); // Her yeni QuestionCard eklendiğinde listeye ekle
  }

  @override
  void dispose() {
    instances.remove(this); // Kart silindiğinde listeden çıkar
    super.dispose();
  }

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

