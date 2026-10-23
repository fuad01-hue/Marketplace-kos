import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_drawing/path_drawing.dart';
import 'auth_service.dart';
import 'dashboard_page.dart';

// ====== Warna dari desain Figma ======
const _kBg = Color(0xFFF4F7FC);
const _kBiruLink = Color(0xFF008CFF);
const _kBiruDaftar = Color(0xFF0065A9);
const _kHint = Color(0xB3989898); // #989898 opacity 70%
const _kMerah = Color(0xFFE53935);

// ====== Path gelombang (diambil langsung dari SVG) ======
final Path _blobBawah = parseSvgPathData('M158 674.464C135.476 628.735 0 666.98 0 666.98V799H359V769.256C284.397 736.244 180.524 720.193 158 674.464Z');
final Path _blobAtas = parseSvgPathData('M157.88 124.536C135.231 170.265 -1 132.02 -1 132.02V0H360V29.7438C284.982 62.7565 180.529 78.8069 157.88 124.536Z');
final Path _waveBawah = parseSvgPathData('M0 712.5L15.25 708.333C30.5 704.167 61 695.833 91.5 708.333C122 720.833 152.5 754.167 183 752.083C213.5 750 244 712.5 274.5 693.75C305 675 335.5 675 350.75 675H366V800H350.75C335.5 800 305 800 274.5 800C244 800 213.5 800 183 800C152.5 800 122 800 91.5 800C61 800 30.5 800 15.25 800H0V712.5Z');
final Path _waveAtas = parseSvgPathData('M-1 86.5L14.2083 90.6667C29.4167 94.8333 59.8333 103.167 90.25 90.6667C120.667 78.1667 151.083 44.8333 181.5 46.9167C211.917 49 242.333 86.5 272.75 105.25C303.167 124 333.583 124 348.792 124H364V-1H348.792C333.583 -1 303.167 -1 272.75 -1C242.333 -1 211.917 -1 181.5 -1C151.083 -1 120.667 -1 90.25 -1C59.8333 -1 29.4167 -1 14.2083 -1H-1V86.5Z');

/// Notifikasi kecil dengan ikon centang biru (mis. "Berhasil Masuk").
void tampilNotif(BuildContext context, String pesan) {
  final m = ScaffoldMessenger.of(context);
  m.hideCurrentSnackBar();
  m.showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.white,
      elevation: 6,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      content: Row(
        children: [
          const Icon(Icons.check_circle, color: Color(0xFF1782FB), size: 22),
          const SizedBox(width: 10),
          Text(pesan,
              style: GoogleFonts.poppins(
                  color: Colors.black, fontWeight: FontWeight.w600, fontSize: 13)),
        ],
      ),
    ),
  );
}

class HalamanLogin extends StatefulWidget {
  const HalamanLogin({super.key});

  @override
  State<HalamanLogin> createState() => _HalamanLoginState();
}

class _HalamanLoginState extends State<HalamanLogin> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _sembunyi = true;
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  bool _loading = false;

  Future<void> _masuk() async {
    if (_loading) return;
    FocusScope.of(context).unfocus();
    final email = _email.text.trim();
    final pass = _password.text;

    if (email.isEmpty || pass.isEmpty) {
      setState(() => _error = 'Email dan password wajib diisi');
      return;
    }
    if (!email.contains('@')) {
      setState(() => _error = 'Format email tidak valid');
      return;
    }

    setState(() {
      _error = null;
      _loading = true;
    });

    // Ganti isi AuthService.login dengan Firebase / API Anda.
    final hasil = await AuthService.login(email, pass);
    if (!mounted) return;

    if (hasil != null) {
      setState(() {
        _loading = false;
        _error = hasil; // mis. "Sandi salah"
      });
      return;
    }

    setState(() => _loading = false);
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const DashboardPage()),
      (route) => false,
    );
    tampilNotif(context, 'Berhasil Masuk');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBg,
      // Gelombang tetap di tempat saat keyboard muncul; isi digeser manual.
      resizeToAvoidBottomInset: false,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Latar gelombang (menyesuaikan ukuran layar)
          const CustomPaint(painter: _LatarGelombang()),

          // Isi halaman (bisa di-scroll saat keyboard muncul)
          SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: EdgeInsets.fromLTRB(
                24, 0, 22, 24 + MediaQuery.viewInsetsOf(context).bottom),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 76),
                Align(
                  alignment: Alignment.center,
                  child: Image.asset('assets/logo.png', width: 98),
                ),
                const SizedBox(height: 15),
                Text(
                  'Selamat\nDatang',
                  style: GoogleFonts.poppins(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    height: 1.5,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 23),

                // Kolom email
                _KolomInput(
                  controller: _email,
                  hint: 'Masukkan Email',
                  blur: 4,
                  padKiri: 19,
                  keyboardType: TextInputType.emailAddress,
                  action: TextInputAction.next,
                  onChanged: (_) {
                    if (_error != null) setState(() => _error = null);
                  },
                ),
                const SizedBox(height: 12),

                // Kolom password
                _KolomInput(
                  controller: _password,
                  hint: 'Masukkan Password',
                  blur: 6,
                  padKiri: 15,
                  obscure: _sembunyi,
                  action: TextInputAction.done,
                  onSubmitted: (_) => _masuk(),
                  onChanged: (_) {
                    if (_error != null) setState(() => _error = null);
                  },
                  suffix: IconButton(
                    icon: Icon(
                      _sembunyi
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: const Color(0xFF1E1E1E),
                      size: 24,
                    ),
                    onPressed: () => setState(() => _sembunyi = !_sembunyi),
                  ),
                ),
                const SizedBox(height: 10),

                // Pesan error (kiri) + Lupa Password (kanan)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        _error ?? '',
                        style: GoogleFonts.nunito(
                            color: _kMerah, fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // TODO: buka halaman Lupa Password
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text('Lupa Password?',
                            style: GoogleFonts.nunito(
                                color: _kBiruLink, fontSize: 14)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 36),

                // Tombol MASUK
                _TombolMasuk(onTap: _masuk, loading: _loading),
                const SizedBox(height: 12),

                // Daftar sekarang
                Center(
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 6,
                    children: [
                      Text('Belum punya akun AyoKost?',
                          style: GoogleFonts.inter(
                              color: Colors.black, fontSize: 14)),
                      GestureDetector(
                        onTap: () {
                          // TODO: buka halaman Daftar
                        },
                        child: Text('Daftar sekarang',
                            style: GoogleFonts.nunito(
                                color: _kBiruDaftar, fontSize: 14)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 160), // ruang agar tidak tertutup gelombang bawah
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _KolomInput extends StatelessWidget {
  const _KolomInput({
    required this.controller,
    required this.hint,
    required this.blur,
    required this.padKiri,
    this.obscure = false,
    this.suffix,
    this.keyboardType,
    this.action,
    this.onChanged,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final String hint;
  final double blur, padKiri;
  final bool obscure;
  final Widget? suffix;
  final TextInputType? keyboardType;
  final TextInputAction? action;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0x40000000), // hitam 25%
            offset: const Offset(0, 2),
            blurRadius: blur,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: obscure,
              keyboardType: keyboardType,
              textInputAction: action,
              onChanged: onChanged,
              onSubmitted: onSubmitted,
              style: GoogleFonts.nunito(fontSize: 16, color: Colors.black),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: GoogleFonts.nunito(fontSize: 16, color: _kHint),
                border: InputBorder.none,
                isCollapsed: true,
                // Atur manual: left = jarak kiri, top/bottom = geser naik/turun
                contentPadding: EdgeInsets.only(left: padKiri),
              ),
            ),
          ),
          if (suffix != null)
            Padding(
              padding: const EdgeInsets.only(right: 16), // jarak ikon dari kanan
              child: suffix,
            ),
        ],
      ),
    );
  }
}

/// Memberi efek gradasi elips (radial) seperti di Figma.
class _Elips extends GradientTransform {
  const _Elips(this.sx);
  final double sx;
  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    final c = bounds.center;
    // skala horizontal sebesar sx dengan titik tengah tetap
    return Matrix4(
      sx, 0, 0, 0,
      0, 1, 0, 0,
      0, 0, 1, 0,
      c.dx * (1 - sx), 0, 0, 1,
    );
  }
}

class _TombolMasuk extends StatelessWidget {
  const _TombolMasuk({required this.onTap, this.loading = false});
  final VoidCallback onTap;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Ink(
        height: 54,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF2FA9FD)),
          gradient: const RadialGradient(
            radius: 1.444,
            colors: [Color(0xE659B5FF), Color(0xE61782FB)],
            stops: [0.0, 0.8413],
            transform: _Elips(2.216),
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: loading ? null : onTap,
          child: Center(
            child: loading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                        strokeWidth: 2.5, color: Colors.white),
                  )
                : Text('MASUK',
                    style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w600)),
          ),
        ),
      ),
    );
  }
}

/// Gelombang atas & bawah (desain 360x800, diskalakan ke layar).
class _LatarGelombang extends CustomPainter {
  const _LatarGelombang();

  Shader _blob(Offset a, Offset b) => ui.Gradient.linear(
        a, b,
        [const Color(0x592089ED), const Color(0x2D2CA0CC)],
        [0.254808, 1.0],
      );

  Shader _wave(double y, double x2) => ui.Gradient.linear(
        Offset(0, y), Offset(x2, y),
        [
          const Color(0x99157CFD),
          const Color(0x4D00AAFF),
          const Color(0x00FFFFFF),
        ],
        [0.0721154, 0.5625, 1.0],
      );

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 360, size.height / 800);

    canvas.drawPath(_blobBawah,
        Paint()..shader = _blob(const Offset(108.803, 665.415), const Offset(183.923, 796.465)));
    canvas.drawPath(_blobAtas,
        Paint()..shader = _blob(const Offset(108.409, 133.585), const Offset(183.317, 2.17591)));

    final garis = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = const Color(0x26E9E9E9);
    canvas.drawPath(_waveBawah, Paint()..shader = _wave(737.5, 366));
    canvas.drawPath(_waveBawah, garis);
    canvas.drawPath(_waveAtas, Paint()..shader = _wave(61.5, 365));
    canvas.drawPath(_waveAtas, garis);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}