// Library utama Flutter (berisi widget-widget siap pakai seperti Text, Scaffold, dll)
import 'package:flutter/material.dart';

// Mengambil file login.dart supaya LoginPage bisa dipakai di sini
import 'login.dart';
// Mengambil file root.dart (kerangka halaman utama dengan menu navigasi bawah)
import 'root.dart';

// Fungsi pertama yang dijalankan saat aplikasi dibuka
void main() {
  // runApp: menjalankan aplikasi, dengan MyApp sebagai widget paling atas
  runApp(const MyApp());
}

// Widget induk dari seluruh aplikasi.
// Stateless = tampilannya tetap, tidak ada data yang berubah di sini
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp: pengaturan dasar aplikasi dengan gaya Material Design
    return MaterialApp(
      // Judul aplikasi (dipakai sistem, misalnya di daftar aplikasi yang sedang berjalan)
      title: 'Resto Order App',
      // Menghilangkan pita merah tulisan DEBUG di pojok kanan atas layar
      debugShowCheckedModeBanner: false,
      // Tema aplikasi (warna dan gaya secara keseluruhan)
      theme: ThemeData(
        // Membuat kumpulan warna otomatis yang serasi dari satu warna dasar (oranye)
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFF6B35)),
        // Memakai Material Design versi 3 (tampilan yang lebih modern)
        useMaterial3: true,
      ),
      // home: halaman yang pertama kali tampil. Di sini yang tampil adalah LoginPage
      home: LoginPage(), // ← panggil Root di sini
    );
  }
}
