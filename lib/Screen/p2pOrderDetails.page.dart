import 'dart:async';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:payment_app/Screen/depositeUSDDetails.page.dart';
import 'package:payment_app/Screen/home.page.dart';
import 'package:payment_app/Screen/p2pUpiPayment.page.dart';
import 'package:payment_app/config/auth/router/rightsliderFageRoute.dart';
import 'package:payment_app/config/network/api.network.dart';
import 'package:payment_app/config/utils/pretty.dio.dart';
import 'package:payment_app/config/utils/showMessage.dart';
import 'package:payment_app/data/controller/buyP2pDetailsController.dart';
import 'package:payment_app/data/controller/getP2pExitBuyController.dart';
import 'package:payment_app/data/model/cancelP2pTransactionBodyModel.dart';
import 'package:payment_app/data/model/cancelUSDTDepositeBodyMOdel.dart';
import 'package:socket_io_client/socket_io_client.dart';

class P2POrderDetailPage extends ConsumerStatefulWidget {
  final String id;

  const P2POrderDetailPage({super.key, required this.id});

  @override
  ConsumerState<P2POrderDetailPage> createState() => _P2POrderDetailPageState();
}

class _P2POrderDetailPageState extends ConsumerState<P2POrderDetailPage> {
  int _selectedPayment = 0;
  bool _cancelLoading = false;
  String? _currentOrderId;

  Timer? _timer;
  int _remainingSeconds = 0;
  bool _dialogShown = false;
  bool _countdownStarted = false;

  void startCountdown(int expiresAt) {
    if (expiresAt.toString().length == 10) {
      expiresAt = expiresAt * 1000;
    }

    final expiryTime = DateTime.fromMillisecondsSinceEpoch(expiresAt);

    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;

      final now = DateTime.now();
      final remaining = expiryTime.difference(now).inSeconds;

      if (remaining > 0) {
        setState(() {
          _remainingSeconds = remaining;
        });
      } else {
        timer.cancel();
        if (!_dialogShown) {
          _dialogShown = true;
          _showExpireDialog();
        }
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
                      Navigator.pop(context);
                      Navigator.pop(context);
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
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _timer?.cancel();
    _remainingSeconds = 0;
    _dialogShown = false;
    _countdownStarted = false;
    Future.microtask(() {
      ref
          .read(p2pTransactionDetailsProvider.notifier)
          .getP2pDetail(id: widget.id, type: "BUY");
    });
  }

  void _showCancelDialog(String id) {
    showDialog(
      context: context,
      barrierDismissible: !_cancelLoading,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return Dialog(
              backgroundColor: const Color(0xFF0F1B2A),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Leave this page?",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      "If you leave this page, your P2P order will be cancelled automatically. Are you sure you want to continue?",
                      style: TextStyle(fontSize: 14, color: Color(0xFF9CA3AF)),
                    ),

                    const SizedBox(height: 25),

                    Row(
                      children: [
                        /// Stay
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

                        /// Leave
                        Expanded(
                          child: GestureDetector(
                            onTap:
                                _cancelLoading
                                    ? null
                                    : () async {
                                      setStateDialog(() {
                                        _cancelLoading = true;
                                      });

                                      try {
                                        final body =
                                            CancelP2pTransactionBodyModel(
                                              id: id.toString(),
                                            );

                                        final service = ApiNetwork(createDio());

                                        final response = await service
                                            .cancelP2pTransation(body);

                                        if (response.code == 0 &&
                                            response.error == false) {
                                          ref
                                              .read(
                                                getP2pExitBuyProvider.notifier,
                                              )
                                              .getP2pExiteBuy("BUY");
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                          ShowMessage.success(
                                            context,
                                            response.message ?? "",
                                          );
                                        } else {
                                          ShowMessage.error(
                                            context,
                                            response.message ?? "",
                                          );
                                        }
                                      } catch (e, st) {
                                        log(e.toString());
                                        log(st.toString());

                                        ShowMessage.error(
                                          context,
                                          " Something went wrong",
                                        );

                                        setStateDialog(() {
                                          _cancelLoading = false;
                                        });
                                      } finally {
                                        setStateDialog(() {
                                          _cancelLoading = false;
                                        });
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
                                    _cancelLoading
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
    final buyP2pDetailState = ref.watch(p2pTransactionDetailsProvider);

    return WillPopScope(
      onWillPop: () async {
        final data = ref.read(p2pTransactionDetailsProvider).value;
        if (data != null && data.data != null) {
          _showCancelDialog(data.data!.id.toString());
        }
        return false;
      },
      child: Scaffold(
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
                  _buildAppBar(context),

                  Expanded(
                    child: buyP2pDetailState.when(
                      data: (data) {
                        if (data == null || data.data == null) {
                          return const Center(
                            child: Text(
                              "No Data Found",
                              style: TextStyle(color: Colors.white),
                            ),
                          );
                        }

                        final snap = data.data!;

                        /// ONLY RUN WHEN ID CHANGES
                        if (_currentOrderId != snap.id) {
                          _currentOrderId = snap.id;

                          /// RESET STATES
                          _dialogShown = false;
                          _remainingSeconds = 0;

                          /// START NEW TIMER
                          if (snap.expiresAt != null) {
                            startCountdown(snap.expiresAt!);
                          }
                        }
                        final paymentMethods = snap.paymentMethods ?? [];
                        final double rate = snap.rate?.toDouble() ?? 0.0;
                        final double amount = snap.amount?.toDouble() ?? 0.0;
                        final double totalPayment = rate * amount;

                        return SingleChildScrollView(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 10.h),
                              // Trader Info Card
                              _buildTraderHeader(
                                snap.name ?? "Unknown",
                                rate.toStringAsFixed(1),
                                amount.toStringAsFixed(0),
                                snap.walletType ?? "",
                              ),

                              SizedBox(height: 24.h),

                              Container(
                                padding: EdgeInsets.all(16.w),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF0F1B2E),
                                  borderRadius: BorderRadius.circular(18.r),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.08),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Fixed Order",
                                      style: GoogleFonts.poppins(
                                        color: const Color(0xFF9CA3AF),
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: 10.h),
                                    _buildAmountInput(
                                      "₹ ${totalPayment.toStringAsFixed(0)}",
                                      // snap.walletType ?? "",
                                      "",
                                    ),

                                    SizedBox(height: 24.h),

                                    Text(
                                      "Select Payment Method",
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(height: 12.h),

                                    // Payment Methods List - improved display logic
                                    ListView.separated(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: paymentMethods.length,
                                      separatorBuilder:
                                          (context, index) =>
                                              SizedBox(height: 12.h),
                                      itemBuilder: (context, index) {
                                        final method = paymentMethods[index];
                                        final methodType =
                                            method.methodType ?? "OTHER";

                                        // Decide what to show in subtitle based on type
                                        String subtitle =
                                            "Details not available";

                                        if (methodType.toUpperCase() == "UPI") {
                                          subtitle =
                                              method.details?.upiId ??
                                              method.details?.upiId ??
                                              "UPI ID not found";
                                        } else if (methodType.toUpperCase() ==
                                            "BANK_TRANSFER") {
                                          final details = method.details;
                                          if (details != null &&
                                              details.accountNumber != null) {
                                            subtitle =
                                                "${details.accountNumber} • ${details.ifsc ?? 'IFSC N/A'}";
                                          } else {
                                            subtitle =
                                                method.label ??
                                                "Bank details not available";
                                          }
                                        } else {
                                          subtitle =
                                              method.label ??
                                              method.details?.toString() ??
                                              "Other method";
                                        }

                                        return _buildPaymentOption(
                                          index: index,
                                          title:
                                              methodType == "UPI"
                                                  ? "UPI"
                                                  : "Bank Transfer",
                                          subtitle: subtitle,
                                          icon:
                                              methodType == "UPI"
                                                  ? Icons.qr_code_scanner
                                                  : Icons.account_balance,
                                          label: method.label ?? "",
                                        );
                                      },
                                    ),

                                    SizedBox(height: 30.h),

                                    // Summary Card
                                    _buildSummaryCard(
                                      totalPayment.toStringAsFixed(2),
                                    ),

                                    SizedBox(height: 25.h),

                                    // Action Button
                                    Container(
                                      width: double.infinity,
                                      height: 56.h,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          16.r,
                                        ),
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color(0xFF06CE8F),
                                            Color(0xFF05B47A),
                                          ],
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(
                                              0xFF06CE8F,
                                            ).withOpacity(0.3),
                                            blurRadius: 15,
                                            offset: const Offset(0, 8),
                                          ),
                                        ],
                                      ),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          final selectedMethod =
                                              paymentMethods[_selectedPayment];
                                          final details =
                                              selectedMethod.details;

                                          final bool isBank =
                                              (selectedMethod.methodType ?? "")
                                                  .toUpperCase() ==
                                              "BANK_TRANSFER";

                                          final methodId =
                                              selectedMethod.id ??
                                              selectedMethod.id;

                                          Navigator.push(
                                            context,
                                            RightSlideFadeRoute(
                                              page: P2pUpiPaymentPage(
                                                merchantName:
                                                    snap.name ?? "Unknown",
                                                totalAmount: (snap.amount ?? 0)
                                                    .toStringAsFixed(2),
                                                assetAmount: amount
                                                    .toStringAsFixed(2),
                                                assetType:
                                                    snap.walletType ?? "USDT",
                                                rate: (snap.rate ?? 0)
                                                    .toStringAsFixed(2),
                                                depositeId: snap.id ?? "",
                                                accountHolder:
                                                    details
                                                        ?.accountHolderName ??
                                                    selectedMethod.label ??
                                                    "N/A",
                                                remainingSeconds:
                                                    _remainingSeconds,
                                                methodType:
                                                    selectedMethod.methodType ??
                                                    "UPI",
                                                upiId:
                                                    isBank
                                                        ? null
                                                        : details?.upiId,
                                                bankName: details?.bankName,
                                                accountNumber:
                                                    details?.accountNumber,
                                                ifsc: details?.ifsc,
                                                branchName: details?.branchName,
                                                methodId: methodId.toString(),
                                              ),
                                            ),
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.transparent,
                                          shadowColor: Colors.transparent,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              16.r,
                                            ),
                                          ),
                                        ),
                                        child: Text(
                                          "Proceed To Buy",
                                          style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.sp,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 20.h),
                                    Container(
                                      width: double.infinity,
                                      height: 50,
                                      child: OutlinedButton(
                                        onPressed: () {
                                          _showCancelDialog(snap.id.toString());
                                        },
                                        style: OutlinedButton.styleFrom(
                                          side: const BorderSide(
                                            color: Colors.red,
                                            width: 1.5,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              14,
                                            ),
                                          ),
                                        ),
                                        child: const Text(
                                          "Cancel Order",
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 16.h),
                                    Center(
                                      child: Text(
                                        "Complete within the timer to avoid cancellation.",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.poppins(
                                          color: const Color(0xFF6B7280),
                                          fontSize: 11.sp,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20.h),
                            ],
                          ),
                        );
                      },
                      error:
                          (error, _) => Center(
                            child: Text(
                              error.toString(),
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                      loading:
                          () => const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFF06CE8F),
                            ),
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: CustomBottomBar(
          currentIndex: 1, // Deposit selected
        ),
      ),
    );
  }

  // ──────────────────────────────────────────────
  //  The rest of your methods remain the same
  // ──────────────────────────────────────────────

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              final data = ref.read(p2pTransactionDetailsProvider).value;

              if (data != null && data.data != null) {
                _showCancelDialog(data.data!.id.toString());
              }
            },
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
          ),
          Text(
            "P2P Order Detail",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          Spacer(),
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

  Widget _buildTraderHeader(
    String name,
    String rate,
    String amount,
    String type,
  ) {
    final double total =
        (double.tryParse(rate) ?? 0) * (double.tryParse(amount) ?? 0);

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF0F1B2E),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// TOP ROW (Avatar + Name + Verified)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 18.r,
                backgroundColor: const Color(0xFF06CE8F).withOpacity(0.15),
                child: Text(
                  name.isNotEmpty ? name[0].toUpperCase() : "U",
                  style: TextStyle(
                    color: const Color(0xFF06CE8F),
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                  ),
                ),
              ),
              SizedBox(width: 10.w),

              /// Name + Seller
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        name,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14.sp,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 3.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF06CE8F),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Text(
                          "VERIFIED",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 9.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "Seller: $name",
                    style: GoogleFonts.poppins(
                      color: Colors.white38,
                      fontSize: 11.sp,
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 16.h),

          /// BUYING ROW
          _infoRow("Buying", "$amount $type"),

          SizedBox(height: 8.h),

          /// RATE ROW
          _infoRow("Rate", "₹${rate}"),

          SizedBox(height: 8.h),

          /// TOTAL VALUE ROW (GREEN HIGHLIGHT)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total Value",
                style: GoogleFonts.poppins(
                  color: Colors.white54,
                  fontSize: 12.sp,
                ),
              ),
              Text(
                "₹${total.toStringAsFixed(2)}",
                style: GoogleFonts.poppins(
                  color: const Color(0xFF00E676),
                  fontWeight: FontWeight.w600,
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// COMMON ROW
  Widget _infoRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(color: Colors.white54, fontSize: 12.sp),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildAmountInput(String totalValue, String type) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 20.w),
      decoration: BoxDecoration(
        color: const Color(0xFF131C29).withOpacity(0.45),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            totalValue,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            type,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption({
    required int index,
    required String title,
    required String subtitle,
    required String label,
    required IconData icon,
  }) {
    bool isSelected = _selectedPayment == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedPayment = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? const Color(0xFF06CE8F).withOpacity(0.1)
                  : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color:
                isSelected
                    ? const Color(0xFF06CE8F)
                    : Colors.white.withOpacity(0.08),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? const Color(0xFF06CE8F) : Colors.white70,
              size: 24,
            ),
            SizedBox(width: 15.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14.sp,
                        ),
                      ),
                      // if (label.isNotEmpty)
                      //   Text(
                      //     " - $label",
                      //     style: GoogleFonts.poppins(
                      //       color: Colors.white,
                      //       fontWeight: FontWeight.w600,
                      //       fontSize: 14.sp,
                      //     ),
                      //   ),
                    ],
                  ),
                  // Text(
                  //   subtitle,
                  //   style: GoogleFonts.poppins(
                  //     color: const Color(0xFF9CA3AF),
                  //     fontSize: 12.sp,
                  //   ),
                  //   overflow: TextOverflow.ellipsis,
                  // ),
                ],
              ),
            ),
            Icon(
              isSelected ? Icons.check_circle : Icons.radio_button_off,
              color: isSelected ? const Color(0xFF06CE8F) : Colors.white24,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(String total) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Total payment",
            style: GoogleFonts.poppins(
              color: const Color(0xFF9CA3AF),
              fontSize: 14.sp,
            ),
          ),
          Text(
            "₹$total",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
