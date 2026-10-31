import 'package:flutter/material.dart';

class UlasanSayaPage extends StatefulWidget {
  const UlasanSayaPage({super.key});

  @override
  State<UlasanSayaPage> createState() => _UlasanSayaPageState();
}

class _UlasanSayaPageState extends State<UlasanSayaPage> {
  bool _isBelumDiulasTab = true;
  int _ratingKos = 4;
  final TextEditingController _reviewController = TextEditingController(
    text: 'Kamar bersih dan pemilik ramah.',
  );

  final _sudahDiulasList = [
    {
      'title': 'Kos Mahogani',
      'date': 'Sewa Selesai 31 Agu 2026',
      'rating': 4,
      'comment': 'Kamar bersih dan pemilik ramah sekali.',
      'image': 'assets/Kost-Mahogani.png',
    },
  ];

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  void _kirimUlasan() {
    setState(() {
      _sudahDiulasList.insert(0, {
        'title': 'Kos Mahogani',
        'date': 'Sewa Selesai 31 Agu 2026',
        'rating': _ratingKos,
        'comment': _reviewController.text.trim(),
        'image': 'assets/Kost-Mahogani.png',
      });
      _isBelumDiulasTab = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Ulasan berhasil dikirim!'),
        backgroundColor: Color(0xFF1E88E5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
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
                  'Ulasan Saya',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _isBelumDiulasTab = true),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 9),
                      decoration: BoxDecoration(
                        color: _isBelumDiulasTab ? const Color(0xFF1E88E5) : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: _isBelumDiulasTab ? const Color(0xFF1E88E5) : const Color(0xFFCBD5E1),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Belum diulas',
                        style: TextStyle(
                          color: _isBelumDiulasTab ? Colors.white : const Color(0xFF64748B),
                          fontWeight: FontWeight.bold,
                          fontSize: 12.5,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _isBelumDiulasTab = false),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 9),
                      decoration: BoxDecoration(
                        color: !_isBelumDiulasTab ? const Color(0xFF1E88E5) : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: !_isBelumDiulasTab ? const Color(0xFF1E88E5) : const Color(0xFFCBD5E1),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Sudah diulas',
                        style: TextStyle(
                          color: !_isBelumDiulasTab ? Colors.white : const Color(0xFF64748B),
                          fontWeight: FontWeight.bold,
                          fontSize: 12.5,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _isBelumDiulasTab ? _buildBelumDiulas() : _buildSudahDiulas(),
          ),
        ],
      ),
    );
  }

  Widget _buildBelumDiulas() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      physics: const BouncingScrollPhysics(),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFEEF2F6)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      'assets/Kost-Mahogani.png',
                      width: 56,
                      height: 48,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 56,
                        height: 48,
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.home, color: Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Kos Mahogani', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      SizedBox(height: 2),
                      Text('Sewa Selesai 31 Agu 2026', style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 14),
              const Text('Bagaimana Pengalamanmu?', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Row(
                children: List.generate(5, (idx) {
                  return GestureDetector(
                    onTap: () => setState(() => _ratingKos = idx + 1),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: Icon(
                        idx < _ratingKos ? Icons.star_rounded : Icons.star_outline_rounded,
                        color: const Color(0xFF1E88E5),
                        size: 28,
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 12),
              const Text('Ulasan', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: TextField(
                  controller: _reviewController,
                  maxLines: 4,
                  style: const TextStyle(fontSize: 13),
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(12),
                    border: InputBorder.none,
                    hintText: 'Tulis ulasanmu di sini...',
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 40,
                child: ElevatedButton(
                  onPressed: _kirimUlasan,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E88E5),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Kirim Ulasan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSudahDiulas() {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      physics: const BouncingScrollPhysics(),
      itemCount: _sudahDiulasList.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = _sudahDiulasList[index];
        final int rating = item['rating'] as int;
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFEEF2F6)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      item['image'].toString(),
                      width: 56,
                      height: 48,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 56,
                        height: 48,
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
                        Text(item['title'].toString(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        const SizedBox(height: 2),
                        Text(item['date'].toString(), style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
                      ],
                    ),
                  ),
                  Row(
                    children: List.generate(5, (s) {
                      return Icon(
                        s < rating ? Icons.star_rounded : Icons.star_outline_rounded,
                        color: const Color(0xFF1E88E5),
                        size: 18,
                      );
                    }),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(item['comment'].toString(), style: const TextStyle(fontSize: 12.5)),
              ),
            ],
          ),
        );
      },
    );
  }
}