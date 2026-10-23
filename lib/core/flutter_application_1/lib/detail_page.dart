import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  final Map<String, dynamic> kostData;

  const DetailPage({super.key, required this.kostData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      body: Stack(
        children: [
          // 1. KONTEN DETAIL (Dapat di-scroll)
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 100), // Agar tidak tertutup tombol bawah
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Biru Melengkung + Gambar Utama
                _buildHeader(context),

                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nama Kos
                      Text(
                        kostData['name'] ?? 'Nama Kos',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF212121),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Badge Gender & Lokasi
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE3F2FD),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: const Color(0xFF42A5F5)),
                            ),
                            child: Text(
                              kostData['type'] ?? 'Semua',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E88E5),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.location_on_outlined,
                            size: 16,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            kostData['location'] ?? 'Lhokseumawe',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Rating (★ 4.7 (9))
                      const Row(
                        children: [
                          Icon(
                            Icons.star_rounded,
                            color: Colors.amber,
                            size: 18,
                          ),
                          SizedBox(width: 4),
                          Text(
                            '4.7',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 2),
                          Text(
                            '(9)',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Divider(color: Colors.black12, thickness: 1),
                      const SizedBox(height: 12),

                      // Fasilitas Kamar
                      const Text(
                        'Fasilitas Kamar',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF212121),
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildFacilitiesList(),

                      const SizedBox(height: 24),

                      // Foto Interior/Kamar Terkait (Bagian bawah)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          'assets/Interior-kamar.png', // Ganti dengan hasil export image_8.png
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            height: 180,
                            width: double.infinity,
                            color: Colors.grey.shade300,
                            alignment: Alignment.center,
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.bed_outlined,
                                    size: 40, color: Colors.grey),
                                SizedBox(height: 4),
                                Text(
                                  'Taruh foto interior_kamar.png di folder assets/',
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.black54),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 2. TOMBOL AKSI DI BAWAH (Melayang)
          _buildBottomButtons(),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return SizedBox(
      height: 280,
      child: Stack(
        children: [
          // Background Biru Melengkung
          Container(
            height: 180,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1E88E5), Color(0xFF42A5F5)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(28),
              ),
            ),
          ),

          // Tombol Kembali
          Positioned(
            top: 45,
            left: 15,
            child: CircleAvatar(
              backgroundColor: Colors.white24,
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          ),

          // Foto Kos Utama di Tengah (Melayang)
          Positioned(
            top: 100,
            left: 20,
            right: 20,
            child: Container(
              height: 170,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  kostData['image'] ?? 'assets/Kost-meranti.png',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey.shade300,
                    alignment: Alignment.center,
                    child: const Icon(Icons.home_work_outlined,
                        size: 50, color: Colors.grey),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFacilitiesList() {
    final List<String> facilities = [
      'AC',
      'Kasur',
      'Meja',
      'Lemari',
      'Jendela',
      'Tempat Tidur',
      'Kursi',
      'WiFi',
    ];

    return Column(
      children: facilities.map((facility) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              const Text(
                '•',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                facility,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBottomButtons() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 25),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Row(
          children: [
            // Tombol Chat Pemilik
            Expanded(
              child: SizedBox(
                height: 48,
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF42A5F5)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Chat Pemilik Sekarang',
                    style: TextStyle(
                      color: Color(0xFF1E88E5),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Tombol Booking Sekarang
            Expanded(
              child: SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF42A5F5),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Booking Sekarang',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}