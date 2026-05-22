import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:payment_app/Screen/confirmSell.page.dart';
import 'package:payment_app/config/auth/router/rightsliderFageRoute.dart';
import 'package:payment_app/data/controller/getFoundController.dart';
import 'package:payment_app/data/controller/profileController.dart';

class SellPage extends ConsumerStatefulWidget {
  const SellPage({super.key});

  @override
  ConsumerState<SellPage> createState() => _SellPageeState();
}

class _SellPageeState extends ConsumerState<SellPage> {
  int selectedTab = 0; // 0 = USDT, 1 = Tokens
  int? activeMethodIndex; // Null initially, set when user clicks a card
  double currentRate = 0;
  double calculatedTotal = 0;
  double usdtBalance = 0;
  double tokenBalance = 0;

  double get currentBalance => selectedTab == 0 ? usdtBalance : tokenBalance;

  final amountController = TextEditingController();

  String selectedPayment = "";
  String selectedTimer = "";
  String selectedTitle = "";
  String paymentType = "";

  @override
  void initState() {
    super.initState();

    amountController.addListener(() {
      final text = amountController.text;

      if (text.isEmpty) return;

      double value = double.tryParse(text) ?? 0;

      // Balance se jyada input ho to auto replace
      if (value > currentBalance) {
        final newText = currentBalance.toStringAsFixed(2);

        amountController.value = TextEditingValue(
          text: newText,
          selection: TextSelection.collapsed(offset: newText.length),
        );
      }

      setState(() {
        activeMethodIndex = null;
        calculatedTotal = 0;
      });
    });
  }

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  double get enteredAmount => double.tryParse(amountController.text) ?? 0;

  @override
  Widget build(BuildContext context) {
    // In real app, these come from your providers
    final getFoundState = ref.watch(getFoundProvider);
    final profileState = ref.watch(profileProvider);

    bool upiEnabled = false;
    bool impsCdmEnabled = false;
    bool rtgsEnabled = false;

    if (selectedTab == 0) {
      // ===== USDT LOGIC =====
      if (enteredAmount > 0 && enteredAmount <= 1000) {
        upiEnabled = true;
      } else if (enteredAmount >= 1001 && enteredAmount <= 1999) {
        impsCdmEnabled = true;
      } else if (enteredAmount >= 2000) {
        rtgsEnabled = true;
      }
    } else {
      // ===== TOKEN LOGIC =====
      if (enteredAmount > 0 && enteredAmount <= 100000) {
        upiEnabled = true;
      } else if (enteredAmount >= 100001 && enteredAmount <= 199000) {
        impsCdmEnabled = true;
      } else if (enteredAmount >= 200001) {
        rtgsEnabled = true;
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFF09111C),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(-0.9, -0.9),
                radius: 1.5,
                colors: [Color(0xFF1A2A3A), Color(0xFF09111C)],
              ),
            ),
          ),
          profileState.when(
            data: (data) {
              usdtBalance =
                  (data!.data?.wallet?.usdt is num)
                      ? (data.data!.wallet!.usdt as num).toDouble()
                      : double.tryParse(
                            data.data?.wallet?.usdt?.toString() ?? '',
                          ) ??
                          0.0;

              tokenBalance =
                  (data.data?.wallet?.token is num)
                      ? (data.data!.wallet!.token as num).toDouble()
                      : double.tryParse(
                            data.data?.wallet?.token?.toString() ?? '',
                          ) ??
                          0.0;
              return SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: SingleChildScrollView(
                    child: getFoundState.when(
                      data: (data) {
                        final double upiRate =
                            (data!.data?.upi is num)
                                ? (data.data!.upi as num).toDouble()
                                : double.tryParse(
                                      data.data?.upi?.toString() ?? '',
                                    ) ??
                                    0.0;
                        final double impsRate =
                            (data!.data?.imps is num)
                                ? (data.data!.imps as num).toDouble()
                                : double.tryParse(
                                      data.data?.imps?.toString() ?? '',
                                    ) ??
                                    0.0;
                        final double cdmRate =
                            (data!.data?.cdm is num)
                                ? (data.data!.cdm as num).toDouble()
                                : double.tryParse(
                                      data.data?.cdm?.toString() ?? '',
                                    ) ??
                                    0.0;
                        final double rtgsRate =
                            (data!.data?.rtgs is num)
                                ? (data.data!.rtgs as num).toDouble()
                                : double.tryParse(
                                      data.data?.rtgs?.toString() ?? '',
                                    ) ??
                                    0.0;

                        if (upiRate <= 0 &&
                            impsRate <= 0 &&
                            cdmRate <= 0 &&
                            rtgsRate <= 0) {
                          return Padding(
                            padding: EdgeInsets.only(top: 20.h),
                            child: Text(
                              "No payment methods available",
                              style: TextStyle(color: Colors.white54),
                            ),
                          );
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 20.h),
                            Text(
                              "Sell",
                              style: GoogleFonts.poppins(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 20.h),
                            // Tabs
                            Container(
                              padding: EdgeInsets.all(4.w),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(30.r),
                              ),
                              child: Row(
                                children: [
                                  buildTab("USDT", 0),
                                  buildTab("Tokens", 1),
                                ],
                              ),
                            ),
                            SizedBox(height: 20.h),

                            glassCard(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Available Balance",
                                    style: GoogleFonts.poppins(
                                      fontSize: 12.sp,
                                      color: const Color(0xFF9CA3AF),
                                    ),
                                  ),
                                  const Spacer(),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "${currentBalance.toStringAsFixed(2)} ${selectedTab == 0 ? 'USDT' : 'TOKEN'}",
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(height: 5.w),
                                      GestureDetector(
                                        onTap:
                                            () =>
                                                amountController
                                                    .text = currentBalance
                                                    .toStringAsFixed(2),
                                        child: miniButton("Max"),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: 20.h),
                            buildLabel("Enter Amount"),
                            SizedBox(height: 8.h),
                            // Amount Field
                            glassField(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: amountController,
                                      keyboardType: TextInputType.number,
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "0",
                                        hintStyle: TextStyle(
                                          color: Colors.white30,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    selectedTab == 0 ? "USDT" : "Token",
                                    style: GoogleFonts.poppins(
                                      color: const Color(0xFF06CE8F),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 15.h),
                            // Receive Row (Updates only after clicking card)
                            Row(
                              children: [
                                Text(
                                  "You Will Receive:",
                                  style: GoogleFonts.poppins(
                                    fontSize: 13.sp,
                                    color: const Color(0xFF9CA3AF),
                                  ),
                                ),
                                SizedBox(width: 6.w),
                                Text(
                                  "₹${calculatedTotal.toStringAsFixed(2)}",
                                  style: GoogleFonts.poppins(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF06CE8F),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 25.h),

                            // Method Cards - Logic updated
                            if (upiRate > 0)
                              buildMethodCard(
                                index: 0,
                                title: "UPI",
                                rate: selectedTab != 0 ? 1 : upiRate,
                                type: selectedTab == 0 ? "USDT" : "TOKEN",
                                color: Colors.green,
                                isEnabled: upiEnabled,
                                payment: "Unified Payments Interface",
                                timer: "20 minutes to 1 hour",
                              ),
                            if (impsRate > 0)
                              buildMethodCard(
                                index: 1,
                                title: "IMPS",
                                rate: selectedTab != 0 ? 1 : impsRate,
                                type: selectedTab == 0 ? "USDT" : "TOKEN",
                                color: Colors.green,
                                isEnabled: impsCdmEnabled,
                                payment: "Immediate Payment Service",
                                timer: "30 minutes to 1 hour",
                              ),
                            if (cdmRate > 0)
                              buildMethodCard(
                                index: 2,
                                title: "CDM",
                                rate: selectedTab != 0 ? 1 : cdmRate,
                                type: selectedTab == 0 ? "USDT" : "TOKEN",
                                color: Colors.green,
                                isEnabled: impsCdmEnabled,
                                payment: "Cash Deposit Machine",
                                timer: "1 hour to 2 hours",
                              ),
                            if (rtgsRate > 0)
                              buildMethodCard(
                                index: 3,
                                title: "RTGS",
                                rate: selectedTab != 0 ? 1 : rtgsRate,
                                type: selectedTab == 0 ? "USDT" : "TOKEN",
                                color: Color(0xFF1CB11C),
                                isEnabled: rtgsEnabled,
                                payment: "Real-Time Gross Settlement",
                                timer: "10 minutes to 30 minutes",
                              ),

                            SizedBox(height: 30.h),
                            // Sell Button
                            InkWell(
                              onTap: () {
                                if (enteredAmount > 0 &&
                                    enteredAmount <= currentBalance) {
                                  Navigator.push(
                                    context,
                                    RightSlideFadeRoute(
                                      page: ConfirmSellPage(
                                        amount: amountController.text.trim(),
                                        rate: currentRate.toString(),
                                        totalamount: calculatedTotal,
                                        walletType:
                                            selectedTab == 0 ? "USDT" : "TOKEN",
                                        payment: selectedPayment,
                                        timer: selectedTimer,
                                        selectedTitle: selectedTitle,
                                        paymentType: paymentType,
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Container(
                                height: 55.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30.r),
                                  gradient: LinearGradient(
                                    colors:
                                        calculatedTotal > 0
                                            ? [
                                              const Color(0xFF06CE8F),
                                              const Color(0xFF06CE8F),
                                            ]
                                            : [
                                              Colors.grey,
                                              Colors.grey.shade700,
                                            ],
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    "Sell ${selectedTab == 0 ? 'USDT' : 'Token'}",
                                    style: GoogleFonts.poppins(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 30.h),
                          ],
                        );
                      },
                      error: (error, stackTrace) {
                        return Center(child: Text(error.toString()));
                      },
                      loading:
                          () => Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                    ),
                  ),
                ),
              );
            },
            error: (error, stackTrace) {
              return Center(child: Text(error.toString()));
            },
            loading:
                () => Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
          ),
        ],
      ),
    );
  }

  Widget buildMethodCard({
    required int index,
    required String title,
    required double rate,
    required String type,
    required Color color,
    required bool isEnabled,
    required String payment,
    required String timer,
  }) {
    bool isCurrentlySelected = activeMethodIndex == index;

    return GestureDetector(
      onTap:
          isEnabled
              ? () {
                setState(() {
                  activeMethodIndex = index;
                  currentRate = rate;
                  calculatedTotal = enteredAmount * rate;
                  selectedPayment = payment;
                  selectedTimer = timer;
                  selectedTitle = title;
                  paymentType = index == 0 ? "UPI" : "BANK";
                });
              }
              : null,
      child: Padding(
        padding: EdgeInsets.only(bottom: 12.h),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            color: isEnabled ? color : Colors.white.withOpacity(0.05),
            border:
                isCurrentlySelected
                    ? Border.all(color: Colors.white, width: 2.5)
                    : Border.all(color: Colors.transparent),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: isEnabled ? Colors.white : Colors.white24,
                      ),
                    ),
                    Text(
                      "Rate: ₹${rate.toStringAsFixed(0)} per $type",
                      style: GoogleFonts.poppins(
                        fontSize: 12.sp,
                        color: isEnabled ? Colors.white70 : Colors.white12,
                      ),
                    ),
                    Text(
                      payment,
                      style: GoogleFonts.poppins(
                        fontSize: 12.sp,
                        color: isEnabled ? Colors.white70 : Colors.white12,
                      ),
                    ),
                    Text(
                      timer,
                      style: GoogleFonts.poppins(
                        fontSize: 12.sp,
                        color: isEnabled ? Colors.white70 : Colors.white12,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: isEnabled ? Colors.white24 : Colors.black26,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  isEnabled
                      ? (isCurrentlySelected ? "SELECTED" : "SELECT")
                      : "N/A",
                  style: GoogleFonts.poppins(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.bold,
                    color: isEnabled ? Colors.white : Colors.white24,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- UI Helpers ---
  Widget buildTab(String text, int index) {
    final isSelected = selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedTab = index),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.r),
            color: isSelected ? const Color(0xFF06CE8F) : null,
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  Widget glassCard({required Widget child}) => Container(
    padding: EdgeInsets.all(16.w),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.05),
      borderRadius: BorderRadius.circular(20.r),
    ),
    child: child,
  );

  Widget glassField({required Widget child}) => Container(
    padding: EdgeInsets.symmetric(horizontal: 16.w),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.05),
      border: Border.all(color: const Color(0xFF06CE8F).withOpacity(0.3)),
      borderRadius: BorderRadius.circular(16.r),
    ),
    child: child,
  );

  Widget buildLabel(String text) => Text(
    text,
    style: GoogleFonts.poppins(
      color: Colors.white,
      fontWeight: FontWeight.w500,
    ),
  );

  Widget miniButton(String text) => Container(
    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
    decoration: BoxDecoration(
      color: const Color(0xFF06CE8F),
      borderRadius: BorderRadius.circular(20.r),
    ),
    child: Text(
      text,
      style: GoogleFonts.poppins(fontSize: 11.sp, color: Colors.white),
    ),
  );
}
