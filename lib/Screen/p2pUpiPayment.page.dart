import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:payment_app/config/utils/showMessage.dart';
import 'package:payment_app/data/controller/P2pPaidController.dart';
import 'package:payment_app/data/controller/getP2pExitBuyController.dart';

class P2pUpiPaymentPage extends ConsumerStatefulWidget {
  final String merchantName;
  final String totalAmount;
  final String assetAmount;
  final String assetType;
  final String rate;
  final String depositeId;
  final String accountHolder;
  final int remainingSeconds;
  final String methodId;

  // Payment method specific fields
  final String methodType; // "UPI" or "BANK_TRANSFER"
  final String? upiId;
  final String? bankName;
  final String? accountNumber;
  final String? ifsc;
  final String? branchName;

  const P2pUpiPaymentPage({
    super.key,
    required this.merchantName,
    required this.totalAmount,
    required this.assetAmount,
    required this.assetType,
    required this.rate,
    required this.depositeId,
    required this.accountHolder,
    required this.methodType,
    required this.remainingSeconds,
    this.upiId,
    this.bankName,
    this.accountNumber,
    this.ifsc,
    this.branchName,
    required this.methodId,
  });

  @override
  ConsumerState<P2pUpiPaymentPage> createState() => _P2pUpiPaymentPageState();
}

class _P2pUpiPaymentPageState extends ConsumerState<P2pUpiPaymentPage> {
  final TextEditingController _utrController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  bool get isUpi => (widget.methodType.toUpperCase() == "UPI");

  String get pageTitle =>
      isUpi ? "Complete UPI Payment" : "Complete Bank Transfer";
  String get payWithText => isUpi ? "Pay with UPI" : "Pay via Bank Transfer";
  String get instructionText =>
      isUpi
          ? "Open your UPI app (PhonePe, Google Pay, BHIM, etc.) and send ₹${widget.totalAmount} to the above UPI ID."
          : "Open your banking app / netbanking / branch and transfer ₹${widget.totalAmount} to the below account details. Mention correct reference / UTR.";

  String get utrLabel =>
      isUpi ? "Enter UTR / Transaction ID" : "Enter Reference / Transaction ID";
  String get utrHint =>
      isUpi
          ? "Enter 12-digit UTR number"
          : "Enter bank reference / transaction number";

  String get copyButtonText => isUpi ? "Copy UPI" : "Copy A/c No";

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 800,
    );
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  Timer? _timer;
  late int _remainingSeconds;

  @override
  void initState() {
    super.initState();

    _remainingSeconds = widget.remainingSeconds;

    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        timer.cancel();
        _showExpireDialog(); // 👈 dialog open hoga
      }
    });
  }

  void _showExpireDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: const Color(0xFF131721), // Dark Navy Background
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
            child: Column(
              mainAxisSize:
                  MainAxisSize.min, // Dialog size content ke hisab se rahega
              children: [
                // --- Red Clock Icon with Circle ---
                Container(
                  padding: EdgeInsets.all(12.r),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEF5350).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.access_time,
                    color: const Color(0xFFEF5350),
                    size: 35.sp,
                  ),
                ),
                SizedBox(height: 24.h),

                // --- Title ---
                Text(
                  "Payment Time Expired",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 12.h),

                // --- Subtitle Description ---
                Text(
                  "The 15-minute payment window has ended. This order has been automatically cancelled.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: Colors.white70,
                    fontSize: 13.sp,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 32.h),

                // --- Green Button ---
                SizedBox(
                  width: double.infinity, // Full width button
                  height: 48.h,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00C853), // Vibrant Green
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () {
                      ref
                          .read(getP2pExitBuyProvider.notifier)
                          .getP2pExiteBuy("BUY");
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    child: Text(
                      "BACK TO P2P LIST",
                      style: GoogleFonts.poppins(
                        color: Colors.black, // Dark text on green background
                        fontWeight: FontWeight.w700,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final remainingSeconds = (seconds % 60).toString().padLeft(2, '0');
    return "$minutes:$remainingSeconds";
  }

  @override
  void dispose() {
    _timer?.cancel();
    _utrController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p2pPaidState = ref.watch(p2pPaidProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF09111C),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(-0.9, -0.9),
                radius: 1.4,
                colors: [Color(0xFF1A2A3A), Color(0xFF09111C)],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                _buildHeader(context),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20.h),
                        _buildMerchantSection(),
                        SizedBox(height: 20.h),
                        _buildOrderSummary(),
                        SizedBox(height: 24.h),

                        Text(
                          payWithText,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 12.h),

                        _buildPaymentDetailsCard(),

                        SizedBox(height: 24.h),
                        _buildInstructions(),
                        SizedBox(height: 24.h),

                        // UTR/Reference field
                        _buildInputField(
                          label: utrLabel,
                          hint: utrHint,
                          controller: _utrController,
                          type: TextInputType.number,
                          mxLength: 12,
                          coutnerText: "",
                        ),

                        SizedBox(height: 16.h),

                        // PIN field
                        _buildInputField(
                          label: "Transaction PIN",
                          hint: "Enter your 6-digit PIN",
                          controller: _pinController,
                          isPassword: true,
                          mxLength: 6,
                          type: TextInputType.number,
                          coutnerText: "",
                        ),

                        SizedBox(height: 16.h),

                        _buildUploadSection(),

                        SizedBox(height: 32.h),

                        p2pPaidState.maybeWhen(
                          loading:
                              () => const Center(
                                child: CircularProgressIndicator(
                                  color: Color(0xFF06CE8F),
                                ),
                              ),
                          orElse: () => _buildPaidButton(context),
                        ),

                        SizedBox(height: 20.h),
                        Center(
                          child: Text(
                            "Complete payment within 15 minutes to avoid cancellation.",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              color: const Color(0xFF6B7280),
                              fontSize: 11.sp,
                            ),
                          ),
                        ),
                        SizedBox(height: 30.h),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
          ),
          Text(
            pageTitle,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: Colors.red.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                Icon(Icons.timer_outlined, size: 12.sp, color: Colors.red),
                SizedBox(width: 4.w),
                Text(
                  formatTime(_remainingSeconds),
                  style: GoogleFonts.poppins(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentDetailsCard() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child:
          isUpi
              ? Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: const Color(0xFF071A24),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: const Color(0xFF00D09C).withOpacity(0.4),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "PAY TO",
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF00D09C),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                      ),
                    ),

                    SizedBox(height: 14.h),
                    Row(
                      children: [
                        Container(
                          height: 40.h,
                          width: 40.w,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.06),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Icon(
                            Icons.phone_iphone,
                            color: Colors.white,
                            size: 20.sp,
                          ),
                        ),

                        SizedBox(width: 12.w),

                        // 🔹 Name + UPI
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Name: ${widget.accountHolder}",
                                style: GoogleFonts.poppins(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                "UPI • ${widget.upiId ?? "Not available"}",
                                style: GoogleFonts.poppins(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // 🔹 Copy Button
                        InkWell(
                          onTap: () {
                            if (widget.upiId != null) {
                              Clipboard.setData(
                                ClipboardData(text: widget.upiId!),
                              ).then((_) {
                                ShowMessage.success(context, "UPI ID copied");
                              });
                            }
                          },
                          borderRadius: BorderRadius.circular(10.r),
                          child: Container(
                            padding: EdgeInsets.all(8.sp),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.06),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Icon(
                              Icons.copy_rounded,
                              size: 18.sp,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
              : Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: const Color(0xFF071A24),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: const Color(0xFF00D09C).withOpacity(0.4),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// 🔹 PAY TO TITLE
                    Text(
                      "PAY TO",
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF00D09C),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                      ),
                    ),

                    SizedBox(height: 14.h),

                    /// 🔹 BANK NAME
                    _detailRow(
                      "BANK NAME",
                      widget.bankName ?? "—",
                      onCopy: () => _copy(widget.bankName, "Bank name copied"),
                    ),

                    _divider(),

                    /// 🔹 ACCOUNT NUMBER
                    _detailRow(
                      "ACCOUNT NUMBER",
                      widget.accountNumber ?? "—",
                      onCopy:
                          () => _copy(
                            widget.accountNumber,
                            "Account number copied",
                          ),
                    ),

                    _divider(),

                    /// 🔹 IFSC
                    _detailRow(
                      "IFSC CODE",
                      widget.ifsc ?? "—",
                      onCopy: () => _copy(widget.ifsc, "IFSC copied"),
                    ),

                    _divider(),

                    /// 🔹 BENEFICIARY NAME
                    _detailRow(
                      "BENEFICIARY NAME",
                      widget.accountHolder,
                      onCopy: () => _copy(widget.accountHolder, "Name copied"),
                    ),
                  ],
                ),
              ),
    );
  }

  Widget _detailRow(String title, String value, {VoidCallback? onCopy}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        children: [
          /// 🔹 Left Icon Box
          Container(
            height: 38.h,
            width: 38.w,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              Icons.account_balance,
              color: Color(0xFF00D09C),
              size: 18.sp,
            ),
          ),

          SizedBox(width: 12.w),

          /// 🔹 Text Section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          /// 🔹 Copy Button
          InkWell(
            onTap: onCopy,
            borderRadius: BorderRadius.circular(10.r),
            child: Container(
              padding: EdgeInsets.all(8.sp),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(Icons.copy_rounded, size: 18.sp, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4.h),
      height: 1,
      color: Colors.white.withOpacity(0.08),
    );
  }

  void _copy(String? text, String message) {
    if (text != null && text.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: text)).then((_) {
        ShowMessage.success(context, message);
      });
    }
  }

  Widget _buildInstructions() {
    return Text(
      "Submit Payment Proof",
      style: GoogleFonts.poppins(
        color: const Color(0xFF9CA3AF),
        fontSize: 13.sp,
        height: 1.5,
      ),
    );
  }

  // ──────────────────────────────────────────────
  // Your existing helper widgets (unchanged)
  // ──────────────────────────────────────────────

  Widget _buildMerchantSection() {
    return Row(
      children: [
        CircleAvatar(
          radius: 15.r,
          backgroundColor: Colors.white10,
          child: Text(
            widget.merchantName.isNotEmpty
                ? widget.merchantName[0].toUpperCase()
                : "M",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(width: 10.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  widget.merchantName,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(width: 4.w),
                const Icon(Icons.verified, color: Color(0xFF06CE8F), size: 14),
              ],
            ),
            Text(
              "P2P Trade Merchant",
              style: GoogleFonts.poppins(
                color: const Color(0xFF9CA3AF),
                fontSize: 11.sp,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOrderSummary() {
    String formatNumber(dynamic value) {
      final num? number = num.tryParse(value.toString());

      if (number == null) return "0";

      // agar decimal part nahi hai → int jaisa show karo
      if (number % 1 == 0) {
        return number.toInt().toString();
      } else {
        return number.toString(); // ya limit chahiye to toStringAsFixed(2)
      }
    }

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "ORDER SUMMERY",
            style: GoogleFonts.poppins(
              color: const Color(0xFF06CE8F),
              fontWeight: FontWeight.w700,
              fontSize: 12.sp,
            ),
          ),
          SizedBox(height: 10.h),
          _summaryRow(
            "Amount to Pay",
            "₹ ${widget.totalAmount}",
            isHighlight: true,
          ),
          const Divider(color: Colors.white10, height: 20),
          _summaryRow(
            "${widget.assetType} You Receive",
            "${widget.assetAmount} ${widget.assetType}",
          ),
          SizedBox(height: 10.h),
          // _summaryRow("Rate", "₹ ${widget.rate.toFixedString(1)} per ${widget.assetType}"),
          _summaryRow(
            "Rate",
            "₹ ${formatNumber(widget.rate)} per ${widget.assetType}",
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value, {bool isHighlight = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            color: const Color(0xFF9CA3AF),
            fontSize: 13.sp,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            color: isHighlight ? const Color(0xFF06CE8F) : Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: isHighlight ? 16.sp : 14.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildInputField({
    required String label,
    required String hint,
    required TextEditingController controller,
    TextInputType? type,
    int? mxLength,
    bool isPassword = false,
    final String? coutnerText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(color: Colors.white70, fontSize: 13.sp),
        ),
        SizedBox(height: 8.h),
        TextField(
          maxLength: mxLength,
          controller: controller,
          obscureText: isPassword,
          keyboardType: type,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            counterText: coutnerText,
            filled: true,
            fillColor: Colors.white.withOpacity(0.05),
            hintText: hint,
            hintStyle: TextStyle(color: Colors.white24, fontSize: 14.sp),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: Colors.white12),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: Color(0xFF06CE8F)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUploadSection() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 24.h),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.03),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color:
                _selectedImage != null
                    ? const Color(0xFF06CE8F)
                    : Colors.white10,
          ),
        ),
        child: Column(
          children: [
            if (_selectedImage != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: Image.file(
                  _selectedImage!,
                  height: 100.h,
                  width: 150.w,
                  fit: BoxFit.cover,
                ),
              )
            else ...[
              const Icon(
                CupertinoIcons.cloud_upload,
                color: Color(0xFF06CE8F),
                size: 32,
              ),
              SizedBox(height: 8.h),
              Text(
                "Attach Payment Screenshot",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                "Required for verification",
                style: GoogleFonts.poppins(
                  color: Colors.white24,
                  fontSize: 11.sp,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPaidButton(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 56.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        gradient: const LinearGradient(
          colors: [Color(0xFF06CE8F), Color(0xFF05B47A)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF06CE8F).withOpacity(0.35),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          if (_utrController.text.trim().isEmpty ||
              _pinController.text.trim().isEmpty ||
              _selectedImage == null) {
            ShowMessage.error(
              context,
              "Please fill all details and upload screenshot",
            );
            return;
          }
          ref
              .read(p2pPaidProvider.notifier)
              .p2pPaid(
                context: context,
                hash: _utrController.text.trim(),
                depositId: widget.depositeId,
                screenshot: _selectedImage!,
                pin: _pinController.text.trim(),
                methodId: widget.methodId.toString(),
              );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
        ),
        child: Text(
          "I HAVE PAID",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 16.sp,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }
}
