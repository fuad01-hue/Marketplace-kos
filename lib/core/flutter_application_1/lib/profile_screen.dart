import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9), // Warna latar abu-abu terang
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bagian Header Biru & Kartu Profil
            Stack(
              clipBehavior: Clip.none,
              children: [
                // Background Biru Melengkung
                Container(
                  height: 180,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.blue, // Sesuaikan warna birunya nanti
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(30),
                    ),
                  ),
                  child: const Center(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 40),
                      child: Text(
                        'Profil',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                // Kartu Profil Putih
                Container(
                  margin: const EdgeInsets.only(top: 120, left: 20, right: 20),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Ganti dengan aset gambarmu nanti
                      const CircleAvatar(
                        radius: 35,
                        backgroundImage: AssetImage('assets/dummy_profile.png'),
                        backgroundColor: Colors.grey,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Nama Kamu',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            _buildProfileInfo(Icons.male, 'Laki-laki'),
                            _buildProfileInfo(Icons.phone, '08*******890'),
                            _buildProfileInfo(Icons.location_on, 'Lhokseumawe'),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade100,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                        ),
                        child: const Text(
                          'Edit Profil',
                          style: TextStyle(color: Colors.blue, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 30),

            // Kategori AKTIVITAS
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'AKTIVITAS',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            _buildMenuCard([
              _buildMenuItem(Icons.search, 'Riwayat Pencarian'),
              _buildMenuItem(Icons.calendar_month, 'Booking & Pembayaran'),
              _buildMenuItem(Icons.star_border, 'Ulasan Saya', showBorder: false),
            ]),

            const SizedBox(height: 20),

            // Kategori PENGATURAN
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'PENGATURAN',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            _buildMenuCard([
              _buildMenuItem(Icons.notifications_none, 'Notifikasi'),
              _buildMenuItem(Icons.lock_outline, 'Ubah Kata Sandi'),
              _buildMenuItem(Icons.headset_mic_outlined, 'Bantuan & CS'),
              _buildMenuItem(Icons.logout, 'Keluar', isLogout: true, showBorder: false),
            ]),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // Widget bantuan untuk teks kecil di kartu profil
  Widget _buildProfileInfo(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        children: [
          Icon(icon, size: 12, color: Colors.grey.shade700),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }

  // Widget bantuan untuk kotak menu putih
  Widget _buildMenuCard(List<Widget> children) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  // Widget bantuan untuk setiap baris menu
  Widget _buildMenuItem(IconData icon, String title, {bool showBorder = true, bool isLogout = false}) {
    return Container(
      decoration: BoxDecoration(
        border: showBorder
            ? Border(bottom: BorderSide(color: Colors.grey.shade200))
            : null,
      ),
      child: ListTile(
        leading: Icon(icon, color: isLogout ? Colors.red : Colors.grey.shade700),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isLogout ? Colors.red : Colors.black87,
          ),
        ),
        trailing: Icon(Icons.chevron_right, color: Colors.grey.shade400, size: 20),
        onTap: () {},
      ),
    );
  }
}