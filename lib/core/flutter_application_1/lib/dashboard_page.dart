import 'package:flutter/material.dart';
import 'detail_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // Indeks tab BottomNavigationBar (2 = Beranda, 1 = Favorit)
  int _selectedNavIndex = 2;

  // Kategori filter yang sedang aktif di Beranda
  String _selectedCategory = 'Semua';

  // Kata kunci pencarian
  String _searchQuery = '';

  final List<String> _categories = [
    'Semua',
    'Laki - Laki',
    'Perempuan',
    'Campur',
  ];

  // Data dummy sesuai desain Figma
  final List<Map<String, dynamic>> _allKosts = [
    {
      'name': 'Kost Meranti',
      'location': 'Kota Lhokseumawe',
      'price': 'Rp. 700.000,00 / Bulan',
      'favPrice': 'Rp. 500.000,00 / Bulan',
      'type': 'Perempuan',
      'image': 'assets/Kost-meranti.png', // Ganti sesuai nama file di folder assets
      'isFavorite': true,
    },
    {
      'name': 'Kost Mahogani',
      'location': 'Kota Lhokseumawe',
      'price': 'Rp. 700.000,00 / Bulan',
      'favPrice': 'Rp. 500.000,00 / Bulan',
      'type': 'Laki - Laki',
      'image': 'assets/Kost-mahogani.png',
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
    final bool isFavoriteTab = _selectedNavIndex == 1;

    // Filter daftar kos berdasarkan tab, kategori, dan pencarian
    final filteredKosts = _allKosts.where((kost) {
      final matchesSearch = kost['name']
          .toString()
          .toLowerCase()
          .contains(_searchQuery.toLowerCase());

      if (isFavoriteTab) {
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
          // 1. HEADER BIRU & SEARCH BAR
          _buildHeader(isFavoriteTab),

          // 2. TOMBOL FILTER KATEGORI (Hanya tampil di tab Beranda)
          if (!isFavoriteTab) ...[
            const SizedBox(height: 12),
            _buildCategoryFilter(),
          ],

          const SizedBox(height: 12),

          // 3. DAFTAR CARD KOS
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              itemCount: filteredKosts.length,
              itemBuilder: (context, index) {
                final kost = filteredKosts[index];
                return _buildKostCard(kost, isFavoriteTab);
              },
            ),
          ),
        ],
      ),

      // 4. BOTTOM NAVIGATION BAR
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildHeader(bool isFavoriteTab) {
    return SizedBox(
      height: 175,
      child: Stack(
        children: [
          // Background Biru Melengkung
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
            child: isFavoriteTab
                ? const Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: EdgeInsets.only(top: 12),
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
                      const Icon(
                        Icons.account_circle_outlined,
                        color: Colors.white,
                        size: 40,
                      ),
                      const SizedBox(width: 10),
                      const Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Text(
                          'Hi, Nama Kamu',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Stack(
                        children: [
                          IconButton(
                            onPressed: () {},
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
                              width: 7,
                              height: 7,
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

          // Search Bar Melayang di Bawah Header
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
                onChanged: (value) => setState(() => _searchQuery = value),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: _categories.map((category) {
          final bool isSelected = _selectedCategory == category;
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = category),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
          );
        }).toList(),
      ),
    );
  }

  Widget _buildKostCard(Map<String, dynamic> kost, bool isFavoriteTab) {
    return GestureDetector(
      onTap: (){
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
              offset: const Offset(0, 3)
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          // Foto Kos
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              kost['image'],
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
              // Fallback kalau foto belum di-export ke folder assets
              errorBuilder: (context, error, stackTrace) => Container(
                height: 150,
                width: double.infinity,
                color: Colors.grey.shade300,
                alignment: Alignment.center,
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.home_work_outlined, size: 40, color: Colors.grey),
                    SizedBox(height: 4),
                    Text(
                      ' Taruh foto di folder assets/',
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Nama Kos & Badge Gender
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
            onTap: () => setState(() => _selectedNavIndex = index),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFFBBDEFB)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    items[index]['icon'] as IconData,
                    size: 22,
                    color: isSelected
                        ? const Color(0xFF1E88E5)
                        : Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  items[index]['label'] as String,
                  style: TextStyle(
                    fontSize: 11,
                    color: isSelected
                        ? const Color(0xFF1E88E5)
                        : Colors.black54,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}