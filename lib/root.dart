// Library utama Flutter untuk membuat tampilan
import 'package:flutter/material.dart';

// Halaman Beranda (daftar menu)
import 'pages/home_page.dart';
// Halaman Profil
import 'pages/profile_page.dart';
// Halaman Login
import 'login.dart';
import 'pages/favorite_page.dart'; // <- tambah di bagian import

// Kerangka utama aplikasi setelah login: berisi halaman-halaman dan menu navigasi di bawah.
// Stateful karena halaman yang tampil berubah tergantung menu yang dipilih
class Root extends StatefulWidget {
  // Nama user yang dikirim dari halaman login
  //tambahan buat menu login
  final String nama;

  // required = nama wajib diisi saat Root dibuat
  const Root({super.key, required this.nama});
  // Membuat State untuk menyimpan menu mana yang sedang aktif
  @override
  State<Root> createState() => _RootState();
}

//Membuat tombol navigator
class _RootState extends State<Root> {
  // Nomor menu yang sedang dipilih: 0 = Beranda, 1 = Favorit, 2 = Profil
  // Awalnya 0, jadi Beranda yang tampil lebih dulu
  int _selectedIndex = 0;

  // build: fungsi yang menggambar tampilan halaman
  @override
  Widget build(BuildContext context) {
    // Daftar halaman. Urutannya harus sama dengan urutan menu di navigasi bawah
    final List<Widget> pages = [
      // Index 0: Beranda
      HomePage(),
      FavoritePage(), // <- tambahkan halaman favorit
      ProfilePage(
        nama: widget.nama,
      ), //untuk meneruskan username ke halaman profile
    ];
    // Scaffold: kerangka dasar halaman
    return Scaffold(
      // Menampilkan halaman sesuai menu yang sedang dipilih
      body: pages[_selectedIndex],
      // Menu navigasi di bagian bawah layar.
      // NavigationBarTheme dipakai untuk mengatur warna dan gaya menunya
      // NavigationBarTheme: atur warna saat dipilih (orange) dan tidak dipilih (abu-abu)
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          // Latar menu berwarna putih
          backgroundColor: Colors.white,
          // Menghilangkan efek warna tambahan bawaan Material 3
          surfaceTintColor: Colors.transparent,
          indicatorColor: const Color(
            0xFFFF9800,
          ), // warna oval di ikon terpilih
          // Mengatur warna ikon sesuai keadaannya (sedang dipilih atau tidak)
          iconTheme: WidgetStateProperty.resolveWith((states) {
            // Kalau ikon sedang dipilih: warna putih
            if (states.contains(WidgetState.selected)) {
              return const IconThemeData(color: Colors.white);
            }
            // Kalau tidak dipilih: warna abu-abu
            return IconThemeData(color: Colors.grey[600]);
          }),
          // Mengatur gaya tulisan di bawah ikon menu
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            // Kalau menu sedang dipilih: tulisan oranye, tebal
            if (states.contains(WidgetState.selected)) {
              return const TextStyle(
                color: Color(0xFFFF9800),
                fontWeight: FontWeight.bold,
                fontSize: 12,
              );
            }
            // Kalau tidak dipilih: tulisan abu-abu biasa
            return TextStyle(color: Colors.grey[600], fontSize: 12);
          }),
        ),
        // Bar navigasi yang sebenarnya
        child: NavigationBar(
          // Menandai menu mana yang sedang aktif
          selectedIndex: _selectedIndex,
          // Dijalankan saat user menekan salah satu menu. index = nomor menu yang ditekan
          onDestinationSelected: (index) {
            // Simpan nomor menu baru, lalu setState supaya halaman berganti
            setState(() {
              _selectedIndex = index;
            });
          },
          // Daftar tombol menu
          destinations: const [
            // Menu 1: Beranda (index 0)
            NavigationDestination(
              icon: Icon(Icons.restaurant_menu),
              label: 'Beranda',
            ),
            // Menu 2: Favorit (index 1)
            NavigationDestination(
              icon: Icon(Icons.favorite),
              label: 'Favorit',
            ), // <- tambahan
            // Menu 3: Profil (index 2)
            NavigationDestination(icon: Icon(Icons.person), label: 'Profil'),
          ],
        ),
      ),
    );
  }
}
