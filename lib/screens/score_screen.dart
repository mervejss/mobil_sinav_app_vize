import 'package:flutter/material.dart';


// Sınav sonuçlarını gösteren ekran için StatelessWidget sınıfı
class ScoreScreen extends StatelessWidget {


  // Kullanıcı ID'si, oturum açmış kullanıcıya göre değiştirilmeli
  final String userId = 'currentUserId';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Uygulama çubuğunda 'Sınav Sonuçları' başlığını gösteriyoruz
      appBar: AppBar(
        title: Text('Sınav Sonuçları'),
        backgroundColor: Color(0xFF6650A4),
      ),
        body: Text("CEVAPLAR VE SKOR BURADA LİSTELENECEK")
    );
  }
}
