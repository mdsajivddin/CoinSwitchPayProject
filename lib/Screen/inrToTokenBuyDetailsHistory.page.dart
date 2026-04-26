import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:payment_app/data/controller/getDepositeDetailsController.dart';

class InrToTokenBuyDetailsHistoryPage extends ConsumerStatefulWidget {
  final String id;

  const InrToTokenBuyDetailsHistoryPage({super.key, required this.id});

  @override
  ConsumerState<InrToTokenBuyDetailsHistoryPage> createState() =>
      _InrToTokenBuyDetailsHistoryPageState();
}

class _InrToTokenBuyDetailsHistoryPageState
    extends ConsumerState<InrToTokenBuyDetailsHistoryPage> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(getdepositeDetislController(widget.id));

    return state.when(
      loading:
          () => const Scaffold(
            backgroundColor: Color(0xFF09111C),
            body: Center(child: CircularProgressIndicator()),
          ),
      error: (e, st) {
        log(st.toString());
        return Center(
          child: Text("Error: $e", style: const TextStyle(color: Colors.white)),
        );
      },
      data: (data) {
        final item = data.data;
        final status = item?.status?.toLowerCase() ?? "process";

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

        return Scaffold(
          backgroundColor: const Color(0xFF09111C),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: const BackButton(color: Colors.white),
            title: Text(
              "Deposit Detail",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 16.sp,
                color: Colors.white,
              ),
            ),
            actions: [
              Container(
                margin: EdgeInsets.only(right: 16.w),
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF06CE8F).withOpacity(.15),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  item?.walletType ?? "INR",
                  style: GoogleFonts.poppins(
                    fontSize: 11.sp,
                    color: const Color(0xFF06CE8F),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                /// TOP CARD
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(18.w),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0F1C2E), Color(0xFF0A1624)],
                    ),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: Colors.orange.withOpacity(.4)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "TOTAL AMOUNT",
                        style: GoogleFonts.poppins(
                          color: Colors.white38,
                          fontSize: 10.sp,
                          letterSpacing: 1,
                        ),
                      ),

                      SizedBox(height: 6.h),

                      Text(
                        "${item?.amount?.toStringAsFixed(0) ?? 0} TOKEN",
                        style: GoogleFonts.poppins(
                          fontSize: 28.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF06CE8F),
                        ),
                      ),

                      SizedBox(height: 14.h),

                      Divider(color: Colors.white12),
                      SizedBox(height: 12.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "RATE / %",
                                style: GoogleFonts.poppins(
                                  color: Colors.white38,
                                  fontSize: 10.sp,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                "${item!.rate?.toStringAsFixed(0) ?? 0}%",
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "ORDER AMOUNT",
                                style: GoogleFonts.poppins(
                                  color: Colors.white38,
                                  fontSize: 10.sp,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                "₹${item?.realAmount?.toStringAsFixed(0) ?? 0}",
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 14.h),

                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 14.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(.15),
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(color: statusColor),
                        ),
                        child: Text(
                          statusText,
                          style: GoogleFonts.poppins(
                            color: statusColor,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 6.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFF111B2E),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Column(
                    children: [
                      _detailTile("ORDER ID", item?.orderId ?? "-"),
                      _detailTile("UTR", item?.hash ?? "N/A"),
                      _detailTile("HOLDER NAME", item?.upiHolder ?? "N/A"),
                      _detailTile("UPI", item?.upi ?? "-"),
                      // _detailTile(
                      //   "WALLET ADDRESS",
                      //   item?.walletAddress ?? "-",
                      //   isWrap: true,
                      // ),
                      _detailTile(
                        "DATE & TIME",
                        DateFormat('d MMM yyyy, hh:mm a').format(
                          DateTime.fromMillisecondsSinceEpoch(
                            item?.createdAt ?? 0,
                          ),
                        ),
                        isLast: true,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 22.h),

                /// PROOF TITLE
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "DEPOSIT PROOF",
                    style: GoogleFonts.poppins(
                      color: Colors.white38,
                      fontWeight: FontWeight.w600,
                      fontSize: 11.sp,
                      letterSpacing: 1,
                    ),
                  ),
                ),

                SizedBox(height: 12.h),

                /// IMAGE
                ClipRRect(
                  borderRadius: BorderRadius.circular(15.r),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white.withOpacity(.08)),
                    ),
                    child: Image.network(
                      item?.image ?? "",
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          width: double.infinity,
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 1.5,
                            ),
                          ),
                        );
                      },
                      errorBuilder:
                          (_, __, ___) => const SizedBox(
                            height: 200,
                            child: Center(
                              child: Text(
                                "No Image",
                                style: TextStyle(color: Colors.white38),
                              ),
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
    );
  }

  Widget _detailTile(
    String title,
    String value, {
    bool isLast = false,
    bool isWrap = false,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        border:
            isLast
                ? null
                : Border(
                  bottom: BorderSide(
                    color: Colors.white.withOpacity(0.08),
                    width: 1,
                  ),
                ),
      ),
      child: Row(
        crossAxisAlignment:
            isWrap ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Text("#  ", style: TextStyle(color: Colors.white38, fontSize: 12.sp)),

          /// TITLE
          Expanded(
            flex: 4,
            child: Text(
              title,
              style: GoogleFonts.poppins(
                color: Colors.white38,
                fontSize: 11.5.sp,
                letterSpacing: 0.5,
              ),
            ),
          ),

          /// VALUE
          Expanded(
            flex: 6,
            child: Text(
              value,
              textAlign: TextAlign.right,
              maxLines: isWrap ? 2 : 1,
              overflow: isWrap ? TextOverflow.visible : TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 12.5.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
