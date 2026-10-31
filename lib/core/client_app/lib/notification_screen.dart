import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  String _selectedTab = 'Semua';

  // Data notifikasi dengan status isUnread
  final  _notifications = [
    {
      'id': 1,
      'title': 'Pembayaran berhasil',
      'desc': 'Pembayaran Kos Mahogani sebesar Rp 700.000 sudah terkonfirmasi.',
      'time': '10 menit yang lalu',
      'category': 'Booking',
      'period': 'Hari ini',
      'icon': Icons.check_circle,
      'iconColor': Color(0xFF1E88E5),
      'iconBg': Color(0xFFE3F2FD),
      'isUnread': true, // Titik biru aktif
    },
    {
      'id': 2,
      'title': 'Pemilik Kos Mahogani mengirim pesan',
      'desc': '"Kamar sudah siap ditempati."',
      'time': '2 jam yang lalu',
      'category': 'Pesan',
      'period': 'Hari ini',
      'icon': Icons.chat_bubble_outline,
      'iconColor': Color(0xFF757575),
      'iconBg': Color(0xFFF1F5F9),
      'isUnread': true, // Titik biru aktif
    },
    {
      'id': 3,
      'title': 'Harga Turun',
      'desc': 'Kos Melati di Lhokseumawe sekarang Rp 600.000 per bulan.',
      'time': '2 hari yang lalu',
      'category': 'Lainnya',
      'period': 'Minggu ini',
      'icon': Icons.local_offer_outlined,
      'iconColor': Color(0xFFFB8C00),
      'iconBg': Color(0xFFFFF3E0),
      'isUnread': false,
    },
    {
      'id': 4,
      'title': 'Batas bayar besok',
      'desc': 'Selesaikan pembayaran kos Meranti sebelum 5 Oktober 2026, 16:00.',
      'time': '3 hari yang lalu',
      'category': 'Booking',
      'period': 'Minggu ini',
      'icon': Icons.warning_amber_rounded,
      'iconColor': Color(0xFFE53935),
      'iconBg': Color(0xFFFFEBEE),
      'isUnread': false,
    },
  ];

  // 1. FUNGSI UNTUK MENGHILANGKAN SEMUA TITIK BIRU
  void _tandaiSemuaTelahDibaca() {
    setState(() {
      for (var notif in _notifications) {
        notif['isUnread'] = false;
      }
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Semua notifikasi ditandai telah dibaca'),
        duration: const Duration(seconds: 1),
        backgroundColor: const Color(0xFF1E88E5),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  // 2. FUNGSI JIKA SALAH SATU ITEM DIKLIK (HILANGKAN TITIK BIRU ITEM TERSEBUT)
  void _bacaNotifikasi(int id) {
    setState(() {
      final index = _notifications.indexWhere((item) => item['id'] == id);
      if (index != -1) {
        _notifications[index]['isUnread'] = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _notifications.where((n) {
      if (_selectedTab == 'Semua') return true;
      return n['category'] == _selectedTab;
    }).toList();

    final hariIniList = filtered.where((n) => n['period'] == 'Hari ini').toList();
    final mingguIniList = filtered.where((n) => n['period'] == 'Minggu ini').toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // ==========================================
          // HEADER BIRU DENGAN TOMBOL "Tandai telah dibaca"
          // ==========================================
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.paddingOf(context).top + 8,
              left: 12,
              right: 16,
              bottom: 8,
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1E88E5), Color(0xFF42A5F5)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          'Notifikasi',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    // TOMBOL TANDAI TELAH DIBACA
                    InkWell(
                      onTap: _tandaiSemuaTelahDibaca,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Text(
                          'Tandai telah dibaca',
                          style: TextStyle(
                            color: Color(0xFF1E88E5),
                            fontSize: 11.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // TAB FILTER (Semua, Booking, Pesan, Lainnya)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: ['Semua', 'Booking', 'Pesan', 'Lainnya'].map((tab) {
                    final isSelected = _selectedTab == tab;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedTab = tab),
                      child: Column(
                        children: [
                          Text(
                            tab,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.white70,
                              fontSize: 14,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            height: 3,
                            width: 32,
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.white : Colors.transparent,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

          // ==========================================
          // DAFTAR ITEM NOTIFIKASI
          // ==========================================
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              physics: const BouncingScrollPhysics(),
              children: [
                if (hariIniList.isNotEmpty) ...[
                  const Text(
                    'Hari ini',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...hariIniList.map((item) => _buildNotificationTile(item)),
                  const SizedBox(height: 16),
                ],

                if (mingguIniList.isNotEmpty) ...[
                  const Text(
                    'Minggu ini',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...mingguIniList.map((item) => _buildNotificationTile(item)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationTile(Map<String, dynamic> item) {
    final bool isUnread = item['isUnread'] as bool;
    final int id = item['id'] as int;

    return InkWell(
      onTap: () => _bacaNotifikasi(id),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Lingkaran Ikon Notifikasi
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: item['iconBg'] as Color,
                shape: BoxShape.circle,
              ),
              child: Icon(
                item['icon'] as IconData,
                color: item['iconColor'] as Color,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),

            // Konten Teks
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['title'].toString(),
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    item['desc'].toString(),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade700,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item['time'].toString(),
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ],
              ),
            ),

            // TITIK BIRU NOTIFIKASI BELUM DIBACA
            if (isUnread)
              Padding(
                padding: const EdgeInsets.only(top: 6, left: 8),
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFF1E88E5), // Titik biru
                    shape: BoxShape.circle,
                  ),
                ),
              )
            else
              const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}