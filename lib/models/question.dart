class Question {
  String id;  // Soru ID'si, her bir soruyu benzersiz şekilde tanımlar.
  String questionText;  // Sorunun metni.
  List<String> options;  // Sorunun şıkları. Şıkları bir liste olarak saklıyoruz.
  String correctAnswer;  // Doğru cevap. Kullanıcı doğru cevabı bu alanda karşılaştırabilir.
  bool isMultipleChoice;  // Çoktan seçmeli olup olmadığı. Eğer true ise, birden fazla cevap seçilebilir.
  bool isMultiAnswer;  // Birden fazla cevabın doğru olup olmadığı. Eğer true ise, birden fazla doğru cevap olabilir.
  bool isOpenEnded;  // Açık uçlu soru olup olmadığı. Eğer true ise, cevap bir metin olabilir.
  int point;  // Sorunun puan değeri.

  // Constructor (Yapıcı Fonksiyon) ile sınıfın örnekleri oluşturuluyor.
  Question({
    required this.id,  // id zorunlu bir parametre olarak alınır.
    required this.questionText,  // questionText zorunlu bir parametre olarak alınır.
    required this.options,  // options zorunlu bir parametre olarak alınır.
    required this.correctAnswer,  // correctAnswer zorunlu bir parametre olarak alınır.
    required this.isMultipleChoice,  // isMultipleChoice zorunlu bir parametre olarak alınır.
    required this.isMultiAnswer,  // isMultiAnswer zorunlu bir parametre olarak alınır.
    required this.isOpenEnded,  // isOpenEnded zorunlu bir parametre olarak alınır.
    required this.point,  // point zorunlu bir parametre olarak alınır.
  });

  // Soru nesnesini Map formatına dönüştüren fonksiyon.
  Map<String, dynamic> toMap() {
    return {
      'questionText': questionText,  // Sorunun metnini map'e ekliyoruz.
      'options': options,  // Şıkları map'e ekliyoruz.
      'correctAnswer': correctAnswer,  // Doğru cevabı map'e ekliyoruz.
      'isMultipleChoice': isMultipleChoice,  // Çoktan seçmeli olup olmadığını map'e ekliyoruz.
      'isMultiAnswer': isMultiAnswer,  // Birden fazla doğru cevabın olup olmadığını map'e ekliyoruz.
      'isOpenEnded': isOpenEnded,  // Açık uçlu soru olup olmadığını map'e ekliyoruz.
      'point': point,  // Sorunun puanını map'e ekliyoruz.
    };
  }

  // Firestore'dan çekilen veriyi kullanarak bir Question nesnesi oluşturuyoruz.
  static Question fromMap(String id, Map<String, dynamic> data) {
    return Question(
      id: id,  // id'yi parametre olarak alıp kullanıyoruz.
      questionText: data['questionText'] ?? '',  // 'questionText' verisi varsa, yoksa boş string döneriz.
      options: List<String>.from(data['options'] ?? []),  // 'options' verisi varsa, yoksa boş liste döneriz.
      correctAnswer: data['correctAnswer'] ?? '',  // 'correctAnswer' verisi varsa, yoksa boş string döneriz.
      isMultipleChoice: data['isMultipleChoice'] ?? false,  // 'isMultipleChoice' verisi varsa, yoksa false döneriz.
      isMultiAnswer: data['isMultiAnswer'] ?? false,  // 'isMultiAnswer' verisi varsa, yoksa false döneriz.
      isOpenEnded: data['isOpenEnded'] ?? false,  // 'isOpenEnded' verisi varsa, yoksa false döneriz.
      point: data['point'] ?? 0,  // 'point' verisi varsa, yoksa 0 döneriz.
    );
  }

  // copyWith metodu, mevcut nesnenin bir kopyasını oluşturup bazı alanları değiştirmemize olanak tanır.
  // Bu, mevcut nesnenin tüm özelliklerini alır, ancak değiştirmek istediğimiz alanları parametre olarak alır.
  Question copyWith({
    String? questionText,  // questionText parametre olarak opsiyoneldir.
    List<String>? options,  // options parametre olarak opsiyoneldir.
    String? correctAnswer,  // correctAnswer parametre olarak opsiyoneldir.
    bool? isMultipleChoice,  // isMultipleChoice parametre olarak opsiyoneldir.
    bool? isMultiAnswer,  // isMultiAnswer parametre olarak opsiyoneldir.
    bool? isOpenEnded,  // isOpenEnded parametre olarak opsiyoneldir.
    int? point,  // point parametre olarak opsiyoneldir.
  }) {
    return Question(
      id: this.id,  // 'id' her durumda aynıdır, bu yüzden mevcut nesneden alıyoruz.
      questionText: questionText ?? this.questionText,  // questionText parametre olarak verilmişse onu, yoksa mevcut değeri kullanıyoruz.
      options: options ?? this.options,  // options parametre olarak verilmişse onu, yoksa mevcut değeri kullanıyoruz.
      correctAnswer: correctAnswer ?? this.correctAnswer,  // correctAnswer parametre olarak verilmişse onu, yoksa mevcut değeri kullanıyoruz.
      isMultipleChoice: isMultipleChoice ?? this.isMultipleChoice,  // isMultipleChoice parametre olarak verilmişse onu, yoksa mevcut değeri kullanıyoruz.
      isMultiAnswer: isMultiAnswer ?? this.isMultiAnswer,  // isMultiAnswer parametre olarak verilmişse onu, yoksa mevcut değeri kullanıyoruz.
      isOpenEnded: isOpenEnded ?? this.isOpenEnded,  // isOpenEnded parametre olarak verilmişse onu, yoksa mevcut değeri kullanıyoruz.
      point: point ?? this.point,  // point parametre olarak verilmişse onu, yoksa mevcut değeri kullanıyoruz.
    );
  }
}
