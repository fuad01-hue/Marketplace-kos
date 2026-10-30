import 'package:flutter/material.dart';
import 'halaman_login.dart';
import 'notification_screen.dart';
import 'reset_password_flow.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  // Notifikasi melayang putih rapi (Pengganti SnackBar hitam kaku)
  void _tampilToast(BuildContext context, String pesan, {IconData icon = Icons.info_outline}) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 4,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.white,
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: Color(0xFFEEF2F6), width: 1.2),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        duration: const Duration(seconds: 2),
        content: Row(
          children: [
            Icon(icon, color: const Color(0xFF1E88E5), size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                pesan,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Alur keluar akun
  void _prosesKeluar(BuildContext context) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 6,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.white,
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFFEEF2F6), width: 1.2),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        duration: const Duration(milliseconds: 1500),
        content: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: Color(0xFF2196F3),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 14),
            const Text(
              'Berhasil Keluar!',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );

    Future.delayed(const Duration(milliseconds: 900), () {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HalamanLogin()),
        (route) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Profil Pengguna
              Row(
                children: [
                  const CircleAvatar(
                    radius: 28,
                    backgroundColor: Color(0xFFE3F2FD),
                    child: Icon(
                      Icons.person,
                      size: 32,
                      color: Color(0xFF1E88E5),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Nama Pengguna',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: const [
                            Icon(Icons.location_on_outlined, size: 14, color: Colors.grey),
                            SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                'Kota Lhokseumawe',
                                style: TextStyle(fontSize: 12, color: Colors.grey),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // Kelompok: Aktivitas
              const Text(
                'AKTIVITAS',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 10),
              _buildMenuCard(
                children: [
                  _buildMenuItem(
                    icon: Icons.search,
                    title: 'Riwayat Pencarian',
                    onTap: () => _tampilToast(context, 'Riwayat pencarian masih kosong'),
                  ),
                  const Divider(height: 1, indent: 48, color: Color(0xFFF1F5F9)),
                  _buildMenuItem(
                    icon: Icons.calendar_today_outlined,
                    title: 'Booking & Pembayaran',
                    onTap: () => _tampilToast(context, 'Belum ada riwayat booking aktif'),
                  ),
                  const Divider(height: 1, indent: 48, color: Color(0xFFF1F5F9)),
                  _buildMenuItem(
                    icon: Icons.star_border_rounded,
                    title: 'Ulasan Saya',
                    onTap: () => _tampilToast(context, 'Belum ada ulasan yang dibuat'),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Kelompok: Pengaturan
              const Text(
                'PENGATURAN',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 10),
              _buildMenuCard(
                children: [
                  _buildMenuItem(
                    icon: Icons.notifications_none_rounded,
                    title: 'Notifikasi',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NotificationScreen(),
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1, indent: 48, color: Color(0xFFF1F5F9)),
                  _buildMenuItem(
                    icon: Icons.lock_outline_rounded,
                    title: 'Ubah Kata Sandi',
                    onTap: () {
                      // Langsung terhubung ke halaman buat password baru
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BuatPasswordBaruPage(),
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1, indent: 48, color: Color(0xFFF1F5F9)),
                  _buildMenuItem(
                    icon: Icons.headset_mic_outlined,
                    title: 'Bantuan & CS',
                    onTap: () => _tampilToast(
                      context,
                      'Menghubungkan ke CS AyoKost...',
                      icon: Icons.headset_mic_outlined,
                    ),
                  ),
                  const Divider(height: 1, indent: 48, color: Color(0xFFF1F5F9)),
                  _buildMenuItem(
                    icon: Icons.logout_rounded,
                    title: 'Keluar',
                    isDanger: true,
                    onTap: () => _prosesKeluar(context),
                  ),
                ],
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuCard({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEEF2F6), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDanger = false,
  }) {
    final itemColor = isDanger ? const Color(0xFFE53935) : Colors.black87;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(icon, color: itemColor, size: 22),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isDanger ? FontWeight.bold : FontWeight.w500,
                    color: itemColor,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                size: 20,
                color: isDanger ? const Color(0xFFE53935) : Colors.grey.shade400,
              ),
            ],
          ),
        ),
      ),
    );
  }
}