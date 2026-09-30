import 'package:flutter/material.dart';

import 'pages/home_page.dart';
import 'pages/profile_page.dart';
import 'login.dart';
import 'pages/favorite_page.dart'; // <- tambah di bagian import

class Root extends StatefulWidget {
  //tambahan buat menu login
  final String nama;

  const Root({super.key, required this.nama});
  @override
  State<Root> createState() => _RootState();
}

//Membuat tombol navigator
class _RootState extends State<Root> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomePage(),
      FavoritePage(), // <- tambahkan halaman favorit
      ProfilePage(
        nama: widget.nama,
      ), //untuk meneruskan username ke halaman profile
    ];
    return Scaffold(
      body: pages[_selectedIndex],
      // NavigationBarTheme: atur warna saat dipilih (orange) dan tidak dipilih (abu-abu)
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          indicatorColor: const Color(
            0xFFFF9800,
          ), // warna oval di ikon terpilih
          iconTheme: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const IconThemeData(color: Colors.white);
            }
            return IconThemeData(color: Colors.grey[600]);
          }),
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const TextStyle(
                color: Color(0xFFFF9800),
                fontWeight: FontWeight.bold,
                fontSize: 12,
              );
            }
            return TextStyle(color: Colors.grey[600], fontSize: 12);
          }),
        ),
        child: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.restaurant_menu),
              label: 'Beranda',
            ),
            NavigationDestination(
              icon: Icon(Icons.favorite),
              label: 'Favorit',
            ), // <- tambahan
            NavigationDestination(icon: Icon(Icons.person), label: 'Profil'),
          ],
        ),
      ),
    );
  }
}
