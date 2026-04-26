import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:payment_app/config/utils/showMessage.dart';
import 'package:payment_app/data/controller/sellTokenDetailsHistoryController.dart';

class TokenToTnrSellDetailsHistoryPage extends ConsumerStatefulWidget {
  final String id;

  const TokenToTnrSellDetailsHistoryPage({super.key, required this.id});

  @override
  ConsumerState<TokenToTnrSellDetailsHistoryPage> createState() =>
      _TokenToTnrSellDetailsHistoryPageState();
}

class _TokenToTnrSellDetailsHistoryPageState
    extends ConsumerState<TokenToTnrSellDetailsHistoryPage> {
  @override
  Widget build(BuildContext context) {
    final asyncData = ref.watch(sellTokenDetailsHistoryController(widget.id));

    return asyncData.when(
      /// 🔄 LOADING
      loading:
          () => const Scaffold(
            backgroundColor: Color(0xFF09111C),
            body: Center(child: CircularProgressIndicator()),
          ),

      /// ❌ ERROR
      error:
          (e, st) => Scaffold(
            backgroundColor: const Color(0xFF09111C),
            body: Center(
              child: Text(
                "Error: $e",
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),

      /// ✅ DATA
      data: (data) {
        final item = data.data;

        /// 🔹 STATUS COLOR
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
            statusText = "Approved";
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

          /// 🔹 APPBAR
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: const BackButton(color: Colors.white),
            title: Text(
              "Sell Detail",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 16.sp,
                color: Colors.white,
              ),
            ),
            actions: [
              Container(
                margin: EdgeInsets.only(right: 16.w),
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF06CE8F).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  item?.walletType ?? "USDT",
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF06CE8F),
                    fontWeight: FontWeight.w600,
                    fontSize: 11.sp,
                  ),
                ),
              ),
            ],
          ),

          /// 🔹 BODY
          body: RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(sellTokenDetailsHistoryController(widget.id));
            },
            child: ListView(
              padding: EdgeInsets.all(16.w),
              children: [
                _card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          _title("Order ID"),
                          Spacer(),

                          InkWell(
                            onTap: () {
                              final orderId = item?.orderId ?? "";
                              Clipboard.setData(ClipboardData(text: orderId));

                              ShowMessage.success(
                                context,
                                "Order ID copied",
                              ); // 👈 optional
                            },
                            borderRadius: BorderRadius.circular(6.r),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 5.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(6.r),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    item?.orderId ?? "-",
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 11.sp,
                                    ),
                                  ),
                                  SizedBox(width: 6.w),

                                  Icon(
                                    Icons.copy,
                                    size: 14.sp,
                                    color: Colors.white70,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 20.h),

                      _row(
                        "SELLING AMOUNT",
                        "${item?.amount ?? 0} TOKEN",
                        isBold: true,
                      ),
                      SizedBox(height: 10.h),
                      _row(
                        "EXCHANGE RATE",
                        "₹${item?.rate.toString() ?? "-"}",
                        isBold: true,
                      ),

                      SizedBox(height: 20.h),

                      _row(
                        "Total Settlement",
                        "₹${item?.totalAmount ?? 0}",
                        isBold: true,
                      ),

                      SizedBox(height: 15.h),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _label("Order Status"),
                          Row(
                            children: [
                              Container(
                                width: 6.w,
                                height: 6.w,
                                decoration: BoxDecoration(
                                  color: statusColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              SizedBox(width: 6.w),
                              Text(
                                statusText ?? "Pending",
                                style: GoogleFonts.poppins(
                                  color: statusColor,
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 18.h),

                /// PAYOUT CARD
                _card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _title("PAYOUT DESTINATION"),
                      SizedBox(height: 18.h),

                      _row("Method", item?.paymentMethods?.methodType ?? "-"),
                      SizedBox(height: 12.h),

                      if (item?.paymentMethods?.methodType == "UPI") ...[
                        _row(
                          "Holder Name",
                          item?.paymentMethods?.label ?? "-", // agar hai to
                        ),
                        SizedBox(height: 12.h),

                        _row(
                          "UPI ID",
                          item?.paymentMethods?.details?.upiId ?? "-",
                        ),
                        SizedBox(height: 12.h),
                      ] else if (item?.paymentMethods?.methodType ==
                          "BANK_TRANSFER") ...[
                        _row("Bank Name", item?.paymentMethods?.label ?? "-"),
                        SizedBox(height: 12.h),

                        _row(
                          "Account Number",
                          item?.paymentMethods?.details?.accountNumber ?? "-",
                        ),
                        SizedBox(height: 12.h),

                        _row(
                          "IFSC",
                          item?.paymentMethods?.details?.ifsc ?? "-",
                        ),
                        SizedBox(height: 12.h),

                        _row(
                          "Account Holder",
                          item?.paymentMethods?.details?.accountHolderName ??
                              "-",
                        ),
                        SizedBox(height: 12.h),
                      ],
                    ],
                  ),
                ),

                /// 🔹 PAYMENT TIMELINE
                if (item?.paidList != null && item!.paidList!.isNotEmpty) ...[
                  SizedBox(height: 20.h),

                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: item.paidList!.length,
                    itemBuilder: (context, index) {
                      final reverseIndex = item.paidList!.length - 1 - index;
                      final data = item.paidList![reverseIndex];

                      return _paymentTimelineCard(
                        amount: data.amount ?? 0,
                        utr: data.hash ?? "-",
                        time: data.createdAt ?? 0,
                        status: item.status ?? "process",
                      );
                    },
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0E1A2B), Color(0xFF09111C)],
        ),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: Colors.white.withOpacity(.05)),
      ),
      child: child,
    );
  }

  /// TITLE
  Widget _title(String text) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        color: Colors.white70,
        fontSize: 11.sp,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  /// LABEL
  Widget _label(String text) {
    return Text(
      text,
      style: GoogleFonts.poppins(color: Colors.white60, fontSize: 11.sp),
    );
  }

  /// ROW
  Widget _row(String title, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label(title),

        Text(
          value,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 12.sp,
            fontWeight: isBold ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ],
    );
  }

  /// AMOUNT BLOCK
  Widget _amountBlock(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(color: Colors.white60, fontSize: 10.sp),
        ),

        SizedBox(height: 6.h),

        Text(
          value,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _paymentTimelineCard({
    required int amount,
    required String utr,
    required int time,
    required String status,
  }) {
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
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0D2230), Color(0xFF071A24)],
        ),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔹 TOP ROW
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// LEFT
              Row(
                children: [
                  Container(
                    height: 8.w,
                    width: 8.w,
                    decoration: BoxDecoration(
                      color: statusColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    "RECEIVED AMOUNT",
                    style: GoogleFonts.poppins(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 10.sp,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),

             
            ],
          ),

          SizedBox(height: 8.h),

          /// 🔹 AMOUNT
          Text(
            "₹$amount",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 22.sp,
              fontWeight: FontWeight.w600,
            ),
          ),

          SizedBox(height: 14.h),

          /// 🔹 UTR BOX (More premium)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.35),
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(color: Colors.white.withOpacity(0.05)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "TRANSACTION UTR NUMBER",
                        style: GoogleFonts.poppins(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 9.sp,
                          letterSpacing: 1,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        utr,
                        style: GoogleFonts.poppins(
                          color: const Color(0xFF00D09C),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: utr));
                    ShowMessage.success(context, "Copied");
                  },
                  child: Container(
                    padding: EdgeInsets.all(8.sp),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.08),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.copy_rounded,
                      size: 14.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 12.h),

          /// 🔹 TIME
          Row(
            children: [
              Icon(
                Icons.access_time_rounded,
                size: 13.sp,
                color: Colors.white.withOpacity(0.5),
              ),
              SizedBox(width: 6.w),
              Text(
                "Paid on ${DateFormat('d MMM, hh:mm a').format(DateTime.fromMillisecondsSinceEpoch(time))}",
                style: GoogleFonts.poppins(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 10.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 🔹 COMMON ROW
  Widget _detailRow(
    String title,
    String value, {
    Color valueColor = Colors.white70,
    bool isBold = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120.w,
          child: Text(
            title,
            style: GoogleFonts.poppins(color: Colors.white38, fontSize: 12.sp),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.poppins(
              color: valueColor,
              fontSize: 13.sp,
              fontWeight: isBold ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
