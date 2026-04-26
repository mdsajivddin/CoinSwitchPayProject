import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:payment_app/Screen/inrToTokenBuyDetailsHistory.page.dart';
import 'package:payment_app/Screen/tokenToInrSellDetailsHistory.page.dart';
import 'package:payment_app/config/auth/router/rightsliderFageRoute.dart';
import 'package:payment_app/data/controller/inrToTokenBuyHistoryConroller.dart';

class TokenToInrSellHistoryPage extends ConsumerStatefulWidget {
  const TokenToInrSellHistoryPage({super.key});

  @override
  ConsumerState<TokenToInrSellHistoryPage> createState() =>
      _TokenToInrSellHistoryPageState();
}

class _TokenToInrSellHistoryPageState
    extends ConsumerState<TokenToInrSellHistoryPage> {
  String selectedWallet = "USDT";

  @override
  Widget build(BuildContext context) {
    final tokenToInrSellState = ref.watch(tokenToInrSellHistoryControlelr);

    return Scaffold(
      backgroundColor: const Color(0xFF09111C),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
        title: Text(
          "Sell History",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 17.sp,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {
              ref.invalidate(tokenToInrSellHistoryControlelr);
            },
            icon: const Icon(Icons.refresh, color: Colors.white70),
          ),
        ],
      ),
      body: tokenToInrSellState.when(
        data: (data) {
          final list = data?.data?.list ?? [];

          if (list.isEmpty) {
            return _buildEmptyState();
          }

          return RefreshIndicator(
            color: const Color(0xFF06CE8F),
            onRefresh: () async {
              ref.invalidate(tokenToInrSellHistoryControlelr);
            },
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              itemCount: list.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      RightSlideFadeRoute(
                        page: TokenToTnrSellDetailsHistoryPage(
                          id: list[index].id.toString(),
                        ),
                      ),
                    );
                  },
                  child: _modernTransactionCard(list[index]),
                );
              },
            ),
          );
        },
        loading:
            () => const Center(
              child: CircularProgressIndicator(color: Color(0xFF06CE8F)),
            ),
        error: (err, stack) {
          log(stack.toString());
          return const Center(
            child: Text(
              "Something went wrong",
              style: TextStyle(color: Colors.redAccent),
            ),
          );
        },
      ),
    );
  }

  // 🔥 Modern Card Design
  Widget _modernTransactionCard(dynamic item) {
    final status = item.status?.toString().toLowerCase() ?? "";

    // Color statusColor;
    // switch (status.toLowerCase()) {
    //   case "pending":
    //     statusColor = const Color(0xFFF59E0B); // yellow
    //     break;

    //   case "process":
    //   case "processing":
    //     statusColor = const Color(0xFF3B82F6); // blue
    //     break;

    //   case "approve":
    //     statusColor = const Color(0xFF00FF9D); // green neon
    //     break;

    //   case "reject":
    //     statusColor = const Color(0xFFEF4444); // red
    //     break;

    //   case "cancel":
    //     statusColor = const Color(0xFF9CA3AF); // gray
    //     break;

    //   case "expired":
    //     statusColor = const Color(0xFFEF4444); // red (same as reject)
    //     break;

    //   default:
    //     statusColor = Colors.white54;
    // }
    Color statusColor;
    String statusText;

    switch (status.toLowerCase()) {
      case "pending":
        statusColor = const Color(0xFFF59E0B);
        statusText = "Pending";
        break;

      case "process":
      case "processing":
        statusColor = const Color(0xFF3B82F6);
        statusText = "Processing";
        break;

      case "approve":
        statusColor = const Color(0xFF00FF9D);
        statusText = "Approved"; // 👈 yahi change chahiye tha
        break;

      case "reject":
        statusColor = const Color(0xFFEF4444);
        statusText = "Rejected";
        break;

      case "cancel":
        statusColor = const Color(0xFF9CA3AF);
        statusText = "Cancelled";
        break;

      case "expired":
        statusColor = const Color(0xFFEF4444);
        statusText = "Expired";
        break;

      default:
        statusColor = Colors.white54;
        statusText = status;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 15.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF111B2E),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Icon Box
          Container(
            height: 45.w,
            width: 45.w,
            decoration: BoxDecoration(
              color: const Color(0xFF06CE8F).withOpacity(0.15),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: const Icon(
              Icons.arrow_downward_rounded,
              color: Color(0xFF06CE8F),
            ),
          ),

          SizedBox(width: 15.w),

          // Middle Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Sell",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  item.createdAt != null
                      ? DateFormat('dd MMM yyyy, hh:mm a').format(
                        DateTime.fromMillisecondsSinceEpoch(item.createdAt),
                      )
                      : "Date N/A",
                  style: GoogleFonts.poppins(
                    color: Colors.white38,
                    fontSize: 11.sp,
                  ),
                ),
              ],
            ),
          ),

          // Right Side
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "-${item.amount} TOKEN",
                style: GoogleFonts.poppins(
                  color: const Color(0xFF06CE8F),
                  fontWeight: FontWeight.bold,
                  fontSize: 15.sp,
                ),
              ),
              SizedBox(height: 5.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  statusText,
                  style: GoogleFonts.poppins(
                    color: statusColor,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history_toggle_off, size: 60.sp, color: Colors.white24),
          SizedBox(height: 10.h),
          Text(
            "No transactions found",
            style: GoogleFonts.poppins(color: Colors.white38),
          ),
        ],
      ),
    );
  }
}
