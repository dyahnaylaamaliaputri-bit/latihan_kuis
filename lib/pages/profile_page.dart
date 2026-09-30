import 'package:flutter/material.dart';
import '../login.dart';

// StatelessWidget karena tidak ada data yang berubah (Modul 3)
class ProfilePage extends StatelessWidget {
  final String nama;

  const ProfilePage({super.key, required this.nama});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF7F4),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF9800),
        title: const Text(
          'Profil',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      // Scroll
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(6.0),
        child: Column(
          children: [
            const SizedBox(height: 10),

            // Foto profil (icon)
            Container(
              width: 98,
              height: 98,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFFFE0B2),
              ),
              child: const Icon(
                Icons.person,
                size: 58,
                color: Color(0xFFF57C00),
              ),
            ),

            const SizedBox(height: 14),

            // Nama pelanggan
            Text(
              nama,
              style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 4),

            Text(
              'Pelanggan Resto',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),

            const SizedBox(height: 34),

            // Card Menu Resto
            _menuCard(
              icon: Icons.restaurant_menu,
              title: 'Menu Resto',
              subtitle: 'Pesan makanan favorit Anda dengan mudah.',
            ),

            const SizedBox(height: 18),

            // Card Pemesanan
            _menuCard(
              icon: Icons.receipt_long,
              title: 'Pemesanan',
              subtitle: 'Jumlah dan harga dihitung otomatis.',
            ),

            const SizedBox(height: 18),
            ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (route) => false, // hapus semua route sebelumnya
                );
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      
      ),
    );
  }

  Widget _menuCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon dalam lingkaran
          Container(
            width: 38,
            height: 38,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFFFE0B2),
            ),
            child: Icon(icon, size: 21, color: Color(0xFFF57C00)),
          ),

          const SizedBox(width: 12),

          // Judul dan deskripsi
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  subtitle,
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
