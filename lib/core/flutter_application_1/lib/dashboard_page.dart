import 'package:flutter/material.dart';
import 'detail_page.dart';
import 'notification_screen.dart';
import 'profile_screen.dart';
import 'search_page.dart';

import 'profil.dart';

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
  String _searchQuery = '';

  final List<String> _categories = [
    'Semua',
    'Laki - Laki',
    'Perempuan',
    'Campur',
  ];

  final List<Map<String, dynamic>> _allKosts = [
    {
      'name': 'Kost Meranti',
      'location': 'Kota Lhokseumawe',
      'price': 'Rp. 700.000,00 / Bulan',
      'favPrice': 'Rp. 500.000,00 / Bulan',
      'type': 'Perempuan',
      'image': 'assets/Kost-meranti.png',
      'isFavorite': true,
    },
    {
      'name': 'Kost Mahogani',
      'location': 'Kota Lhokseumawe',
      'price': 'Rp. 700.000,00 / Bulan',
      'favPrice': 'Rp. 500.000,00 / Bulan',
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

    // Filter data berdasarkan tab favorit, filter chip kategori, dan pencarian
    final filteredKosts = _allKosts.where((kost) {
      final matchesSearch = kost['name']
          .toString()
          .toLowerCase()
          .contains(_searchQuery.toLowerCase());

      if (isFav) {
        return kost['isFavorite'] == true && matchesSearch;
      }

      final matchesCategory = _selectedCategory == 'Semua' ||
          kost['type'] == _selectedCategory;
      return matchesCategory && matchesSearch;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      body: Column(
        children: [
          // 1. Header & Search Bar
          _buildHeader(isFav),

          // 2. Filter Kategori (Hanya muncul di Beranda biasa)
          if (!isFav) ...[
            const SizedBox(height: 12),
            _buildCategoryFilter(),
          ],

          const SizedBox(height: 12),

          // 3. List Kos
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
                      // Navigasi ke Halaman Profil
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

                      // Navigasi ke Halaman Notifikasi
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

          // Search Bar Melayang
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
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                readOnly: true,
                onTap: () {
                  // Navigasi ke halaman pencarian
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SearchPage(),
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
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                kost['image'],
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 150,
                  width: double.infinity,
                  color: Colors.grey.shade300,
                  alignment: Alignment.center,
                  child: const Icon(Icons.home_work_outlined, size: 40, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  kost['name'],
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),

          // Lokasi
          Text(
            kost['location'],
            style: const TextStyle(fontSize: 11, color: Colors.black54),
          ),
          const SizedBox(height: 6),

          // Harga
          Text(
            isFavoriteTab ? kost['favPrice'] : kost['price'],
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

  Widget _buildBottomNav() {
    final items = [
      {'icon': Icons.search, 'label': 'Cari'},
      {'icon': Icons.favorite_border, 'label': 'Favorit'},
      {'icon': Icons.home_outlined, 'label': 'Beranda'},
      {'icon': Icons.chat_bubble_outline, 'label': 'Chat'},
      {'icon': Icons.person_outline, 'label': 'Profil'},
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (index) {
          final isSelected = _selectedNavIndex == index;
          return GestureDetector(
            onTap: () {
              if (index == 4) {
                // Navigasi ke TampilanProfil jika ikon ke-5 (indeks 4) diklik
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TampilanProfil()),
                );
              } else {
                setState(() => _selectedNavIndex = index);
              }
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFF42A5F5)),
                  ),
                  child: Text(
                    kost['type'],
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
            Text(
              kost['location'],
              style: const TextStyle(fontSize: 11, color: Colors.black54),
            ),
            const SizedBox(height: 6),
            Text(
              isFav ? kost['favPrice'] : kost['price'],
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