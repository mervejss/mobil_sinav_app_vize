// File generated by FlutterFire CLI.
// ignore_for_file: type=lint

// Firebase'ı platforma özel seçeneklerle başlatabilmek için gerekli olan yapılandırmalar.
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

// Platforma göre uygulama başlatma işlemi yapılacak. Web ve mobil platformlar arasındaki farkları göz önünde bulunduruyoruz.
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
/// Firebase ile olan bağlantıyı yapılandırmak için platforma özel seçenekler.
class DefaultFirebaseOptions {
  // Platforma göre doğru FirebaseOptions değerini döndüren getter.
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {  // Web platformu kontrol ediliyor.
      return web;  // Web platformu için tanımlanan FirebaseOptions döndürülüyor.
    }
    // Diğer platformlar için platform tipine göre uygun seçenek döndürülüyor.
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;  // Android platformu için Firebase ayarları döndürülüyor.
      case TargetPlatform.iOS:
        return ios;  // iOS platformu için Firebase ayarları döndürülüyor.
      case TargetPlatform.macOS:
        return macos;  // macOS platformu için Firebase ayarları döndürülüyor.
      case TargetPlatform.windows:
        return windows;  // Windows platformu için Firebase ayarları döndürülüyor.
      case TargetPlatform.linux:
      // Linux platformu için Firebase ayarları henüz yapılandırılmadığı için hata fırlatılıyor.
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
              'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
      // Diğer platformlar desteklenmiyor ve hata mesajı gösteriliyor.
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  // Web platformu için Firebase seçeneklerini içerir.
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAMgb-ba1dGHQpP9DbUP-Yk1mmCiTEvZFg',  // Web için API anahtarı.
    appId: '1:745585172447:web:c82b7c9d485c6e7dfb6e6a',  // Web için uygulama ID'si.
    messagingSenderId: '745585172447',  // Mesaj gönderen ID'si.
    projectId: 'mobilsinavapp',  // Firebase projesinin ID'si.
    authDomain: 'mobilsinavapp.firebaseapp.com',  // Web için Firebase authentication domain'i.
    storageBucket: 'mobilsinavapp.firebasestorage.app',  // Web için storage bucket.
    measurementId: 'G-H777JTMSC8',  // Web için ölçüm ID'si (Analytics).
  );

  // Android platformu için Firebase seçeneklerini içerir.
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBw--PuGVSaR0Be2Z3zZg4j1GLwkxaRDPk',  // Android için API anahtarı.
    appId: '1:745585172447:android:313bb7e3c9738c6cfb6e6a',  // Android için uygulama ID'si.
    messagingSenderId: '745585172447',  // Android için mesaj gönderici ID'si.
    projectId: 'mobilsinavapp',  // Firebase projesinin ID'si.
    storageBucket: 'mobilsinavapp.firebasestorage.app',  // Android için storage bucket.
  );

  // iOS platformu için Firebase seçeneklerini içerir.
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDd9Q3yYKWm7qZ22-DWvPjWopSo-crrwEA',  // iOS için API anahtarı.
    appId: '1:745585172447:ios:fb93947ec3dbdc06fb6e6a',  // iOS için uygulama ID'si.
    messagingSenderId: '745585172447',  // iOS için mesaj gönderici ID'si.
    projectId: 'mobilsinavapp',  // Firebase projesinin ID'si.
    storageBucket: 'mobilsinavapp.firebasestorage.app',  // iOS için storage bucket.
    iosBundleId: 'com.example.mobilSinavApp',  // iOS için bundle ID.
  );

  // macOS platformu için Firebase seçeneklerini içerir.
  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDd9Q3yYKWm7qZ22-DWvPjWopSo-crrwEA',  // macOS için API anahtarı.
    appId: '1:745585172447:ios:fb93947ec3dbdc06fb6e6a',  // macOS için uygulama ID'si.
    messagingSenderId: '745585172447',  // macOS için mesaj gönderici ID'si.
    projectId: 'mobilsinavapp',  // Firebase projesinin ID'si.
    storageBucket: 'mobilsinavapp.firebasestorage.app',  // macOS için storage bucket.
    iosBundleId: 'com.example.mobilSinavApp',  // macOS için bundle ID (iOS'a benzer).
  );

  // Windows platformu için Firebase seçeneklerini içerir.
  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAMgb-ba1dGHQpP9DbUP-Yk1mmCiTEvZFg',  // Windows için API anahtarı.
    appId: '1:745585172447:web:ebff0442cf40b3effb6e6a',  // Windows için uygulama ID'si.
    messagingSenderId: '745585172447',  // Windows için mesaj gönderici ID'si.
    projectId: 'mobilsinavapp',  // Firebase projesinin ID'si.
    authDomain: 'mobilsinavapp.firebaseapp.com',  // Windows için Firebase authentication domain'i.
    storageBucket: 'mobilsinavapp.firebasestorage.app',  // Windows için storage bucket.
    measurementId: 'G-FFJKKQ8YHP',  // Windows için ölçüm ID'si (Analytics).
  );
}
