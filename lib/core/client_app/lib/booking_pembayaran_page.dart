import 'package:flutter/material.dart';
import 'payment_page.dart';


class BookingPembayaranPage extends StatefulWidget {
  const BookingPembayaranPage({super.key});

  @override
  State<BookingPembayaranPage> createState() => _BookingPembayaranPageState();
}

class _BookingPembayaranPageState extends State<BookingPembayaranPage> {
  // Data daftar booking dinamis
  late List<Map<String, dynamic>> _bookingList;

  @override
  void initState() {
    super.initState();
    _bookingList = [
      {
        'id': '1',
        'title': 'Kos Mahanti',
        'period': 'Masuk: 10 Okt 2026 • 2 Bulan',
        'total': 'Rp 1.900.000',
        'status': 'Menunggu Bayar',
        'badgeBg': const Color(0xFFFEF3C7),
        'badgeTextColor': const Color(0xFFD97706),
        'image': 'assets/Kost-mahonti.png',
        'extraInfo': 'Batas bayar: 11 Okt 2026, 18.00',
      },
      {
        'id': '2',
        'title': 'Kos Meranti',
        'period': 'Masuk: 15 Sep 2026 • 12 Bulan',
        'total': 'Rp 9.200.000',
        'status': 'Lunas',
        'badgeBg': const Color(0xFFDCFCE7),
        'badgeTextColor': const Color(0xFF16A34A),
        'image': 'assets/Kost-meranti.png',
      },
      {
        'id': '3',
        'title': 'Kos Mahogani',
        'period': '1 Mei - 31 Agu 2026',
        'total': 'Rp 2.000.000',
        'status': 'Selesai',
        'badgeBg': const Color(0xFFF1F5F9),
        'badgeTextColor': const Color(0xFF64748B),
        'image': 'assets/Kost-Mahogani.png',
      },
      {
        'id': '4',
        'title': 'Kos Meranti',
        'period': '1 Januari - 31 Jul 2026',
        'total': 'Rp 3.500.000',
        'status': 'Selesai',
        'badgeBg': const Color(0xFFF1F5F9),
        'badgeTextColor': const Color(0xFF64748B),
        'image': 'assets/Kost-meranti.png',
      },
    ];
  }

  // Fungsi Batalkan Booking
  void _batalkanBooking(String id, String namaKos) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Batalkan Booking?',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        content: Text(
          'Apakah Anda yakin ingin membatalkan pesanan $namaKos?',
          style: const TextStyle(fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Tidak', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);

              // Hapus item dari daftar secara instan
              setState(() {
                _bookingList.removeWhere((item) => item['id'] == id);
              });

              // SnackBar melayang rapi
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Pesanan $namaKos berhasil dibatalkan'),
                  backgroundColor: const Color(0xFFEF4444),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            child: const Text('Ya, Batalkan', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          // Header Biru
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
                  'Booking & Pembayaran',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Daftar Pesan Kos
          Expanded(
            child: _bookingList.isEmpty
                ? const Center(
                    child: Text(
                      'Belum ada riwayat booking',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                    physics: const BouncingScrollPhysics(),
                    itemCount: _bookingList.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 14),
                    itemBuilder: (context, index) {
                      final item = _bookingList[index];
                      return _buildBookingCard(item);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingCard(Map<String, dynamic> item) {
    final status = item['status'] as String;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEEF2F6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Info Kos & Badge
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  item['image'] as String,
                  width: 72,
                  height: 64,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 72,
                    height: 64,
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.home, color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            item['title'].toString(),
                            style: const TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: item['badgeBg'] as Color,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            status,
                            style: TextStyle(
                              color: item['badgeTextColor'] as Color,
                              fontSize: 10.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item['period'].toString(),
                      style: const TextStyle(fontSize: 11.5, color: Color(0xFF64748B)),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Total: ${item['total']}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Teks Tambahan Jika Menunggu Bayar
          if (item['extraInfo'] != null) ...[
            const SizedBox(height: 10),
            Text(
              item['extraInfo'].toString(),
              style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
            ),
          ],

          const SizedBox(height: 12),

          // Tombol Aksi Berdasarkan Status
          if (status == 'Menunggu Bayar') ...[
            SizedBox(
              width: double.infinity,
              height: 40,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentPage(
                        kostName: item['title'].toString(),
                        nominal: item['total'].toString(),
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E88E5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Bayar Sekarang',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              height: 40,
              child: OutlinedButton(
                onPressed: () => _batalkanBooking(
                  item['id'].toString(),
                  item['title'].toString(),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFEF4444)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Batal Booking',
                  style: TextStyle(
                    color: Color(0xFFEF4444),
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ] else if (status == 'Lunas') ...[
            SizedBox(
              width: double.infinity,
              height: 38,
              child: OutlinedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Membuka Invoice Pembayaran...'),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF1E88E5)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Lihat Detail & Invoice',
                  style: TextStyle(
                    color: Color(0xFF1E88E5),
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ] else ...[
            // Status Selesai -> Pesan Lagi
            SizedBox(
              width: double.infinity,
              height: 38,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentPage(
                        kostName: item['title'].toString(),
                        nominal: item['total'].toString(),
                      ),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF1E88E5)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Pesan lagi',
                  style: TextStyle(
                    color: Color(0xFF1E88E5),
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}