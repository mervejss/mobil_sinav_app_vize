// Flutter kütüphanesini import ediyoruz, kullanıcı arayüzünü oluşturabilmek için.
import 'package:flutter/material.dart';
// Uygulama içerisindeki 'Question' modelini import ediyoruz, çünkü her bir soru için bu modelin verilerine ihtiyacımız var.
import 'package:mobil_sinav_app/models/question.dart';

// Soru kartını temsil eden StatefulWidget. Bu widget, bir sorunun hem metnini hem de seçeneklerini içerecek.
class QuestionCard extends StatefulWidget {
  // 'Question' modelinden gelen bir soru objesi alıyoruz.
  final Question question;
  // State objesinin başlangıçta kullanılması için bir callback fonksiyonu alıyoruz.
  final void Function(QuestionCardState) onInit;

  // Yapıcı fonksiyon ile soru ve init callback fonksiyonunu alıyoruz.
  QuestionCard({required this.question, required this.onInit});

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
    // Widget ilk kez oluşturulduğunda, onInit fonksiyonu çağrılıyor ve 'this' (bu state objesi) iletiliyor.
    widget.onInit(this);
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
              '${widget.question.questionText} (${widget.question.point} puan)', // Soru metni ve puan bilgisi.
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // Yazı stilini belirliyoruz.
            ),
            // Soru metninden sonra boşluk bırakıyoruz.
            SizedBox(height: 10),
            // Eğer soru çoktan seçmeli ise, seçenekleri liste halinde ekliyoruz.
            if (widget.question.isMultipleChoice)
              ...widget.question.options.map((option) {
                return ListTile(
                  // Eğer soru birden fazla yanıtı kabul ediyorsa, Checkbox kullanıyoruz. Aksi takdirde, tek seçim için Radio butonu kullanıyoruz.
                  leading: widget.question.isMultiAnswer
                      ? Checkbox(
                    value: selectedAnswers.contains(option), // Eğer bu seçenek seçildiyse, checkbox işaretlenir.
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          selectedAnswers.add(option); // Seçenek seçildiyse listeye ekleriz.
                        } else {
                          selectedAnswers.remove(option); // Seçenek seçilmediyse listeden çıkarırız.
                        }
                      });
                    },
                  )
                      : Radio<String>(
                    value: option, // Seçilen değeri gönderiyoruz.
                    groupValue: selectedAnswers.isNotEmpty ? selectedAnswers.first : null, // Grup değerini seçilen ilk öğe olarak belirliyoruz.
                    onChanged: (String? value) {
                      setState(() {
                        // Kullanıcı yeni bir seçenek seçerse, önceki seçimi sıfırlayıp yenisini ekliyoruz.
                        selectedAnswers = value != null ? [value] : [];
                      });
                    },
                  ),
                  // Seçeneğin metnini ekliyoruz.
                  title: Text(option),
                );
              }).toList(),
            // Eğer soru açık uçluysa, bir TextField ekliyoruz.
            if (widget.question.isOpenEnded)
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
