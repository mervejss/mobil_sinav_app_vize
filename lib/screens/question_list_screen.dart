// Flutter material kütüphanesini import ediyoruz, bu kütüphane widget'ları ve tema desteği sağlar.
import 'package:flutter/material.dart';

// Soruları eklemek için kullanılan ekranı import ediyoruz, bu ekranda soruları düzenleyebiliriz.
import 'package:mobil_sinav_app/screens/add_question_screen.dart'; // Firestore'ı ekleyin

// QuestionListScreen widget'ını oluşturuyoruz. Bu widget, eklenen soruların listelendiği ekranı temsil eder.
class QuestionListScreen extends StatefulWidget {
  // Stateful widget olduğu için createState fonksiyonu ile state sınıfı oluşturuyoruz.
  @override
  _QuestionListScreenState createState() => _QuestionListScreenState();
}

// Soruların listelendiği ekranın durumunu yöneten State sınıfı.
class _QuestionListScreenState extends State<QuestionListScreen> {

  @override
  void initState() {
    super.initState();

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Scaffold widget'ı, temel ekran yapısını sağlar. Burada app bar ve body kısmı var.
      appBar: AppBar(
        title: Text('Eklenen Sorular', style: TextStyle(color: Colors.white)), // AppBar başlığını belirliyoruz.
        backgroundColor: Color(0xFF6650A4), // AppBar arka plan rengini belirliyoruz.
      ),
      // Sorular veritabanından asenkron olarak yüklenecek, bu yüzden FutureBuilder widget'ı kullanıyoruz.
        body: Text("SORULAR BURADA LİSTELENECEK VE GÜNCELLENEBİLECEKTİR.")

    );
  }
}
