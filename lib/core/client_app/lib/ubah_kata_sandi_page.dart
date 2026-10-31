import 'package:flutter/material.dart';

class UbahKataSandiPage extends StatefulWidget {
  const UbahKataSandiPage({super.key});

  @override
  State<UbahKataSandiPage> createState() => _UbahKataSandiPageState();
}

class _UbahKataSandiPageState extends State<UbahKataSandiPage> {
  final TextEditingController _sandiLamaController = TextEditingController();
  final TextEditingController _sandiBaruController = TextEditingController();
  final TextEditingController _konfirmasiController = TextEditingController();

  // State untuk toggle visibilitas kata sandi (lihat / sembunyikan)
  bool _obscureSandiLama = true;
  bool _obscureSandiBaru = true;
  bool _obscureKonfirmasi = true;

  // Pesan error validasi
  String? _errorMessage;

  @override
  void dispose() {
    _sandiLamaController.dispose();
    _sandiBaruController.dispose();
    _konfirmasiController.dispose();
    super.dispose();
  }

  void _validasiDanSimpan() {
    final sandiLama = _sandiLamaController.text.trim();
    final sandiBaru = _sandiBaruController.text.trim();
    final konfirmasi = _konfirmasiController.text.trim();

    if (sandiLama.isEmpty) {
      setState(() => _errorMessage = 'Masukkan kata sandi lama');
      return;
    }

    if (sandiBaru.length < 8) {
      setState(() => _errorMessage = 'Sandi baru minimal 8 karakter');
      return;
    }

    // Pengecekan kecocokan sandi baru dan konfirmasi (sesuai Figma)
    if (sandiBaru != konfirmasi) {
      setState(() => _errorMessage = 'Sandi baru tidak sesuai');
      return;
    }

    // Jika semua valid
    setState(() => _errorMessage = null);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Kata sandi berhasil diperbarui!'),
        backgroundColor: const Color(0xFF1E88E5),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    Navigator.pop(context); // Kembali ke menu Profil
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          // ==========================================
          // 1. HEADER BIRU DENGAN TOMBOL KEMBALI
          // ==========================================
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.paddingOf(context).top + 8,
              left: 12,
              right: 20,
              bottom: 16,
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1E88E5), Color(0xFF42A5F5)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Ubah Kata Sandi',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // ==========================================
          // 2. FORM INPUT KATA SANDI
          // ==========================================
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Field Sandi Lama
                  _buildLabel('Sandi lama'),
                  const SizedBox(height: 8),
                  _buildPasswordField(
                    controller: _sandiLamaController,
                    hint: 'Masukkan sandi lama',
                    isObscure: _obscureSandiLama,
                    onToggleObscure: () {
                      setState(() => _obscureSandiLama = !_obscureSandiLama);
                    },
                    onChanged: (_) {
                      if (_errorMessage != null) setState(() => _errorMessage = null);
                    },
                  ),

                  const SizedBox(height: 20),

                  // Field Sandi Baru
                  _buildLabel('Sandi baru'),
                  const SizedBox(height: 8),
                  _buildPasswordField(
                    controller: _sandiBaruController,
                    hint: 'Masukkan sandi baru',
                    isObscure: _obscureSandiBaru,
                    onToggleObscure: () {
                      setState(() => _obscureSandiBaru = !_obscureSandiBaru);
                    },
                    onChanged: (_) {
                      if (_errorMessage != null) setState(() => _errorMessage = null);
                    },
                  ),
                  const SizedBox(height: 6),

                  // Teks Petunjuk Sandi Kuat (Figma)
                  const Text(
                    'Buat sandi kuat dengan minimal 8 karakter, huruf besar, huruf kecil, dan angka.',
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFF64748B),
                      height: 1.35,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Field Konfirmasi Sandi Baru
                  _buildLabel('Konfirmasi sandi baru'),
                  const SizedBox(height: 8),
                  _buildPasswordField(
                    controller: _konfirmasiController,
                    hint: 'Konfirmasi sandi baru',
                    isObscure: _obscureKonfirmasi,
                    onToggleObscure: () {
                      setState(() => _obscureKonfirmasi = !_obscureKonfirmasi);
                    },
                    onChanged: (val) {
                      if (_errorMessage != null) {
                        setState(() => _errorMessage = null);
                      }
                    },
                  ),

                  // Teks Error Merah jika Tidak Sesuai (Figma)
                  if (_errorMessage != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      _errorMessage!,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFFE53935),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // ==========================================
          // 3. TOMBOL AKSI BAWAH
          // ==========================================
          Container(
            padding: EdgeInsets.fromLTRB(
              24,
              12,
              24,
              MediaQuery.paddingOf(context).bottom + 16,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFEEF2F6))),
            ),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _validasiDanSimpan,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E88E5),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Simpan Perubahan',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hint,
    required bool isObscure,
    required VoidCallback onToggleObscure,
    required ValueChanged<String> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: (_errorMessage != null && hint.contains('Konfirmasi'))
              ? const Color(0xFFE53935)
              : const Color(0xFFE2E8F0),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: isObscure,
        onChanged: onChanged,
        style: const TextStyle(fontSize: 13.5, color: Colors.black87),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(fontSize: 13, color: Colors.grey.shade400),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: InputBorder.none,
          suffixIcon: IconButton(
            icon: Icon(
              isObscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
              color: Colors.grey.shade500,
              size: 20,
            ),
            onPressed: onToggleObscure,
          ),
        ),
      ),
    );
  }
}