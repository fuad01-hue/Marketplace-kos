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

  // Data master kos
  final List<Map<String, dynamic>> _masterKosts = const [
    {
      'name': 'Kost Mahogani',
      'location': 'Jalan Medan-Banda Aceh,\nAceh, Indonesia',
      'price': 'Rp. 700.000,00 / Bulan',
      'favPrice': 'Rp. 500.000,00 / Bulan',
      'type': 'Laki - Laki',
      'image': 'assets/Kost-Mahogani.png',
      'isFavorite': true,
    },
    {
      'name': 'Kost Meranti',
      'location': 'Jalan Medan-Banda Aceh,\nAceh, Indonesia',
      'price': 'Rp. 700.000,00 / Bulan',
      'favPrice': 'Rp. 500.000,00 / Bulan',
      'type': 'Perempuan',
      'image': 'assets/Kost-meranti.png',
      'isFavorite': true,
    },
    {
      'name': 'Kost Mahonti',
      'location': 'Jalan Medan-Banda Aceh,\nAceh, Indonesia',
      'price': 'Rp. 700.000,00 / Bulan',
      'favPrice': 'Rp. 700.000,00 / Bulan',
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
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else if (widget.onBackToHome != null) {
      widget.onBackToHome!();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Filter data berdasarkan input
    final filteredList = _masterKosts.where((kost) {
      final name = kost['name'].toString().toLowerCase();
      final loc = kost['location'].toString().toLowerCase();
      final q = _query.toLowerCase().trim();
      return name.contains(q) || loc.contains(q);
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFD),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. BAGIAN ATAS: Back Button & Capsule Search Bar
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 18, 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Tombol Kembali Sejajar Tengah
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black87, size: 24),
                    onPressed: _handleBack,
                    splashRadius: 20,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                  ),
                  const SizedBox(width: 4),

                  // Capsule Search Field Presisi Figma
                  Expanded(
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22), // Bentuk Pill / Kapsul
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
                        onChanged: (val) => setState(() => _query = val),
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
                                    setState(() => _query = '');
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

            // 2. LABEL "Saran Pencarian"
            const Padding(
              padding: EdgeInsets.fromLTRB(22, 6, 22, 10),
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

            // 3. WADAH KARTU SARAN PENCARIAN (Satu Container Menyatu + Divider)
            Expanded(
              child: filteredList.isEmpty
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
                          itemCount: filteredList.length,
                          separatorBuilder: (_, __) => const Divider(
                            height: 1,
                            thickness: 1,
                            indent: 68,
                            endIndent: 16,
                            color: Color(0xFFF1F5F9),
                          ),
                          itemBuilder: (context, index) {
                            final kost = filteredList[index];
                            final bool isMatched = _query.isNotEmpty &&
                                kost['name']
                                    .toString()
                                    .toLowerCase()
                                    .contains(_query.toLowerCase().trim());

                            return InkWell(
                              borderRadius: index == 0
                                  ? const BorderRadius.vertical(top: Radius.circular(16))
                                  : index == filteredList.length - 1
                                      ? const BorderRadius.vertical(bottom: Radius.circular(16))
                                      : BorderRadius.zero,
                              onTap: () {
                                _focusNode.unfocus();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailPage(kostData: kost),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 12,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // Ikon Lokasi Berlatar Biru Muda
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

                                    // Nama Kos & Alamat
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            kost['name'].toString(),
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
                                            kost['location'].toString(),
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.grey.shade500,
                                              height: 1.25,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Ikon Panah Serong (North East)
                                    IconButton(
                                      splashRadius: 18,
                                      icon: Icon(
                                        Icons.north_east,
                                        size: 18,
                                        color: Colors.grey.shade400,
                                      ),
                                      onPressed: () {
                                        final String namaKos = kost['name'].toString();
                                        _searchController.text = namaKos;
                                        _searchController.selection =
                                            TextSelection.fromPosition(
                                          TextPosition(offset: namaKos.length),
                                        );
                                        setState(() => _query = namaKos);
                                      },
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
        ),
      ),
    );
  }
}