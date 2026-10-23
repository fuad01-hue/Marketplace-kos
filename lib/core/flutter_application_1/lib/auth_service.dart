/// Layanan login. Saat ini memakai AKUN DEMO lokal supaya alur
/// login -> dashboard bisa dicoba. Nanti ganti isi fungsi [login]
/// dengan Firebase Auth atau API server Anda; halaman lain tidak perlu diubah.
class AuthService {
  AuthService._();

  // ===== Akun demo (hapus saat sudah memakai server sungguhan) =====
  static const String demoEmail = 'admin@ayokost.com';
  static const String demoPassword = '123456';

  /// Mengembalikan `null` jika login berhasil, atau pesan error jika gagal.
  static Future<String?> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 800)); // simulasi loading

    if (email.toLowerCase() != demoEmail) {
      return 'Akun tidak ditemukan';
    }
    if (password != demoPassword) {
      return 'Sandi salah';
    }
    return null; // berhasil
  }
}