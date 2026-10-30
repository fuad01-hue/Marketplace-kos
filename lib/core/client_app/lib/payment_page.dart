import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'main_screen.dart';

class PaymentPage extends StatefulWidget {
  final Map<String, dynamic>? kostData;
  final String namaPenyewa;
  final String jadwalMasuk;
  final String jadwalKeluar;

  const PaymentPage({
    super.key,
    this.kostData,
    required this.namaPenyewa,
    required this.jadwalMasuk,
    required this.jadwalKeluar,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  // Status Langkah Pembayaran:
  // 0 = Pilih Metode, 1 = Input Kartu, 2 = Konfirmasi, 3 = Bukti Berhasil
  int _currentStep = 0;

  String _selectedMethod = 'Kartu Debit / Kredit';
  int _selectedCardTheme = 0; // 0 = Kartu Hitam, 1 = Kartu Emas

  // Controller Form Kartu
  final _cardNumberController = TextEditingController();
  final _cardHolderController = TextEditingController();
  final _cardExpiryController = TextEditingController();
  final _cardCvvController = TextEditingController();

  @override
  void dispose() {
    _cardNumberController.dispose();
    _cardHolderController.dispose();
    _cardExpiryController.dispose();
    _cardCvvController.dispose();
    super.dispose();
  }

  void _handleBack() {
    if (_currentStep > 0 && _currentStep < 3) {
      setState(() => _currentStep--);
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_currentStep > 0 && _currentStep < 3) {
          setState(() => _currentStep--);
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: _currentStep == 3
            ? null
            : AppBar(
                backgroundColor: const Color(0xFF1E88E5),
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: _handleBack,
                ),
                title: Text(
                  _currentStep == 0
                      ? 'Metode Pembayaran'
                      : _currentStep == 1
                          ? 'Detail Kartu'
                          : 'Konfirmasi Pembayaran',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
                centerTitle: true,
              ),
        body: SafeArea(
          child: _buildBodyContent(),
        ),
      ),
    );
  }

  Widget _buildBodyContent() {
    switch (_currentStep) {
      case 0:
        return _buildSelectMethodView();
      case 1:
        return _buildCardInputView();
      case 2:
        return _buildConfirmationView();
      case 3:
        return _buildReceiptSuccessView();
      default:
        return const SizedBox.shrink();
    }
  }

  // ===========================================================================
  // TAHAP 1: PILIH METODE PEMBAYARAN
  // ===========================================================================
  Widget _buildSelectMethodView() {
    final methods = [
      {
        'title': 'Kartu Debit / Kredit',
        'subtitle': 'Visa, Mastercard, JCB',
        'icon': Icons.credit_card_rounded,
      },
      {
        'title': 'Transfer Bank (Virtual Account)',
        'subtitle': 'BCA, Mandiri, BNI, BRI, BSI',
        'icon': Icons.account_balance_outlined,
      },
      {
        'title': 'E-Wallet / QRIS',
        'subtitle': 'GoPay, OVO, DANA, ShopeePay',
        'icon': Icons.qr_code_scanner_rounded,
      },
    ];

    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            itemCount: methods.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = methods[index];
              final isSelected = _selectedMethod == item['title'];

              return InkWell(
                onTap: () {
                  setState(() => _selectedMethod = item['title'].toString());
                },
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF1E88E5)
                          : const Color(0xFFE2E8F0),
                      width: isSelected ? 2 : 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.02),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFFE3F2FD)
                              : const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          item['icon'] as IconData,
                          color: isSelected
                              ? const Color(0xFF1E88E5)
                              : Colors.black54,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['title'].toString(),
                              style: const TextStyle(
                                fontSize: 14.5,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              item['subtitle'].toString(),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        isSelected
                            ? Icons.radio_button_checked
                            : Icons.radio_button_off,
                        color: isSelected
                            ? const Color(0xFF1E88E5)
                            : Colors.grey.shade400,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        _buildBottomButton(
          title: 'Lanjut Pembayaran',
          onTap: () {
            if (_selectedMethod == 'Kartu Debit / Kredit') {
              setState(() => _currentStep = 1);
            } else {
              setState(() => _currentStep = 2);
            }
          },
        ),
      ],
    );
  }

  // ===========================================================================
  // TAHAP 2: INPUT KARTU DEBIT / KREDIT
  // ===========================================================================
  Widget _buildCardInputView() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Pilihan Kartu Fisik (Hitam & Emas Figma)
                SizedBox(
                  height: 180,
                  child: PageView(
                    onPageChanged: (idx) => setState(() => _selectedCardTheme = idx),
                    children: [
                      _buildVisualCard(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF232526), Color(0xFF414345)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        typeLabel: 'DEBIT CARD',
                      ),
                      _buildVisualCard(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFD4AF37), Color(0xFF8C6D1F)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        typeLabel: 'CREDIT CARD',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [0, 1].map((index) {
                      return Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _selectedCardTheme == index
                              ? const Color(0xFF1E88E5)
                              : Colors.grey.shade300,
                        ),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 20),

                // Form Input Kartu
                _buildInputLabel('Nomor Kartu'),
                const SizedBox(height: 6),
                _buildCardTextField(
                  controller: _cardNumberController,
                  hint: '•••• •••• •••• ••••',
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(16),
                    _CardNumberFormatter(),
                  ],
                  onChanged: (_) => setState(() {}),
                ),

                const SizedBox(height: 16),

                _buildInputLabel('Nama di Kartu'),
                const SizedBox(height: 6),
                _buildCardTextField(
                  controller: _cardHolderController,
                  hint: 'NAMA LENGKAP PEMEGANG',
                  keyboardType: TextInputType.name,
                  onChanged: (_) => setState(() {}),
                ),

                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInputLabel('Masa Berlaku'),
                          const SizedBox(height: 6),
                          _buildCardTextField(
                            controller: _cardExpiryController,
                            hint: 'BB/TT (MM/YY)',
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(4),
                              _CardExpiryFormatter(),
                            ],
                            onChanged: (_) => setState(() {}),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInputLabel('CVV'),
                          const SizedBox(height: 6),
                          _buildCardTextField(
                            controller: _cardCvvController,
                            hint: '•••',
                            keyboardType: TextInputType.number,
                            obscureText: true,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(3),
                            ],
                            onChanged: (_) => setState(() {}),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
        _buildBottomButton(
          title: 'Lanjut Konfirmasi',
          onTap: () {
            if (_cardNumberController.text.length < 16) {
              _showSnackbar('Nomor kartu minimal 16 digit');
              return;
            }
            if (_cardHolderController.text.trim().isEmpty) {
              _showSnackbar('Nama di kartu wajib diisi');
              return;
            }
            if (_cardExpiryController.text.length < 5) {
              _showSnackbar('Masa berlaku format MM/YY');
              return;
            }
            if (_cardCvvController.text.length < 3) {
              _showSnackbar('CVV wajib 3 digit');
              return;
            }
            setState(() => _currentStep = 2);
          },
        ),
      ],
    );
  }

  // ===========================================================================
  // TAHAP 3: KONFIRMASI PEMBAYARAN & RINCIAN TAGIHAN
  // ===========================================================================
  Widget _buildConfirmationView() {
    final namaKos = widget.kostData?['name'] ?? 'Kost Mahogani';
    final hargaSewa = widget.kostData?['price'] ?? 'Rp. 500.000,00 / Bulan';

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Info Kos Singkat
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          width: 65,
                          height: 65,
                          color: const Color(0xFFE3F2FD),
                          child: const Icon(
                            Icons.home_work_outlined,
                            color: Color(0xFF1E88E5),
                            size: 30,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              namaKos.toString(),
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              widget.kostData?['location'] ?? 'Kota Lhokseumawe',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              hargaSewa.toString(),
                              style: const TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E88E5),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Rincian Jadwal & Penyewa
                const Text(
                  'Detail Pemesanan',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                _buildInfoCard([
                  _buildDetailRow('Penyewa', widget.namaPenyewa),
                  _buildDetailRow('Jadwal Masuk', widget.jadwalMasuk),
                  _buildDetailRow('Jadwal Keluar', widget.jadwalKeluar),
                  _buildDetailRow('Metode', _selectedMethod),
                ]),

                const SizedBox(height: 20),

                // Rincian Pembayaran
                const Text(
                  'Rincian Pembayaran',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                _buildInfoCard([
                  _buildDetailRow('Biaya Sewa Kos (1 Bulan)', 'Rp. 500.000'),
                  _buildDetailRow('Biaya Layanan & Admin', 'Rp. 5.000'),
                  const Divider(height: 20, color: Color(0xFFE2E8F0)),
                  _buildDetailRow(
                    'Total Tagihan',
                    'Rp. 505.000',
                    isTotal: true,
                  ),
                ]),
              ],
            ),
          ),
        ),
        _buildBottomButton(
          title: 'Bayar Sekarang',
          onTap: () {
            // Simulasi proses bayar & menuju Bukti Transaksi
            setState(() => _currentStep = 3);
          },
        ),
      ],
    );
  }

  // ===========================================================================
  // TAHAP 4: BUKTI TRANSAKSI (BERHASIL SESUAI FIGMA)
  // ===========================================================================
  Widget _buildReceiptSuccessView() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ikon Centang Lingkaran Biru
            Container(
              width: 76,
              height: 76,
              decoration: const BoxDecoration(
                color: Color(0xFF1E88E5),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_rounded,
                size: 46,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 18),

            const Text(
              'Transaksi Berhasil!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Pembayaran sewa kos telah diverifikasi oleh sistem',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12.5, color: Colors.grey.shade600),
            ),

            const SizedBox(height: 24),

            // Kartu Struk Transaksi
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildDetailRow('No. Transaksi', 'TRX-AK-20261030-88'),
                  _buildDetailRow('Waktu', '30 Okt 2026, 21:26 WIB'),
                  _buildDetailRow('Kos', widget.kostData?['name'] ?? 'Kost Mahogani'),
                  _buildDetailRow('Metode', _selectedMethod),
                  const Divider(height: 22, color: Color(0xFFE2E8F0)),
                  _buildDetailRow('Total Terbayar', 'Rp. 505.000', isTotal: true),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // Tombol Unduh Bukti Transaksi
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Bukti transaksi berhasil disimpan ke penyimpanan'),
                      backgroundColor: Color(0xFF1E88E5),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                icon: const Icon(Icons.download_rounded, color: Color(0xFF1E88E5)),
                label: const Text(
                  'Unduh Bukti Transaksi',
                  style: TextStyle(
                    color: Color(0xFF1E88E5),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF1E88E5), width: 1.4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Tombol Kembali ke Beranda
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const MainScreen()),
                    (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E88E5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Kembali ke Beranda',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // WIDGET HELPER
  // ===========================================================================
  Widget _buildVisualCard({
    required Gradient gradient,
    required String typeLabel,
  }) {
    final rawNumber = _cardNumberController.text.replaceAll(' ', '');
    final displayNum = rawNumber.isEmpty
        ? '•••• •••• •••• ••••'
        : _formatCardNumberPreview(rawNumber);
    final displayName = _cardHolderController.text.isEmpty
        ? 'NAMA PEMEGANG'
        : _cardHolderController.text.toUpperCase();
    final displayExp = _cardExpiryController.text.isEmpty
        ? 'MM/YY'
        : _cardExpiryController.text;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.18),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                typeLabel,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const Icon(Icons.wifi, color: Colors.white70, size: 20),
            ],
          ),
          Row(
            children: [
              Container(
                width: 38,
                height: 26,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFD54F),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
          Text(
            displayNum,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  displayName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                displayExp,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatCardNumberPreview(String text) {
    var buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 4 == 0 && nonZeroIndex != text.length) {
        buffer.write(' ');
      }
    }
    return buffer.toString();
  }

  Widget _buildInputLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildCardTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    List<TextInputFormatter>? inputFormatters,
    ValueChanged<String>? onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFCBD5E1)),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        inputFormatters: inputFormatters,
        onChanged: onChanged,
        style: const TextStyle(fontSize: 14, color: Colors.black87),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> rows) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(children: rows),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12.5,
              color: isTotal ? Colors.black87 : Colors.grey.shade600,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 14 : 12.5,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
              color: isTotal ? const Color(0xFF1E88E5) : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButton({
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 48,
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1E88E5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  void _showSnackbar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: const Color(0xFFE53935),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

// Formatter Spasi Nomor Kartu (4 digit spasi)
class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var text = newValue.text.replaceAll(' ', '');
    var buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 4 == 0 && nonZeroIndex != text.length) {
        buffer.write(' ');
      }
    }
    var string = buffer.toString();
    return newValue.copyWith(
      text: string,
      selection: TextSelection.collapsed(offset: string.length),
    );
  }
}

// Formatter Masa Berlaku Kartu (MM/YY)
class _CardExpiryFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var text = newValue.text.replaceAll('/', '');
    var buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      if (i == 1 && text.length > 2) {
        buffer.write('/');
      }
    }
    var string = buffer.toString();
    return newValue.copyWith(
      text: string,
      selection: TextSelection.collapsed(offset: string.length),
    );
  }
}