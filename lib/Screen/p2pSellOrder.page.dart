import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:payment_app/Screen/depositeUSDDetails.page.dart';
import 'package:payment_app/Screen/home.page.dart';
import 'package:payment_app/Screen/p2pBuySellTransationHistory.page.dart';
import 'package:payment_app/Screen/p2pWaitingPayment.page.dart';
import 'package:payment_app/config/auth/router/rightsliderFageRoute.dart';
import 'package:payment_app/config/network/api.network.dart';
import 'package:payment_app/config/utils/pretty.dio.dart';
import 'package:payment_app/config/utils/showMessage.dart';
import 'package:payment_app/data/controller/buyP2pDetailsController.dart';
import 'package:payment_app/data/controller/getP2pExitBuyController.dart';
import 'package:payment_app/data/controller/getp2pTrasationSellController.dart';
import 'package:payment_app/data/controller/p2pSaveSellRequestController.dart';
import 'package:payment_app/data/controller/sellP2pDetailsController.dart';
import 'package:payment_app/data/model/cancelP2pTransactionBodyModel.dart';
import 'package:payment_app/data/model/saveRequest.dart';

class P2PSellOrderPage extends ConsumerStatefulWidget {
  final String id;
  const P2PSellOrderPage({super.key, required this.id});

  @override
  ConsumerState<P2PSellOrderPage> createState() => _P2PSellOrderPageState();
}

class _P2PSellOrderPageState extends ConsumerState<P2PSellOrderPage> {
  int selectedMethodIndex = 0;

  // Controllers to capture input data
  final TextEditingController upiNameControlelr = TextEditingController();
  final TextEditingController upiIdController = TextEditingController();
  final TextEditingController accountHolderNameControlelr =
      TextEditingController();

  final accountNumberController = TextEditingController();
  final bankNameController = TextEditingController();
  final branchNameController = TextEditingController();
  final ifscController = TextEditingController();
  bool isSubmitting = false;
  bool _cancelLoading = false;
  String? _currentOrderId;

  Timer? _timer;
  int _remainingSeconds = 0;
  bool _dialogShown = false;
  bool _countdownStarted = false;

  // void startCountdown(int expiresAt) {
  //   /// FIX: detect seconds vs milliseconds
  //   if (expiresAt.toString().length == 10) {
  //     expiresAt = expiresAt * 1000;
  //   }
  //   final expiryTime = DateTime.fromMillisecondsSinceEpoch(expiresAt);
  //   final now = DateTime.now();
  //   _remainingSeconds = expiryTime.difference(now).inSeconds;
  //   if (_remainingSeconds < 0) {
  //     _remainingSeconds = 0;
  //   }
  //   _timer?.cancel();
  //   _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
  //     if (!mounted) return;
  //     if (_remainingSeconds > 0) {
  //       setState(() {
  //         _remainingSeconds--;
  //       });
  //     } else {
  //       timer.cancel();
  //       if (!_dialogShown) {
  //         _dialogShown = true;
  //         _showExpireDialog();
  //       }
  //     }
  //   });
  // }

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
                          .getP2pExiteBuy("SELL");
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: Text(
                      "BACK TO P2P LIST",
                      style: GoogleFonts.poppins(
                        color: Colors.black,
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
  void initState() {
    super.initState();
    _timer?.cancel();
    _remainingSeconds = 0;
    _dialogShown = false;
    _countdownStarted = false;
    Future.microtask(() {
      ref
          .read(p2pTransactionDetailsProvider.notifier)
          .getP2pDetail(id: widget.id, type: "SELL");
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
                                              .getP2pExiteBuy("SELL");
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
                                      } catch (e) {
                                        log(e.toString());

                                        ShowMessage.error(
                                          context,
                                          "Something went wrong",
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

  String formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final remainingSeconds = (seconds % 60).toString().padLeft(2, '0');
    return "$minutes:$remainingSeconds";
  }

  @override
  void dispose() {
    _timer?.cancel();
    upiNameControlelr.dispose();
    upiIdController.dispose();
    accountHolderNameControlelr.dispose();
    bankNameController.dispose();
    accountNumberController.dispose();
    ifscController.dispose();
    branchNameController.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final p2pSellDetailState = ref.watch(p2pTransactionDetailsProvider);

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
                  center: Alignment(-0.8, -0.8),
                  radius: 1.5,
                  colors: [Color(0xFF1A2A3A), Color(0xFF09111C)],
                ),
              ),
            ),
            SafeArea(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildAppBar(context),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: p2pSellDetailState.when(
                          data: (data) {
                            if (data == null || data.data == null) {
                              return const Center(
                                child: Text(
                                  "No Data Found",
                                  style: TextStyle(color: Colors.white),
                                ),
                              );
                            }
                            // final snap = data.data!;

                            // /// START COUNTDOWN USING expiresAt
                            // if (!_countdownStarted && snap.expiresAt != null) {
                            //   _countdownStarted = true;
                            //   startCountdown(snap.expiresAt!);
                            // }

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

                            final item = data.data!;
                            final double totalReceive =
                                (item.amount ?? 0) * (item.rate ?? 0);

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 12.h),
                                Container(
                                  padding: EdgeInsets.all(16.w),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.05),
                                    borderRadius: BorderRadius.circular(20.r),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.08),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildTraderCard(item.name ?? "Trader"),
                                      SizedBox(height: 20.h),
                                      _buildSummaryCard(
                                        amount:
                                            "${item.amount} ${item.walletType}",
                                        rate:
                                            "₹${item.rate} per ${item.walletType}",
                                        total:
                                            "₹${totalReceive.toStringAsFixed(2)}",
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 24.h),
                                Text(
                                  "Select where you want to receive INR",
                                  style: GoogleFonts.poppins(
                                    color: const Color(0xFF9CA3AF),
                                    fontSize: 13.sp,
                                  ),
                                ),
                                SizedBox(height: 12.h),
                                _buildPaymentToggle(),
                                SizedBox(height: 24.h),
                                if (selectedMethodIndex == 0) ...[
                                  _buildInputField(
                                    "Account Holder's Name",
                                    "Account Holder's Name",
                                    type: TextInputType.name,
                                    controller: accountHolderNameControlelr,
                                    validator: (value) {
                                      if (selectedMethodIndex == 0) {
                                        if (value == null ||
                                            value.trim().isEmpty) {
                                          return "Enter account holder name";
                                        }
                                        if (value.trim().length < 3) {
                                          return "Name must be at least 3 characters";
                                        }
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: 16.h),
                                  _buildInputField(
                                    "Enter Your UPI ID",
                                    "example@upi",
                                    controller: upiIdController,
                                    type: TextInputType.emailAddress,
                                    validator: (value) {
                                      if (selectedMethodIndex == 0) {
                                        // ✅ correct
                                        if (value == null ||
                                            value.trim().isEmpty) {
                                          return "Enter UPI ID";
                                        }
                                        if (!value.contains("@")) {
                                          return "Invalid UPI ID";
                                        }
                                      }
                                      return null;
                                    },
                                  ),
                                ]
                                // 🔥 Bank Fields
                                else ...[
                                  _buildInputField(
                                    "Bank Name",
                                    "Bank Name",
                                    controller: bankNameController,
                                    type: TextInputType.text,
                                    validator: (value) {
                                      if (selectedMethodIndex == 1) {
                                        if (value == null ||
                                            value.trim().isEmpty) {
                                          return "Enter bank name";
                                        }
                                        if (value.trim().length < 3) {
                                          return "Bank name must be at least 3 characters";
                                        }
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: 16.h),

                                  _buildInputField(
                                    "Account Number",
                                    "Account Number",
                                    controller: accountNumberController,
                                    type: TextInputType.number,
                                    validator: (value) {
                                      if (selectedMethodIndex == 1) {
                                        if (value == null ||
                                            value.trim().isEmpty) {
                                          return "Enter account number";
                                        }
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: 16.h),

                                  _buildInputField(
                                    "IFSC Code",
                                    "IFSC Code",
                                    controller: ifscController,
                                    textCapitalization:
                                        TextCapitalization.characters,

                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(
                                        11,
                                      ), // ✅ max 11
                                      FilteringTextInputFormatter.allow(
                                        RegExp("[A-Za-z0-9]"),
                                      ), // ✅ valid chars
                                    ],

                                    validator: (value) {
                                      if (selectedMethodIndex == 1) {
                                        if (value == null ||
                                            value.trim().isEmpty) {
                                          return "Enter IFSC Code";
                                        }
                                        if (value.trim().length != 11) {
                                          return "IFSC must be exactly 11 characters";
                                        }
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: 16.w),
                                  _buildInputField(
                                    "Branch Name",
                                    "Branch Name",
                                    type: TextInputType.text,
                                    controller: branchNameController,
                                    validator: (value) {
                                      if (selectedMethodIndex == 1) {
                                        if (value == null ||
                                            value.trim().isEmpty) {
                                          return "Enter Branch Name";
                                        }
                                        if (value.trim().length < 3) {
                                          return "Branch name must be at least 3 characters";
                                        }
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: 16.h),

                                  _buildInputField(
                                    "Account Holder's Name",
                                    "Account Holder's Name",
                                    controller: accountHolderNameControlelr,
                                    type: TextInputType.text,
                                    validator: (value) {
                                      if (selectedMethodIndex == 1) {
                                        if (value == null ||
                                            value.trim().isEmpty) {
                                          return "Enter Account Holder Name";
                                        }
                                        if (value.trim().length < 3) {
                                          return "Name must be at least 3 characters";
                                        }
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                                SizedBox(height: 40.h),
                                _buildConfirmButton(),
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
                                        borderRadius: BorderRadius.circular(14),
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
                                SizedBox(height: 20.h),
                              ],
                            );
                          },
                          error:
                              (error, stackTrace) => Center(
                                child: Text(
                                  "Error: $error",
                                  style: const TextStyle(color: Colors.red),
                                ),
                              ),
                          loading:
                              () => const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              ),
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
          currentIndex: 1, // Deposit selected
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
            "P2P Sell Order",
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

  Widget _buildTraderCard(String name) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: const Color(0xFF06CE8F).withOpacity(0.2),
          child: Text(
            name.isNotEmpty ? name[0].toUpperCase() : "U",
            style: TextStyle(
              color: const Color(0xFF06CE8F),
              fontWeight: FontWeight.bold,
              fontSize: 14.sp,
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  name,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15.sp,
                  ),
                ),
                SizedBox(width: 8.w),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
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
              "Buyer: $name",
              style: GoogleFonts.poppins(
                color: Colors.white38,
                fontSize: 11.sp,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSummaryCard({
    required String amount,
    required String rate,
    required String total,
  }) {
    return Column(
      children: [
        _summaryRow("Selling", amount),
        const Divider(color: Colors.white10, height: 25),
        _summaryRow("Rate", rate),
        const Divider(color: Colors.white10, height: 25),
        _summaryRow("You Will Receive", total, isTotal: true),
      ],
    );
  }

  Widget _summaryRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(color: Colors.white60, fontSize: 13.sp),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            color: isTotal ? const Color(0xFF06CE8F) : Colors.white,
            fontWeight: isTotal ? FontWeight.w800 : FontWeight.w600,
            fontSize: isTotal ? 17.sp : 14.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentToggle() {
    return Row(
      children: [
        Expanded(
          child: _toggleItem(
            "UPI",
            0,
            () => setState(() => selectedMethodIndex = 0),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _toggleItem(
            "Bank Transfer",
            1,
            () => setState(() => selectedMethodIndex = 1),
          ),
        ),
      ],
    );
  }

  Widget _toggleItem(String title, int index, VoidCallback onTap) {
    bool isActive = selectedMethodIndex == index;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color:
              isActive
                  ? const Color(0xFF06CE8F).withOpacity(0.1)
                  : Colors.white.withOpacity(0.03),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isActive ? const Color(0xFF06CE8F) : Colors.white12,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isActive ? Icons.check_circle : Icons.circle_outlined,
              size: 18,
              color: isActive ? const Color(0xFF06CE8F) : Colors.white24,
            ),
            SizedBox(width: 8.w),
            Text(
              title,
              style: GoogleFonts.poppins(
                color: isActive ? Colors.white : Colors.white38,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(
    String label,
    String hint, {
    bool isPassword = false,
    bool isReadOnly = false,
    TextEditingController? controller,
    String? Function(String?)? validator,
    TextInputType? type,
    List<TextInputFormatter>? inputFormatters,
    TextCapitalization textCapitalization = TextCapitalization.none,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12.sp),
        ),
        SizedBox(height: 8.h),
        TextFormField(
          keyboardType: type,
          controller: controller,
          readOnly: isReadOnly,
          obscureText: isPassword,
          inputFormatters: inputFormatters,
          textCapitalization: textCapitalization,
          style: GoogleFonts.poppins(color: Colors.white, fontSize: 14.sp),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white.withOpacity(0.05),
            hintText: hint,
            hintStyle: TextStyle(color: Colors.white24, fontSize: 13.sp),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 16.h,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: Colors.white12),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: Color(0xFF06CE8F)),
            ),
            errorStyle: const TextStyle(color: Colors.red),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: Colors.red),
            ),
          ),
          validator: validator,
        ),
      ],
    );
  }

  Widget _buildConfirmButton() {
    return Container(
      width: double.infinity,
      height: 55.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.r),
        gradient: const LinearGradient(
          colors: [Color(0xFF06CE8F), Color(0xFF05B47A)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF06CE8F).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed:
            isSubmitting
                ? null
                : () async {
                  FocusScope.of(context).unfocus();
                  if (!_formKey.currentState!.validate()) {
                    return;
                  }
                  setState(() {
                    isSubmitting = true;
                  });

                  try {
                    final service = ApiNetwork(createDio());

                    saveRequest body;

                    if (selectedMethodIndex == 0) {
                      body = saveRequest(
                        orderId: widget.id,
                        paymentMethods: [
                          PaymentMethod(
                            methodType: "UPI",
                            label: upiNameControlelr.text.trim(),
                            isPrimary: true,
                            details: Details(
                              upiId: upiIdController.text.trim(),
                              holderName:
                                  accountHolderNameControlelr.text.trim(),
                            ),
                          ),
                        ],
                      );
                    } else {
                      body = saveRequest(
                        orderId: widget.id,
                        paymentMethods: [
                          PaymentMethod(
                            methodType: "BANK_TRANSFER",
                            label: "My Bank Account",
                            isPrimary: true,
                            details: Details(
                              bankName: bankNameController.text.trim(),
                              accountNumber:
                                  accountNumberController.text.trim(),
                              ifscCode: ifscController.text.trim(),
                              branchName: branchNameController.text.trim(),
                              accountHolderName:
                                  accountHolderNameControlelr.text.trim(),
                            ),
                          ),
                        ],
                      );
                    }

                    final response = await service.p2pSaveSell(body);

                    if (response.error == false && response.code == 0) {
                      ShowMessage.success(
                        context,
                        response.message ??
                            "Sell request submitted successfully",
                      );

                      ref.read(p2pTabProvider.notifier).state = 1;
                      ref.invalidate(p2pBuyHistoryProvider);
                      ref.invalidate(p2pSellProvider);
                      Navigator.pushAndRemoveUntil(
                        context,
                        RightSlideFadeRoute(
                          page: const P2pBuySellTransationHistoryPage(),
                        ),
                        ModalRoute.withName(
                          '/home',
                        ), // Home page ko stack mein rehne dega, baaki sab hata dega
                      );
                    } else {
                      ShowMessage.error(
                        context,
                        response.message ?? "Submission failed",
                      );
                    }
                  } catch (e, stack) {
                    log(e.toString());
                    log(stack.toString());

                    if (e is DioException) {
                      final errorMessage =
                          e.response?.data?["message"] ??
                          "Network error occurred";
                      ShowMessage.error(context, errorMessage);
                    } else {
                      ShowMessage.error(
                        context,
                        e.toString(),
                      ); // <-- yaha change
                    }
                  } finally {
                    if (mounted) {
                      setState(() {
                        isSubmitting = false;
                      });
                    }
                  }
                },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.r),
          ),
        ),
        child:
            isSubmitting
                ? SizedBox(
                  width: 20.w,
                  height: 20.h,
                  child: const CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
                : Text(
                  "Confirm Sell",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 16.sp,
                  ),
                ),
      ),
    );
  }
}
