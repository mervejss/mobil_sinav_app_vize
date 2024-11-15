// Flutter kütüphanesini import ediyoruz, kullanıcı arayüzünü oluşturabilmek için.
import 'package:flutter/material.dart';

// Soru kartını temsil eden StatefulWidget. Bu widget, bir sorunun hem metnini hem de seçeneklerini içerecek.
class QuestionCard extends StatefulWidget {



  // Widget'ın State'ini oluşturan fonksiyon. Bu, widget'ın durumunu yöneten sınıfı döndürür.
  @override
  QuestionCardState createState() => QuestionCardState();
}

// QuestionCard widget'ının durumunu yöneten State sınıfı.
class QuestionCardState extends State<QuestionCard> {
  // Kullanıcının seçtiği yanıtları tutan liste. Bu liste birden fazla cevap içerebilir.
  List<String> selectedAnswers = [];

  @override
  void initState() {
    super.initState();
  }

  // Widget'ı oluştururken kullanıcı arayüzü bileşenlerini döndüren build fonksiyonu.
  @override
  Widget build(BuildContext context) {
    return Card(
      // Kartın dikey ve yatayda boşluklarla etrafını sarmak için margin belirliyoruz.
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      // Kartın köşelerini yuvarlamak için rounded rectangle kullanıyoruz.
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Color(0xFF6650A4), width: 2),
      ),
      child: Padding(
        // Kartın içeriği etrafında 16 piksel boşluk bırakıyoruz.
        padding: EdgeInsets.all(16),
        child: Column(
          // Yatay eksende baştan başlayarak öğeleri sıralıyoruz.
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sorunun metnini ve puanını ekliyoruz.
            Text(
              'puan', // Soru metni ve puan bilgisi.
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // Yazı stilini belirliyoruz.
            ),
            // Soru metninden sonra boşluk bırakıyoruz.
            SizedBox(height: 10),

              TextField(
                onChanged: (value) {
                  setState(() {
                    selectedAnswers = [value]; // Kullanıcı metin girdikçe seçilen yanıtı güncelliyoruz.
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Cevabınızı girin', // TextField için etiket metni.
                  border: OutlineInputBorder(), // TextField kenarlığını belirliyoruz.
                ),
              ),
          ],
        ),
      ),
    );
  }
}
