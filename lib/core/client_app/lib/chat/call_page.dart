import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';

class CallPage extends StatefulWidget {
  final String name;
  final String avatar;

  const CallPage({
    super.key,
    required this.name,
    required this.avatar,
  });

  @override
  State<CallPage> createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  bool _isConnected = false;
  bool _isSpeakerOn = false;
  bool _isMuted = false;
  int _seconds = 0;
  Timer? _callTimer;
  Timer? _connectTimer;

  @override
  void initState() {
    super.initState();
    // Simulasi: 2.5 detik memanggil, lalu panggilan tersambung
    _connectTimer = Timer(const Duration(milliseconds: 2500), () {
      if (mounted) {
        setState(() {
          _isConnected = true;
        });
        _mulaiTimerPanggilan();
      }
    });
  }

  void _mulaiTimerPanggilan() {
    _callTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _seconds++;
        });
      }
    });
  }

  String _formatWaktu(int totalSeconds) {
    final menit = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final detik = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$menit:$detik';
  }

  void _akhiriPanggilan() {
    _callTimer?.cancel();
    _connectTimer?.cancel();
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _callTimer?.cancel();
    _connectTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. LATAR BELAKANG FOTO DENGAN EFEK BLUR (SESUAI FIGMA)
          Positioned.fill(
            child: Image.asset(
              widget.avatar,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: const Color(0xFF1E293B),
              ),
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
              child: Container(
                color: Colors.black.withOpacity(0.55),
              ),
            ),
          ),

          // 2. KONTEN PANGGILAN
          SafeArea(
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  const SizedBox(height: 70),

                  // Avatar Foto Profil Pemilik Kos
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 12,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 42,
                      backgroundImage: AssetImage(widget.avatar),
                      onBackgroundImageError: (_, __) {},
                      child: widget.avatar.isEmpty
                          ? const Icon(Icons.person, size: 40, color: Colors.grey)
                          : null,
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Nama Pemilik Kos
                  Text(
                    widget.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Status Panggilan / Timer Berjalan
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.phone_in_talk, size: 14, color: Colors.white70),
                      const SizedBox(width: 6),
                      Text(
                        _isConnected ? _formatWaktu(_seconds) : 'Memanggil...',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  // 3. BARIS TOMBOL AKSI BAWAH (SPEAKER, MUTE, END CALL)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 48),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Tombol Loudspeaker
                        _buildCallActionButton(
                          icon: _isSpeakerOn ? Icons.volume_up : Icons.volume_down,
                          isActive: _isSpeakerOn,
                          onTap: () {
                            setState(() {
                              _isSpeakerOn = !_isSpeakerOn;
                            });
                          },
                        ),

                        // Tombol Mute Mikrofon
                        _buildCallActionButton(
                          icon: _isMuted ? Icons.mic_off : Icons.mic,
                          isActive: _isMuted,
                          onTap: () {
                            setState(() {
                              _isMuted = !_isMuted;
                            });
                          },
                        ),

                        // Tombol Tutup Telepon (Merah)
                        GestureDetector(
                          onTap: _akhiriPanggilan,
                          child: Container(
                            width: 58,
                            height: 58,
                            decoration: const BoxDecoration(
                              color: Color(0xFFE53935),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 8,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.call_end,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCallActionButton({
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 54,
        height: 54,
        decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.white.withOpacity(0.25),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: isActive ? const Color(0xFF1E293B) : Colors.white,
          size: 24,
        ),
      ),
    );
  }
}