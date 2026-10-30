import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'halaman_awal.dart';
import 'splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Aplikasi hanya portrait (sesuai desain 360x800).
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Status bar transparan dengan ikon gelap.
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
    systemNavigationBarColor: Colors.white,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));

  runApp(const AyoKostApp());
}

class AyoKostApp extends StatelessWidget {
  const AyoKostApp({super.key});

  static const Color biru = Color(0xFF157CFD);
  static const Color latar = Color(0xFFF4F7FC);

  @override
  Widget build(BuildContext context) {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: biru, primary: biru),
      scaffoldBackgroundColor: latar,
    );

    return MaterialApp(
      title: 'Ayo Kost!',
      debugShowCheckedModeBanner: false,
      theme: base.copyWith(
        textTheme: GoogleFonts.poppinsTextTheme(base.textTheme),
      ),
      // Alur: Splash -> Halaman Awal -> Login -> Dashboard
      home: const SplashScreen(
        next: HalamanAwal()),
    );
  }
}