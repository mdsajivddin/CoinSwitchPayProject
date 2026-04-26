import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Clipboard ke liye
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:payment_app/Screen/depositeUSDDetails.page.dart';
import 'package:payment_app/config/utils/showMessage.dart';
import 'package:payment_app/data/controller/cancelINRDepositeController.dart';
import 'package:payment_app/data/controller/getBuyInrDepositeController.dart';
import 'package:payment_app/data/controller/submitINRDepositeControler.dart';

class OrderDetailsPage extends ConsumerStatefulWidget {
  final String amount;
  final String percentage;
  final String id;
  final String upiId;
  final String name;
  final int remainingSeconds;

  const OrderDetailsPage({
    super.key,
    required this.amount,
    required this.percentage,
    required this.id,
    required this.upiId,
    required this.name,
    required this.remainingSeconds,
  });

  @override
  ConsumerState<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends ConsumerState<OrderDetailsPage> {
  final utrController = TextEditingController();
  final pinController = TextEditingController();
  final hasController = TextEditingController();

  // 🔹 New Field for Image
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Timer? _timer;
  late int _remainingSeconds;
  @override
  void initState() {
    super.initState();

    _remainingSeconds = widget.remainingSeconds;

    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;

      if (_remainingSeconds <= 0) {
        timer.cancel();
        _showExpireDialog();
      } else {
        setState(() {
          _remainingSeconds--;
        });
      }
    });
  }

  String formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final sec = (seconds % 60).toString().padLeft(2, '0');

    return "$minutes:$sec";
  }

  // 🔹 Function to pick image
  Future<void> _pickScreenshot() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 800,
    );
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
      ShowMessage.success(context, "Screenshot selected successfully!");
    }
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
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: Text(
                      "BACK TO Deposite LIST",
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

  @override
  void dispose() {
    _timer?.cancel();
    pinController.dispose();
    super.dispose();
  }

  void showLeaveDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Consumer(
          builder: (context, ref, _) {
            final cancelINRDepositeState = ref.watch(cancelINRDepositeProvider);

            return Dialog(
              backgroundColor: const Color(0xFF0F1B2A),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color(0xFF0F1B2A),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Title
                    const Text(
                      "Leave this page?",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 10),

                    /// Subtitle
                    const Text(
                      "Your deposit will be cancelled if you leave.",
                      style: TextStyle(fontSize: 14, color: Color(0xFF9CA3AF)),
                    ),

                    const SizedBox(height: 25),

                    /// Buttons
                    Row(
                      children: [
                        /// Stay Button
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              height: 45,
                              decoration: BoxDecoration(
                                color: const Color(0xFF2A3646),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Center(
                                child: Text(
                                  "Stay",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        /// Leave Button
                        Expanded(
                          child: GestureDetector(
                            onTap:
                                cancelINRDepositeState is AsyncLoading
                                    ? null
                                    : () async {
                                      final result = await ref
                                          .read(
                                            cancelINRDepositeProvider.notifier,
                                          )
                                          .cancelINRDeposite(
                                            context: context,
                                            depositId: widget.id,
                                          );
                                      if (result == true) {
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      }
                                    },
                            child: Container(
                              height: 45,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFF4B4B),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child:
                                    cancelINRDepositeState is AsyncLoading
                                        ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        )
                                        : const Text(
                                          "Leave",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double amount = double.tryParse(widget.amount) ?? 0;
    final double percentage = double.tryParse(widget.percentage) ?? 0;

    final int quota = ((amount * percentage) / 100).round();
    final int totalquota = (amount + quota).round();

    final submitINRState = ref.watch(submiteINRDepositeProvider);
    final cancelINRDepositeState = ref.watch(cancelINRDepositeProvider);

    // Is logic ko reuse karne ke liye function bana lo
    void handleCancel() async {
      ref
          .read(cancelINRDepositeProvider.notifier)
          .cancelINRDeposite(context: context, depositId: widget.id);
      Navigator.of(context).pop();
    }

    return PopScope(
      canPop: false, // Hum manual control le rahe hain
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        // ref
        //     .read(cancelINRDepositeProvider.notifier)
        //     .cancelINRDeposite(context: context, depositId: widget.id);
        showLeaveDialog();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF09111C),
        body: Stack(
          children: [
            /// 🔹 Background Gradient
            Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(-0.9, -0.9),
                  radius: 1.5,
                  colors: [Color(0xFF1A2A3A), Color(0xFF09111C)],
                ),
              ),
            ),

            SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  children: [
                    SizedBox(height: 15.h),

                    /// 🔹 Top Bar
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            showLeaveDialog();
                          },
                          borderRadius: BorderRadius.circular(50.r),
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 22.sp,
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Text(
                          "Order Details",
                          style: GoogleFonts.poppins(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        const Spacer(),
                        _buildTimerBadge(), // Timer yahan display ho raha hai
                      ],
                    ),

                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 25.h),

                            /// 🔹 Order Summary Card
                            glassCard(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.receipt_long,
                                        color: const Color(0xFF06CE8F),
                                        size: 20.sp,
                                      ),
                                      SizedBox(width: 8.w),
                                      Text(
                                        "Order Summary",
                                        style: GoogleFonts.poppins(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 15.h),
                                  infoRow("Order Amount:", "₹${widget.amount}"),
                                  infoRow(
                                    "Percentage:",
                                    "${widget.percentage}%",
                                    highlight: true,
                                  ),
                                  infoRow(
                                    "Total Quota:",
                                    "+₹$totalquota",
                                    highlight: true,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 12.h,
                                    ),
                                    child: Divider(
                                      color: Colors.white10,
                                      thickness: 1.h,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          // "Order ID: ${widget.id}",
                                          "Order ID: ${(widget.id.length > 8 ? widget.id.substring(widget.id.length - 8) : widget.id).toUpperCase()}",
                                          style: GoogleFonts.poppins(
                                            fontSize: 11.sp,
                                            color: const Color(0xFF9CA3AF),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        "Pending Payment",
                                        style: GoogleFonts.poppins(
                                          fontSize: 11.sp,
                                          color: Colors.orange,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: 20.h),

                            /// 🔹 Payment Details Card (UPI Copy Logic)
                            glassCard(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Payment Details",
                                    style: GoogleFonts.poppins(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 12.h),
                                  Text(
                                    "RECEIVER NAME",
                                    style: GoogleFonts.poppins(
                                      fontSize: 12.sp,
                                      color: const Color(0xFF9CA3AF),
                                    ),
                                  ),
                                  Text(
                                    "${widget.name}",
                                    style: GoogleFonts.poppins(
                                      fontSize: 12.sp,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  Divider(color: Colors.white12),
                                  SizedBox(height: 8.h),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "${widget.upiId}",
                                          style: GoogleFonts.poppins(
                                            fontSize: 13.sp,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),

                                      // 🔹 Copy Button Functionality
                                      InkWell(
                                        onTap: () {
                                          Clipboard.setData(
                                            ClipboardData(text: widget.upiId),
                                          );
                                          ShowMessage.success(
                                            context,
                                            "UPI ID Copied to Clipboard!",
                                          );
                                        },
                                        child: miniBlueButton("Copy"),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: 20.h),

                            /// 🔹 Important Note Box
                            Container(
                              padding: EdgeInsets.only(
                                left: 16.w,
                                top: 16.h,
                                bottom: 16.h,
                                right: 12.w,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.orange.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(16.r),
                                border: Border.all(
                                  color: Colors.orange.withOpacity(0.2),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "IMPORTANT GUIDE (INR)",
                                    style: GoogleFonts.poppins(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  SizedBox(height: 10.h),
                                  bullet(
                                    "Verify UPI ID & receiver name before payment",
                                  ),
                                  bullet(
                                    "Confirmation usually takes 5-10 minutes",
                                  ),
                                  bullet("You can pay using any UPI app"),
                                  bullet("Send the exact order amount only"),
                                  bullet(
                                    "Tokens will be credited after successful payment",
                                  ),
                                  SizedBox(height: 8.h),
                                  Divider(
                                    color: Colors.orange.withOpacity(0.2),
                                  ),
                                  SizedBox(height: 8.h),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.warning,
                                        color: Colors.orange,
                                        size: 13.sp,
                                      ),
                                      Expanded(
                                        child: Text(
                                          "Double-check all details. Transactions are non-reversible",
                                          style: GoogleFonts.poppins(
                                            fontSize: 10.sp,
                                            color: Colors.orange,
                                            height: 1,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: 20.h),
                            buildLabel("Enter UTR / Transaction ID"),
                            SizedBox(height: 8.h),

                            /// 🔹 UTR Field
                            TextField(
                              controller: utrController,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.sp,
                              ),
                              keyboardType: TextInputType.number,
                              maxLength: 12,
                              decoration: InputDecoration(
                                counterText: "",
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.05),
                                hintText: "Enter 12-digit UTR",
                                isDense: true,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                  borderSide: BorderSide(
                                    color: Colors.white.withOpacity(0.1),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                  borderSide: BorderSide(
                                    color: Colors.white.withOpacity(0.1),
                                  ),
                                ),
                                hintStyle: TextStyle(
                                  color: const Color(0xFF6B7280),
                                  fontSize: 13.sp,
                                ),
                              ),
                            ),

                            // SizedBox(height: 15.h),
                            /// 🔹 UTR Field
                            // buildLabel("Enter has"),
                            // SizedBox(height: 8.h),
                            // glassField(
                            //   child: TextField(
                            //     controller: hasController,
                            //     style: TextStyle(
                            //       color: Colors.white,
                            //       fontSize: 14.sp,
                            //     ),
                            //     decoration: InputDecoration(
                            //       hintText: "Enter has",
                            //       isDense: true,
                            //       border: InputBorder.none,
                            //       hintStyle: TextStyle(
                            //         color: const Color(0xFF6B7280),
                            //         fontSize: 13.sp,
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            SizedBox(height: 15.h),

                            buildLabel("Upload Payment Screenshot"),
                            SizedBox(height: 6.h),
                            GestureDetector(
                              onTap: _pickScreenshot,
                              child: Container(
                                height: 55.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.r),
                                  border: Border.all(
                                    color: const Color(
                                      0xFF06CE8F,
                                    ).withOpacity(0.5),
                                  ),
                                  color:
                                      _selectedImage != null
                                          ? const Color(
                                            0xFF06CE8F,
                                          ).withOpacity(0.1)
                                          : Colors.white.withOpacity(0.05),
                                ),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        _selectedImage != null
                                            ? Icons.check_circle
                                            : Icons.cloud_upload_outlined,
                                        size: 18.sp,
                                        color: const Color(0xFF06CE8F),
                                      ),
                                      SizedBox(width: 8.w),
                                      Text(
                                        _selectedImage != null
                                            ? "Screenshot Added"
                                            : "Upload Screenshot",
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 13.sp,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: 15.h),

                            /// 🔹 PIN Field
                            buildLabel("Enter Transaction Pin"),
                            SizedBox(height: 8.h),
                            glassField(
                              child: TextField(
                                controller: pinController,
                                keyboardType: TextInputType.number,
                                maxLength: 6,
                                obscureText: true,
                                style: const TextStyle(
                                  color: Colors.white,
                                  letterSpacing: 5,
                                ),
                                decoration: InputDecoration(
                                  counterText: "",
                                  hintText: "••••••",
                                  isDense: true,
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(
                                    color: const Color(0xFF6B7280),
                                    fontSize: 13.sp,
                                    letterSpacing: 2,
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: 25.h),

                            /// 🔹 Confirm Button
                            //gradientButton("Confirm Payment"),\
                            Row(
                              children: [
                                Expanded(
                                  child: InkWell(
                                    onTap: showLeaveDialog,
                                    child: Container(
                                      height: 50.h,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          12.r,
                                        ),
                                        border: Border.all(
                                          color: Colors.white.withOpacity(0.2),
                                        ),
                                        color: Colors.white.withOpacity(0.05),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "Cancel",
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15.sp,
                                            color: Colors.white70,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: InkWell(
                                    onTap:
                                        submitINRState.isLoading
                                            ? null
                                            : () {
                                              if (pinController.text.isEmpty ||
                                                  _selectedImage == null) {
                                                ShowMessage.error(
                                                  context,
                                                  "Please fill all fields and upload screenshot",
                                                );
                                                return;
                                              }
                                              ref
                                                  .read(
                                                    submiteINRDepositeProvider
                                                        .notifier,
                                                  )
                                                  .submitINRDeposite(
                                                    context: context,
                                                    UTR:
                                                        utrController.text
                                                            .trim(),
                                                    depositId: widget.id,
                                                    screenshot: _selectedImage!,
                                                    pin:
                                                        pinController.text
                                                            .trim(),
                                                    rate: widget.percentage,
                                                    realAmount: widget.amount,
                                                    upi: widget.upiId,
                                                    upiHolder: widget.name,
                                                  );
                                            },
                                    child: Container(
                                      height: 50.h,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          12.r,
                                        ),
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color(0xFF06CE8F),
                                            Color(0xFF05B47A),
                                          ],
                                        ),
                                      ),
                                      child: Center(
                                        child:
                                            submitINRState.isLoading
                                                ? SizedBox(
                                                  width: 20,
                                                  height: 20,
                                                  child: Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                          color: Colors.white,
                                                        ),
                                                  ),
                                                )
                                                : Text(
                                                  "Confirm Payment",
                                                  style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 15.sp,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 15.h),

                            Center(
                              child: Text(
                                "Waiting for Verification...",
                                style: GoogleFonts.poppins(
                                  fontSize: 11.sp,
                                  color: const Color(0xFF9CA3AF),
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
            ),
          ],
        ),
        bottomNavigationBar: CustomBottomBar(currentIndex: 2),
      ),
    );
  }

  Widget _buildTimerBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.red.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.timer_outlined, size: 14.sp, color: Colors.red),
          SizedBox(width: 6.w),
          Text(
            formatTime(_remainingSeconds),
            style: GoogleFonts.poppins(
              color: Colors.red,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget glassCard({required Widget child}) {
    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: child,
    );
  }

  Widget infoRow(String title, String value, {bool highlight = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              color: const Color(0xFF9CA3AF),
              fontSize: 12.sp,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              color: highlight ? const Color(0xFF06CE8F) : Colors.white,
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        color: Colors.white70,
        fontSize: 12.sp,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget glassField({required Widget child}) {
    return Container(
      height: 48.h,
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      alignment: Alignment.center,
      child: child,
    );
  }

  Widget gradientButton(String text, {bool isOutline = false}) {
    return Container(
      height: 48.h,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        gradient:
            isOutline
                ? null
                : const LinearGradient(
                  colors: [Color(0xFF4F6EF7), Color(0xFF3458D4)],
                ),
        color: isOutline ? Colors.white.withOpacity(0.05) : null,
        border:
            isOutline
                ? Border.all(color: const Color(0xFF4F6EF7).withOpacity(0.5))
                : null,
        boxShadow:
            isOutline
                ? null
                : [
                  BoxShadow(
                    color: const Color(0xFF4F6EF7).withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
      ),
      child: Center(
        child: Text(
          text,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget miniBlueButton(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        color: const Color(0xFF06CE8F),
      ),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 11.sp,
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget bullet(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 6.h),
            child: Icon(Icons.circle, size: 5.sp, color: Colors.orange),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 11.5.sp,
                color: Colors.white70,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
