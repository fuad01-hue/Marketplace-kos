import 'package:flutter/material.dart';
import 'main_screen.dart';

class PaymentPage extends StatefulWidget {
  // Tambahkan deklarasi properti berikut:
  final dynamic kostData;
  final String? namaPenyewa;
  final String? jadwalMasuk;
  final String? jadwalKeluar;
  final String? kostName;
  final dynamic nominal;

  const PaymentPage({
    super.key,
    this.kostData,
    this.namaPenyewa,
    this.jadwalMasuk,
    this.jadwalKeluar,
    this.kostName,
    this.nominal,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String _selectedMethod = 'QRIS';

  final _paymentMethods = [
    {
      'id': 'QRIS',
      'name': 'QRIS (GoPay, OVO, Dana)',
      'icon': Icons.qr_code_scanner,
    },
    {
      'id': 'Transfer Bank',
      'name': 'Transfer Virtual Account (BCA, Mandiri, BRI)',
      'icon': Icons.account_balance,
    },
    {
      'id': 'Kartu Debit/Kredit',
      'name': 'Kartu Debit / Kredit (Visa, Mastercard)',
      'icon': Icons.credit_card,
    },
  ];

  // Ekstraksi nama kos secara dinamis
  String _getNamaKos() {
    if (widget.kostName != null && widget.kostName!.isNotEmpty) {
      return widget.kostName!;
    }
    if (widget.kostData != null && widget.kostData is Map) {
      return widget.kostData['name']?.toString() ??
          widget.kostData['nama']?.toString() ??
          'Kost Mahanti';
    }
    return 'Kost Mahanti';
  }

  // Ekstraksi total bayar secara dinamis
  String _getHarga() {
    if (widget.nominal != null && widget.nominal!.isNotEmpty) {
      return widget.nominal!;
    }
    if (widget.kostData != null && widget.kostData is Map) {
      final price = widget.kostData['price'] ?? widget.kostData['harga'];
      if (price != null) return price.toString();
    }
    return 'Rp 1.900.000';
  }

  void _handleBack() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Batalkan Pembayaran?',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        content: const Text(
          'Pesanan Anda akan tetap tersimpan di menu Booking & Pembayaran.',
          style: TextStyle(fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Lanjut Bayar', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
            ),
            child: const Text('Keluar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _prosesPembayaran() {
    final namaKos = _getNamaKos();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFFDCFCE7),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: Color(0xFF16A34A), size: 40),
            ),
            const SizedBox(height: 16),
            const Text(
              'Pembayaran Berhasil!',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 6),
            Text(
              'Pembayaran untuk $namaKos telah berhasil dikonfirmasi.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 42,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const MainScreen()),
                    (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E88E5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Selesai',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final namaKos = _getNamaKos();
    final harga = _getHarga();

    return WillPopScope(
      onWillPop: () async {
        _handleBack();
        return false;
      },
      child: Scaffold(
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
                    onPressed: _handleBack,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Pembayaran',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  // Rincian Tagihan & Booking
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
                        const Text(
                          'Rincian Tagihan',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        const Divider(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Nama Kos', style: TextStyle(color: Colors.grey, fontSize: 13)),
                            Text(namaKos, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          ],
                        ),

                        // Tampilkan info penyewa jika dikirim dari booking_page
                        if (widget.namaPenyewa != null && widget.namaPenyewa!.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Penyewa', style: TextStyle(color: Colors.grey, fontSize: 13)),
                              Text(widget.namaPenyewa!, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                            ],
                          ),
                        ],

                        // Tampilkan tanggal masuk jika ada
                        if (widget.jadwalMasuk != null && widget.jadwalMasuk!.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Jadwal Sewa', style: TextStyle(color: Colors.grey, fontSize: 13)),
                              Text(
                                '${widget.jadwalMasuk} s/d ${widget.jadwalKeluar ?? "-"}',
                                style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
                              ),
                            ],
                          ),
                        ],

                        const SizedBox(height: 8),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Biaya Layanan', style: TextStyle(color: Colors.grey, fontSize: 13)),
                            Text('Gratis', style: TextStyle(color: Color(0xFF16A34A), fontWeight: FontWeight.bold, fontSize: 13)),
                          ],
                        ),
                        const Divider(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total Pembayaran',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            Text(
                              harga,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Color(0xFF1E88E5),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                  const Text(
                    'Pilih Metode Pembayaran',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 10),

                  // Pilihan Metode
                  ..._paymentMethods.map((m) {
                    final isSelected = _selectedMethod == m['id'];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isSelected ? const Color(0xFF1E88E5) : const Color(0xFFEEF2F6),
                          width: isSelected ? 1.5 : 1.0,
                        ),
                      ),
                      child: ListTile(
                        leading: Icon(
                          m['icon'] as IconData,
                          color: isSelected ? const Color(0xFF1E88E5) : Colors.grey,
                        ),
                        title: Text(
                          m['name'].toString(),
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        trailing: Radio<String>(
                          value: m['id'].toString(),
                          groupValue: _selectedMethod,
                          activeColor: const Color(0xFF1E88E5),
                          onChanged: (val) {
                            if (val != null) setState(() => _selectedMethod = val);
                          },
                        ),
                        onTap: () => setState(() => _selectedMethod = m['id'].toString()),
                      ),
                    );
                  }),
                ],
              ),
            ),

            // Tombol Konfirmasi Bayar
            Container(
              padding: EdgeInsets.fromLTRB(20, 12, 20, MediaQuery.paddingOf(context).bottom + 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Color(0xFFEEF2F6))),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _prosesPembayaran,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E88E5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    'Bayar Sekarang • $harga',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}