import 'dart:async';
import 'package:flutter/material.dart';
import 'call_page.dart';

class ChatRoomPage extends StatefulWidget {
  final String name;
  final String? avatar;

  const ChatRoomPage({
    super.key,
    required this.name,
    this.avatar,
  });

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // State Recording Voice Note
  bool _isRecording = false;
  int _recordSeconds = 0;
  Timer? _recordTimer;

  // State Pemutaran Animasi Voice Note
  int? _playingIndex;
  bool _isPlayingAudio = false;
  double _audioProgress = 0.0; // Progres dari 0.0 sampai 1.0
  Timer? _audioTimer;

  // Daftar Pesan
  final  _messages = [
    {
      "type": "text",
      "text": "Halo pak, Apakah Ada kos kosong?",
      "isMe": true,
      "time": "11.08",
    },
    {
      "type": "text",
      "text": "Halo Kak! Masih ada 1 kamar kosong nih. Mau survei kapan?",
      "isMe": false,
      "time": "11.09",
    },
    {
      "type": "vn",
      "isMe": true,
      "time": "11.09",
    },
  ];

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    _recordTimer?.cancel();
    _audioTimer?.cancel();
    super.dispose();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // 1. Kirim Pesan Teks
  void _kirimPesanTeks() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    final now = TimeOfDay.now();
    final timeStr =
        '${now.hour.toString().padLeft(2, '0')}.${now.minute.toString().padLeft(2, '0')}';

    setState(() {
      _messages.add({
        "type": "text",
        "text": text,
        "isMe": true,
        "time": timeStr,
      });
    });

    _textController.clear();
    _scrollToBottom();
  }

  // 2. Mulai Merekam Voice Note
  void _mulaiRekamVN() {
    setState(() {
      _isRecording = true;
      _recordSeconds = 0;
    });

    _recordTimer?.cancel();
    _recordTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _recordSeconds++;
      });
    });
  }

  // 3. Batalkan Rekaman
  void _batalRekamVN() {
    _recordTimer?.cancel();
    setState(() {
      _isRecording = false;
      _recordSeconds = 0;
    });
  }

  // 4. Kirim Voice Note
  void _kirimVoiceNote() {
    _recordTimer?.cancel();

    final now = TimeOfDay.now();
    final timeStr =
        '${now.hour.toString().padLeft(2, '0')}.${now.minute.toString().padLeft(2, '0')}';

    setState(() {
      _isRecording = false;
      _messages.add({
        "type": "vn",
        "isMe": true,
        "time": timeStr,
      });
    });

    _scrollToBottom();
  }

  // 5. Play / Pause & Animasi Bar Gelombang Suara (Waveform)
  void _togglePlayAudio(int index) {
    if (_playingIndex == index && _isPlayingAudio) {
      // Jeda (Pause)
      _audioTimer?.cancel();
      setState(() {
        _isPlayingAudio = false;
      });
    } else {
      // Putar baru atau lanjutkan
      if (_playingIndex != index) {
        _audioProgress = 0.0;
        _playingIndex = index;
      }

      setState(() {
        _isPlayingAudio = true;
      });

      _audioTimer?.cancel();
      const int totalDurationMs = 5000; // Total durasi simulasi 5 detik
      const int intervalMs = 50;        // Update setiap 50ms agar halus
      const double step = intervalMs / totalDurationMs;

      _audioTimer = Timer.periodic(const Duration(milliseconds: intervalMs), (timer) {
        if (!mounted) return;

        setState(() {
          _audioProgress += step;
          if (_audioProgress >= 1.0) {
            _audioProgress = 0.0;
            _isPlayingAudio = false;
            _playingIndex = null;
            timer.cancel();
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final avatarPath = widget.avatar ??
        (widget.name.contains('Mahogani')
            ? 'assets/foto_profile_1.png'
            : 'assets/foto_profile_2.png');

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      body: Column(
        children: [
          // Header Biru AyoKost
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.paddingOf(context).top + 10,
              left: 10,
              right: 18,
              bottom: 18,
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF4CA0FF), Color(0xFF1E88E5)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(22)),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new,
                      color: Colors.white, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    avatarPath,
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.grey.shade300,
                      child: const Icon(Icons.person, color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        "Online",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                // DIBUNGKUS INKWELL AGAR BISA DIKLIK MEMBUKA TELEPON
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CallPage(
                          name: widget.name,
                          avatar: avatarPath,
                        ),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.call, color: Color(0xFF4CA0FF), size: 18),
                  ),
                ),
              ],
            ),
          ),

          // Area Gelembung Pesan
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              physics: const BouncingScrollPhysics(),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final bool isMe = msg['isMe'] as bool;
                final bool isVN = msg['type'] == 'vn';

                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: isVN
                      ? _buildVoiceNoteBubble(msg, index)
                      : _buildTextBubble(msg, isMe),
                );
              },
            ),
          ),

          // Input Bar Bawah (Normal / Mode Merekam)
          Container(
            padding: EdgeInsets.fromLTRB(
              16,
              10,
              16,
              MediaQuery.paddingOf(context).bottom + 10,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: _isRecording
                ? _buildRecordingBar()
                : _buildNormalInputBar(),
          ),
        ],
      ),
    );
  }

  // Gelembung Pesan Teks
  Widget _buildTextBubble(Map<String, dynamic> msg, bool isMe) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.75,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isMe ? const Color(0xFF4CA0FF) : Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(16),
          topRight: const Radius.circular(16),
          bottomLeft: isMe ? const Radius.circular(16) : Radius.zero,
          bottomRight: isMe ? Radius.zero : const Radius.circular(16),
        ),
        boxShadow: isMe
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            msg['text'].toString(),
            style: TextStyle(
              color: isMe ? Colors.white : Colors.black87,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            msg['time'].toString(),
            style: TextStyle(
              color: isMe ? Colors.white70 : Colors.grey,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  // Gelembung Voice Note yang rapi dan proporsional (Gaya WhatsApp)
  Widget _buildVoiceNoteBubble(Map<String, dynamic> msg, int index) {
    final bool isThisPlaying = (_playingIndex == index) && _isPlayingAudio;
    final double currentProgress = (_playingIndex == index) ? _audioProgress : 0.0;

    final barHeights = [
      6.0, 10.0, 16.0, 24.0, 14.0, 18.0, 22.0, 12.0, 20.0, 15.0, 8.0, 18.0,
      24.0, 14.0, 20.0, 10.0, 16.0, 8.0, 12.0, 6.0
    ];

    return Align(
      alignment: Alignment.centerRight, // Rata kanan mengikuti chat pengirim
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.fromLTRB(10, 10, 14, 8),
        constraints: const BoxConstraints(maxWidth: 235), // Kunci lebar agar pas & tidak melar
        decoration: const BoxDecoration(
          color: Color(0xFF4CA0FF),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.zero,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 1. Tombol Play / Pause Putih di Kiri
            GestureDetector(
              onTap: () => _togglePlayAudio(index),
              child: Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isThisPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                  color: const Color(0xFF4CA0FF),
                  size: 22,
                ),
              ),
            ),
            const SizedBox(width: 10),

            // 2. Kolom Kanan: Waveform di Atas, Durasi & Jam di Bawah
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Gelombang Suara (Waveform)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(barHeights.length, (barIdx) {
                      final double barThreshold = (barIdx + 1) / barHeights.length;
                      final bool isFilled = isThisPlaying && (currentProgress >= barThreshold);

                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 100),
                        width: 2.2,
                        height: barHeights[barIdx],
                        decoration: BoxDecoration(
                          color: isFilled
                              ? Colors.white
                              : Colors.white.withOpacity(0.35),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      );
                    }),
                  ),

                  const SizedBox(height: 6),

                  // Durasi Detik (Kiri) & Jam Pengiriman (Kanan) Tepat di Bawah Gelombang
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        msg['duration']?.toString() ?? '00:15',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        msg['time'].toString(),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 9.5,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Input Bar Biasa
  Widget _buildNormalInputBar() {
    return Row(
      children: [
        const Icon(Icons.sentiment_satisfied_alt, color: Colors.grey, size: 24),
        const SizedBox(width: 10),
        Expanded(
          child: TextField(
            controller: _textController,
            onSubmitted: (_) => _kirimPesanTeks(),
            decoration: const InputDecoration(
              hintText: 'Ketik Pesan....',
              hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 8),
            ),
          ),
        ),
        const SizedBox(width: 8),
        const Icon(Icons.add_circle_outline_rounded, color: Colors.grey, size: 24),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: _mulaiRekamVN,
          child: const Icon(Icons.mic_none_rounded, color: Colors.grey, size: 26),
        ),
      ],
    );
  }

  // Input Bar Mode Merekam VN
  Widget _buildRecordingBar() {
    final timerString = '0.${_recordSeconds.toString().padLeft(2, '0')}';

    return Container(
      height: 46,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF4CA0FF),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            decoration: const BoxDecoration(
              color: Colors.white24,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.mic, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 10),
          Text(
            timerString,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.white, size: 22),
            onPressed: _batalRekamVN,
            splashRadius: 18,
          ),
          GestureDetector(
            onTap: _kirimVoiceNote,
            child: Container(
              padding: const EdgeInsets.all(7),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.send_rounded,
                color: Color(0xFF4CA0FF),
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}