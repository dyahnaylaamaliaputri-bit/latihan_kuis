import 'package:flutter/material.dart';

import '../models/food_item.dart';
import 'detail_page.dart';

// StatefulWidget karena quantity makanan bisa berubah
// saat user balik dari halaman detail
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // STATE: list makanan: quantity-nya bisa berubah
  final List<FoodItem> _menuItems = FoodItem.sampleData;

  // Getter: hitung total semua pesanan
  int get _grandTotal =>
      _menuItems.fold(0, (sum, item) => sum + item.totalPrice);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF9800),
        title: const Text(
          '🍽️ Menu Resto',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Banner total pesanan
          Container(
            width: double.infinity,
            color: const Color(0xFFFF9800),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Text(
              'Total Pesanan: Rp ${formatPrice(_grandTotal)}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          // ListView.builder: tampilkan daftar makanan
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _menuItems.length,
              itemBuilder: (context, index) {
                final item = _menuItems[index];
                return _buildFoodCard(item, index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFoodCard(FoodItem item, int index) {
    return GestureDetector(
      // Navigasi ke DetailPage saat kartu diklik
      onTap: () async {
        // await: tunggu sampai user selesai di halaman detail
        // result: nilai quantity yang dikirim balik dari detail
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailPage(item: item, index: index),
          ),
        );

        // Kalau ada data balik (quantity baru), update state
        if (result != null && result is int) {
          setState(() {
            _menuItems[index].quantity = result;
          });
        }
      },

      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.07),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // ── Gambar makanan
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
              child: Image.network(
                item.imageUrl,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 100,
                  height: 100,
                  color: Colors.grey[200],
                  child: const Icon(Icons.fastfood, color: Colors.grey),
                ),
              ),
            ),

            // ── Info makanan ──
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nama makanan
                    // Nama makanan + tombol favorit
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              item.isFavorite =
                                  !item.isFavorite; // balik true/false
                            });
                          },
                          child: Icon(
                            item.isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: Colors.red,
                            size: 22,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),

                    // Deskripsi
                    Text(
                      item.description,
                      style: TextStyle(color: Colors.grey[500], fontSize: 11),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),

                    // Jumlah porsi yang dipilih user
                    // Otomatis berubah saat balik dari detail
                    Text(
                      'Jumlah porsi: ${item.quantity} porsi',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 6),

                    // ── Baris bawah: harga/porsi kiri + total harga kanan
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Harga per porsi — kecil, warna abu-abu
                        Text(
                          'Rp ${item.formattedPrice}/porsi',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 11,
                          ),
                        ),

                        // Jika quantity = 0 tampilan "Rp 0"
                        Text(
                          'Rp ${item.quantity > 0 ? item.formattedTotal : '0'}',
                          style: const TextStyle(
                            color: Colors.green,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
