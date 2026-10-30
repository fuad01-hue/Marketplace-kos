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

  DateTime? _jadwalMasuk;
  DateTime? _jadwalKeluar;

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
    if (_jadwalMasuk == null) {
      _showWarning('Harap pilih Jadwal Masuk');
      return;
    }
    if (_jadwalKeluar == null) {
      _showWarning('Harap pilih Jadwal Keluar');
      return;
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
        final hargaKos = widget.kostData?['price'] ?? 'Rp. 500.000,00 / Bulan';

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
              _buildSummaryRow('Jadwal Masuk', _formatTanggalIndo(_jadwalMasuk)),
              _buildSummaryRow('Jadwal Keluar', _formatTanggalIndo(_jadwalKeluar)),
              _buildSummaryRow('Harga', hargaKos.toString(), isHighlight: true),
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

                  // Jadwal Masuk
                  _buildFieldLabel('Jadwal Masuk'),
                  const SizedBox(height: 6),
                  _buildDateSelector(
                    valueText: _formatTanggalIndo(_jadwalMasuk),
                    hintText: 'Pilih Tanggal Masuk',
                    onTap: _pilihJadwalMasuk,
                  ),

                  const SizedBox(height: 18),

                  // Jadwal Keluar
                  _buildFieldLabel('Jadwal Keluar'),
                  const SizedBox(height: 6),
                  _buildDateSelector(
                    valueText: _formatTanggalIndo(_jadwalKeluar),
                    hintText: 'Pilih Tanggal Keluar',
                    onTap: _pilihJadwalKeluar,
                  ),

                  const SizedBox(height: 18),

                  // Catatan (Opsional)
                  _buildFieldLabel('Catatan'),
                  const SizedBox(height: 6),
                  _buildTextInput(
                    controller: _catatanController,
                    hint: 'Catatan (Opsional)',
                    maxLines: 3,
                  ),

                  const SizedBox(height: 32),

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
                      child: const Text(
                        'Lanjut ke Pembayaran',
                        style: TextStyle(
                          fontSize: 15,
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
    final bool hasValue = valueText.isNotEmpty;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
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
              hasValue ? valueText : hintText,
              style: TextStyle(
                fontSize: 13.5,
                color: hasValue ? Colors.black87 : Colors.grey.shade400,
                fontWeight: hasValue ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            const Icon(
              Icons.calendar_month_outlined,
              size: 20,
              color: Color(0xFF1E88E5),
            ),
          ],
        ),
      ),
    );
  }
}