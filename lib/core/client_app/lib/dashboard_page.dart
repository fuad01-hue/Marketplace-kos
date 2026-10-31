import 'package:flutter/material.dart';
import 'detail_page.dart';
import 'notification_screen.dart';
import 'profile_screen.dart';
import 'search_page.dart';

class DashboardPage extends StatefulWidget {
  final bool isFavoriteView;

  const DashboardPage({
    super.key,
    this.isFavoriteView = false,
  });

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String _selectedCategory = 'Semua';
  final String _searchQuery = '';

  final List<String> _categories = [
    'Semua',
    'Laki - Laki',
    'Perempuan',
    'Campur',
  ];

  static final List<Map<String, dynamic>> _allKosts = [
    {
      'name': 'Kost Meranti',
      'location': 'Kota Lhokseumawe',
      'price': 'Rp. 700.000,00 / Bulan',
      'favPrice': 'Rp. 700.000,00 / Bulan',
      'type': 'Perempuan',
      'image': 'assets/Kost-meranti.png',
      'isFavorite': true,
    },
    {
      'name': 'Kost Mahogani',
      'location': 'Kota Lhokseumawe',
      'price': 'Rp. 700.000,00 / Bulan',
      'favPrice': 'Rp. 700.000,00 / Bulan',
      'type': 'Laki - Laki',
      'image': 'assets/Kost-Mahogani.png',
      'isFavorite': true,
    },
    {
      'name': 'Kost Mahonti',
      'location': 'Kota Lhokseumawe',
      'price': 'Rp. 700.000,00 / Bulan',
      'favPrice': 'Rp. 700.000,00 / Bulan',
      'type': 'Campur',
      'image': 'assets/Kost-mahonti.png',
      'isFavorite': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final bool isFav = widget.isFavoriteView;

    // Filter data berdasarkan tab favorit, kategori, dan kata kunci pencarian
    final filteredKosts = _allKosts.where((kost) {
      final matchesSearch = kost['name']
          .toString()
          .toLowerCase()
          .contains(_searchQuery.toLowerCase());

      if (isFav) {
        return (kost['isFavorite'] == true) && matchesSearch;
      }

      final matchesCategory = _selectedCategory == 'Semua' ||
          kost['type'] == _selectedCategory;
      return matchesCategory && matchesSearch;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      body: Column(
        children: [
          // 1. Header & Bar Pencarian
          _buildHeader(isFav),

          // 2. Filter Kategori (Hanya ditampilkan pada Beranda utama)
          if (!isFav) ...[
            const SizedBox(height: 12),
            _buildCategoryFilter(),
          ],

          const SizedBox(height: 12),

          // 3. Daftar Kartu Kos
          Expanded(
            child: filteredKosts.isEmpty
                ? Center(
                    child: Text(
                      isFav
                          ? 'Belum ada kos favorit'
                          : 'Tidak ada kos ditemukan',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    physics: const BouncingScrollPhysics(),
                    itemCount: filteredKosts.length,
                    itemBuilder: (context, index) {
                      final kost = filteredKosts[index];
                      return _buildKostCard(kost, isFav);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isFav) {
    return SizedBox(
      height: 175,
      child: Stack(
        children: [
          Container(
            height: 150,
            width: double.infinity,
            padding: const EdgeInsets.only(top: 45, left: 20, right: 20),
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
            child: isFav
                ? const Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Text(
                        'Kos Favoritku',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tombol Menuju Profil Pengguna
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ProfileScreen(),
                            ),
                          );
                        },
                        child: const Row(
                          children: [
                            Icon(
                              Icons.account_circle_outlined,
                              color: Colors.white,
                              size: 38,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Hi, Nama Kamu',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),

                      // Tombol Menuju Notifikasi
                      Stack(
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const NotificationScreen(),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.notifications_none,
                              color: Colors.white,
                              size: 26,
                            ),
                          ),
                          Positioned(
                            right: 12,
                            top: 12,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Colors.redAccent,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
          ),

          // Kolom Pencarian Melayang
          Positioned(
            bottom: 0,
            left: 20,
            right: 20,
            child: Container(
              height: 46,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                readOnly: true,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SearchPage(),
                    ),
                  );
                },
                decoration: const InputDecoration(
                  hintText: 'Pencarian...',
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: _categories.map((category) {
          final bool isSelected = _selectedCategory == category;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => setState(() => _selectedCategory = category),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF42A5F5) : Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0xFF42A5F5),
                    width: 1,
                  ),
                ),
                child: Text(
                  category,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : Colors.black87,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildKostCard(Map<String, dynamic> kost, bool isFav) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailPage(kostData: kost),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar Kos
            // Gambar Kos + Tombol Love
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  kost['image'].toString(),
                  width: double.infinity,
                  height: 160,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 160,
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.home, size: 40, color: Colors.grey),
                  ),
                ),
              ),

              // Tombol Love Bulat Putih (Pojok Kanan Atas Foto)
              Positioned(
                top: 8,
                right: 8,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {
                      setState(() {
                        kost['isFavorite'] = !(kost['isFavorite'] ?? false);
                      });

                      final bool isFavNow = kost['isFavorite'] ?? false;
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            isFavNow
                                ? '${kost['name']} disimpan ke favorit'
                                : '${kost['name']} dihapus dari favorit',
                          ),
                          duration: const Duration(seconds: 1),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.92),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.18),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        (kost['isFavorite'] ?? false)
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: (kost['isFavorite'] ?? false)
                            ? const Color(0xFFEF4444)
                            : Colors.grey.shade600,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
            const SizedBox(height: 10),

            // Nama Kos & Badge Tipe
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    kost['name'].toString(),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFF42A5F5)),
                  ),
                  child: Text(
                    kost['type'].toString(),
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),

            // Lokasi
            Text(
              kost['location'].toString(),
              style: const TextStyle(fontSize: 11, color: Colors.black54),
            ),
            const SizedBox(height: 6),

            // Harga Sewa (Menyesuaikan tab favorit atau reguler)
            Text(
              (isFav ? (kost['favPrice'] ?? kost['price']) : kost['price']).toString(),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E88E5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}