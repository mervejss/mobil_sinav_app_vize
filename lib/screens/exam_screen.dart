import 'package:flutter/material.dart'; // Flutter'dan Material Design widget'larını ve özelliklerini kullanmak için gerekli paket.
import 'package:mobil_sinav_app/models/question.dart'; // Question modelini içe aktararak sınav sorularının yapısını kullanıyoruz.
import 'package:mobil_sinav_app/screens/question_card.dart'; // Soru kartlarını göstermek için QuestionCard widget'ını içe aktarıyoruz.
import 'package:mobil_sinav_app/services/question_service.dart'; // Soru verilerini almak ve cevapları kaydetmek için QuestionService'i içe aktarıyoruz.

class ExamScreen extends StatefulWidget {
  // QuestionService nesnesi, soru verileri ve cevapları yönetmek için kullanılacak.
  final QuestionService _questionService = QuestionService();
  // Kullanıcı ID'si, şu anki kullanıcıyı temsil eder. Burada hardcoded bir değer kullanıyoruz.
  final String userId = 'currentUserId';

  @override
  _ExamScreenState createState() => _ExamScreenState(); // ExamScreen için durumu yöneten _ExamScreenState sınıfını oluşturuyoruz.
}

class _ExamScreenState extends State<ExamScreen> {
  // Soruların her birinin durumunu saklamak için bir liste oluşturuyoruz.
  final List<QuestionCardState> _questionStates = [];

  // Kullanıcının cevaplarını kaydetme işlemini yapan asenkron fonksiyon.
  Future<void> saveAnswers() async {
    // Her bir soru kartının durumunu alıp, cevabı kaydediyoruz.
    for (var questionCardState in _questionStates) {
      await widget._questionService.saveOrUpdateAnswer(
        widget.userId, // Kullanıcı ID'si
        questionCardState.widget.question.id, // Sorunun ID'si
        questionCardState.selectedAnswers, // Seçilen cevaplar
      );
    }
    // Cevaplar kaydedildikten sonra kullanıcıya bir bildirim gösteriyoruz.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Cevaplar kaydedildi!')), // Cevapların başarıyla kaydedildiğine dair bir mesaj.
    );
    // Sayfayı kapatıyoruz ve önceki ekrana dönüyoruz.
    Navigator.pop(context);
  }

  // Cevapları kaydetmeden önce kullanıcıdan onay almak için bir diyalog kutusu açan fonksiyon.
  Future<void> _showSaveConfirmationDialog() async {
    bool confirm = await showDialog(
      context: context, // Diyalog kutusunun bağlı olduğu bağlam (context).
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Yanıtları Göndermek İstediğinize Emin misiniz?"), // Diyalog kutusunun başlığı.
          content: Text("Test yanıtlarınızı göndermek üzeresiniz. Onaylıyor musunuz?"), // Kullanıcıya uyarı mesajı.
          actions: [
            TextButton(
              child: Text("Hayır"), // Hayır butonuna basıldığında
              onPressed: () {
                Navigator.of(context).pop(false); // Diyalog kutusunu kapatıp false döndürüyoruz.
              },
            ),
            TextButton(
              child: Text("Evet"), // Evet butonuna basıldığında
              onPressed: () {
                Navigator.of(context).pop(true); // Diyalog kutusunu kapatıp true döndürüyoruz.
              },
            ),
          ],
        );
      },
    );
    // Eğer kullanıcı "Evet" diyorsa, cevapları kaydediyoruz.
    if (confirm) {
      await saveAnswers();
    }
  }

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
            onPressed: _showSaveConfirmationDialog, // Tıklanıldığında save confirmation dialog'ını gösteriyoruz.
          ),
        ],
      ),
      body: FutureBuilder<List<Question>>(
        // Soruları asenkron olarak alıyoruz ve ekranda göstermek için bekliyoruz.
        future: widget._questionService.getQuestions(),
        builder: (context, snapshot) {
          // Veriler henüz yükleniyorsa loading spinner'ı gösteriyoruz.
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          // Eğer bir hata oluşmuşsa hata mesajı gösteriyoruz.
          if (snapshot.hasError) {
            return Center(child: Text('Bir hata oluştu: ${snapshot.error}'));
          }
          // Eğer veri yoksa veya boşsa, "Henüz soru yok." mesajını gösteriyoruz.
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Henüz soru yok.'));
          }

          // Eğer sorular mevcutsa, soruları listeleyip kullanıcıya göstereceğiz.
          final questions = snapshot.data!;
          return ListView.builder(
            itemCount: questions.length, // Soruların sayısını belirtiyoruz.
            itemBuilder: (context, index) {
              final question = questions[index]; // Listeyi gezerek her bir soruyu alıyoruz.
              // Her bir soru için bir QuestionCard widget'ı oluşturuyoruz.
              final questionCard = QuestionCard(
                question: question,
                onInit: (QuestionCardState state) {
                  // QuestionCard her başlatıldığında, kartın durumunu (state) kaydediyoruz.
                  _questionStates.add(state);
                },
              );
              return questionCard; // Soru kartını döndürüyoruz.
            },
          );
        },
      ),
    );
  }
}
