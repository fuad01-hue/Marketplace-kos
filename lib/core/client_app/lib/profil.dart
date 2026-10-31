import 'package:flutter/material.dart';


class TampilanProfil extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 360,
          height: 800,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(color: const Color(0xFFF4F7FC)),
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: 0,
                child: Container(
                  width: 360,
                  height: 151,
                  decoration: ShapeDecoration(
                    gradient: RadialGradient(
                      center: Alignment(0.50, 0.51),
                      radius: 1.42,
                      colors: [const Color(0xFF59B4FF), const Color(0xFF1681FB)],
                    ),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 1,
                        color: const Color(0xFF2FA9FD),
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(28),
                        bottomRight: Radius.circular(28),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 16,
                top: 96,
                child: Container(
                  width: 328,
                  height: 106,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 22,
                top: 104,
                child: Container(
                  width: 87,
                  height: 87,
                  clipBehavior: Clip.antiAlias,
                  decoration: ShapeDecoration(
                    image: DecorationImage(
                      image: NetworkImage("https://placehold.co/87x87"),
                      fit: BoxFit.cover,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(80),
                    ),
                  ),
                  child: Stack(),
                ),
              ),
              Positioned(
                left: 116,
                top: 100,
                child: Text(
                  'Nama Kamu',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Positioned(
                left: 140,
                top: 130,
                child: SizedBox(
                  width: 65,
                  child: Text(
                    'Laki-laki',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 139,
                top: 154,
                child: SizedBox(
                  width: 81,
                  child: Text(
                    '08*******890',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 139,
                top: 173,
                child: Text(
                  'Lhokseumawe',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Positioned(
                left: 120,
                top: 154,
                child: Container(
                  width: 12,
                  height: 12,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(),
                  child: Stack(),
                ),
              ),
              Positioned(
                left: 119,
                top: 176,
                child: Container(
                  width: 12,
                  height: 12,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(),
                  child: Stack(),
                ),
              ),
              Positioned(
                left: 119,
                top: 131,
                child: Container(width: 12, height: 12, child: Stack()),
              ),
              Positioned(
                left: 21,
                top: 217,
                child: SizedBox(
                  width: 85,
                  height: 27,
                  child: Text(
                    'AKTIVITAS\n',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 21,
                top: 404,
                child: SizedBox(
                  width: 120,
                  height: 27,
                  child: Text(
                    'PENGATURAN',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 16,
                top: 244,
                child: Container(
                  width: 328,
                  height: 148,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    shadows: [
                      BoxShadow(
                        color: Color(0x3F000000),
                        blurRadius: 4,
                        offset: Offset(0, 4),
                        spreadRadius: 0,
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 16,
                top: 432,
                child: Container(
                  width: 328,
                  height: 194,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    shadows: [
                      BoxShadow(
                        color: Color(0x3F000000),
                        blurRadius: 4,
                        offset: Offset(0, 4),
                        spreadRadius: 0,
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 22,
                top: 254,
                child: Container(
                  width: 35,
                  height: 35,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(),
                  child: Stack(),
                ),
              ),
              Positioned(
                left: 57,
                top: 262,
                child: SizedBox(
                  width: 201,
                  height: 32,
                  child: Text(
                    'Riwayat Pencarian',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 57,
                top: 454,
                child: SizedBox(
                  width: 201,
                  height: 32,
                  child: Text(
                    'Notifikasi',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 58,
                top: 309,
                child: SizedBox(
                  width: 201,
                  height: 32,
                  child: Text(
                    'Booking & Pembayaran',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 58,
                top: 502,
                child: SizedBox(
                  width: 201,
                  height: 32,
                  child: Text(
                    'Ubah Kata Sandi',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 57,
                top: 353,
                child: SizedBox(
                  width: 201,
                  height: 32,
                  child: Text(
                    'Ulasan Saya',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 57,
                top: 545,
                child: SizedBox(
                  width: 201,
                  height: 32,
                  child: Text(
                    'Bantuan & CS',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 16,
                top: 294,
                child: Container(
                  width: 328,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 1,
                        strokeAlign: BorderSide.strokeAlignCenter,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 16,
                top: 488,
                child: Container(
                  width: 328,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 1,
                        strokeAlign: BorderSide.strokeAlignCenter,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 16,
                top: 341,
                child: Container(
                  width: 328,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 1,
                        strokeAlign: BorderSide.strokeAlignCenter,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 16,
                top: 534,
                child: Container(
                  width: 328,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 1,
                        strokeAlign: BorderSide.strokeAlignCenter,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 16,
                top: 579,
                child: Container(
                  width: 328,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 1,
                        strokeAlign: BorderSide.strokeAlignCenter,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 333,
                top: 261,
                child: Container(
                  transform: Matrix4.identity()..translate(0.0, 0.0)..rotateZ(1.57),
                  height: 24,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(),
                  child: Stack(),
                ),
              ),
              Positioned(
                left: 334,
                top: 452,
                child: Container(
                  transform: Matrix4.identity()..translate(0.0, 0.0)..rotateZ(1.57),
                  height: 24,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(),
                  child: Stack(),
                ),
              ),
              Positioned(
                left: 334,
                top: 308,
                child: Container(
                  transform: Matrix4.identity()..translate(0.0, 0.0)..rotateZ(1.57),
                  height: 24,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(),
                  child: Stack(),
                ),
              ),
              Positioned(
                left: 334,
                top: 505,
                child: Container(
                  transform: Matrix4.identity()..translate(0.0, 0.0)..rotateZ(1.57),
                  height: 24,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(),
                  child: Stack(),
                ),
              ),
              Positioned(
                left: 334,
                top: 353,
                child: Container(
                  transform: Matrix4.identity()..translate(0.0, 0.0)..rotateZ(1.57),
                  height: 24,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(),
                  child: Stack(),
                ),
              ),
              Positioned(
                left: 334,
                top: 545,
                child: Container(
                  transform: Matrix4.identity()..translate(0.0, 0.0)..rotateZ(1.57),
                  height: 24,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(),
                  child: Stack(),
                ),
              ),
              Positioned(
                left: 334,
                top: 590,
                child: Container(
                  transform: Matrix4.identity()..translate(0.0, 0.0)..rotateZ(1.57),
                  height: 24,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(),
                  child: Stack(),
                ),
              ),
              Positioned(
                left: 26,
                top: 306,
                child: Container(
                  width: 24,
                  height: 24,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(),
                  child: Stack(),
                ),
              ),
              Positioned(
                left: 22,
                top: 254,
                child: Container(
                  width: 35,
                  height: 35,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(),
                  child: Stack(),
                ),
              ),
              Positioned(
                left: 22,
                top: 347,
                child: Container(
                  width: 33,
                  height: 33,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(),
                  child: Stack(),
                ),
              ),
              Positioned(
                left: 23,
                top: 447,
                child: Container(
                  width: 35,
                  height: 35,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(),
                  child: Stack(),
                ),
              ),
              Positioned(
                left: 20,
                top: 491,
                child: Container(
                  width: 39,
                  height: 39,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(),
                  child: Stack(),
                ),
              ),
              Positioned(
                left: 22,
                top: 540,
                child: Container(
                  width: 32,
                  height: 32,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(),
                  child: Stack(),
                ),
              ),
              Positioned(
                left: 16,
                top: 250,
                child: Container(
                  width: 328,
                  height: 44,
                  decoration: BoxDecoration(color: const Color(0x00D9D9D9)),
                ),
              ),
              Positioned(
                left: 16,
                top: 295,
                child: Container(
                  width: 328,
                  height: 44,
                  decoration: BoxDecoration(color: const Color(0x00D9D9D9)),
                ),
              ),
              Positioned(
                left: 16,
                top: 342,
                child: Container(
                  width: 328,
                  height: 44,
                  decoration: BoxDecoration(color: const Color(0x00D9D9D9)),
                ),
              ),
              Positioned(
                left: 16,
                top: 443,
                child: Container(
                  width: 328,
                  height: 44,
                  decoration: BoxDecoration(color: const Color(0x00D9D9D9)),
                ),
              ),
              Positioned(
                left: 16,
                top: 487,
                child: Container(
                  width: 328,
                  height: 44,
                  decoration: BoxDecoration(color: const Color(0x00D9D9D9)),
                ),
              ),
              Positioned(
                left: 16,
                top: 534,
                child: Container(
                  width: 328,
                  height: 44,
                  decoration: BoxDecoration(color: const Color(0x00D9D9D9)),
                ),
              ),
              Positioned(
                left: 16,
                top: 582,
                child: Container(
                  width: 328,
                  height: 44,
                  decoration: BoxDecoration(color: const Color(0x00D9D9D9)),
                ),
              ),
              Positioned(
                left: 59,
                top: 593,
                child: SizedBox(
                  width: 52,
                  height: 23,
                  child: Text(
                    'Keluar',
                    style: TextStyle(
                      color: const Color(0xFFFF0000),
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 150,
                top: 34,
                child: SizedBox(
                  width: 60,
                  height: 27,
                  child: Text(
                    'Profil',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 255,
                top: 130,
                child: Container(
                  width: 73,
                  height: 44,
                  decoration: ShapeDecoration(
                    color: const Color(0x4C2FA9FD),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 264,
                top: 143,
                child: SizedBox(
                  width: 56,
                  height: 22,
                  child: Text(
                    'Edit Profil',
                    style: TextStyle(
                      color: const Color(0xFF2FA9FD),
                      fontSize: 12,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 32,
                top: 593,
                child: Container(
                  width: 20,
                  height: 20,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(),
                  child: Stack(),
                ),
              ),
              Positioned(
                left: 0,
                top: 736,
                child: Container(
                  width: 360,
                  height: 64,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(18),
                        topRight: Radius.circular(18),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 19,
                top: 736,
                child: Container(
                  width: 55,
                  height: 64,
                  decoration: BoxDecoration(color: Colors.white),
                ),
              ),
              Positioned(
                left: 84,
                top: 736,
                child: Container(
                  width: 55,
                  height: 64,
                  decoration: BoxDecoration(color: Colors.white),
                ),
              ),
              Positioned(
                left: 153,
                top: 736,
                child: Container(
                  width: 57,
                  height: 64,
                  decoration: BoxDecoration(color: Colors.white),
                ),
              ),
              Positioned(
                left: 227,
                top: 736,
                child: Container(
                  width: 42,
                  height: 64,
                  decoration: BoxDecoration(color: Colors.white),
                ),
              ),
              Positioned(
                left: 285,
                top: 736,
                child: Container(
                  width: 45,
                  height: 64,
                  decoration: BoxDecoration(color: Colors.white),
                ),
              ),
              Positioned(
                left: 282,
                top: 743,
                child: Container(
                  width: 51,
                  height: 30,
                  decoration: ShapeDecoration(
                    color: const Color(0x4C2FA9FD),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 295,
                top: 745,
                child: Container(
                  width: 25,
                  height: 25,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(),
                  child: Stack(),
                ),
              ),
              Positioned(
                left: 236,
                top: 745,
                child: Container(
                  width: 25,
                  height: 25,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(),
                  child: Stack(),
                ),
              ),
              Positioned(
                left: 167,
                top: 745,
                child: Container(
                  width: 25,
                  height: 25,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(),
                  child: Stack(),
                ),
              ),
              Positioned(
                left: 98,
                top: 745,
                child: Container(
                  width: 25,
                  height: 25,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(),
                  child: Stack(),
                ),
              ),
              Positioned(
                left: 33,
                top: 745,
                child: Container(
                  width: 25,
                  height: 25,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(),
                  child: Stack(),
                ),
              ),
              Positioned(
                left: 31,
                top: 775,
                child: SizedBox(
                  width: 31,
                  height: 21,
                  child: Text(
                    'Cari',
                    style: TextStyle(
                      color: const Color(0xFF797979),
                      fontSize: 13,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      height: 1.54,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 88,
                top: 775,
                child: SizedBox(
                  width: 48,
                  height: 21,
                  child: Text(
                    'Favorit',
                    style: TextStyle(
                      color: const Color(0xFF797979),
                      fontSize: 13,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      height: 1.54,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 153,
                top: 775,
                child: SizedBox(
                  width: 60,
                  height: 21,
                  child: Text(
                    'Beranda',
                    style: TextStyle(
                      color: const Color(0xFF797979),
                      fontSize: 13,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      height: 1.54,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 232,
                top: 775,
                child: SizedBox(
                  width: 37,
                  height: 21,
                  child: Text(
                    'Chat',
                    style: TextStyle(
                      color: const Color(0xFF797979),
                      fontSize: 13,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      height: 1.54,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 291,
                top: 775,
                child: SizedBox(
                  width: 36,
                  height: 21,
                  child: Text(
                    'Profil',
                    style: TextStyle(
                      color: const Color(0xFF2FA9FD),
                      fontSize: 13,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      height: 1.54,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}