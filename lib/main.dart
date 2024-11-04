import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore'ı ekleyin
import 'package:mobil_sinav_app/screens/exam_screen.dart';
import 'package:mobil_sinav_app/screens/score_screen.dart';
import 'firebase_options.dart';
import 'screens/add_question_screen.dart';
import 'models/question.dart'; // Modeli ekleyin

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mobil Sınav Uygulaması',
      home: HomeScreen(),
    );
  }
}
/*
StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('questions').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Bir hata oluştu!'));
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(child: Text('Henüz soru yok.'));
              }

              final questions = snapshot.data!.docs.map((doc) {
                return Question.fromMap(doc.id, doc.data() as Map<String, dynamic>);
              }).toList();

              return ListView.builder(
                itemCount: questions.length,
                itemBuilder: (context, index) {
                  final question = questions[index];
                  return ListTile(
                    title: Text(question.questionText),
                    subtitle: Text('Cevaplar: ${question.options.join(", ")}'),
                  );
                },
              );
            },
          ),
 */
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sınav Uygulaması',
        style: TextStyle(color: Colors.white),
      ),
        backgroundColor:  Color(0xFF6650A4),
      ),
      body: Column(
        children: [
          ElevatedButton(onPressed: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ExamScreen()),
            );
          }, child: Column(
            children: [
              Center(child: Text("Sınava Başla")),
            ],
          ),),
          SizedBox(height: 10,),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ScoreScreen()),
              );
            },
            child: Center(child: Text("Sınav Puanımı Göster")),
          ),


        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddQuestionScreen()),
          );
        },
        child: Icon(Icons.add),
      ),

    );
  }
}
