import 'package:flutter/material.dart';
import '../models/question.dart'; // Question modelini içe aktar
import '../services/question_service.dart'; // QuestionService sınıfını içe aktar

class AddQuestionScreen extends StatefulWidget {
  final Question? question; // Optional olarak bir soru alıyoruz, var mı diye kontrol edeceğiz

  AddQuestionScreen({this.question}); // Constructor ile soru alabiliyoruz

  @override
  _AddQuestionScreenState createState() => _AddQuestionScreenState(); // StatefulWidget için state oluşturuluyor
}

class _AddQuestionScreenState extends State<AddQuestionScreen> {
  final QuestionService _questionService = QuestionService(); // QuestionService nesnesi oluşturuluyor
  final TextEditingController _questionController = TextEditingController(); // Soru metni için controller
  final TextEditingController _pointController = TextEditingController(); // Puan için controller

  List<TextEditingController> _optionControllers = []; // Seçenekler için controller'lar listesi
  String _questionType = 'Çoktan Seçmeli'; // Soru tipi (default: çoktan seçmeli)
  bool _allowMultipleSelection = false; // Birden fazla seçim yapılmasına izin verme
  List<int> _selectedCorrectOptionIndices = []; // Seçilen doğru seçeneklerin indekslerini tutan liste

  @override
  void initState() {
    super.initState();

    // Eğer widget.question null değilse (yani bir soru düzenleniyorsa), o zaman veriler yüklenir
    if (widget.question != null) {
      _questionController.text = widget.question!.questionText; // Soru metni yükleniyor
      _pointController.text = widget.question!.point.toString(); // Puan yükleniyor
      _questionType = widget.question!.isMultipleChoice ? 'Çoktan Seçmeli' : 'Açık Uçlu'; // Soru tipi belirleniyor
      _allowMultipleSelection = widget.question!.isMultiAnswer; // Çoklu seçim izni belirleniyor

      // Sorunun seçeneklerini controller'lara yükleme
      for (var option in widget.question!.options) {
        _optionControllers.add(TextEditingController(text: option));
      }

      // Eğer soru çoktan seçmeli ise doğru seçeneklerin indeksleri yükleniyor
      if (widget.question!.isMultipleChoice) {
        _selectedCorrectOptionIndices = widget.question!.correctAnswer
            .split(', ') // Doğru cevapları virgülle ayır
            .map((answer) => widget.question!.options.indexOf(answer)) // Seçeneklerin indekslerini al
            .toList();
      }
    }
  }

  @override
  void dispose() {
    // Bu widget yok olurken tüm controller'ları temizle
    _questionController.dispose();
    for (var controller in _optionControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  // Seçenek alanı eklemek için fonksiyon
  void _addOptionField() {
    setState(() {
      _optionControllers.add(TextEditingController()); // Yeni bir seçenek ekleniyor
    });
  }

  // Seçenek alanını silmek için fonksiyon
  void _removeOptionField(int index) {
    setState(() {
      _optionControllers.removeAt(index); // Seçeneği listeden çıkar
      _selectedCorrectOptionIndices.remove(index); // Doğru seçeneklerden de çıkart
    });
  }

  // Bir seçeneği doğru seçenek olarak işaretlemek ya da işaretini kaldırmak için fonksiyon
  void _toggleCorrectOption(int index) {
    setState(() {
      if (_allowMultipleSelection) {
        // Çoklu seçim izni varsa, doğru seçeneği ekleyip çıkarabilirsin
        if (_selectedCorrectOptionIndices.contains(index)) {
          _selectedCorrectOptionIndices.remove(index);
        } else {
          _selectedCorrectOptionIndices.add(index);
        }
      } else {
        // Eğer tek seçimse, sadece bir doğru cevap olabilir
        _selectedCorrectOptionIndices = [index];
      }
    });
  }

  // Yeni soru eklemek için fonksiyon
  void _addQuestion() {
    final question = Question(
      id: '', // Yeni soru olduğunda id boş gelir
      questionText: _questionController.text, // Soru metnini al
      options: _optionControllers.map((e) => e.text).toList(), // Seçenekleri al
      correctAnswer: (_questionType == 'Çoktan Seçmeli' && _selectedCorrectOptionIndices.isNotEmpty)
          ? _selectedCorrectOptionIndices.map((index) => _optionControllers[index].text).join(", ") // Doğru cevapları al
          : '',
      isMultipleChoice: _questionType == 'Çoktan Seçmeli', // Çoktan seçmeli mi?
      isMultiAnswer: _allowMultipleSelection, // Birden fazla seçenek seçilebilir mi?
      isOpenEnded: _questionType == 'Açık Uçlu', // Açık uçlu soru mu?
      point: int.tryParse(_pointController.text) ?? 0, // Puanı al, geçersizse 0 olarak ayarla
    );

    _questionService.addQuestion(question).then((_) {
      // Soru ekleme başarılı olursa
      Navigator.pop(context); // Sayfayı geri kapat
    }).catchError((error) {
      // Hata durumunda
      print("Soru eklenirken hata oluştu: $error");
    });
  }

  // Var olan soruyu güncellemek için fonksiyon
  void _updateQuestion() {
    if (widget.question == null) return;

    final updatedQuestion = widget.question!.copyWith(
      questionText: _questionController.text, // Soru metnini güncelle
      options: _optionControllers.map((e) => e.text).toList(), // Seçenekleri güncelle
      correctAnswer: (_questionType == 'Çoktan Seçmeli' && _selectedCorrectOptionIndices.isNotEmpty)
          ? _selectedCorrectOptionIndices.map((index) => _optionControllers[index].text).join(", ") // Doğru cevapları güncelle
          : '',
      isMultipleChoice: _questionType == 'Çoktan Seçmeli', // Çoktan seçmeli mi?
      isMultiAnswer: _allowMultipleSelection, // Birden fazla seçenek seçilebilir mi?
      isOpenEnded: _questionType == 'Açık Uçlu', // Açık uçlu soru mu?
      point: int.tryParse(_pointController.text) ?? 0, // Puanı güncelle
    );

    _questionService.updateQuestion(updatedQuestion).then((_) {
      Navigator.pop(context); // Güncelleme başarılıysa geri dön
    }).catchError((error) {
      print("Soru güncellenirken hata oluştu: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Sayfa başlığı ve stilini ayarlıyoruz
      appBar: AppBar(
        title: Text('Soru Ekle',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF6650A4), // Başlık barı rengi
      ),
      body: Container(
        // Sayfa içeriği
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Soru tipi dropdown menüsü
                DropdownButton<String>(
                  value: _questionType,
                  items: [
                    DropdownMenuItem(value: 'Çoktan Seçmeli', child: Text('Çoktan Seçmeli')),
                    DropdownMenuItem(value: 'Açık Uçlu', child: Text('Açık Uçlu')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _questionType = value!; // Yeni soru tipi seçildiğinde güncelle
                      _optionControllers.clear(); // Seçenekleri sıfırla
                      _selectedCorrectOptionIndices.clear(); // Doğru seçenekleri sıfırla
                    });
                  },
                ),
                SizedBox(height: 20),
                // Soru metni için TextField
                TextField(
                  controller: _questionController,
                  decoration: InputDecoration(
                    labelText: 'Soru metni',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                // Puan için TextField
                TextField(
                  controller: _pointController, // Puan giriş alanı
                  keyboardType: TextInputType.number, // Sayısal klavye açılır
                  decoration: InputDecoration(
                    labelText: 'Puan',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                // Eğer soru çoktan seçmeli ise seçenekler gösterilsin
                if (_questionType == 'Çoktan Seçmeli') ...[
                  SizedBox(height: 20),
                  // Çoklu seçenek izni
                  Row(
                    children: [
                      Text('Birden çok seçenek seçimine izin verilsin mi?'),
                      Checkbox(
                        value: _allowMultipleSelection, // Çoklu seçim izni
                        onChanged: (value) {
                          setState(() {
                            _allowMultipleSelection = value!; // İzin durumunu güncelle
                          });
                        },
                      ),
                    ],
                  ),
                  // Container widget'ı, tüm seçeneklerin yer aldığı bölgeyi sarar ve sınırları çizer.
                  Container(
                    decoration: BoxDecoration(
                      // BoxDecoration, kenarlık rengi ve kalınlığını ayarlar
                      border: Border.all(color: Color(0xFF6650A4), width: 2),
                    ),
                    padding: EdgeInsetsDirectional.all(10), // Padding, tüm kenarlarda 10 birim boşluk bırakır
                    child: Column(
                      // Column widget'ı, tüm çocuk widget'ları dikey olarak sıralar
                      children: _optionControllers.asMap().entries.map((entry) {
                        // _optionControllers, metin alanlarının kontrolcülerini içerir ve her biri için bir giriş yapar
                        int index = entry.key; // entry.key, mevcut seçeneğin indeksini alır
                        return Row(
                          // Row widget'ı, öğeleri yatayda hizalar
                          children: [
                            Expanded(
                              // Expanded widget'ı, TextField'ın mevcut alanı en iyi şekilde kullanmasını sağlar
                              child: TextField(
                                controller: entry.value, // entry.value, her bir TextField için kontrolcü
                                decoration: InputDecoration(labelText: 'Seçenek ${index + 1}'),
                                // TextField etiketini "Seçenek 1", "Seçenek 2" vs. olarak ayarlar
                              ),
                            ),
                            IconButton(
                              // IconButton, seçenek için onay işareti ekler
                              icon: Icon(
                                Icons.check_circle,
                                color: _selectedCorrectOptionIndices.contains(index) ? Colors.green : Colors.grey,
                                // Eğer seçenek doğru seçeneklerden biri ise yeşil, değilse gri renk gösterilir
                              ),
                              onPressed: () => _toggleCorrectOption(index),
                              // Bu butona basıldığında, _toggleCorrectOption fonksiyonu çağrılır
                            ),
                            IconButton(
                              // IconButton, seçenek alanını silmek için bir çarpı işareti gösterir
                              icon: Icon(Icons.remove),
                              onPressed: () => _removeOptionField(index),
                              // Bu butona basıldığında, _removeOptionField fonksiyonu çağrılır ve ilgili seçenek silinir
                            ),
                          ],
                        );
                      }).toList(), // Her seçenek için bu işlemi tekrar ederiz
                    ),
                  ),
// Aradaki boşluğu ayarlamak için SizedBox eklenir.
                  SizedBox(height: 10),

// Yeni bir seçenek eklemek için bir buton eklenir.
                  ElevatedButton(
                    onPressed: _addOptionField, // Butona basıldığında _addOptionField fonksiyonu çalışır
                    child: Text('Seçenek Ekle'), // Butonun etiketini 'Seçenek Ekle' olarak ayarlar
                  ),

// Eğer soru tipi 'Açık Uçlu' ise aşağıdaki widget gösterilir.
                ] else if (_questionType == 'Açık Uçlu') ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    // Açık uçlu sorunun uyarı metnini ve stilini ayarlıyoruz
                    child: Text(
                      'Bu soru açık uçludur, doğru cevap alanı yoktur.',
                      style: TextStyle(color: Colors.grey), // Yazı rengini gri yapıyoruz
                    ),
                  ),
                ],
                SizedBox(height: 20),

// Soruyu eklemek ya da güncellemek için bir buton eklenir.
                ElevatedButton(
                  onPressed: widget.question != null ? _updateQuestion : _addQuestion,
                  // Eğer mevcut bir soru varsa, 'Soruyu Güncelle' butonuna basılır, yoksa 'Soruyu Ekle' butonuna basılır
                  child: Center(child: Text(widget.question != null ? 'Soruyu Güncelle' : 'Soruyu Ekle')),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
