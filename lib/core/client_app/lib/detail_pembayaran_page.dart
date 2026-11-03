import 'package:flutter/material.dart';
import 'main_screen.dart';

class DetailPembayaranPage extends StatelessWidget {
  final Map<String, dynamic>? paymentData;

  const DetailPembayaranPage({super.key, this.paymentData});

  @override
  Widget build(BuildContext context) {
    // Data dinamis dengan fallback ke nilai default sesuai rancangan Figma
    final idTransaksi = paymentData?['idTransaksi'] ?? 'KOS-20260817-007';
    final metodePembayaran = paymentData?['metodePembayaran'] ?? 'Transfer Bank';
    final status = paymentData?['status'] ?? 'Lunas';
    final namaKos = paymentData?['namaKos'] ?? 'Kos Mahogani';
    final penyewa = paymentData?['penyewa'] ?? 'fuad';
    final lokasi = paymentData?['lokasi'] ?? 'Lhokseumawe';
    final tipeSewa = paymentData?['tipeSewa'] ?? 'mingguan';
    final biayaLayanan = paymentData?['biayaLayanan'] ?? 'gratis';
    final totalBayar = paymentData?['totalBayar'] ?? 'Rp 1.002.500';
    final tanggal = paymentData?['tanggal'] ?? '17 Agustus 2026, 07:25:09 WIB';

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            // ==========================================
            // HEADER BIRU MELENGKUNG DENGAN TOMBOL KEMBALI
            // ==========================================
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                top: MediaQuery.paddingOf(context).top + 12,
                bottom: 22,
                left: 16,
                right: 16,
              ),
              decoration: const ShapeDecoration(
                gradient: RadialGradient(
                  center: Alignment(0.50, 0.51),
                  radius: 1.42,
                  colors: [Color(0xFF59B4FF), Color(0xFF1681FB)],
                ),
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 1,
                    color: Color(0xFF2FA9FD),
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(28),
                    bottomRight: Radius.circular(28),
                  ),
                ),
              ),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(20),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Detail Pembayaran',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontFamily: 'Poppins', 
                        color: Colors.white,
                        fontSize: 19,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  // Placeholder penyeimbang agar judul tetap berada persis di tengah
                  const SizedBox(width: 36),
                ],
              ),
            ),

            // ==========================================
            // KONTEN UTAMA (SCROLLABLE)
            // ==========================================
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 8),

                    // IKON CENTANG SUKSES
                    Container(
                      width: 76,
                      height: 76,
                      decoration: const BoxDecoration(
                        color: Color(0xFF2FA9FD),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Container(
                          width: 64,
                          height: 64,
                          decoration: const BoxDecoration(
                            color: Color(0xFFF4F7FC),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check_rounded,
                            color: Color(0xFF2FA9FD),
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // JUDUL STATUS PEMBAYARAN
                    Text(
                      'Pembayaran Berhasil',
                      style: TextStyle(fontFamily: 'Poppins', 
                        color: Colors.black,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // WAKTU TRANSAKSI
                    Text(
                      tanggal,
                      style: TextStyle(fontFamily: 'Poppins', 
                        color: const Color(0xFF797979),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ==========================================
                    // KARTU RINCIAN PEMBAYARAN
                    // ==========================================
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDetailRow(label: 'ID Transaksi', value: idTransaksi),
                          const SizedBox(height: 12),
                          _buildDetailRow(label: 'Metode Pembayaran', value: metodePembayaran),
                          const SizedBox(height: 12),
                          
                          // Baris Status dengan badge hijau 'Lunas'
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Status',
                                style: TextStyle(fontFamily: 'Poppins', 
                                  color: const Color(0xFF797979),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFDCFCE7),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  status,
                                  style: TextStyle(fontFamily: 'Poppins', 
                                    color: const Color(0xFF14532D),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 14),
                          const Divider(color: Color(0xFFE5E7EB), thickness: 1, height: 1),
                          const SizedBox(height: 14),

                          _buildDetailRow(label: 'Nama Kos', value: namaKos),
                          const SizedBox(height: 12),
                          _buildDetailRow(label: 'penyewa', value: penyewa),
                          const SizedBox(height: 12),
                          _buildDetailRow(label: 'Lokasi', value: lokasi),
                          const SizedBox(height: 12),
                          _buildDetailRow(label: 'tipe sewa', value: tipeSewa),
                          const SizedBox(height: 12),
                          _buildDetailRow(label: 'Biaya layanan', value: biayaLayanan),

                          const SizedBox(height: 14),
                          const Divider(color: Color(0xFFE5E7EB), thickness: 1, height: 1),
                          const SizedBox(height: 14),

                          // Baris Total Bayar
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total Bayar',
                                style: TextStyle(fontFamily: 'Poppins', 
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                totalBayar,
                                style: TextStyle(fontFamily: 'Poppins', 
                                  color: Colors.black,
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // ==========================================
            // TOMBOL KEMBALI KE BERANDA (BOTTOM BAR)
            // ==========================================
            Container(
              padding: EdgeInsets.fromLTRB(
                16,
                10,
                16,
                MediaQuery.paddingOf(context).bottom > 0
                    ? MediaQuery.paddingOf(context).bottom + 10
                    : 16,
              ),
              child: SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const MainScreen()),
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2FA9FD),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Kembali ke Beranda',
                    style: TextStyle(fontFamily: 'Poppins', 
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow({required String label, required String value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontFamily: 'Poppins', 
            color: const Color(0xFF797979),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          textAlign: TextAlign.right,
          style: TextStyle(fontFamily: 'Poppins', 
            color: const Color(0xFF797979),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
