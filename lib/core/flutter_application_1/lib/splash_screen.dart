import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_drawing/path_drawing.dart';

// ====== Path gelombang (dari desain Figma, ukuran 360x800) ======
final Path _blobBawah = parseSvgPathData('M158 674.464C135.476 628.735 0 666.98 0 666.98V799H359V769.256C284.397 736.244 180.524 720.193 158 674.464Z');
final Path _blobAtas = parseSvgPathData('M157.88 124.536C135.231 170.265 -1 132.02 -1 132.02V0H360V29.7438C284.982 62.7565 180.529 78.8069 157.88 124.536Z');
final Path _waveBawah = parseSvgPathData('M0 712.5L15.25 708.333C30.5 704.167 61 695.833 91.5 708.333C122 720.833 152.5 754.167 183 752.083C213.5 750 244 712.5 274.5 693.75C305 675 335.5 675 350.75 675H366V800H350.75C335.5 800 305 800 274.5 800C244 800 213.5 800 183 800C152.5 800 122 800 91.5 800C61 800 30.5 800 15.25 800H0V712.5Z');
final Path _waveAtas = parseSvgPathData('M-1 86.5L14.2083 90.6667C29.4167 94.8333 59.8333 103.167 90.25 90.6667C120.667 78.1667 151.083 44.8333 181.5 46.9167C211.917 49 242.333 86.5 272.75 105.25C303.167 124 333.583 124 348.792 124H364V-1H348.792C333.583 -1 303.167 -1 272.75 -1C242.333 -1 211.917 -1 181.5 -1C151.083 -1 120.667 -1 90.25 -1C59.8333 -1 29.4167 -1 14.2083 -1H-1V86.5Z');

const _kBiru = Color(0xFF2FA9FD);

/// Splash screen modern:
/// gelombang meluncur masuk lalu bergerak halus, logo muncul dengan efek
/// membesar + riak cahaya, tagline naik pelan, bar loading, lalu pindah
/// ke [next] dengan transisi fade.
class SplashScreen extends StatefulWidget {
  const SplashScreen({
    super.key,
    required this.next,
    this.duration = const Duration(milliseconds: 3200),
    this.hold = const Duration(milliseconds: 400),
  });

  /// Halaman tujuan setelah splash selesai.
  final Widget next;

  /// Lama animasi masuk.
  final Duration duration;

  /// Jeda setelah animasi selesai sebelum pindah halaman.
  final Duration hold;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // Animasi masuk (sekali jalan)
  late final AnimationController _intro =
      AnimationController(vsync: this, duration: widget.duration);

  // Gerak halus yang berulang (gelombang, riak, logo melayang)
  late final AnimationController _loop =
      AnimationController(vsync: this, duration: const Duration(seconds: 5))
        ..repeat();

  Animation<double> _iv(double a, double b, [Curve c = Curves.easeOutCubic]) =>
      CurvedAnimation(parent: _intro, curve: Interval(a, b, curve: c));

  late final _topBlobA = _iv(0.00, 0.30);
  late final _topWaveA = _iv(0.05, 0.40);
  late final _botBlobA = _iv(0.10, 0.45);
  late final _botWaveA = _iv(0.15, 0.52);
  late final _logoScale = _iv(0.34, 0.72, Curves.easeOutBack);
  late final _logoFade = _iv(0.34, 0.60, Curves.easeOut);
  late final _barShow = _iv(0.20, 0.40, Curves.easeOut);
  late final _barFill = _iv(0.20, 1.00, Curves.easeInOut);

  @override
  void initState() {
    super.initState();
    _jalankan();
  }

  Future<void> _jalankan() async {
    await _intro.forward();
    await Future.delayed(widget.hold);
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 650),
        pageBuilder: (_, __, ___) => widget.next,
        transitionsBuilder: (_, anim, __, child) {
          final kurva = CurvedAnimation(parent: anim, curve: Curves.easeOut);
          return FadeTransition(
            opacity: kurva,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.97, end: 1).animate(kurva),
              child: child,
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _intro.dispose();
    _loop.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final lebarLogo = size.width * 0.58;
    final tinggiLogo = lebarLogo * 166 / 306; // rasio logo.png
    final pusatLogo = Offset(size.width / 2, size.height * 0.45);

    return Scaffold(
      backgroundColor: Colors.white,
      body: AnimatedBuilder(
        animation: Listenable.merge([_intro, _loop]),
        builder: (context, _) {
          final t = _loop.value;
          final melayang = math.sin(t * 2 * math.pi) * 4;
          final logoFade = _logoFade.value.clamp(0.0, 1.0);

          return Stack(
            fit: StackFit.expand,
            children: [
              // Latar putih -> biru sangat muda
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFFFFFFFF), Color(0xFFF1F7FE)],
                  ),
                ),
              ),

              // Gelombang atas & bawah
              CustomPaint(
                painter: _GelombangPainter(
                  topBlob: _topBlobA.value,
                  topWave: _topWaveA.value,
                  botBlob: _botBlobA.value,
                  botWave: _botWaveA.value,
                  t: t,
                ),
              ),

              // Riak cahaya di belakang logo
              CustomPaint(
                painter: _RiakPainter(pusat: pusatLogo, t: t, fade: logoFade),
              ),

              // Logo
              Positioned(
                left: 0,
                right: 0,
                top: pusatLogo.dy - tinggiLogo / 2,
                child: Center(
                  child: Transform.translate(
                    offset: Offset(0, melayang),
                    child: Transform.scale(
                      scale: 0.7 + 0.3 * _logoScale.value,
                      child: Opacity(
                        opacity: logoFade,
                        child: Image.asset('assets/logo.png', width: lebarLogo),
                      ),
                    ),
                  ),
                ),
              ),

              // Bar loading
              Positioned(
                left: 0,
                right: 0,
                top: size.height * 0.78,
                child: Opacity(
                  opacity: _barShow.value.clamp(0.0, 1.0),
                  child: Center(
                    child: SizedBox(
                      width: 120,
                      height: 4,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: Stack(
                          children: [
                            const ColoredBox(
                              color: Color(0xFFDCEAFB),
                              child: SizedBox.expand(),
                            ),
                            FractionallySizedBox(
                              widthFactor: _barFill.value.clamp(0.0, 1.0),
                              child: const DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Color(0xFF59B5FF), Color(0xFF1782FB)],
                                  ),
                                ),
                                child: SizedBox.expand(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Riak lingkaran halus + cahaya di belakang logo.
class _RiakPainter extends CustomPainter {
  _RiakPainter({required this.pusat, required this.t, required this.fade});

  final Offset pusat;
  final double t, fade;

  @override
  void paint(Canvas canvas, Size size) {
    if (fade <= 0) return;

    // Cahaya lembut
    canvas.drawCircle(
      pusat,
      110,
      Paint()
        ..shader = ui.Gradient.radial(
          pusat,
          110,
          [
            Color.fromRGBO(47, 169, 253, 0.16 * fade),
            const Color.fromRGBO(47, 169, 253, 0),
          ],
        ),
    );

    // Tiga lingkaran riak yang membesar bergantian
    for (var i = 0; i < 3; i++) {
      final p = (t + i / 3) % 1.0;
      final r = 70 + p * 140;
      final a = (1 - p) * 0.16 * fade;
      canvas.drawCircle(
        pusat,
        r,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5
          ..color = Color.fromRGBO(47, 169, 253, a),
      );
    }
  }

  @override
  bool shouldRepaint(_RiakPainter o) =>
      o.t != t || o.fade != fade || o.pusat != pusat;
}

/// Gelombang atas & bawah (desain 360x800, diskalakan ke layar).
class _GelombangPainter extends CustomPainter {
  _GelombangPainter({
    required this.topBlob,
    required this.topWave,
    required this.botBlob,
    required this.botWave,
    required this.t,
  });

  final double topBlob, topWave, botBlob, botWave, t;

  Shader _blob(Offset a, Offset b) => ui.Gradient.linear(
        a,
        b,
        [const Color(0x592089ED), const Color(0x2D2CA0CC)],
        [0.254808, 1.0],
      );

  Shader _wave(double y, double x2) => ui.Gradient.linear(
        Offset(0, y),
        Offset(x2, y),
        [
          const Color(0x99157CFD),
          const Color(0x4D00AAFF),
          const Color(0x00FFFFFF),
        ],
        [0.0721154, 0.5625, 1.0],
      );

  void _fade(Canvas canvas, double v, void Function() gambar) {
    final a = v.clamp(0.0, 1.0);
    if (a <= 0) return;
    canvas.saveLayer(
      const Rect.fromLTWH(-10, -140, 380, 1100),
      Paint()..color = Color.fromRGBO(255, 255, 255, a),
    );
    gambar();
    canvas.restore();
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 360, size.height / 800);

    // Gerak napas halus: 0..1..0
    final napas = 0.5 - 0.5 * math.cos(t * 2 * math.pi);
    final garis = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = const Color(0x26E9E9E9);

    // Blob atas
    _fade(canvas, topBlob, () {
      canvas.drawPath(
        _blobAtas,
        Paint()
          ..shader = _blob(const Offset(108.409, 133.585), const Offset(183.317, 2.17591)),
      );
    });

    // Gelombang atas: meluncur turun dari atas, lalu bergerak halus
    _fade(canvas, topWave, () {
      canvas.save();
      canvas.translate(180, -130 * (1 - topWave) - 4 * napas);
      canvas.scale(1 + 0.02 * napas, 1);
      canvas.translate(-180, 0);
      canvas.drawPath(_waveAtas, Paint()..shader = _wave(61.5, 365));
      canvas.drawPath(_waveAtas, garis);
      canvas.restore();
    });

    // Blob bawah
    _fade(canvas, botBlob, () {
      canvas.drawPath(
        _blobBawah,
        Paint()
          ..shader = _blob(const Offset(108.803, 665.415), const Offset(183.923, 796.465)),
      );
    });

    // Gelombang bawah: naik dari bawah, lalu bergerak halus berlawanan arah
    _fade(canvas, botWave, () {
      canvas.save();
      canvas.translate(180, 130 * (1 - botWave) + 4 * napas);
      canvas.scale(1 + 0.02 * napas, 1);
      canvas.translate(-180, 0);
      canvas.drawPath(_waveBawah, Paint()..shader = _wave(737.5, 366));
      canvas.drawPath(_waveBawah, garis);
      canvas.restore();
    });

    canvas.restore();
  }

  @override
  bool shouldRepaint(_GelombangPainter o) =>
      o.topBlob != topBlob ||
      o.topWave != topWave ||
      o.botBlob != botBlob ||
      o.botWave != botWave ||
      o.t != t;
}