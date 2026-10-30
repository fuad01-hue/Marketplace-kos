import 'package:flutter/material.dart';
import 'detail_page.dart';

class SearchPage extends StatefulWidget {
  final VoidCallback? onBackToHome;

  const SearchPage({super.key, this.onBackToHome});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String _query = '';
  bool _showResults = false;

  // Data master kos lengkap dengan tipe data eksplisit
  final List<Map<String, dynamic>> _masterKosts = const [
    {
      'name': 'Kost Mahogani',
      'location': 'Kota Lhokseumawe',
      'addressDetail': 'Jalan Medan-Banda Aceh,\nAceh, Indonesia',
      'price': 'Rp. 500.000,00 / Bulan',
      'type': 'Laki - Laki',
      'image': 'assets/Kost-Mahogani.png',
      'isFavorite': true,
    },
    {
      'name': 'Kost Mahogani 2',
      'location': 'Kota Lhokseumawe',
      'addressDetail': 'Jalan Medan-Banda Aceh,\nAceh, Indonesia',
      'price': 'Rp. 500.000,00 / Bulan',
      'type': 'Laki - Laki',
      'image': 'assets/Kost-Mahogani.png',
      'isFavorite': true,
    },
    {
      'name': 'Kost Meranti',
      'location': 'Kota Lhokseumawe',
      'addressDetail': 'Jalan Medan-Banda Aceh,\nAceh, Indonesia',
      'price': 'Rp. 500.000,00 / Bulan',
      'type': 'Perempuan',
      'image': 'assets/Kost-meranti.png',
      'isFavorite': true,
    },
    {
      'name': 'Kost Mahonti',
      'location': 'Kota Lhokseumawe',
      'addressDetail': 'Jalan Medan-Banda Aceh,\nAceh, Indonesia',
      'price': 'Rp. 700.000,00 / Bulan',
      'type': 'Campur',
      'image': 'assets/Kost-mahonti.png',
      'isFavorite': false,
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleBack() {
    _focusNode.unfocus();
    if (_showResults) {
      setState(() {
        _showResults = false;
      });
    } else if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else if (widget.onBackToHome != null) {
      widget.onBackToHome!();
    }
  }

  void _jalankanPencarian(String keyword) {
    _focusNode.unfocus();
    setState(() {
      _query = keyword;
      _searchController.text = keyword;
      _searchController.selection = TextSelection.fromPosition(
        TextPosition(offset: keyword.length),
      );
      _showResults = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = _masterKosts.where((kost) {
      final name = kost['name'].toString().toLowerCase();
      final loc = kost['location'].toString().toLowerCase();
      final q = _query.toLowerCase().trim();
      if (q.isEmpty) return true;
      return name.contains(q) || loc.contains(q);
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFD),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Bar: Back Button & Capsule Search Field
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 18, 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black87, size: 24),
                    onPressed: _handleBack,
                    splashRadius: 20,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                          color: const Color(0xFF42A5F5),
                          width: 1.4,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF42A5F5).withOpacity(0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _searchController,
                        focusNode: _focusNode,
                        textAlignVertical: TextAlignVertical.center,
                        textInputAction: TextInputAction.search,
                        onSubmitted: (val) {
                          if (val.trim().isNotEmpty) {
                            _jalankanPencarian(val.trim());
                          }
                        },
                        onChanged: (val) {
                          setState(() {
                            _query = val;
                            if (val.isEmpty) {
                              _showResults = false;
                            }
                          });
                        },
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
                          hintText: 'Cari Kos...',
                          hintStyle: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 13.5,
                            fontWeight: FontWeight.normal,
                          ),
                          prefixIcon: const Padding(
                            padding: EdgeInsets.only(left: 12, right: 8),
                            child: Icon(
                              Icons.search,
                              color: Color(0xFF2196F3),
                              size: 22,
                            ),
                          ),
                          prefixIconConstraints: const BoxConstraints(
                            minWidth: 40,
                            minHeight: 40,
                          ),
                          suffixIcon: _query.isNotEmpty
                              ? IconButton(
                                  splashRadius: 16,
                                  icon: const Icon(
                                    Icons.cancel,
                                    size: 18,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() {
                                      _query = '';
                                      _showResults = false;
                                    });
                                  },
                                )
                              : null,
                          suffixIconConstraints: const BoxConstraints(
                            minWidth: 36,
                            minHeight: 36,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Konten: Hasil Pencarian atau Saran Pencarian
            Expanded(
              child: _showResults
                  ? _buildHasilPencarian(filteredList)
                  : _buildSaranPencarian(filteredList),
            ),
          ],
        ),
      ),
    );
  }

  // Tampilan Hasil Pencarian (Kartu Kos Vertikal Sesuai Figma)
  Widget _buildHasilPencarian(List<Map<String, dynamic>> results) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(22, 10, 22, 12),
          child: Text(
            '${results.length} kost ditemukan',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),
        ),
        Expanded(
          child: results.isEmpty
              ? Center(
                  child: Text(
                    'Tidak ada kos yang cocok dengan "$_query"',
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  physics: const BouncingScrollPhysics(),
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    final kost = results[index];
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
                              blurRadius: 10,
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
                                kost['image'].toString(),
                                height: 155,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  height: 155,
                                  color: Colors.grey.shade300,
                                  alignment: Alignment.center,
                                  child: const Icon(
                                    Icons.home_work_outlined,
                                    size: 40,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  kost['name'].toString(),
                                  style: const TextStyle(
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: const Color(0xFF42A5F5),
                                    ),
                                  ),
                                  child: Text(
                                    kost['type'].toString(),
                                    style: const TextStyle(
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              kost['location'].toString(),
                              style: const TextStyle(
                                fontSize: 11.5,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              kost['price'].toString(),
                              style: const TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E88E5),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  // Tampilan Saran Pencarian
  Widget _buildSaranPencarian(List<Map<String, dynamic>> suggestions) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(22, 10, 22, 10),
          child: Text(
            'Saran Pencarian',
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              letterSpacing: -0.2,
            ),
          ),
        ),
        Expanded(
          child: suggestions.isEmpty
              ? Center(
                  child: Text(
                    'Kos "$_query" tidak ditemukan',
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 13,
                    ),
                  ),
                )
              : SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFFEEF2F6),
                        width: 1.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: suggestions.length,
                      separatorBuilder: (_, __) => const Divider(
                        height: 1,
                        thickness: 1,
                        indent: 68,
                        endIndent: 16,
                        color: Color(0xFFF1F5F9),
                      ),
                      itemBuilder: (context, index) {
                        final kost = suggestions[index];
                        final String namaKos = kost['name'].toString();
                        final bool isMatched = _query.isNotEmpty &&
                            namaKos.toLowerCase().contains(_query.toLowerCase().trim());

                        return InkWell(
                          borderRadius: index == 0
                              ? const BorderRadius.vertical(top: Radius.circular(16))
                              : index == suggestions.length - 1
                                  ? const BorderRadius.vertical(bottom: Radius.circular(16))
                                  : BorderRadius.zero,
                          onTap: () => _jalankanPencarian(namaKos),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 12,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE8F2FD),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.location_on_outlined,
                                    color: Color(0xFF2196F3),
                                    size: 22,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        namaKos,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: isMatched
                                              ? const Color(0xFF1E88E5)
                                              : Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        (kost['addressDetail'] ?? kost['location']).toString(),
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey.shade500,
                                          height: 1.25,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  splashRadius: 18,
                                  icon: Icon(
                                    Icons.north_east,
                                    size: 18,
                                    color: Colors.grey.shade400,
                                  ),
                                  onPressed: () => _jalankanPencarian(namaKos),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}