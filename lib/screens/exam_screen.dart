import 'package:flutter/material.dart'; // Flutter'dan Material Design widget'larını ve özelliklerini kullanmak için gerekli paket.
import 'package:mobil_sinav_app/screens/question_card.dart'; // Soru kartlarını göstermek için QuestionCard widget'ını içe aktarıyoruz.

class ExamScreen extends StatefulWidget {

  // Kullanıcı ID'si, şu anki kullanıcıyı temsil eder. Burada hardcoded bir değer kullanıyoruz.
  final String userId = 'currentUserId';

  @override
  _ExamScreenState createState() => _ExamScreenState(); // ExamScreen için durumu yöneten _ExamScreenState sınıfını oluşturuyoruz.
}

class _ExamScreenState extends State<ExamScreen> {
  // Soruların her birinin durumunu saklamak için bir liste oluşturuyoruz.
  final List<QuestionCardState> _questionStates = [];

  

  // Ekran görselini oluşturan build metodu.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sınav Ekranı', // App bar'da başlık
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF6650A4), // App bar arka plan rengini ayarlıyoruz.
        actions: [
          // Sağ üst köşede kaydetme ikonuna tıklanınca cevapları kaydetme işlemi başlatılıyor.
          IconButton(
            icon: Icon(Icons.save, color: Colors.white), // Kaydet ikonunu gösteriyoruz.
            onPressed: () {}, // Tıklanıldığında save confirmation dialog'ını gösteriyoruz.
          ),
        ],
      ),
      body: Text("SORULAR BURADA LİSTELENECEK")
    );
  }
}
