import 'dart:developer';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:payment_app/Screen/addBankAccount,page.dart';
import 'package:payment_app/Screen/addUpiAccount.page.dart';
import 'package:payment_app/Screen/depositeUSDDetails.page.dart';
import 'package:payment_app/Screen/home.page.dart';
import 'package:payment_app/Screen/orderProcessing.page.dart';
import 'package:payment_app/config/auth/router/rightsliderFageRoute.dart';
import 'package:payment_app/config/network/api.network.dart';
import 'package:payment_app/config/utils/pretty.dio.dart';
import 'package:payment_app/config/utils/showMessage.dart';
import 'package:payment_app/data/controller/sellUpiController.dart';
import 'package:payment_app/data/model/confirmSellBodyModel.dart' as upiModel;
import 'package:payment_app/data/model/confirmsellBankBodyModel.dart'
    as bankModel;

class ConfirmSellPage extends ConsumerStatefulWidget {
  final String amount;
  final String rate;
  final totalamount;
  final String walletType;
  final String payment;
  final String timer;
  final String selectedTitle;
  final String paymentType;

  const ConfirmSellPage({
    super.key,
    required this.amount,
    required this.rate,
    required this.totalamount,
    required this.walletType,
    required this.payment,
    required this.timer,
    required this.selectedTitle,
    required this.paymentType,
  });

  @override
  ConsumerState<ConfirmSellPage> createState() => _ConfirmSellPageState();
}

class _ConfirmSellPageState extends ConsumerState<ConfirmSellPage> {
  final pinController = TextEditingController();
  String? selectedBank; // Display name ke liye
  String? selectedlabel; // Display name ke liye
  String? selectedUpiId; // API mein bhejne ke liye
  String? selectedMethodType; // API mein bhejne ke liye (Bank ya UPI)
  bool isDropdownOpen = false;
  bool isLoader = false; // API call ke waqt button par loader dikhane ke liye
  String? selectedAccountNumber;
  String? selectedIfsc;
  String? selectedHolderName;

  @override
  void dispose() {
    pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log(widget.walletType);
    final setUpiState = ref.watch(sellUpiControllerProvider);
    final setBankState = ref.watch(sellBankControllerProvider);
    return Scaffold(
      backgroundColor: const Color(0xFF09111C),
      body: Stack(
        children: [
          /// 🔹 Background Radial Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(-0.8, -0.7),
                radius: 1.2,
                colors: [Color(0xFF1A2A3A), Color(0xFF09111C)],
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                /// 🔹 Custom Header
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 10.h,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 22.sp,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Spacer(),
                      Text(
                        "Confirm Sell",
                        style: GoogleFonts.poppins(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const Spacer(),
                      SizedBox(width: 40.w),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [mainGlassCard()],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: 3, // Deposit selected
      ),
    );
  }

  Widget mainGlassCard() {
    final upiState = ref.watch(sellUpiControllerProvider);
    return upiState.when(
      data: (data) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(24.r),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(24.r),
                border: Border.all(color: Colors.white10, width: 1.5),
              ),
              child: Column(
                children: [
                  /// ✅ Success Icon (Neon Style)
                  Container(
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFF06CE8F).withOpacity(0.2),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF06CE8F),
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      Icons.check,
                      color: const Color(0xFF06CE8F),
                      size: 24.sp,
                    ),
                  ),
                  SizedBox(height: 15.h),
                  Text(
                    "Confirm Your Sell Order",
                    style: GoogleFonts.poppins(
                      fontSize: 15.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 30.h),

                  /// ⚡ Order Summary
                  sectionHeader(Icons.flash_on, "Order Summary"),
                  SizedBox(height: 15.h),
                  detailRow(
                    "Selling",
                    "${widget.amount} ${widget.walletType}",
                    icon: Icons.token,
                    iconColor: Colors.blueAccent,
                  ),
                  detailRow("Rate", "₹${widget.rate}", isInfo: true),

                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 15.h),
                    child: Divider(color: Colors.white10, thickness: 1),
                  ),

                  detailRow(
                    "Total Receive:",
                    "₹${widget.totalamount}",
                    isBold: true,
                  ),

                  SizedBox(height: 15.h),

                  // bankDropdownOverlay(),
                  widget.paymentType.toLowerCase() == "upi"
                      ? upiDropdownOverlay()
                      : bankDropdownOverlay(),

                  SizedBox(height: 25.h),

                  /// 🔢 PIN Input
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Enter Transaction PIN",
                      style: GoogleFonts.poppins(
                        fontSize: 12.sp,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  TextField(
                    controller: pinController,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    textAlign: TextAlign.center,
                    obscureText: true,
                    style: const TextStyle(
                      color: Colors.white,
                      letterSpacing: 8,
                    ),
                    decoration: InputDecoration(
                      counterText: "",
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.05),
                      border: InputBorder.none,
                      hintText: "••••••",
                      hintStyle: TextStyle(
                        color: Colors.white24,
                        letterSpacing: 8,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.white10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.white10),
                      ),
                    ),
                  ),

                  SizedBox(height: 25.h),
                  settlementCard(),
                  SizedBox(height: 35.h),

                  /// 🚀 Confirm Button
                  InkWell(
                    onTap: () async {
                      if (selectedBank == null || selectedBank!.isEmpty) {
                        ShowMessage.error(
                          context,
                          widget.paymentType.toLowerCase() == "upi"
                              ? "Select UPI"
                              : "Select Bank",
                        );
                        return;
                      }

                      if (pinController.text.length < 6) {
                        ShowMessage.error(context, "Enter valid PIN");
                        return;
                      }

                      // 🔥 FIXED AMOUNT
                      num parsedAmount =
                          num.tryParse(widget.amount.toString().trim()) ?? 0;

                      log("RAW AMOUNT: ${widget.amount}");
                      log("PARSED AMOUNT: $parsedAmount");

                      if (parsedAmount <= 0) {
                        ShowMessage.error(context, "Invalid amount");
                        return;
                      }

                      if (parsedAmount < 10) {
                        ShowMessage.error(context, "Minimum amount is 10");
                        return;
                      }

                      final amount = parsedAmount.toInt();

                      setState(() => isLoader = true);

                      try {
                        final isUpi = widget.paymentType.toLowerCase() == "upi";

                        final service = ApiNetwork(createDio());

                        final body = upiModel.ConfirmSellBodyModel(
                          amount: amount,
                          pin: pinController.text.trim(),
                          walletType: widget.walletType,
                          // assetSymbol: isUpi ? "upi" : "BANK_TRANSFER",
                          assetSymbol: widget.selectedTitle.toLowerCase(),
                          paymentMethods: upiModel.PaymentMethods(
                            methodType: isUpi ? "UPI" : "BANK_TRANSFER",
                            label: selectedlabel ?? "",
                            isPrimary: true,
                            details:
                                isUpi
                                    ? upiModel.Details(
                                      upiId: selectedBank ?? "",
                                    )
                                    : upiModel.Details(
                                      accountNumber: selectedAccountNumber,
                                      ifsc: selectedIfsc,
                                      accountHolderName: selectedHolderName,
                                    ),
                          ),
                        );

                        final response = await service.confirmSellWallet(
                          body.toJson(),
                        );

                        if (response.error == true) {
                          ShowMessage.error(context, response.message ?? "");
                          return;
                        }

                        final order = response.data;

                        Navigator.push(
                          context,
                          RightSlideFadeRoute(
                            page: OrderProcessingPage(
                              amount: order?.amount?.toString() ?? "",
                              walletType: order?.walletType ?? "",
                              rate: order?.rate?.toString() ?? "",
                              totalAmount: order?.totalAmount?.toString() ?? "",
                              paymentMethod:
                                  order?.paymentMethods?.first.methodType ?? "",
                              upiId: order?.paymentMethods?.first.label ?? "",
                              orderId: order?.orderId ?? "",
                              status: order?.status ?? "",
                              createdAt: order?.createdAt ?? 0,
                            ),
                          ),
                        );
                      } catch (e, st) {
                        ShowMessage.error(context, "Error: $e");
                        log(st.toString());
                        log(e.toString());
                      } finally {
                        setState(() => isLoader = false);
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      height: 52.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.r),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF06CE8F), Color(0xFF04A774)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF06CE8F).withOpacity(0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Center(
                        child:
                            isLoader
                                ? SizedBox(
                                  width: 20,
                                  height: 20.h,
                                  child: const CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 1.5,
                                  ),
                                )
                                : Text(
                                  "Confirm & Process Sell",
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.sp,
                                  ),
                                ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      error: (error, stackTrace) {
        return Center(child: Text(error.toString()));
      },
      loading:
          () => Center(child: CircularProgressIndicator(color: Colors.white)),
    );
  }

  Widget upiDropdownOverlay() {
    final upiState = ref.watch(sellUpiControllerProvider);

    return upiState.when(
      data: (upiModel) {
        final upiList = upiModel.data ?? [];
        if (upiList.isEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "TRANSFER VIA UPI:",
                style: GoogleFonts.poppins(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white70,
                  letterSpacing: 1.2,
                ),
              ),
              SizedBox(height: 12.h),

              /// 🔥 ADD UPI BUTTON
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    RightSlideFadeRoute(page: AddUpiAccountPage()),
                  ).then((value) {
                    return ref
                        .read(sellUpiControllerProvider.notifier)
                        .fetchSellUpi();
                  });
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.r),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF06CE8F), Color(0xFF05B47A)],
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "Add UPI",
                      style: GoogleFonts.poppins(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔹 Header text matching your image
            Text(
              "TRANSFER VIA UPI:",
              style: GoogleFonts.poppins(
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white70,
                letterSpacing: 1.2,
              ),
            ),
            SizedBox(height: 12.h),

            /// 🔹 Selected UPI Display (Top Box)
            GestureDetector(
              onTap: () => setState(() => isDropdownOpen = !isDropdownOpen),
              child: Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A212A), // Dark background from image
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: Colors.white10),
                ),
                child: Row(
                  children: [
                    upiIconBadge(),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            selectedBank ?? "Select UPI",
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "UPI ACCOUNT",
                            style: GoogleFonts.poppins(
                              color: Colors.white38,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      isDropdownOpen
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: Colors.white30,
                    ),
                  ],
                ),
              ),
            ),

            /// 🔹 Dropdown List (Visible when isDropdownOpen is true)
            if (isDropdownOpen)
              Container(
                margin: EdgeInsets.only(top: 8.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A212A),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: Colors.white10),
                ),
                child: Padding(
                  padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 16.h),
                  child: Column(
                    children:
                        upiList.map((item) {
                          return InkWell(
                            onTap: () {
                              setState(() {
                                selectedBank = item.upi; // UI Display
                                selectedlabel = item.name;
                                selectedUpiId = item.upi.toString();
                                selectedMethodType = "UPI";
                                isDropdownOpen = false;
                              });
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    upiIconBadge(),
                                    SizedBox(width: 12.w),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.upi ?? "",
                                          style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          item.name ?? "",
                                          style: GoogleFonts.poppins(
                                            color: Colors.white38,
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),

                                if (item != upiList.last)
                                  const Divider(
                                    color: Colors.white10,
                                    height: 1,
                                  ),
                                SizedBox(height: 10),
                              ],
                            ),
                          );
                        }).toList(),
                  ),
                ),
              ),
          ],
        );
      },
      loading:
          () => const Center(
            child: CircularProgressIndicator(color: Color(0xFF06CE8F)),
          ),
      error:
          (err, stack) => const Text(
            "Error fetching UPI",
            style: TextStyle(color: Colors.red),
          ),
    );
  }

  /// 🟢 Green "UPI" badge helper
  Widget upiIconBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: const Color(0xFF06CE8F).withOpacity(0.1),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        "UPI",
        style: TextStyle(
          color: const Color(0xFF06CE8F),
          fontSize: 10.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget bankDropdownOverlay() {
    final bankState = ref.watch(sellBankControllerProvider);

    return bankState.when(
      data: (bankModel) {
        final bankList = bankModel.data ?? [];

        if (bankList.isEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "TRANSFER VIA BANK:",
                style: GoogleFonts.poppins(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white70,
                ),
              ),
              SizedBox(height: 12.h),

              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    RightSlideFadeRoute(page: AddBankAccountPage()),
                  ).then((value) {
                    return ref
                        .read(sellBankControllerProvider.notifier)
                        .fetchSellBank();
                  });
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.r),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF06CE8F), Color(0xFF05B47A)],
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "Add Bank",
                      style: GoogleFonts.poppins(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "TRANSFER VIA BANK:",
              style: GoogleFonts.poppins(
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white70,
              ),
            ),
            SizedBox(height: 12.h),

            GestureDetector(
              onTap: () => setState(() => isDropdownOpen = !isDropdownOpen),
              child: Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A212A), // Dark background from image
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: Colors.white10),
                ),
                child: Row(
                  children: [
                    bankIconBadge(),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(
                        selectedBank ?? "Select Bank",
                        style: GoogleFonts.poppins(color: Colors.white),
                      ),
                    ),
                    Icon(Icons.keyboard_arrow_down, color: Colors.white30),
                  ],
                ),
              ),
            ),

            if (isDropdownOpen)
              Container(
                margin: EdgeInsets.only(top: 8.h),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF1A212A),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: Colors.white10),
                ),
                child: Padding(
                  padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 16.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:
                        bankList.map((item) {
                          String maskAccountNumber(String? accNumber) {
                            if (accNumber == null || accNumber.length <= 4)
                              return accNumber ?? "";

                            String last4 = accNumber.substring(
                              accNumber.length - 4,
                            );
                            return "$last4"; // 🔥 clean UI
                          }

                          return InkWell(
                            onTap: () {
                              setState(() {
                                selectedBank = item.bankName;
                                selectedlabel = item.bankName;
                                selectedAccountNumber =
                                    item.accountNumber.toString();
                                selectedIfsc = item.ifscCode.toString();
                                selectedHolderName =
                                    item.accountHolderName.toString();
                                selectedMethodType = "BANK_TRANSFER";
                                isDropdownOpen = false;
                              });
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.bankName ?? "",
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "A/C • ${maskAccountNumber(item.accountNumber?.toString())} | ${item.accountHolderName ?? ""}",
                                  style: GoogleFonts.poppins(
                                    color: Colors.white38,
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 10.h),
                                if (item != bankList.last)
                                  const Divider(
                                    color: Colors.white10,
                                    height: 1,
                                  ),
                                SizedBox(height: 10.h),
                              ],
                            ),
                          );
                        }).toList(),
                  ),
                ),
              ),
          ],
        );
      },
      loading: () => const CircularProgressIndicator(color: Color(0xFF06CE8F)),
      error:
          (err, stack) => const Text(
            "Error fetching Bank",
            style: TextStyle(color: Colors.red),
          ),
    );
  }

  /// 🟢 Green "UPI" badge helper
  Widget bankIconBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: const Color(0xFF06CE8F).withOpacity(0.1),
        borderRadius: BorderRadius.circular(6.r),
      ),

      child: Icon(Icons.security, color: Color(0xFF06CE8F), size: 12.sp),
    );
  }

  Widget detailRow(
    String label,
    String value, {
    bool isInfo = false,
    bool isBold = false,
    IconData? icon,
    Color? iconColor,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (icon != null) Icon(icon, color: iconColor, size: 14.sp),
              if (icon != null) SizedBox(width: 6.w),
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 13.sp,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: isBold ? 16.sp : 14.sp,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
              color: isBold ? const Color(0xFF06CE8F) : Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget sectionHeader(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF06CE8F), size: 18.sp),
        SizedBox(width: 8.w),
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget settlementCard() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.r),
        gradient: LinearGradient(
          colors: [const Color(0xFF0F1E2E), const Color(0xFF0B1622)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Top Row
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: const Color(0xFF06CE8F).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: const Icon(
                  Icons.access_time_rounded,
                  color: Color(0xFF06CE8F),
                  size: 18,
                ),
              ),

              SizedBox(width: 12.w),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "ESTIMATED SETTLEMENT",
                      style: GoogleFonts.poppins(
                        fontSize: 10.sp,
                        color: Colors.white54,
                        letterSpacing: 1.2,
                      ),
                    ),
                    SizedBox(height: 4.h),

                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Approx. ",
                            style: GoogleFonts.poppins(
                              fontSize: 14.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextSpan(
                            text: widget.timer,
                            style: GoogleFonts.poppins(
                              fontSize: 14.sp,
                              color: const Color(0xFF06CE8F),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              /// Method Tag
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF1C2A3A),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  widget.selectedTitle,
                  style: GoogleFonts.poppins(
                    fontSize: 10.sp,
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 12.h),

          Divider(color: Colors.white12, thickness: 1),

          SizedBox(height: 10.h),

          /// Bottom Note
          Row(
            children: [
              const Icon(Icons.security, color: Colors.white38, size: 16),
              SizedBox(width: 8.w),
              Text(
                "Secure transfer via encrypted gateway",
                style: GoogleFonts.poppins(
                  fontSize: 10.sp,
                  color: Colors.white38,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
