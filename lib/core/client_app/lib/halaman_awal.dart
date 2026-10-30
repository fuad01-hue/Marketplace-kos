import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'halaman_login.dart';

class HalamanAwal extends StatelessWidget {
  const HalamanAwal({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: const Color(0xFF9CCBF5),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1) Foto latar penuh. Jika file gagal dimuat, tampil gradasi biru
          //    (bukan layar putih kosong) dan pesan error muncul di Debug Console.
          Image.asset(
            'assets/halaman_awal_bg.png',
            fit: BoxFit.cover,
            alignment: Alignment.center,
            errorBuilder: (context, error, stack) {
              debugPrint('GAGAL memuat assets/halaman_awal_bg.png: $error');
              return const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFFBFE0FF), Color(0xFF2089ED)],
                  ),
                ),
              );
            },
          ),

          // 2) Pudar putih di atas supaya logo terbaca
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 220,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xE6FFFFFF), Color(0x00FFFFFF)],
                ),
              ),
            ),
          ),

          // 4) Logo
          Positioned(
            top: size.height * 0.11,
            left: 0,
            right: 0,
            child: Center(
              child: Image.asset('assets/logo.png', width: size.width * 0.5),
            ),
          ),

          // 5) Tombol Login / Daftar
          Positioned(
            bottom: size.height * 0.115,
            left: 0,
            right: 0,
            child: Center(
              child: SizedBox(
                width: size.width * 0.55,
                height: 54,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF2FA9FD)),
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF59B5FF), Color(0xFF1782FB)],
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x40000000),
                        offset: Offset(0, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const HalamanLogin()),
                      ),
                      child: Center(
                        child: Text(
                          'Login / Daftar',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}