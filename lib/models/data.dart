//Membuat kelas user untuk menyimpan data user untuk login
class User {
  // Nama pengguna untuk login
  String username;
  // Kata sandi untuk login
  String password;
  // Nama lengkap yang ditampilkan di halaman Profil
  String nama;

  // Constructor: cara membuat objek User
  User({
    required this.username,
    required this.password,
    required this.nama,
  }); //syarat kalo mau membuat objek
}

// Data user contoh (akun bawaan) yang dipakai untuk login.
// Datanya ditulis langsung di kode, belum memakai database
User user1 = User(username: 'Nayla', password: 'nayla123', nama: 'Dyah Nayla');
