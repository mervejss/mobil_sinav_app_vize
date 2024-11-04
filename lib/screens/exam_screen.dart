import 'package:flutter/material.dart';
import 'package:mobil_sinav_app/models/question.dart';
import 'package:mobil_sinav_app/services/question_service.dart';

class ExamScreen extends StatefulWidget {
  final QuestionService _questionService = QuestionService();
  final String userId = 'currentUserId'; // Kullanıcı ID'si, oturum açmış kullanıcıya göre belirlenmeli

  @override
  _ExamScreenState createState() => _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> {
  final List<QuestionCardState> _questionStates = [];

  Future<void> saveAnswers() async {
    for (var questionCardState in _questionStates) {
      await widget._questionService.saveOrUpdateAnswer(
        widget.userId,
        questionCardState.widget.question.id,
        questionCardState.selectedAnswers,
      );
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Cevaplar kaydedildi!')),
    );
    Navigator.pop(context); // Ana sayfaya dön
  }

  Future<void> _showSaveConfirmationDialog() async {
    bool confirm = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Yanıtları Göndermek İstediğinize Emin misiniz?"),
          content: Text("Test yanıtlarınızı göndermek üzeresiniz. Onaylıyor musunuz?"),
          actions: [
            TextButton(
              child: Text("Hayır"),
              onPressed: () {
                Navigator.of(context).pop(false); // Save işlemini iptal et
              },
            ),
            TextButton(
              child: Text("Evet"),
              onPressed: () {
                Navigator.of(context).pop(true); // Save işlemini onayla
              },
            ),
          ],
        );
      },
    );
    if (confirm) {
      await saveAnswers();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sınav Ekranı',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF6650A4),
        actions: [
          IconButton(
            icon: Icon(Icons.save, color: Colors.white),
            onPressed: _showSaveConfirmationDialog,
          ),
        ],
      ),
      body: FutureBuilder<List<Question>>(
        future: widget._questionService.getQuestions(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Bir hata oluştu: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Henüz soru yok.'));
          }

          final questions = snapshot.data!;
          return ListView.builder(
            itemCount: questions.length,
            itemBuilder: (context, index) {
              final question = questions[index];
              final questionCard = QuestionCard(
                question: question,
                onInit: (QuestionCardState state) {
                  _questionStates.add(state); // State’i listeye ekle
                },
              );
              return questionCard;
            },
          );
        },
      ),
    );
  }
}

class QuestionCard extends StatefulWidget {
  final Question question;
  final void Function(QuestionCardState) onInit;

  QuestionCard({required this.question, required this.onInit});

  @override
  QuestionCardState createState() => QuestionCardState();
}

class QuestionCardState extends State<QuestionCard> {
  List<String> selectedAnswers = [];

  @override
  void initState() {
    super.initState();
    widget.onInit(this); // State’i ExamScreen’e bildir
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
