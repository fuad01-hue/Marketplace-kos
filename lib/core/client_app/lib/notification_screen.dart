import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // DefaultTabController untuk mengatur 4 tab (Semua, Booking, Pesan, Lainnya)
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.blue,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
            onPressed: () => Navigator.pop(context), // Tombol kembali
          ),
          title: const Text(
            'Notifikasi',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16, top: 12, bottom: 12),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.blue,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text('Tandai telah dibaca', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
          bottom: const TabBar(
            isScrollable: true,
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            tabs: [
              Tab(text: 'Semua'),
              Tab(text: 'Booking'),
              Tab(text: 'Pesan'),
              Tab(text: 'Lainnya'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildNotifList(), // Tab Semua
            _buildNotifList(), // Tab Booking (Bisa diubah isinya nanti)
            _buildNotifList(), // Tab Pesan
            _buildNotifList(), // Tab Lainnya
          ],
        ),
      ),
    );
  }

  // Widget untuk membuat daftar notifikasi
  Widget _buildNotifList() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Hari ini', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
        const SizedBox(height: 12),
        _buildNotifItem(
          icon: Icons.check_circle,
          iconColor: Colors.blue,
          title: 'Pembayaran berhasil',
          desc: 'Pembayaran Kos Mahogani sebesar Rp 700.000 sudah terkonfirmasi.',
          time: '10 menit yang lalu',
          isUnread: true,
        ),
        _buildNotifItem(
          icon: Icons.chat_bubble_outline,
          iconColor: Colors.grey,
          title: 'Pemilik Kos Mahogani mengirim pesan',
          desc: '"Kamar sudah siap ditempati."',
          time: '2 jam yang lalu',
          isUnread: true,
        ),
        const SizedBox(height: 20),
        const Text('Minggu ini', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
        const SizedBox(height: 12),
        _buildNotifItem(
          icon: Icons.local_offer_outlined,
          iconColor: Colors.orange,
          title: 'Harga Turun',
          desc: 'Kos Melati di Lhokseumawe sekarang Rp 600.000 per bulan.',
          time: '2 hari yang lalu',
          isUnread: false,
        ),
        _buildNotifItem(
          icon: Icons.warning_amber_rounded,
          iconColor: Colors.red,
          title: 'Batas bayar besok',
          desc: 'Selesaikan pembayaran kos Meranti sebelum 5 Oktober 2026, 16:00.',
          time: '3 hari yang lalu',
          isUnread: false,
        ),
      ],
    );
  }

  // Widget kerangka untuk setiap baris notifikasi
  Widget _buildNotifItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String desc,
    required String time,
    required bool isUnread,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: iconColor.withOpacity(0.1),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 4),
                Text(desc, style: const TextStyle(fontSize: 12, color: Colors.black87)),
                const SizedBox(height: 4),
                Text(time, style: const TextStyle(fontSize: 10, color: Colors.grey)),
              ],
            ),
          ),
          if (isUnread) // Menampilkan titik biru jika belum dibaca
            Container(
              margin: const EdgeInsets.only(top: 6),
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
            )
        ],
      ),
    );
  }
}