// Gerekli Flutter paketlerini import ediyoruz.
import 'package:flutter/material.dart'; // Flutter uygulaması için Material tasarım bileşenlerini kullanmak için gerekli.
import 'package:mobil_sinav_app/screens/exam_screen.dart'; // Sınav ekranını import ediyoruz.
import 'package:mobil_sinav_app/screens/question_list_screen.dart'; // Soru listesini gösteren ekranı import ediyoruz.
import 'package:mobil_sinav_app/screens/score_screen.dart'; // Puan ekranını import ediyoruz.
import 'screens/add_question_screen.dart'; // Yeni soru eklemek için ekranı import ediyoruz.

// Ana fonksiyonumuzda Firebase'i başlatıyoruz ve uygulamayı çalıştırıyoruz.
void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Flutter'ın UI ile ilgili işlemlerinin başlamadan önce çalışmasını sağlıyoruz.

  runApp(MyApp()); // Uygulamayı çalıştırıyoruz.
}

// MyApp sınıfı, uygulamanın kök widget'ıdır. StatelessWidget kullanılarak oluşturulmuş.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp( // Material tasarımını kullanan bir uygulama başlatıyoruz.
      title: 'Mobil Sınav Uygulaması', // Uygulamanın başlığını belirliyoruz.
      home: HomeScreen(), // Ana ekranı belirliyoruz.
    );
  }
}

// HomeScreen sınıfı, ana ekranı temsil eder. StatelessWidget kullanılır çünkü ekranın durumu değişmeyecek.
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold( // Scaffold, temel bir uygulama sayfası yapısı sunar.
      appBar: AppBar( // Uygulamanın üst kısmındaki başlık çubuğu.
        title: Text('Sınav Uygulaması', // Başlık metnini belirliyoruz.
          style: TextStyle(color: Colors.white), // Başlık metninin rengini beyaz yapıyoruz.
        ),
        backgroundColor: Color(0xFF6650A4), // AppBar'ın arka plan rengini belirliyoruz.
      ),
      body: Column( // Sayfa gövdesini dikey olarak düzenlemek için Column widget'ı kullanıyoruz.
        children: [
          // 'Sınava Başla' butonunu oluşturuyoruz.
          ElevatedButton(
            onPressed: (){ // Butona tıklanıldığında yapılacak işlemi belirliyoruz.
              Navigator.push( // Navigator ile başka bir ekrana geçiş yapıyoruz.
                context,
                MaterialPageRoute(builder: (context) => ExamScreen()), // Sınav ekranına yönlendiriyoruz.
              );
            },
            child: Column( // Butonun içeriğini düzenliyoruz.
              children: [
                Center(child: Text("Sınava Başla")), // Butonun ortasında "Sınava Başla" yazısını gösteriyoruz.
              ],
            ),
          ),
          SizedBox(height: 10,), // Butonlar arasında boşluk bırakıyoruz.

          // 'Sınav Puanımı Göster' butonunu oluşturuyoruz.
          ElevatedButton(
            onPressed: () { // Butona tıklanıldığında yapılacak işlemi belirliyoruz.
              Navigator.push( // Navigator ile başka bir ekrana geçiş yapıyoruz.
                context,
                MaterialPageRoute(builder: (context) => ScoreScreen()), // Puan ekranına yönlendiriyoruz.
              );
            },
            child: Center(child: Text("Sınav Puanımı Göster")), // Butonun içeriğini düzenliyoruz.
          ),
          SizedBox(height: 10), // Butonlar arasında boşluk bırakıyoruz.

          // 'Eklenen Soruları Göster' butonunu oluşturuyoruz.
          ElevatedButton(
            onPressed: () { // Butona tıklanıldığında yapılacak işlemi belirliyoruz.
              Navigator.push( // Navigator ile başka bir ekrana geçiş yapıyoruz.
                context,
                MaterialPageRoute(builder: (context) => QuestionListScreen()), // Soru listesi ekranına yönlendiriyoruz.
              );
            },
            child: Center(child: Text("Eklenen Soruları Göster/Güncelle")), // Butonun içeriğini düzenliyoruz.
          ),
        ],
      ),
      // Sayfanın sağ alt köşesinde bir FloatingActionButton (FAB) ekliyoruz.
      floatingActionButton: FloatingActionButton(
        onPressed: () { // Butona tıklanıldığında yapılacak işlemi belirliyoruz.
          Navigator.push( // Navigator ile başka bir ekrana geçiş yapıyoruz.
            context,
            MaterialPageRoute(builder: (context) => AddQuestionScreen()), // Yeni soru ekleme ekranına yönlendiriyoruz.
          );
        },
        child: Icon(Icons.add), // FAB'ye bir artı işareti (ikon) ekliyoruz.
      ),
    );
  }
}
