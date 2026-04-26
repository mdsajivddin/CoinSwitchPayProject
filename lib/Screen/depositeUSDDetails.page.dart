import 'dart:async';
import 'dart:io'; // Added for File
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart'; // Add this to pubspec.yaml
import 'package:payment_app/Screen/deposit.page.dart';
import 'package:payment_app/Screen/home.page.dart';
import 'package:payment_app/Screen/p2p.page.dart';
import 'package:payment_app/Screen/sell.page.dart';
import 'package:payment_app/Screen/wallet.page.dart';
import 'package:payment_app/config/auth/router/navigate.dart';
import 'package:payment_app/config/utils/showMessage.dart';
import 'package:payment_app/data/controller/cancelUSDTDepositeController.dart';
import 'package:payment_app/data/controller/submiteUSDTDepositeController.dart';
import 'package:qr_flutter/qr_flutter.dart';

class DepositUsdtDetailsPage extends ConsumerStatefulWidget {
  final String walletAddress;
  final String network;
  final String depositeId;
  final String amount;
  final int expireAt;
  const DepositUsdtDetailsPage({
    super.key,
    required this.walletAddress,
    required this.network,
    required this.depositeId,
    required this.amount,
    required this.expireAt,
  });

  @override
  ConsumerState<DepositUsdtDetailsPage> createState() =>
      _DepositUsdtDetailsPageState();
}

class _DepositUsdtDetailsPageState
    extends ConsumerState<DepositUsdtDetailsPage> {
  final hashController = TextEditingController();
  final pinController = TextEditingController();

  // 🔹 New Field for Image
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Timer? _timer;
  int _remainingSeconds = 900;
  bool _isDialogShown = false;

  void startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        if (mounted) {
          setState(() {
            _remainingSeconds--;
          });
        }
      } else {
        _timer?.cancel();

        if (!_isDialogShown) {
          _isDialogShown = true;
          _showExpireDialog();
        }
      }
    });
  }

  // 🔹 Function to pick image
  Future<void> _pickScreenshot() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
      ShowMessage.success(context, "Screenshot selected successfully!");
    }
  }

  @override
  void initState() {
    super.initState();

    final now = DateTime.now().millisecondsSinceEpoch;

    final difference = widget.expireAt - now;

    // convert to seconds
    _remainingSeconds = (difference / 1000).floor();

    // safety fallback
    if (_remainingSeconds <= 0 || _remainingSeconds > 900) {
      _remainingSeconds = 900; // start from 15 min
    }

    startCountdown();
  }

  String formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final remainingSeconds = (seconds % 60).toString().padLeft(2, '0');
    return "$minutes:$remainingSeconds";
  }

  void _showExpireDialog() {
    _timer?.cancel();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF131C29),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          title: Text(
            "Order Expired",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            "Time is over. This order has expired.",
            style: GoogleFonts.poppins(color: Colors.white70, fontSize: 13.sp),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF06CE8F),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              onPressed: () {
                Navigator.pop(context); // dialog close
                Navigator.pop(context); // page close
              },
              child: Text(
                "OK",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showCancelDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        final cancelState = ref.watch(cancelUSDTDepositeProvider);

        return AlertDialog(
          backgroundColor: const Color(0xFF131C29),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          title: Text(
            "Cancel Deposit",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            "Are you sure you want to cancel this deposit order?",
            style: GoogleFonts.poppins(color: Colors.white70, fontSize: 13.sp),
          ),
          actions: [
            /// NO BUTTON
            TextButton(
              onPressed:
                  cancelState is AsyncLoading
                      ? null
                      : () {
                        Navigator.pop(context);
                      },
              child: Text(
                "No",
                style: GoogleFonts.poppins(color: Colors.white70),
              ),
            ),

            /// YES CANCEL BUTTON
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              onPressed:
                  cancelState is AsyncLoading
                      ? null
                      : () {
                        ref
                            .read(cancelUSDTDepositeProvider.notifier)
                            .cancelUSDTDeposite(
                              context: context,
                              depositId: widget.depositeId,
                            );
                      },
              child:
                  cancelState is AsyncLoading
                      ? SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                      : Text(
                        "Yes Cancel",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    hashController.dispose();
    pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final submitState = ref.watch(submiteUSDTDepositeProvider);
    final cancelState = ref.watch(cancelUSDTDepositeProvider);

    void handleCancel() async {
      ref
          .read(cancelUSDTDepositeProvider.notifier)
          .cancelUSDTDeposite(context: context, depositId: widget.depositeId);
      Navigator.of(context).pop();
    }

    return PopScope(
      canPop: false, // Hum manual control le rahe hain
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        _showCancelDialog();
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 0,
            backgroundColor: const Color(0xFF09111C),
          ),
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
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    children: [
                      SizedBox(height: 15.h),

                      /// 🔹 Top Bar
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              _showCancelDialog();
                            },
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "Deposit USDT",
                            style: GoogleFonts.poppins(
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          const Spacer(),

                          /// 🔹 Timer
                          _buildTimerBadge(),
                        ],
                      ),

                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 20.h),

                              /// 🔹 Network & Amount Card
                              glassCard(
                                child: Column(
                                  children: [
                                    infoRow("Network:", widget.network),
                                    SizedBox(height: 12.h),
                                    infoRow(
                                      "Deposit Amount:",
                                      "${widget.amount} USDT",
                                      highlight: true,
                                    ),
                                    Divider(
                                      height: 25.h,
                                      color: Colors.white10,
                                    ),
                                    Text(
                                      "Please transfer exact amount. Do not include gas fees to ensure fast processing.",
                                      style: GoogleFonts.poppins(
                                        fontSize: 10.5.sp,
                                        color: const Color(0xFF9CA3AF),
                                        height: 1.4,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(height: 18.h),

                              /// 🔹 Wallet QR Card
                              _buildQRCard(widget.walletAddress),

                              SizedBox(height: 20.h),

                              /// 🔹 Transaction Hash Input
                              buildLabel("Transaction Hash"),
                              SizedBox(height: 6.h),
                              TextField(
                                controller: hashController,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13.sp,
                                ),
                                decoration: InputDecoration(
                                  hintText: "Enter TXID / Hash",
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.05),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                    borderSide: BorderSide(
                                      color: Colors.white.withOpacity(0.1),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                    borderSide: BorderSide(
                                      color: Colors.white.withOpacity(0.1),
                                    ),
                                  ),
                                  hintStyle: TextStyle(
                                    color: Color(0xFF6B7280),
                                  ),
                                ),
                              ),

                              SizedBox(height: 15.h),

                              /// 🔹 Upload Screenshot (Updated)
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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

                              /// 🔹 Transfer Pin Input
                              buildLabel("Enter Transfer Pin"),
                              SizedBox(height: 6.h),
                              TextField(
                                controller: pinController,
                                obscureText: true,
                                maxLength: 6,
                                keyboardType: TextInputType.number,
                                style: const TextStyle(
                                  color: Colors.white,
                                  letterSpacing: 5,
                                ),
                                decoration: InputDecoration(
                                  counterText: "",
                                  hintText: "••••••",
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.05),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                    borderSide: BorderSide(
                                      color: Colors.white.withOpacity(0.1),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                    borderSide: BorderSide(
                                      color: Colors.white.withOpacity(0.1),
                                    ),
                                  ),
                                  hintStyle: TextStyle(
                                    color: Color(0xFF6B7280),
                                    letterSpacing: 2,
                                  ),
                                ),
                              ),

                              SizedBox(height: 25.h),

                              /// 🔹 Buttons
                              Row(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      // onTap: handleCancel,
                                      onTap: _showCancelDialog,
                                      child: Container(
                                        height: 50.h,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            12.r,
                                          ),
                                          border: Border.all(
                                            color: Colors.white.withOpacity(
                                              0.2,
                                            ),
                                          ),
                                          color: Colors.white.withOpacity(0.05),
                                        ),
                                        child: Center(
                                          child:
                                              cancelState.isLoading
                                                  ? Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                          color: Colors.white,
                                                        ),
                                                  )
                                                  : Text(
                                                    "Cancel",
                                                    style: GoogleFonts.poppins(
                                                      fontWeight:
                                                          FontWeight.w600,
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
                                          submitState.isLoading
                                              ? null
                                              : () {
                                                if (hashController
                                                        .text
                                                        .isEmpty ||
                                                    pinController
                                                        .text
                                                        .isEmpty ||
                                                    _selectedImage == null) {
                                                  ShowMessage.error(
                                                    context,
                                                    "Please fill all fields and upload screenshot",
                                                  );
                                                  return;
                                                }
                                                ref
                                                    .read(
                                                      submiteUSDTDepositeProvider
                                                          .notifier,
                                                    )
                                                    .submitUSDTDeposite(
                                                      context: context,
                                                      hash:
                                                          hashController.text
                                                              .trim(),
                                                      depositId:
                                                          widget.depositeId,
                                                      screenshot:
                                                          _selectedImage!,
                                                      pin:
                                                          pinController.text
                                                              .trim(),
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
                                              submitState.isLoading
                                                  ? CircularProgressIndicator(
                                                    color: Colors.white,
                                                  )
                                                  : Text(
                                                    "Submit Deposit",
                                                    style: GoogleFonts.poppins(
                                                      fontWeight:
                                                          FontWeight.w600,
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

                              SizedBox(height: 20.h),
                              Center(
                                child: Text(
                                  "Waiting for deposit confirmation...",
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
          bottomNavigationBar: CustomBottomBar(
            currentIndex: 2, // Deposit selected
          ),
        ),
      ),
    );
  }

  // --- Helper UI Methods ---

  Widget _buildTimerBadge() {
    return Container(
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
            // formatTime(_remainingSeconds),
            formatTime(_remainingSeconds),
            style: GoogleFonts.poppins(
              fontSize: 11.sp,
              fontWeight: FontWeight.w500,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQRCard(String address) {
    return glassCard(
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Wallet Address",
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 15.h),
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: QrImageView(
              data: address,
              version: QrVersions.auto,
              size: 130.h,
            ),
          ),
          SizedBox(height: 18.h),
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Colors.white10),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    address,
                    style: GoogleFonts.poppins(
                      fontSize: 10.sp,
                      color: const Color(0xFF9CA3AF),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: address));
                    ShowMessage.success(context, "Address Copied");
                  },
                  child: Icon(
                    Icons.copy,
                    size: 16.sp,
                    color: const Color(0xFF06CE8F),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Same Helper Widgets
  Widget glassCard({required Widget child}) => Container(
    padding: EdgeInsets.all(16.w),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.04),
      borderRadius: BorderRadius.circular(16.r),
      border: Border.all(color: Colors.white.withOpacity(0.08)),
    ),
    child: child,
  );

  Widget buildLabel(String text) => Text(
    text,
    style: GoogleFonts.poppins(
      color: Colors.white70,
      fontSize: 12.sp,
      fontWeight: FontWeight.w500,
    ),
  );

  Widget glassField({required Widget child}) => Container(
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

  Widget infoRow(String title, String value, {bool highlight = false}) => Row(
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
  );
}

class CustomBottomBar extends StatelessWidget {
  final int currentIndex;

  const CustomBottomBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.h,
      margin: EdgeInsets.fromLTRB(14.w, 0, 14.w, 14.h),
      decoration: BoxDecoration(
        color: const Color(0xFF131B27).withOpacity(0.94),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: Colors.white.withOpacity(0.07), width: 0.8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.38),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: BottomNavigationBar(
            currentIndex: currentIndex,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedItemColor: const Color(0xFF06CE8F),
            unselectedItemColor: const Color(0xFF5A6677),
            selectedFontSize: 11.sp,
            unselectedFontSize: 11.sp,
            iconSize: 24.sp,
            selectedLabelStyle: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              height: 1.0,
            ),
            unselectedLabelStyle: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
              height: 1.0,
            ),
            onTap: (index) {
              navigateToMainScreen(context, index);
            },
            items: [
              const BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.house_fill),
                label: 'Home',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.swap_horiz_outlined),
                label: 'P2P',
              ),
              BottomNavigationBarItem(
                icon: _buildDepositIcon(false),
                activeIcon: _buildDepositIcon(true),
                label: 'Deposit',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.trending_up_outlined),
                label: 'Sell',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.wallet_outlined),
                label: 'Wallet',
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 🔥 Same premium deposit icon
  Widget _buildDepositIcon(bool isActive) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient:
            isActive
                ? const LinearGradient(
                  colors: [Color(0xFF06CE8F), Color(0xFF05B47A)],
                )
                : null,
      ),
      child: Icon(
        CupertinoIcons.plus,
        color: isActive ? Colors.white : const Color(0xFF5A6677),
      ),
    );
  }
}
