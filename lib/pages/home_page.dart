// Library utama Flutter untuk membuat tampilan
import 'package:flutter/material.dart';

// Model data makanan
import '../models/food_item.dart';
// Halaman detail makanan
import 'detail_page.dart';

// StatefulWidget karena quantity makanan bisa berubah
// saat user balik dari halaman detail
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  // Membuat State untuk menyimpan data halaman Beranda
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Mengambil data menu dari FoodItem.sampleData.
  // Ini bukan salinan, jadi perubahan di sini juga terlihat di halaman lain (misalnya Favorit)
  // STATE: list makanan: quantity-nya bisa berubah
  final List<FoodItem> _menuItems = FoodItem.sampleData;

  // Getter: hitung total semua pesanan
  int get _grandTotal =>
      // fold: menjumlahkan totalPrice semua menu, dimulai dari angka 0
      _menuItems.fold(0, (sum, item) => sum + item.totalPrice);

  // build: fungsi yang menggambar tampilan halaman
  @override
  Widget build(BuildContext context) {
    // Scaffold: kerangka dasar halaman (ada appBar di atas dan body sebagai isi)
    return Scaffold(
      // Warna latar halaman: abu-abu sangat muda
      backgroundColor: const Color(0xFFF5F5F5),
      // Bar judul di bagian atas
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
        // Judul diletakkan di tengah
        centerTitle: true,
        // Menghilangkan bayangan di bawah bar
        elevation: 0,
      ),
      // Isi halaman disusun dari atas ke bawah: banner total pesanan, lalu daftar menu
      body: Column(
        children: [
          // Banner total pesanan
          Container(
            // Lebar selebar layar
            width: double.infinity,
            color: const Color(0xFFFF9800),
            // Jarak di dalam banner: kiri-kanan 16, atas-bawah 10
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Text(
              // Menampilkan total semua pesanan. Angkanya ikut berubah saat data berubah
              'Total Pesanan: Rp ${formatPrice(_grandTotal)}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          // Expanded: memakai seluruh sisa ruang layar supaya daftar bisa di-scroll
          // ListView.builder: tampilkan daftar makanan
          Expanded(
            child: ListView.builder(
              // Jarak 12 di semua sisi daftar
              padding: const EdgeInsets.all(12),
              // Jumlah item yang ditampilkan = jumlah menu
              itemCount: _menuItems.length,
              // Dipanggil untuk setiap item. index = urutan item (mulai dari 0)
              itemBuilder: (context, index) {
                // Ambil data makanan sesuai urutannya
                final item = _menuItems[index];
                // Buat kartu untuk makanan tersebut
                return _buildFoodCard(item, index);
              },
            ),
          ),
        ],
      ),
    );
  }

  // Fungsi pembuat kartu untuk satu makanan
  Widget _buildFoodCard(FoodItem item, int index) {
    // GestureDetector: membuat widget di dalamnya bisa mendeteksi ketukan
    return GestureDetector(
      // Navigasi ke DetailPage saat kartu diklik
      onTap: () async {
        // Navigator.push: membuka halaman baru (DetailPage) sambil mengirim data makanan yang diklik
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
            // Simpan jumlah porsi baru ke makanan yang sesuai
            _menuItems[index].quantity = result;
          });
        }
      },

      child: Container(
        // Jarak 10 di bawah kartu, supaya antar kartu tidak menempel
        margin: const EdgeInsets.only(bottom: 10),
        // Tampilan kartu: latar putih, sudut membulat, dan ada bayangan halus
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          // Bayangan kartu
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.07),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        // Row: menyusun widget ke samping. Gambar di kiri, info di kanan
        child: Row(
          children: [
            // ClipRRect: memotong sudut gambar supaya melengkung (mengikuti sudut kartu)
            // ── Gambar makanan
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
              // Memuat gambar dari internet lewat URL
              child: Image.network(
                item.imageUrl,
                width: 100,
                height: 100,
                // Gambar memenuhi kotak, bagian yang berlebih dipotong
                fit: BoxFit.cover,
                // Tampilan cadangan kalau gambar gagal dimuat (ikon makanan abu-abu)
                errorBuilder: (_, __, ___) => Container(
                  width: 100,
                  height: 100,
                  color: Colors.grey[200],
                  child: const Icon(Icons.fastfood, color: Colors.grey),
                ),
              ),
            ),

            // Expanded: bagian info memakai sisa lebar kartu setelah gambar
            // ── Info makanan ──
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                child: Column(
                  // Isi kolom rata kiri
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
                          // Saat ikon hati diketuk, ubah status favorit
                          onTap: () {
                            setState(() {
                              // Membalik nilai: kalau tadinya true jadi false, kalau tadinya false jadi true
                              item.isFavorite =
                                  !item.isFavorite; // balik true/false
                            });
                          },
                          child: Icon(
                            item.isFavorite
                                // Kalau favorit: ikon hati penuh. Kalau bukan: hati kosong (garis luar saja)
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
                      // Deskripsi paling banyak 2 baris
                      maxLines: 2,
                      // Kalau teks lebih panjang, dipotong dan diberi titik-titik (...)
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),

                    // Jumlah porsi yang dipilih user
                    // Otomatis berubah saat balik dari detail
                    Text(
                      // Menampilkan jumlah porsi yang dipilih
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
                      // Satu widget di ujung kiri, satunya di ujung kanan
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
                          // Kalau jumlah porsi lebih dari 0 tampilkan total harga, kalau tidak tampilkan 0
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
