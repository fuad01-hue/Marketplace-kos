import 'package:flutter/material.dart';

class SettingNotifikasiPage extends StatefulWidget {
  const SettingNotifikasiPage({super.key});

  @override
  State<SettingNotifikasiPage> createState() => _SettingNotifikasiPageState();
}

class _SettingNotifikasiPageState extends State<SettingNotifikasiPage> {
  // Status toggle switch (default aktif sesuai desain Figma)
  bool _statusBooking = true;
  bool _pesanBaru = true;
  bool _kosFavorit = true;
  bool _promoInfo = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          // ==========================================
          // HEADER BIRU DENGAN TOMBOL KEMBALI
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
                  'Notifikasi',
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
          // DAFTAR TOGGLE PENGATURAN NOTIFIKASI
          // ==========================================
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              physics: const BouncingScrollPhysics(),
              children: [
                // 1. Status Booking
                _buildToggleCard(
                  title: 'Status Booking',
                  subtitle: 'Konfirmasi, pembayaran, dan pengingat',
                  value: _statusBooking,
                  onChanged: (val) => setState(() => _statusBooking = val),
                ),
                const SizedBox(height: 12),

                // 2. Pesan Baru
                _buildToggleCard(
                  title: 'Pesan Baru',
                  subtitle: 'Chat dari Pemilik Kos',
                  value: _pesanBaru,
                  onChanged: (val) => setState(() => _pesanBaru = val),
                ),
                const SizedBox(height: 12),

                // 3. Kos Favorit
                _buildToggleCard(
                  title: 'Kos Favorit',
                  subtitle: 'Turun harga atau kamar kosong',
                  value: _kosFavorit,
                  onChanged: (val) => setState(() => _kosFavorit = val),
                ),
                const SizedBox(height: 12),

                // 4. Promo & Info
                _buildToggleCard(
                  title: 'Promo & Info',
                  subtitle: 'Diskon dan Rekomendasi',
                  value: _promoInfo,
                  onChanged: (val) => setState(() => _promoInfo = val),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleCard({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEEF2F6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            activeColor: Colors.white,
            activeTrackColor: const Color(0xFF1E88E5),
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: const Color(0xFFCBD5E1),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}