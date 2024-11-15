// Flutter material kütüphanesini import ediyoruz, bu kütüphane widget'ları ve tema desteği sağlar.
import 'package:flutter/material.dart';
// Firestore ile veritabanı işlemleri yapabilmek için cloud_firestore paketini import ediyoruz.
import 'package:cloud_firestore/cloud_firestore.dart';
// 'Question' modelini import ediyoruz, her bir soruyu gösterebilmek için bu modele ihtiyacımız var.
import 'package:mobil_sinav_app/models/question.dart';
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
  // Firestore veritabanına erişim sağlamak için FirebaseFirestore instance'ı oluşturuyoruz.
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // Soruları yüklemek için kullanılacak Future objesi. Liste halinde soruları alacak.
  late Future<List<Question>> _questionsFuture;

  @override
  void initState() {
    super.initState();
    // initState içinde soruları almak için _fetchQuestions fonksiyonunu çağırıyoruz.
    _questionsFuture = _fetchQuestions();
  }

  // Firestore'dan soruları çekmek için asenkron fonksiyon. Soruları 'questions' koleksiyonundan alıyoruz.
  Future<List<Question>> _fetchQuestions() async {
    // 'questions' koleksiyonundan tüm dökümanları alıyoruz.
    final snapshot = await _firestore.collection('questions').get();
    // Dökümanları map fonksiyonu ile 'Question' modeline çeviriyoruz.
    return snapshot.docs.map((doc) {
      // Firestore'dan gelen her bir dokümanı 'Question' modeline dönüştürüyoruz.
      return Question.fromMap(doc.id, doc.data() as Map<String, dynamic>);
    }).toList();
  }

  // Soruyu düzenlemek için AddQuestionScreen'e yönlendiren fonksiyon.
  void _editQuestion(Question question) {
    // Navigator.push ile AddQuestionScreen'e gidiyoruz ve düzenlenecek soruyu iletmek için parametre olarak gönderiyoruz.
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddQuestionScreen(
          question: question, // Düzenlenecek soruyu bu ekrana gönderiyoruz.
        ),
      ),
    ).then((_) {
      // Soruyu düzenledikten sonra veri güncellemesi yapmak için setState çağırıyoruz.
      // Future'ı yeniden başlatıyoruz ve yeni verileri yüklüyoruz.
      setState(() {
        _questionsFuture = _fetchQuestions();  // Veri güncellendikten sonra Future'ı yeniden yükle
      });
    });
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
      body: FutureBuilder<List<Question>>(
        future: _questionsFuture, // Soruları çekmek için oluşturduğumuz Future'ı kullanıyoruz.

        // FutureBuilder'ın builder fonksiyonu, verilerin durumuna göre farklı ekranlar render eder.
        builder: (context, snapshot) {
          // Eğer veri hala yükleniyorsa (waiting durumundaysa) bir loading spinner gösteriyoruz.
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); // Yükleniyor spinner'ı.
          }
          // Eğer bir hata oluşursa kullanıcıya hata mesajı gösteriyoruz.
          else if (snapshot.hasError) {
            return Center(child: Text('Bir hata oluştu!')); // Hata mesajı.
          }
          // Eğer veri yoksa veya boşsa, eklenmiş soru yok demek için uyarı mesajı gösteriyoruz.
          else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Henüz soru eklenmemiş.')); // Boş liste durumunda uyarı.
          }
          // Eğer veriler başarılı bir şekilde geldiyse, soruları liste olarak gösteriyoruz.
          else {
            final questions = snapshot.data!; // Sorular verisini alıyoruz.
            return ListView.builder(
              itemCount: questions.length, // Liste uzunluğunu belirliyoruz.
              itemBuilder: (context, index) {
                final question = questions[index]; // Her bir soru objesini alıyoruz.
                return ListTile(
                  title: Text(question.questionText), // Sorunun metnini gösteriyoruz.
                  subtitle: Text('Cevaplar: ${question.options.join(", ")}'), // Sorunun seçeneklerini liste olarak gösteriyoruz.
                  trailing: IconButton(
                    icon: Icon(Icons.edit), // Düzenleme butonu için bir icon ekliyoruz.
                    onPressed: () => _editQuestion(question), // Butona tıklanırsa soruyu düzenlemek için _editQuestion fonksiyonunu çağırıyoruz.
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
