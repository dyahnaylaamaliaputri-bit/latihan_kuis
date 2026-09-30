// Library utama Flutter untuk membuat tampilan
import 'package:flutter/material.dart';

// Model data makanan
import '../models/food_item.dart';
// Halaman detail makanan
import 'detail_page.dart';

// StatefulWidget karena daftar favorit bisa berubah
// saat user menghapus favorit dari halaman ini
class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  // Membuat State untuk menyimpan data halaman Favorit
  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  // Getter: ambil hanya makanan yang ditandai favorit
  List<FoodItem> get _favorites =>
      // where: menyaring daftar menu, hanya yang isFavorite-nya true yang diambil
      // toList: hasil saringan dijadikan daftar (List) lagi
      FoodItem.sampleData.where((item) => item.isFavorite).toList();

  // build: fungsi yang menggambar tampilan halaman
  @override
  Widget build(BuildContext context) {
    // Ambil daftar favorit terbaru setiap kali tampilan digambar ulang
    final favorites = _favorites;

    // Scaffold: kerangka dasar halaman
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF9800),
        title: const Text(
          'Favorit',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      // Kalau daftar favorit kosong, tampilkan tulisan.
      // Kalau ada isinya, tampilkan daftar favorit
      body: favorites.isEmpty
          // Bagian ini dipakai kalau BELUM ada favorit
          ? const Center(
              child: Text(
                'Belum ada menu favorit.',
                style: TextStyle(color: Colors.grey),
              ),
            )
          // Bagian ini dipakai kalau SUDAH ada favorit: membuat daftar yang bisa di-scroll
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              // Jumlah item = jumlah menu favorit
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                // Ambil menu favorit sesuai urutannya
                final item = favorites[index];
                // Card: kotak dengan bayangan tipis untuk membungkus tiap menu
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  // ListTile: baris siap pakai (gambar di kiri, judul, subjudul, dan tombol di kanan)
                  child: ListTile(
                    //ditambahin kalo mau menu favorite bisa dilihat detailnya
                    // Navigasi ke DetailPage saat kartu diklik
                    onTap: () async {
                      // Buka DetailPage, lalu tunggu sampai user kembali (await) sambil membawa jumlah porsi baru
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailPage(
                            item: item,
                            // Mencari posisi asli menu di daftar menu lengkap (bukan posisinya di daftar favorit)
                            index: FoodItem.sampleData.indexOf(item),
                          ),
                        ),
                      );

                      // Pastikan ada data yang kembali dan bentuknya angka
                      // Kalau ada data balik (quantity baru), update state
                      if (result != null && result is int) {
                        setState(() {
                          item.quantity = result;
                        });
                      }
                    },
                    // leading: bagian paling kiri baris (gambar menu dengan sudut membulat)
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        item.imageUrl,
                        width: 56,
                        height: 56,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 56,
                          height: 56,
                          color: Colors.grey[200],
                          child: const Icon(Icons.fastfood, color: Colors.grey),
                        ),
                      ),
                    ),
                    // Judul baris: nama menu
                    title: Text(
                      item.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    // Teks di bawah judul: harga per porsi
                    subtitle: Text('Rp ${item.formattedPrice}/porsi'),
                    // trailing: bagian paling kanan baris (tombol hati untuk menghapus dari favorit)
                    trailing: IconButton(
                      icon: const Icon(Icons.favorite, color: Colors.red),
                      onPressed: () {
                        // setState: memperbarui tampilan supaya menu yang dihapus langsung hilang dari daftar
                        setState(() {
                          item.isFavorite = false; // hapus dari favorit
                        });
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
