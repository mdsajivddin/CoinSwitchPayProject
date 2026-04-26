import 'dart:developer';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:payment_app/data/controller/getWalletController.dart';
import 'package:payment_app/data/controller/profileController.dart';

class WalletPage extends ConsumerStatefulWidget {
  const WalletPage({super.key});

  @override
  ConsumerState<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends ConsumerState<WalletPage> {
  /// 🎨 Theme Colors (Matching OrderProcessingPage)
  final Color bgColor = const Color(0xFF09111C);

  final Color accentIndigo = const Color(0xFF4F6EF7);

  final Color textGrey = const Color(0xFF9CA3AF);

  final Color successGreen = const Color(0xFF06CE8F);

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.refresh(getWalletProvider);
      ref.refresh(commissionController);
    });
  }

  @override
  Widget build(BuildContext context) {
    final walletState = ref.watch(getWalletProvider);
    final commissionState = ref.watch(commissionController);
    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        children: [
          /// 🔹 Background Radial Gradient
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
            child: Column(
              children: [
                /// 🔹 Header
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 15.h,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Wallet",
                        style: GoogleFonts.poppins(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      ref.read(getWalletProvider.notifier).getWallet();
                      ref.invalidate(commissionController);
                    },
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: walletState.when(
                        data: (data) {
                          // final totalUsdt = data!.data!.totalUsdt ?? 0.0;
                          // final totalToken = data.data!.totalToken ?? 0.0;
                          // final usdtBuy = data.data!.stats!.usdtBuy ?? 0;
                          // final tokenBuy = data.data!.stats!.tokenBuy ?? 0;
                          // final usdtSold = data.data!.stats!.usdtSold ?? 0;
                          // final tokenSold = data.data!.stats!.tokenSold ?? 0;
                          // final tokenSelling =
                          //     data.data!.activeSelling!.tokenSelling ?? 0;
                          // final usdtSelling =
                          //     data.data!.activeSelling!.usdtSelling ?? 0;

                          // final totalUsdtCommission =
                          //     data.data!.totalUsdtCommission ?? 0;
                          // final totalTokenCommission =
                          //     data.data!.totalTokenCommission ?? 0;

                          final totalUsdt = data!.data!.totalUsdt ?? 0.0;
                          final totalToken = data.data!.totalToken ?? 0.0;

                          final usdtBuy = data.data!.stats!.usdtBuy ?? 0.0;
                          final tokenBuy = data.data!.stats!.tokenBuy ?? 0.0;
                          final usdtSold = data.data!.stats!.usdtSold ?? 0.0;
                          final tokenSold = data.data!.stats!.tokenSold ?? 0.0;

                          final tokenSelling =
                              data.data!.activeSelling!.tokenSelling ?? 0.0;
                          final usdtSelling =
                              data.data!.activeSelling!.usdtSelling ?? 0.0;

                          final totalUsdtCommission =
                              data.data!.totalUsdtCommission ?? 0.0;
                          final totalTokenCommission =
                              data.data!.totalTokenCommission ?? 0.0;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// 🔹 Main Balance Card
                              balanceCard(
                                title: "Available USDT Balance",
                                amount: "${totalUsdt.toStringAsFixed(2)} USDT",

                                icon: Icons.account_balance_wallet,
                                isFullWidth: true,
                              ),
                              SizedBox(height: 15.h),
                              balanceCard(
                                title: "Available TOKEN Balance",
                                amount: "$totalToken TOKEN",

                                icon: Icons.account_balance_wallet,
                                isFullWidth: true,
                              ),

                              SizedBox(height: 25.h),
                              sectionTitle("Today's Activity"),

                              /// 🔹 Activity Grid
                              Row(
                                children: [
                                  Expanded(
                                    child: AspectRatio(
                                      aspectRatio: 1.6,
                                      child: activityCard(
                                        Icons.trending_up,
                                        Color(0xFF06CE8F),
                                        "Today Buy & Deposit",
                                        "+${usdtBuy.toStringAsFixed(0)}",
                                        "USDT",
                                        successGreen,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  Expanded(
                                    child: AspectRatio(
                                      aspectRatio: 1.6,
                                      child: activityCard(
                                        Icons.trending_up,
                                        Color(0xFF06CE8F),
                                        "Today Buy Tokens",
                                        "+${tokenBuy.toStringAsFixed(0)}",
                                        "Tokens",
                                        successGreen,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12.h),
                              Row(
                                children: [
                                  Expanded(
                                    child: AspectRatio(
                                      aspectRatio: 1.6,
                                      child: activityCard(
                                        Icons.trending_down,
                                        Colors.redAccent,
                                        "Today Sold USDT",
                                        "-${usdtSold.toStringAsFixed(0)}",
                                        "USDT",
                                        Colors.redAccent,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  Expanded(
                                    child: AspectRatio(
                                      aspectRatio: 1.6,
                                      child: activityCard(
                                        Icons.trending_down,
                                        Colors.redAccent,
                                        "Today Sold Tokens",
                                        "-${tokenSold.toStringAsFixed(0)}",
                                        "Tokens",
                                        Colors.redAccent,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: 25.h),
                              sectionTitle("Team Earnings"),

                              commissionState.when(
                                data: (data) {
                                  return Column(
                                    children: [
                                      teamCard(
                                        title: "TEAM EARNINGs USDT",
                                        leftTitle: "Today Team Commission",
                                        leftAmount:
                                            "${data.data?.usdtAmount ?? 0}",
                                        rightTitle: "Total Team Commission",
                                        rightAmount:
                                            "${totalUsdtCommission.toStringAsFixed(0)}",
                                      ),
                                      SizedBox(height: 25.h),
                                      teamCard(
                                        title: "TEAM EARNINGs TOKEN",
                                        leftTitle: "Today Team Commission",
                                        leftAmount:
                                            "${data.data?.tokenAmount ?? 0}",
                                        rightTitle: "Total Team Commission",
                                        rightAmount:
                                            "${totalTokenCommission.toStringAsFixed(0)}",
                                      ),
                                    ],
                                  );
                                },
                                error: (error, stackTrace) {
                                  return Center(
                                    child: Text(
                                      error.toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  );
                                },
                                loading:
                                    () => const Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    ),
                              ),

                              SizedBox(height: 25.h),

                              activeSellingCard(
                                "Active Selling",
                                "${tokenSelling.toStringAsFixed(0)}",
                                "${usdtSelling.toStringAsFixed(0)}",
                              ),
                              SizedBox(height: 30.h),
                            ],
                          );
                        },
                        error: (error, stackTrace) {
                          print(error.toString());
                          print(stackTrace.toString());
                          Center(child: Text(error.toString()));
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 🔹 Glassmorphism Card Wrapper (Dark Theme)
  Widget glassEffect({required Widget child}) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.white.withOpacity(0.08), width: 1),
      ),
      child: child,
    );
  }

  Widget sectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 15.sp,
          fontWeight: FontWeight.w500,
          color: textGrey,
        ),
      ),
    );
  }

  /// 🔹 Balance Card Component
  Widget balanceCard({
    required String title,
    required String amount,

    required IconData icon,
    Color iconColor = Colors.blueAccent,
    bool isFullWidth = false,
  }) {
    return glassEffect(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18.sp, color: iconColor),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.poppins(fontSize: 11.sp, color: textGrey),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          RichText(
            text: TextSpan(
              style: GoogleFonts.poppins(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              children: [
                TextSpan(
                  text: amount,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget activityCard(
    IconData icon,
    Color iconColor,
    String title,
    String amount,
    String type,
    Color color,
  ) {
    return glassEffect(
      child: Padding(
        padding: EdgeInsets.all(8.w), // ✅ thoda compact padding
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: iconColor, size: 16), // ✅ icon small
            SizedBox(width: 6.w),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// 🔹 Title (MOST IMPORTANT FIX)
                  Flexible(
                    child: Text(
                      title,
                      maxLines: 2, // ✅ limit lines
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: 10.sp, // ✅ thoda small
                        color: textGrey,
                      ),
                    ),
                  ),

                  /// 🔹 Amount
                  Text(
                    amount,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 12.sp, // ✅ reduce size
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),

                  /// 🔹 Type
                  Text(
                    type,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w500,
                      color: textGrey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔹 Today Activity Card
  // Widget activityCard(
  //   IconData icon,
  //   Color iconColor,
  //   String title,
  //   String amount,
  //   String type,
  //   Color color,
  // ) {
  //   return glassEffect(
  //     child: Row(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Icon(icon, color: iconColor, size: 18),
  //         SizedBox(width: 5.w),
  //         Expanded(
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text(
  //                 title,
  //                 style: GoogleFonts.poppins(fontSize: 11.sp, color: textGrey),
  //               ),
  //               SizedBox(height: 5.h),
  //               Text(
  //                 "$amount",
  //                 style: GoogleFonts.poppins(
  //                   fontSize: 13.sp,
  //                   fontWeight: FontWeight.w600,
  //                   color: color,
  //                 ),
  //               ),
  //               SizedBox(height: 5.h),
  //               Text(
  //                 "$type",
  //                 style: GoogleFonts.poppins(
  //                   fontSize: 13.sp,
  //                   fontWeight: FontWeight.w600,
  //                   color: textGrey,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  /// 🔹 Team Card (Single Container)
  Widget teamCard({
    required String title,
    required String leftTitle,
    required String leftAmount,
    required String rightTitle,
    required String rightAmount,
  }) {
    return glassEffect(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: textGrey,
            ),
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              /// Left Block
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.emoji_events_outlined,
                          color: const Color(0xFF06CE8F),
                          size: 18.sp,
                        ),
                        SizedBox(width: 6.w),
                        Expanded(
                          child: Text(
                            leftTitle.toUpperCase(),
                            style: GoogleFonts.poppins(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w600,
                              color: textGrey,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      leftAmount,
                      style: GoogleFonts.poppins(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF06CE8F),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(width: 20.w),

              /// Right Block
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.emoji_events_outlined,
                          color: Colors.orange,
                          size: 18.sp,
                        ),
                        SizedBox(width: 6.w),
                        Expanded(
                          child: Text(
                            rightTitle.toUpperCase(),
                            style: GoogleFonts.poppins(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w600,
                              color: textGrey,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      rightAmount,
                      style: GoogleFonts.poppins(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 🔹 Active Selling Card
  Widget activeSellingCard(String title, String tokenCount, String usdtCount) {
    return glassEffect(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Title
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
              color: textGrey,
            ),
          ),

          SizedBox(height: 15.h),

          /// Token Selling
          _sellingRow(
            "Active Token Selling",
            tokenCount,
            Icons.bolt,
            accentIndigo,
          ),

          SizedBox(height: 12.h),

          /// USDT Selling
          _sellingRow(
            "Active USDT Selling",
            usdtCount,
            Icons.account_balance_wallet_outlined,
            const Color(0xFF00E6A8),
          ),
        ],
      ),
    );
  }

  /// 🔹 Inner Row
  Widget _sellingRow(
    String subtitle,
    String count,
    IconData icon,
    Color iconColor,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: const Color(0xFF0B1622),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        children: [
          /// Icon Circle
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: iconColor.withOpacity(0.15),
            ),
            child: Icon(icon, size: 18.sp, color: iconColor),
          ),

          SizedBox(width: 12.w),

          /// Subtitle
          Expanded(
            child: Text(
              subtitle,
              style: GoogleFonts.poppins(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),

          /// Orders Badge
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: const Color(0xFF00E6A8).withOpacity(0.15),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              "$count Orders",
              style: GoogleFonts.poppins(
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF00E6A8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
