import 'dart:developer';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:payment_app/Screen/refreshRotate.page.dart';
import 'package:payment_app/config/network/socketSrvice.dart';
import 'package:payment_app/config/utils/showMessage.dart';
import 'package:payment_app/data/controller/depositeINRListController.dart';
import 'package:payment_app/data/controller/depositeUSDTController.dart';
import 'package:payment_app/data/controller/getBuyInrDepositeController.dart';
import 'package:payment_app/data/controller/processBuyINRDepositeController.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class DepositPage extends ConsumerStatefulWidget {
  const DepositPage({super.key});

  @override
  ConsumerState<DepositPage> createState() => _DepositPageState();
}

class _DepositPageState extends ConsumerState<DepositPage> {
  int selectedTab = 0;

  final TextEditingController amountController = TextEditingController();
  final TextEditingController pinController = TextEditingController();
  String? selectedNetwork;

  @override
  void dispose() {
    amountController.dispose();
    pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final usdtDepositeState = ref.watch(usdtDepositeProvider);
    final isLoading = usdtDepositeState is AsyncLoading;
    return Scaffold(
      backgroundColor: const Color(0xFF09111C),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 15.h),
            Row(
              children: [
                SizedBox(width: 20.w),
                Text(
                  "Deposit",
                  style: GoogleFonts.poppins(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(height: 30.h),
            Container(
              margin: EdgeInsets.only(left: 20.w, right: 20.w),
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(30.r),
              ),
              child: Row(children: [buildTab("USDT", 0), buildTab("INR", 1)]),
            ),
            Expanded(
              child:
                  selectedTab == 0 ? buildUSDkUI(isLoading) : DepositInrPage(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTab(String text, int index) {
    final isSelected = selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedTab = index;
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.r),
            color: isSelected ? Color(0xFF06CE8F) : null,
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : const Color(0xFF9CA3AF),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildUSDkUI(bool isLoading) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 22.w),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30.h), // Top Spacing
            /// 🔹 Amount Field
            _buildFieldLabel("Amount", Icons.account_balance_wallet_outlined),
            SizedBox(height: 8.h),
            _glassField(
              child: TextField(
                controller: amountController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 15.sp,
                ),
                decoration: _inputDecoration(
                  hint: "Enter Amount",
                  suffix: _buildSuffixLabel("USDT"),
                ),
              ),
            ),

            SizedBox(height: 20.h),

            /// 🔹 Select Network
            _buildFieldLabel("Select Network", Icons.lan_outlined),
            SizedBox(height: 8.h),

            _glassField(
              child: DropdownButtonFormField<String>(
                value: selectedNetwork,
                isExpanded: true,
                dropdownColor: const Color(0xFF1A2A3A),

                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                ),

                hint: Text(
                  "Select Network",
                  style: TextStyle(color: Colors.white),
                ),

                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 14.sp,
                ),

                icon: Icon(
                  Icons.unfold_more_rounded,
                  color: const Color(0xFF06CE8F),
                  size: 20.sp,
                ),

                items: [
                  DropdownMenuItem(
                    value: "TRC20",
                    child: Text("TRC20", style: TextStyle(color: Colors.white)),
                  ),
                  DropdownMenuItem(
                    value: "ERC20",
                    child: Text("ERC20", style: TextStyle(color: Colors.white)),
                  ),
                  DropdownMenuItem(
                    value: "BEP20",
                    child: Text("BEP20", style: TextStyle(color: Colors.white)),
                  ),
                ],

                onChanged: (value) {
                  setState(() {
                    selectedNetwork = value;
                  });
                },
              ),
            ),

            SizedBox(height: 20.h),

            /// 🔹 Transfer Pin
            _buildFieldLabel("Transfer Pin", Icons.lock_outline_rounded),
            SizedBox(height: 8.h),
            _glassField(
              child: TextField(
                keyboardType: TextInputType.number,
                controller: pinController,
                maxLength: 6,
                obscureText: true,
                style: const TextStyle(color: Colors.white, letterSpacing: 6),
                decoration: _inputDecoration(hint: "••••••"),
              ),
            ),

            SizedBox(height: 40.h),

            /// 🔹 Submit Button
            _buildSubmitButton(isLoading),

            SizedBox(height: 35.h),

            /// 🔹 Important Notice Box
            _buildNoticeBox(),

            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }

  // --- UI Components ---

  Widget _buildFieldLabel(String text, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 14.sp, color: Colors.white38),
        SizedBox(width: 6.w),
        Text(
          text,
          style: GoogleFonts.poppins(
            color: Colors.white70,
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration({required String hint, Widget? suffix}) {
    return InputDecoration(
      hintText: hint,
      isDense: true,

      contentPadding: EdgeInsets.symmetric(vertical: 14.h),
      hintStyle: GoogleFonts.poppins(
        color: const Color(0xFF6B7280),
        fontSize: 13.sp,
        letterSpacing: 0,
      ),
      counterText: "",
      border: InputBorder.none,
      suffixIcon: suffix,
      suffixIconConstraints: BoxConstraints(minHeight: 0, minWidth: 0),
    );
  }

  Widget _buildSuffixLabel(String text) {
    return Container(
      margin: EdgeInsets.only(left: 8.w),
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: const Color(0xFF06CE8F).withOpacity(0.1),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: const Color(0xFF06CE8F),
          fontWeight: FontWeight.bold,
          fontSize: 11.sp,
        ),
      ),
    );
  }

  Widget _glassField({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _buildSubmitButton(bool isLoading) {
    return GestureDetector(
      onTap: isLoading ? null : _handleDeposit,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: 54.h,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14.r),
          gradient: LinearGradient(
            colors:
                isLoading
                    ? [Colors.grey.shade700, Colors.grey.shade800]
                    : [const Color(0xFF06CE8F), const Color(0xFF05B47A)],
          ),
          boxShadow: [
            if (!isLoading)
              BoxShadow(
                color: const Color(0xFF06CE8F).withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
          ],
        ),
        child: Center(
          child:
              isLoading
                  ? SizedBox(
                    height: 24.h,
                    width: 24.h,
                    child: const CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                  : Text(
                    "Confirm Deposit",
                    style: GoogleFonts.poppins(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
        ),
      ),
    );
  }

  void _handleDeposit() {
    final amountText = amountController.text.trim();
    if (amountText.isEmpty || pinController.text.isEmpty) {
      ShowMessage.error(context, "Please fill all fields");
      return;
    }

    final amount = num.tryParse(amountText);
    if (amount == null) {
      ShowMessage.error(context, "Please enter a valid amount");
      return;
    }

    ref
        .read(usdtDepositeProvider.notifier)
        .createUSDTDeposite(
          context: context,
          ammount: amount,
          network: selectedNetwork!,
          pin: pinController.text,
        );
  }

  Widget _buildNoticeBox() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1921),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🟢 Header: Circle Dot + Title
          Row(
            children: [
              Container(
                height: 12.r,
                width: 12.r,
                decoration: const BoxDecoration(
                  color: Color(0xFF00C853), // Bright green dot
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                "IMPORTANT GUIDE (USDT)",
                style: GoogleFonts.poppins(
                  color: const Color(0xFF819199), // Greyish text color
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 15.h),

          /// 1️⃣ Minimum Deposit
          _noticeItem(
            icon: Icons.done,
            text: "Minimum deposit is 10 USDT.",
            subText: "Transactions below this limit will not be credited.",
          ),

          /// 2️⃣ Blockchain Confirmation
          _noticeItem(
            icon: Icons.done,
            text:
                "Blockchain confirmation typically requires 5–10 minutes depending on network congestion.",
          ),

          /// 3️⃣ Supported Networks List
          _noticeItem(
            icon: Icons.done,
            text: "Supported Networks:",
            isList: true,
            listItems: [
              "TRC20 — TRON Network",
              "ERC20 — Ethereum Network",
              "BEP20 — BNB Smart Chain Network",
            ],
          ),

          /// 4️⃣ Warning Section
          Padding(
            padding: EdgeInsets.only(top: 10.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.report_problem_outlined,
                  color: const Color(0xFF819199),
                  size: 16.sp,
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    "Please ensure the correct network is selected.",
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF819199),
                      fontSize: 12.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),

          /// 5️⃣ Final Notes
          Padding(
            padding: EdgeInsets.only(top: 10.h),
            child: Text(
              "Incorrect network selection may lead to permanent loss of funds.\n\nCryptocurrency transactions are final and irreversible once confirmed on the blockchain.",
              style: GoogleFonts.poppins(
                color: const Color(0xFF819199),
                fontSize: 12.sp,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _noticeItem({
    required IconData icon,
    required String text,
    String? subText,
    bool isList = false,
    List<String>? listItems,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: const Color(0xFF819199), size: 16.sp),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  text,
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF819199),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          if (subText != null)
            Padding(
              padding: EdgeInsets.only(left: 26.w, top: 4.h),
              child: Text(
                subText,
                style: GoogleFonts.poppins(
                  color: const Color(0xFF819199),
                  fontSize: 12.sp,
                ),
              ),
            ),
          if (isList && listItems != null)
            Padding(
              padding: EdgeInsets.only(left: 26.w, top: 10.h),
              child: Column(
                children:
                    listItems
                        .map(
                          (item) => Padding(
                            padding: EdgeInsets.only(bottom: 8.h),
                            child: Row(
                              children: [
                                Container(
                                  height: 4.r,
                                  width: 4.r,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF819199),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                Text(
                                  item,
                                  style: GoogleFonts.poppins(
                                    color: const Color(0xFF819199),
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
              ),
            ),
        ],
      ),
    );
  }

  // --- Helper Widgets ---

  Widget buildLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        color: Colors.white.withOpacity(0.8),
        fontSize: 13.sp,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget glassField({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: 48.h,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          alignment: Alignment.center,
          child: child,
        ),
      ),
    );
  }

  Widget glassCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: child,
    );
  }

  Widget noticeBulletPoint(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 6.h),
            child: Icon(
              Icons.circle,
              size: 5.sp,
              color: const Color(0xFF06CE8F),
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                color: Colors.white60,
                fontSize: 11.5.sp,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

///////////////////////////////////////////

class DepositInrPage extends ConsumerStatefulWidget {
  const DepositInrPage({super.key});

  @override
  ConsumerState<DepositInrPage> createState() => _DepositInrPageState();
}

class _DepositInrPageState extends ConsumerState<DepositInrPage> {
  int selectedTab = 1; // 0 = USDT, 1 = INR

  final api = DepositSocketApi();
  final socketService = SocketService();

  List deposits = [];
  String sortOrder = "desc";
  bool loading = false;

  /// ⭐ Fetch Data
  Future<void> fetchDeposits() async {
    try {
      setState(() {
        loading = true;
      });

      final response = await api.getBuyInrDepositList(sortOrder);

      if (mounted) {
        setState(() {
          deposits = response["data"] ?? [];
        });
      }
    } catch (e) {
      print("Fetch Error $e");
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  /// ⭐ Live Socket Listener
  void listenSocketDeposit() {
    socketService.socket.off("buyInrDepositListUpdated");

    socketService.socket.on("buyInrDepositListUpdated", (data) {
      List sortedList = List.from(data ?? []);

      /// Sorting
      if (sortOrder == "asc") {
        sortedList.sort((a, b) => a["amount"].compareTo(b["amount"]));
      } else {
        sortedList.sort((a, b) => b["amount"].compareTo(a["amount"]));
      }

      if (mounted) {
        setState(() {
          deposits = sortedList;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    fetchDeposits();
    listenSocketDeposit();
    Future.microtask(() {
      ref.read(getBuyInrDepoProvider.notifier).getbuyInrDeposite();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    fetchDeposits();
    ref.read(getBuyInrDepoProvider.notifier).getbuyInrDeposite();
  }

  bool isLowToHigh = true;

  @override
  void dispose() {
    socketService.socket.off("buyInrDepositListUpdated");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final getBuyInrDepoState = ref.watch(getBuyInrDepoProvider);
    List sortedDeposits = [...deposits];

    sortedDeposits.sort((a, b) {
      double amountA = double.tryParse(a['amount'].toString()) ?? 0;
      double amountB = double.tryParse(b['amount'].toString()) ?? 0;

      return isLowToHigh
          ? amountA.compareTo(amountB)
          : amountB.compareTo(amountA);
    });

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        children: [
          /// 🔹 Tab Switch
          SizedBox(height: 20.h),

          /// 🔹 Commission Banner
          glassCard(
            child: Row(
              children: [
                const Icon(Icons.monetization_on, color: Color(0xFF06CE8F)),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    "Complete a task to earn Commission and Bonus",
                    style: GoogleFonts.poppins(
                      fontSize: 12.sp,
                      color: const Color(0xFF9CA3AF),
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    isLowToHigh = !isLowToHigh;
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white.withOpacity(0.08),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isLowToHigh ? Icons.arrow_upward : Icons.arrow_downward,
                        size: 16,
                        color: Colors.white,
                      ),
                      SizedBox(width: 6),
                      Text(
                        isLowToHigh ? "Low → High" : "High → Low",
                        style: GoogleFonts.poppins(
                          fontSize: 12.sp,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Spacer(),
              getBuyInrDepoState.when(
                data: (data) {
                  final status = data?.data?.status ?? false;

                  /// ❌ Status false → Hide Full Widget
                  if (status == false) {
                    return const SizedBox();
                  }
                  return Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () {
                        ref
                            .read(processBuyINRDepositeProvider.notifier)
                            .processBuyINRDeposite(
                              context: context,
                              orderId: data!.data!.lastData!.id.toString(),
                            );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 14.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.r),
                          color: const Color(0xFF06CE8F),
                        ),
                        child: Text(
                          "Processing",
                          style: GoogleFonts.poppins(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  );
                },
                error: (error, stackTrace) {
                  log(stackTrace.toString());
                  log(error.toString());
                  return Center(
                    child: Text(
                      error.toString(),
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                },
                loading:
                    () => SizedBox(
                      width: 20.w,
                      height: 20.h,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 1.5,
                        ),
                      ),
                    ),
              ),
            ],
          ),
          SizedBox(height: 12.h),

          loading
              ? const Center(
                child: CircularProgressIndicator(color: Colors.white),
              )
              : Expanded(
                child: ListView.builder(
                  // itemCount: deposits.length,
                  itemCount: sortedDeposits.length,
                  itemBuilder: (context, index) {
                    final item = sortedDeposits[index];
                    final amount =
                        double.tryParse(item['amount'].toString()) ?? 0;
                    final percentage =
                        double.tryParse(item['percentage'].toString()) ?? 0;

                    final quota = (amount * percentage) / 100;
                    final totalquota = amount + quota;

                    return Padding(
                      padding: EdgeInsets.only(bottom: 15.h),
                      child: glassCard(
                        child: Row(
                          children: [
                            /// LEFT DETAILS
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  /// Amount
                                  Text(
                                    "₹${item["amount"]} INR",
                                    style: GoogleFonts.poppins(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),

                                  SizedBox(height: 6.h),

                                  /// Percentage
                                  Text(
                                    // "Income ₹${quota + item["percentage"]} %",
                                    "Income $percentage% (₹${quota.toStringAsFixed(0)})",
                                    style: GoogleFonts.poppins(
                                      fontSize: 12.sp,
                                      color: const Color(0xFF9CA3AF),
                                    ),
                                  ),

                                  SizedBox(height: 4.h),

                                  /// Quota
                                  Text(
                                    // "Quota +${item["quota"]}",
                                    "Quota +$totalquota",
                                    style: GoogleFonts.poppins(
                                      fontSize: 12.sp,
                                      color: const Color(0xFF06CE8F),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            /// BUY BUTTON
                            InkWell(
                              onTap: () {
                                ref
                                    .read(
                                      processBuyINRDepositeProvider.notifier,
                                    )
                                    .processBuyINRDeposite(
                                      context: context,
                                      orderId: item["_id"].toString(),
                                    );
                              },
                              child: Container(
                                height: 38.h,
                                padding: EdgeInsets.symmetric(horizontal: 20.w),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.r),
                                  color: const Color(0xFF06CE8F),
                                ),
                                child: Center(
                                  child: Text(
                                    "Buy",
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
        ],
      ),
    );
  }

  Widget glassCard({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
          ),
          child: child,
        ),
      ),
    );
  }
}
