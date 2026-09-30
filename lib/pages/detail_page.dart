// Library utama Flutter untuk membuat tampilan
import 'package:flutter/material.dart';

// Model data makanan
import '../models/food_item.dart';

// StatefulWidget karena _quantity bisa berubah
// saat user tekan tombol + dan -
class DetailPage extends StatefulWidget {
  final FoodItem item; // data makanan yang diklik dari beranda
  final int index; // index makanan di list

  const DetailPage({super.key, required this.item, required this.index});

  // Membuat State untuk menyimpan jumlah porsi di halaman ini
  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  // late: nilainya diisi nanti (di initState), bukan saat dideklarasikan
  // STATE: quantity lokal di halaman ini
  late int _quantity;

  // initState: dijalankan satu kali saat halaman pertama kali dibuka
  @override
  void initState() {
    // Wajib dipanggil supaya proses awal bawaan Flutter tetap berjalan
    super.initState();
    // Ambil quantity awal dari item yang dikirim halaman beranda
    _quantity = widget.item.quantity;
  }

  // widget.item: cara mengambil data item yang dikirim ke halaman ini
  // Hitung total harga berdasarkan quantity lokal
  int get _totalPrice => _quantity * widget.item.price;

  // build: fungsi yang menggambar tampilan halaman
  @override
  Widget build(BuildContext context) {
    // Scaffold: kerangka dasar halaman
    return Scaffold(
      backgroundColor: const Color(0xFFFAF7F4),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF8C00),
        title: Text(
          widget.item.name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        // Tombol back — kirim quantity kembali ke HomePage
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          // pop: menutup halaman ini dan kembali ke halaman sebelumnya,
          // sambil membawa nilai _quantity
          onPressed: () => Navigator.pop(context, _quantity),
        ),
        centerTitle: true,
        elevation: 0,
      ),

      // Isi halaman bisa di-scroll supaya tidak terpotong di layar kecil
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar makanan
            Padding(
              // fromLTRB = jarak dari Kiri, Atas, Kanan, Bawah
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.network(
                  widget.item.imageUrl,
                  width: double.infinity,
                  height: 170,
                  fit: BoxFit.cover,
                  // Tampilan cadangan kalau gambar gagal dimuat
                  errorBuilder: (_, __, ___) => Container(
                    width: double.infinity,
                    height: 170,
                    color: Colors.grey[200],
                    child: const Icon(
                      Icons.fastfood,
                      size: 80,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Card detail makanan
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          // Warna bayangan: hitam dengan transparansi tinggi (hanya 6%)
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Nama makanan
                        Text(
                          widget.item.name,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 3),

                        // Harga per porsi
                        Text(
                          'Rp ${widget.item.formattedPrice} / porsi',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF5FA86B),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Deskripsi
                        Text(
                          widget.item.description,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[600],
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // ===== KONTROL JUMLAH PORSI =====
                        Container(
                          width: double.infinity,
                          height: 34,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            // Garis tepi kotak kontrol jumlah
                            border: Border.all(
                              color: const Color(0xFF9A7445),
                              width: 1.2,
                            ),
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.format_list_numbered,
                                size: 17,
                                color: Colors.grey,
                              ),

                              const SizedBox(width: 7),

                              const Text(
                                'Jumlah (porsi)',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                ),
                              ),

                              // Spacer: mendorong widget setelahnya ke ujung kanan
                              const Spacer(),

                              // Tombol kurang (-)
                              GestureDetector(
                                // Tombol kurang hanya aktif kalau jumlah lebih dari 0, jadi jumlah tidak bisa minus.
                                // null artinya tombol tidak bisa ditekan
                                onTap: _quantity > 0
                                    ? () {
                                        // setState: memperbarui tampilan supaya angka yang baru langsung terlihat
                                        setState(() {
                                          _quantity--;
                                        });
                                      }
                                    : null,
                                child: const Icon(
                                  Icons.remove,
                                  size: 16,
                                  color: Colors.grey,
                                ),
                              ),

                              const SizedBox(width: 12),

                              // Tampilkan jumlah porsi
                              Text(
                                '$_quantity',
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),

                              const SizedBox(width: 12),

                              // Tombol tambah (+)
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _quantity++;
                                  });
                                },
                                child: const Icon(
                                  Icons.add,
                                  size: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Total harga
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey,
                              ),
                            ),

                            Text(
                              // Kalau sudah ada pesanan tampilkan total harga, kalau belum tampilkan Rp 0
                              _quantity > 0
                                  ? 'Rp ${formatPrice(_totalPrice)}'
                                  : 'Rp 0',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                // Warna hijau kalau ada pesanan, abu-abu kalau belum ada
                                color: _quantity > 0
                                    ? const Color(0xFF5FA86B)
                                    : Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Tombol Simpan, kembali ke beranda + kirim quantity baru
                  SizedBox(
                    width: double.infinity,
                    height: 34,
                    child: ElevatedButton.icon(
                      // Navigator.pop(context, _quantity) → kirim data balik
                      // ke HomePage
                      onPressed: () => Navigator.pop(context, _quantity),
                      icon: const Icon(Icons.shopping_cart, size: 14),
                      label: const Text(
                        'Simpan Pesanan',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      // Gaya tombol
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF9800),
                        // Warna tulisan dan ikon tombol: putih
                        foregroundColor: Colors.white,
                        elevation: 0,
                        // Bentuk tombol dengan sudut membulat
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
