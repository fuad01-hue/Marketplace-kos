import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'payment_page.dart';

class BookingPage extends StatefulWidget {
  final Map<String, dynamic>? kostData;

  const BookingPage({super.key, this.kostData});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final _namaController = TextEditingController();
  final _teleponController = TextEditingController();
  final _catatanController = TextEditingController();
  String _tipeSewa = 'Bulanan'; // default terpilih Bulanan
  final List<String> _opsiTipeSewa = ['Harian', 'Mingguan', 'Bulanan'];
  int _durasiMinggu = 1; // default 1 minggu
  int _durasiBulan = 1;  // default 1 bulan

  DateTime? _jadwalMasuk;
  DateTime? _jadwalKeluar;
  // Perhitungan harga otomatis berdasarkan tipe sewa & durasi
  int _getBaseMonthlyPrice() {
    if (widget.kostData != null && widget.kostData is Map) {
      final p = widget.kostData?['price']?.toString() ?? '';
      final clean = p.replaceAll(RegExp(r'[^\\d]'), '');
      if (clean.isNotEmpty) {
        if (p.contains(',00') && clean.endsWith('00')) {
          final val = int.tryParse(clean.substring(0, clean.length - 2));
          if (val != null && val > 0) return val;
        }
        final val = int.tryParse(clean);
        if (val != null && val > 0) return val;
      }
    }
    return 700000;
  }

  int get _hargaPerBulan => _getBaseMonthlyPrice();
  int get _hargaPerMinggu => (_hargaPerBulan == 700000) ? 250000 : ((_hargaPerBulan * 0.35) / 1000).round() * 1000;
  int get _hargaPerHari => (_hargaPerBulan == 700000) ? 50000 : ((_hargaPerBulan * 0.08) / 1000).round() * 1000;

  String _formatRupiah(int nominal) {
    final str = nominal.toString();
    final buffer = StringBuffer();
    int count = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      buffer.write(str[i]);
      count++;
      if (count % 3 == 0 && i != 0) {
        buffer.write('.');
      }
    }
    return 'Rp ${buffer.toString().split('').reversed.join('')}';
  }

  int get _totalNominalAngka {
    switch (_tipeSewa) {
      case 'Harian':
        int hari = 1;
        if (_jadwalMasuk != null && _jadwalKeluar != null) {
          hari = _jadwalKeluar!.difference(_jadwalMasuk!).inDays;
          if (hari < 1) hari = 1;
        }
        return _hargaPerHari * hari;
      case 'Mingguan':
        return _hargaPerMinggu * _durasiMinggu;
      case 'Bulanan':
      default:
        return _hargaPerBulan * _durasiBulan;
    }
  }

  String _getTotalHargaFormatted() {
    return _formatRupiah(_totalNominalAngka);
  }

  String _getTarifSatuanText() {
    switch (_tipeSewa) {
      case 'Harian':
        return '${_formatRupiah(_hargaPerHari)} / Hari';
      case 'Mingguan':
        return '${_formatRupiah(_hargaPerMinggu)} / Minggu';
      case 'Bulanan':
      default:
        return '${_formatRupiah(_hargaPerBulan)} / Bulan';
    }
  }

  String _getDurasiText() {
    switch (_tipeSewa) {
      case 'Harian':
        int hari = 1;
        if (_jadwalMasuk != null && _jadwalKeluar != null) {
          hari = _jadwalKeluar!.difference(_jadwalMasuk!).inDays;
          if (hari < 1) hari = 1;
        }
        return '$hari Hari';
      case 'Mingguan':
        return '$_durasiMinggu Minggu';
      case 'Bulanan':
      default:
        return '$_durasiBulan Bulan';
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _teleponController.dispose();
    _catatanController.dispose();
    super.dispose();
  }

  // Nama-nama bulan dalam Bahasa Indonesia
  static const List<String> _namaBulan = [
    '', 'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
    'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
  ];

  // Format tanggal rapi dalam Bahasa Indonesia (Contoh: 30 Oktober 2026)
  String _formatTanggalIndo(DateTime? date) {
    if (date == null) return '';
    return '${date.day} ${_namaBulan[date.month]} ${date.year}';
  }

  // Pemilih Tanggal Masuk (Mode Kalender Visual Tanpa Keyboard)
  Future<void> _pilihJadwalMasuk() async {
    FocusScope.of(context).unfocus();
    final picked = await showDatePicker(
      context: context,
      initialDate: _jadwalMasuk ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      helpText: 'PILIH TANGGAL MASUK',
      cancelText: 'BATAL',
      confirmText: 'PILIH',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF1E88E5),
              onPrimary: Colors.white,
              onSurface: Colors.black87,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF1E88E5),
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _jadwalMasuk = picked;
        if (_jadwalKeluar != null && _jadwalKeluar!.isBefore(picked)) {
          _jadwalKeluar = null;
        }
      });
    }
  }

  // Pemilih Tanggal Keluar (Mode Kalender Visual Tanpa Keyboard)
  Future<void> _pilihJadwalKeluar() async {
    FocusScope.of(context).unfocus();
    final minDate = _jadwalMasuk ?? DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _jadwalKeluar ?? minDate.add(const Duration(days: 30)),
      firstDate: minDate,
      lastDate: minDate.add(const Duration(days: 730)),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      helpText: 'PILIH TANGGAL KELUAR',
      cancelText: 'BATAL',
      confirmText: 'PILIH',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF1E88E5),
              onPrimary: Colors.white,
              onSurface: Colors.black87,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF1E88E5),
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _jadwalKeluar = picked;
      });
    }
  }

  void _lanjutKePembayaran() {
    FocusScope.of(context).unfocus();

    if (_namaController.text.trim().isEmpty) {
      _showWarning('Harap masukkan Nama Lengkap Anda');
      return;
    }
    if (_teleponController.text.trim().isEmpty) {
      _showWarning('Harap masukkan Nomor Telepon');
      return;
    }
    // Hanya validasi tanggal masuk & keluar jika memilih Harian
    if (_tipeSewa == 'Harian') {
      if (_jadwalMasuk == null) {
        _showWarning('Harap pilih Jadwal Masuk');
        return;
      }
      if (_jadwalKeluar == null) {
        _showWarning('Harap pilih Jadwal Keluar');
        return;
      }
    }

    // Modal konfirmasi ringkasan pemesanan
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        final namaKos = widget.kostData?['name'] ?? 'Kost Mahogani';
        final hargaKos = _getTotalHargaFormatted();

        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Ringkasan Pemesanan',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 14),
              _buildSummaryRow('Kos', namaKos.toString()),
              _buildSummaryRow('Penyewa', _namaController.text.trim()),
              _buildSummaryRow('Tipe Sewa', _tipeSewa),
              _buildSummaryRow('Durasi', _getDurasiText()),
              _buildSummaryRow('Tarif Satuan', _getTarifSatuanText()),
              if (_tipeSewa == 'Harian') ...[
                _buildSummaryRow('Jadwal Masuk', _formatTanggalIndo(_jadwalMasuk)),
                _buildSummaryRow('Jadwal Keluar', _formatTanggalIndo(_jadwalKeluar)),
              ],
              _buildSummaryRow('Total Pembayaran', hargaKos, isHighlight: true),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx); // Tutup modal ringkasan

                    // Navigasi langsung ke halaman Payment Gateway
                    Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentPage(
                        kostData: widget.kostData,
                        namaPenyewa: _namaController.text.trim(),
                        jadwalMasuk: _formatTanggalIndo(_jadwalMasuk),
                        jadwalKeluar: _formatTanggalIndo(_jadwalKeluar),
                        kostName: namaKos.toString(),
                        nominal: hargaKos.toString(), // <-- WAJIB TAMBAHKAN INI AGAR HARGA TERKIRIM
                      ),
                    ),
                  );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2196F3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Bayar Sekarang',
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showWarning(String pesan) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(pesan),
        backgroundColor: const Color(0xFFE53935),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isHighlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
          Text(
            value,
            style: TextStyle(
              color: isHighlight ? const Color(0xFF1E88E5) : Colors.black87,
              fontWeight: isHighlight ? FontWeight.bold : FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFD),
      body: Column(
        children: [
          // Header Biru AyoKost
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.paddingOf(context).top + 10,
              bottom: 20,
              left: 16,
              right: 16,
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
                  icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
                  onPressed: () => Navigator.pop(context),
                  splashRadius: 20,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const Expanded(
                  child: Text(
                    'Booking',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 24),
              ],
            ),
          ),

          // Form Pemesanan
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nama Lengkap
                  _buildFieldLabel('Nama Lengkap'),
                  const SizedBox(height: 6),
                  _buildTextInput(
                    controller: _namaController,
                    hint: 'Masukkan Nama Lengkap',
                    keyboardType: TextInputType.name,
                  ),

                  const SizedBox(height: 18),

                  // No. Telepon
                  _buildFieldLabel('No. Telepon'),
                  const SizedBox(height: 6),
                  _buildTextInput(
                    controller: _teleponController,
                    hint: '081234567890',
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),

                  const SizedBox(height: 18),
                    // Tipe Sewa
                  _buildFieldLabel('Tipe Sewa'),
                  const SizedBox(height: 6),
                  Row(
                    children: _opsiTipeSewa.map((opsi) {
                      final bool isSelected = _tipeSewa == opsi;
                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: () {
                            setState(() {
                              _tipeSewa = opsi;
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 9,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFF1E88E5)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFF1E88E5)
                                    : Colors.grey.shade300,
                                width: 1.5,
                              ),
                            ),
                            child: Text(
                              opsi,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                color: isSelected ? Colors.white : Colors.black87,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 18),
                  // === FORM DINAMIS SESUAI TIPE SEWA ===
            if (_tipeSewa == 'Harian') ...[
              // Opsi Harian: Tanggal Masuk & Tanggal Keluar
              _buildFieldLabel('Jadwal Masuk'),
              const SizedBox(height: 6),
              _buildDateSelector(
                valueText: _formatTanggalIndo(_jadwalMasuk),
                hintText: 'Pilih Tanggal Masuk',
                onTap: _pilihJadwalMasuk,
              ),
              const SizedBox(height: 18),

              _buildFieldLabel('Jadwal Keluar'),
              const SizedBox(height: 6),
              _buildDateSelector(
                valueText: _formatTanggalIndo(_jadwalKeluar),
                hintText: 'Pilih Tanggal Keluar',
                onTap: _pilihJadwalKeluar,
              ),
              const SizedBox(height: 18),
              ] else if (_tipeSewa == 'Mingguan') ...[
              // Opsi Mingguan: Pemilih Jumlah Minggu
              _buildFieldLabel('Durasi Sewa (Minggu)'),
              const SizedBox(height: 6),
              _buildCounterSelector(
                valueText: '$_durasiMinggu Minggu',
                onDecrement: () {
                  if (_durasiMinggu > 1) {
                    setState(() => _durasiMinggu--);
                  }
                },
                onIncrement: () {
                  setState(() => _durasiMinggu++);
                },
              ),
              const SizedBox(height: 18),
            ] else ...[
              // Opsi Bulanan: Pemilih Jumlah Bulan
              _buildFieldLabel('Durasi Sewa (Bulan)'),
              const SizedBox(height: 6),
              _buildCounterSelector(
                valueText: '$_durasiBulan Bulan',
                onDecrement: () {
                  if (_durasiBulan > 1) {
                    setState(() => _durasiBulan--);
                  }
                },
                onIncrement: () {
                  setState(() => _durasiBulan++);
                },
              ),
              const SizedBox(height: 18),
            ],

            // Catatan (Opsional)
            _buildFieldLabel('Catatan (Opsional)'),
            const SizedBox(height: 6),
            _buildTextInput(
              controller: _catatanController,
              hint: 'Catatan (Opsional)',
              maxLines: 3,
            ),

            const SizedBox(height: 20),

            // ==========================================
            // KARTU RINCIAN BIAYA OTOMATIS
            // ==========================================
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF4F7FC),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Tarif ()',
                        style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                      ),
                      Text(
                        _getTarifSatuanText(),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Durasi',
                        style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                      ),
                      Text(
                        _getDurasiText(),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Divider(height: 1, color: Color(0xFFE2E8F0)),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Biaya',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        _getTotalHargaFormatted(),
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E88E5),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Tombol Lanjut ke Pembayaran
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _lanjutKePembayaran,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2196F3),
                  elevation: 3,
                  shadowColor: const Color(0x592196F3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Lanjut ke Pembayaran • ${_getTotalHargaFormatted()}',
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget pemilih jumlah minggu/bulan dengan tombol minus & plus
  Widget _buildCounterSelector({
    required String valueText,
    required VoidCallback onDecrement,
    required VoidCallback onIncrement,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            valueText,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          Row(
            children: [
              // Tombol Kurang (-)
              InkWell(
                onTap: onDecrement,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: const Icon(Icons.remove, size: 18, color: Colors.black87),
                ),
              ),
              const SizedBox(width: 12),
              // Tombol Tambah (+)
              InkWell(
                onTap: onIncrement,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E88E5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.add, size: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildTextInput({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        maxLines: maxLines,
        style: const TextStyle(fontSize: 14, color: Colors.black87),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildDateSelector({
    required String valueText,
    required String hintText,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              valueText.isNotEmpty ? valueText : hintText,
              style: TextStyle(
                fontSize: 14,
                color: valueText.isNotEmpty ? Colors.black87 : Colors.grey.shade400,
              ),
            ),
            const Icon(Icons.calendar_today, size: 18, color: Color(0xFF1E88E5)),
          ],
        ),
      ),
      
    );
  }

}