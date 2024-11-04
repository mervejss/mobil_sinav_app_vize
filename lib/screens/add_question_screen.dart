import 'package:flutter/material.dart';
import '../models/question.dart';
import '../services/question_service.dart';

class AddQuestionScreen extends StatefulWidget {
  @override
  _AddQuestionScreenState createState() => _AddQuestionScreenState();
}

class _AddQuestionScreenState extends State<AddQuestionScreen> {
  final QuestionService _questionService = QuestionService();
  final TextEditingController _questionController = TextEditingController();
  List<TextEditingController> _optionControllers = [];
  String _questionType = 'Çoktan Seçmeli';
  bool _allowMultipleSelection = false;
  List<int> _selectedCorrectOptionIndices = [];

  @override
  void dispose() {
    _questionController.dispose();
    for (var controller in _optionControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addOptionField() {
    setState(() {
      _optionControllers.add(TextEditingController());
    });
  }

  void _removeOptionField(int index) {
    setState(() {
      _optionControllers.removeAt(index);
      _selectedCorrectOptionIndices.remove(index);
    });
  }

  void _toggleCorrectOption(int index) {
    setState(() {
      if (_allowMultipleSelection) {
        // Çoklu seçim izin veriliyorsa doğru cevap olarak ekleyip çıkarabilsin
        if (_selectedCorrectOptionIndices.contains(index)) {
          _selectedCorrectOptionIndices.remove(index);
        } else {
          _selectedCorrectOptionIndices.add(index);
        }
      } else {
        // Tek seçim varsa sadece bir doğru cevap seçebilsin
        _selectedCorrectOptionIndices = [index];
      }
    });
  }
  void _addQuestion() {
    final question = Question(
      id: '',
      questionText: _questionController.text,
      options: _optionControllers.map((e) => e.text).toList(),
      correctAnswer: (_questionType == 'Çoktan Seçmeli' && _selectedCorrectOptionIndices.isNotEmpty)
          ? _selectedCorrectOptionIndices.map((index) => _optionControllers[index].text).join(", ")
          : '',
      isMultipleChoice: _questionType == 'Çoktan Seçmeli',
      isMultiAnswer: _allowMultipleSelection,
      isOpenEnded: _questionType == 'Açık Uçlu',
    );

    _questionService.addQuestion(question).then((_) {
      // Soru ekleme başarılı olduğunda yapılacak işlemler
      Navigator.pop(context);
    }).catchError((error) {
      // Hata durumunda yapılacak işlemler
      print("Soru eklenirken hata oluştu: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(title: Text('Soru Ekle',
        style: TextStyle(color: Colors.white),
      ),
        backgroundColor:  Color(0xFF6650A4),
      ),
      body: Container(

        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),

          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButton<String>(
                  value: _questionType,


                  items: [
                    DropdownMenuItem(value: 'Çoktan Seçmeli', child: Text('Çoktan Seçmeli')),
                    DropdownMenuItem(value: 'Açık Uçlu', child: Text('Açık Uçlu')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _questionType = value!;
                      _optionControllers.clear();
                      _selectedCorrectOptionIndices.clear();
                    });
                  },
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _questionController,
                  decoration: InputDecoration(labelText: 'Soru metni',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),

                if (_questionType == 'Çoktan Seçmeli') ...[
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Text('Birden çok seçenek seçimine izin verilsin mi?'),
                      Checkbox(
                        value: _allowMultipleSelection,
                        onChanged: (value) {
                          setState(() {
                            _allowMultipleSelection = value!;
                            _selectedCorrectOptionIndices.clear();
                          });
                        },
                      ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFF6650A4),width: 2
                        )),
                    padding: EdgeInsetsDirectional.all(10),
                    child: Column(

                      children: _optionControllers.asMap().entries.map((entry) {
                        int index = entry.key;
                        return Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: entry.value,
                                decoration: InputDecoration(labelText: 'Seçenek ${index + 1}'),
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.check_circle,
                                color: _selectedCorrectOptionIndices.contains(index) ? Colors.green : Colors.grey,
                              ),
                              onPressed: () => _toggleCorrectOption(index),
                            ),
                            IconButton(
                              icon: Icon(Icons.remove),
                              onPressed: () => _removeOptionField(index),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _addOptionField,
                    child: Text('Seçenek Ekle'),
                  ),
                ] else if (_questionType == 'Açık Uçlu') ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(
                      'Bu soru açık uçludur, doğru cevap alanı yoktur.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _addQuestion(); // Call the new method

                  },
                  child: Center(child: Text('Soruyu Ekle')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
