import 'package:flutter/material.dart';

// ==========================================
// 1. HALAMAN UTAMA: BANTUAN & CS (FAQ)
// ==========================================
class BantuanCsPage extends StatelessWidget {
  const BantuanCsPage({super.key});

  final _faqList = const [
    {
      'q': 'Bagaimana cara booking kos?',
      'a': 'Pilih kos, tentukan tanggal masuk, lalu bayar. Konfirmasi muncul di menu Booking & Pembayaran.',
    },
    {
      'q': 'Bagaimana kalau saya lupa kata sandi?',
      'a': 'Tekan "Lupa Password?" di halaman login, lalu ikuti tautan yang dikirim ke emailmu.',
    },
    {
      'q': 'Bagaimana cara membatalkan booking?',
      'a': 'Buka Booking & Pembayaran, pilih booking yang ingin dibatalkan, lalu tekan "Batalkan Booking". Untuk pembayaran yang sudah masuk, hubungi CS untuk proses pengembalian dana.',
    },
  ];

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
                  'Bantuan & CS',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Konten FAQ
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              physics: const BouncingScrollPhysics(),
              children: [
                const Text(
                  'Pertanyaan umum',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                ..._faqList.map((faq) => Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
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
                          Text(
                            faq['q']!,
                            style: const TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            faq['a']!,
                            style: const TextStyle(
                              fontSize: 11.5,
                              color: Color(0xFF64748B),
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    )),
                const SizedBox(height: 8),

                // Tombol Hubungi CS
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const HubungiCsPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E88E5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Hubungi CS',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// 2. HALAMAN CHAT: HUBUNGI CS
// ==========================================
class HubungiCsPage extends StatefulWidget {
  const HubungiCsPage({super.key});

  @override
  State<HubungiCsPage> createState() => _HubungiCsPageState();
}

class _HubungiCsPageState extends State<HubungiCsPage> {
  final TextEditingController _msgController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final _messages = [
    {
      'isMe': true,
      'text':
          'Halo Min, saya sudah melakukan transfer untuk booking Kost Mahogani sejak 1 jam lalu, tapi status pesanan saya belum berubah jadi \'Lunas\'. Mohon dibantu cek ya.',
    },
    {
      'isMe': false,
      'text':
          'Halo Kak Fu\'ad! Mohon maaf atas ketidaknyamanannya. Boleh informasikan Nomor Booking atau kirimkan foto bukti transfernya di sini agar tim kami bisa segera melakukan pengecekan?',
    },
  ];

  void _kirimPesan() {
    final text = _msgController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({'isMe': true, 'text': text});
    });
    _msgController.clear();

    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          // Header CS
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.paddingOf(context).top + 8,
              left: 10,
              right: 18,
              bottom: 16,
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1E88E5), Color(0xFF42A5F5)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(22)),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
                Container(
                  width: 38,
                  height: 38,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.support_agent, color: Color(0xFF1E88E5), size: 22),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Customer Service',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Online',
                        style: TextStyle(color: Colors.white70, fontSize: 11),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.call, color: Color(0xFF1E88E5), size: 18),
                ),
              ],
            ),
          ),

          // Pesan Chat
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              physics: const BouncingScrollPhysics(),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final bool isMe = msg['isMe'] as bool;

                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.76,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: isMe ? const Color(0xFF1E88E5) : Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(14),
                        topRight: const Radius.circular(14),
                        bottomLeft: isMe ? const Radius.circular(14) : Radius.zero,
                        bottomRight: isMe ? Radius.zero : const Radius.circular(14),
                      ),
                      boxShadow: isMe
                          ? []
                          : [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                    ),
                    child: Text(
                      msg['text'].toString(),
                      style: TextStyle(
                        color: isMe ? Colors.white : Colors.black87,
                        fontSize: 13,
                        height: 1.35,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Input Bar Bawah
          Container(
            padding: EdgeInsets.fromLTRB(
              16,
              8,
              16,
              MediaQuery.paddingOf(context).bottom + 10,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFEEF2F6))),
            ),
            child: Row(
              children: [
                const Icon(Icons.sentiment_satisfied_alt, color: Colors.grey, size: 22),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _msgController,
                    onSubmitted: (_) => _kirimPesan(),
                    style: const TextStyle(fontSize: 13),
                    decoration: const InputDecoration(
                      hintText: 'Ketik Pesan....',
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: _kirimPesan,
                  child: const Icon(Icons.add_circle_outline, color: Colors.grey, size: 22),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.mic_none_rounded, color: Colors.grey, size: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}