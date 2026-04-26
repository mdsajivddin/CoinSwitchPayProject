// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:intl/intl.dart';

// import '../data/model/usdtDepositeHistoryModel.dart';

// class UsdtDepositeHisDetailsPage extends StatelessWidget {
//   final Datum item; // pass transaction model here

//   const UsdtDepositeHisDetailsPage({super.key, required this.item});

//   @override
//   Widget build(BuildContext context) {
//     final status = item.status?.toLowerCase() ?? "process";

//     // Color statusColor;
//     // switch (status.toLowerCase()) {
//     //   case "pending":
//     //     statusColor = const Color(0xFFF59E0B); // yellow
//     //     break;
//     //   case "process":
//     //   case "processing":
//     //     statusColor = const Color(0xFF3B82F6); // blue
//     //     break;

//     //   case "approve":
//     //     statusColor = const Color(0xFF00FF9D); // green neon
//     //     break;

//     //   case "reject":
//     //     statusColor = const Color(0xFFEF4444); // red
//     //     break;

//     //   case "cancel":
//     //     statusColor = const Color(0xFF9CA3AF); // gray
//     //     break;

//     //   case "expired":
//     //     statusColor = const Color(0xFFEF4444); // red (same as reject)
//     //     break;

//     //   default:
//     //     statusColor = Colors.white54;
//     // }

//     Color statusColor;
//     String statusText;
//     switch (status.toLowerCase()) {
//       case "pending":
//         statusColor = const Color(0xFFF59E0B);
//         statusText = "Pending";
//         break;

//       case "process":
//       case "processing":
//         statusColor = const Color(0xFF3B82F6);
//         statusText = "Processing";
//         break;

//       case "approve":
//         statusColor = const Color(0xFF00FF9D);
//         statusText = "Approved"; // 👈 yahi change chahiye tha
//         break;

//       case "reject":
//         statusColor = const Color(0xFFEF4444);
//         statusText = "Rejected";
//         break;

//       case "cancel":
//         statusColor = const Color(0xFF9CA3AF);
//         statusText = "Cancelled";
//         break;

//       case "expired":
//         statusColor = const Color(0xFFEF4444);
//         statusText = "Expired";
//         break;

//       default:
//         statusColor = Colors.white54;
//         statusText = status;
//     }

//     return Scaffold(
//       backgroundColor: const Color(0xFF09111C),
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: const BackButton(color: Colors.white),
//         title: Text(
//           "Deposit Detail",
//           style: GoogleFonts.poppins(
//             fontWeight: FontWeight.w600,
//             fontSize: 17.sp,
//             color: Colors.white,
//           ),
//         ),
//         actions: [
//           Container(
//             margin: EdgeInsets.only(right: 16.w),
//             padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
//             decoration: BoxDecoration(
//               color: const Color(0xFF06CE8F).withOpacity(0.15),
//               borderRadius: BorderRadius.circular(20.r),
//             ),
//             child: Text(
//               item.walletType ?? "USDT",
//               style: GoogleFonts.poppins(
//                 color: const Color(0xFF06CE8F),
//                 fontWeight: FontWeight.w600,
//                 fontSize: 12.sp,
//               ),
//             ),
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(16.w),
//         child: Container(
//           padding: EdgeInsets.all(18.w),
//           decoration: BoxDecoration(
//             color: const Color(0xFF111B2E),
//             borderRadius: BorderRadius.circular(20.r),
//             border: Border.all(color: Colors.white.withOpacity(0.05)),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               /// Amount
//               _detailRow(
//                 "Amount",
//                 "${item.amount ?? 0} ${item.walletType ?? "USDT"}",
//                 valueColor: Colors.white,
//                 isBold: true,
//               ),

//               SizedBox(height: 18.h),

//               /// Status
//               _detailRow(
//                 "Status",
//                 statusText ?? "process",
//                 valueColor: statusColor,
//               ),

//               SizedBox(height: 18.h),

//               /// Network
//               _detailRow("Network", item.network ?? "-"),

//               SizedBox(height: 18.h),

//               /// Wallet Address
//               _detailRow("Wallet Address", item.walletAddress ?? "-"),

//               SizedBox(height: 18.h),

//               /// Hash
//               _detailRow("Hash", item.hash ?? "-"),

//               SizedBox(height: 18.h),

//               /// Created Date
//               _detailRow(
//                 "Created",
//                 DateFormat('d/M/yyyy, hh:mm:ss a').format(
//                   DateTime.fromMillisecondsSinceEpoch(item.createdAt ?? 0),
//                 ),
//               ),

//               if (item.status == "reject" &&
//                   item.rejectReason != null &&
//                   item.rejectReason!.isNotEmpty) ...[
//                 SizedBox(height: 18.h),
//                 _detailRow(
//                   "Reject Reason",
//                   item.rejectReason!,
//                   valueColor: Colors.red,
//                 ),
//               ],

//               SizedBox(height: 25.h),

//               Text(
//                 "DEPOSIT PROOF",
//                 style: GoogleFonts.poppins(
//                   color: Colors.white38,
//                   fontWeight: FontWeight.w600,
//                   fontSize: 11.sp,
//                   letterSpacing: 1,
//                 ),
//               ),

//               SizedBox(height: 12.h),

//               ClipRRect(
//                 borderRadius: BorderRadius.circular(15.r),
//                 child: Container(
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Colors.white.withOpacity(0.08)),
//                   ),
//                   child: Image.network(
//                     item.image ?? "",
//                     fit: BoxFit.cover,
//                     errorBuilder:
//                         (_, __, ___) => const SizedBox(
//                           height: 150,
//                           child: Center(
//                             child: Text(
//                               "No Image",
//                               style: TextStyle(color: Colors.white38),
//                             ),
//                           ),
//                         ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _detailRow(
//     String title,
//     String value, {
//     Color valueColor = Colors.white70,
//     bool isBold = false,
//   }) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         SizedBox(
//           width: 120.w,
//           child: Text(
//             title,
//             style: GoogleFonts.poppins(color: Colors.white38, fontSize: 13.sp),
//           ),
//         ),
//         Expanded(
//           child: Text(
//             value,
//             style: GoogleFonts.poppins(
//               color: valueColor,
//               fontSize: 13.sp,
//               fontWeight: isBold ? FontWeight.w600 : FontWeight.w500,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:payment_app/config/utils/showMessage.dart';
import '../data/model/usdtDepositeHistoryModel.dart';

class UsdtDepositeHisDetailsPage extends StatelessWidget {
  final Datum item;

  const UsdtDepositeHisDetailsPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final status = item.status?.toLowerCase() ?? "process";

    Color statusColor;
    String statusText;

    switch (status) {
      case "pending":
        statusColor = const Color(0xFFF59E0B);
        statusText = "PENDING";
        break;
      case "approve":
        statusColor = const Color(0xFF06CE8F); // Neon Green
        statusText = "APPROVED";
        break;
      case "reject":
        statusColor = const Color(0xFFEF4444);
        statusText = "REJECTED";
        break;
      default:
        statusColor = const Color(0xFF3B82F6);
        statusText = status.toUpperCase();
    }

    return Scaffold(
      backgroundColor: const Color(0xFF09111C),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Deposit Detail",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            fontSize: 18.sp,
            color: Colors.white,
          ),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 16.w, top: 12.h, bottom: 12.h),
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            decoration: BoxDecoration(
              color: const Color(0xFF06CE8F).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: const Color(0xFF06CE8F).withOpacity(0.3),
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              item.walletType ?? "USDT",
              style: GoogleFonts.poppins(
                color: const Color(0xFF06CE8F),
                fontWeight: FontWeight.w600,
                fontSize: 12.sp,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        child: Column(
          children: [
            /// 1. TOP AMOUNT CARD
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: const Color(0xFF111B2E),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: Colors.white.withOpacity(0.05)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "TOTAL AMOUNT",
                    style: GoogleFonts.poppins(
                      color: Colors.white38,
                      fontWeight: FontWeight.w600,
                      fontSize: 11.sp,
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    "${item.amount ?? 0} ${item.walletType ?? "USDT"}",
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF06CE8F),
                      fontWeight: FontWeight.w800,
                      fontSize: 32.sp,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 18.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(25.r),
                    ),
                    child: Text(
                      statusText,
                      style: GoogleFonts.poppins(
                        color: statusColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 16.h),

            /// 2. DETAILS LIST CARD
            Container(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              decoration: BoxDecoration(
                color: const Color(0xFF111B2E),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: Colors.white.withOpacity(0.05)),
              ),
              child: Column(
                children: [
                  _infoTile(
                    icon: Icons.tag,
                    label: "ORDER ID",
                    value: item.orderId ?? "-",
                    showCopy: true,
                    context: context,
                  ),
                  _divider(),
                  _infoTile(
                    icon: Icons.tag,
                    label: "HASH",
                    value: item.hash ?? "-",
                    context: context,
                  ),
                  // _divider(),
                  // _infoTile(
                  //   icon: Icons.wifi,
                  //   label: "NETWORK",
                  //   value: item.network ?? "TRC20",
                  //   context: context,
                  // ),
                  _divider(),
                  _infoTile(
                    icon: Icons.account_balance_wallet_outlined,
                    label: "WALLET ADDRESS",
                    value: item.walletAddress ?? "-",
                    context: context,
                  ),
                  _divider(),
                  _infoTile(
                    icon: Icons.calendar_today_outlined,
                    label: "DATE & TIME",
                    value: DateFormat('dd MMM yyyy, hh:mm a').format(
                      DateTime.fromMillisecondsSinceEpoch(item.createdAt ?? 0),
                    ),
                    context: context,
                  ),
                ],
              ),
            ),

            SizedBox(height: 16.h),

            /// 3. DEPOSIT PROOF CARD
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: const Color(0xFF111B2E),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: Colors.white.withOpacity(0.05)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.insert_drive_file_outlined,
                        color: Colors.white38,
                        size: 16.sp,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        "DEPOSIT PROOF",
                        style: GoogleFonts.poppins(
                          color: Colors.white38,
                          fontWeight: FontWeight.w600,
                          fontSize: 11.sp,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: Image.network(
                      item.image ?? "",
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (_, __, ___) => Container(
                            height: 150.h,
                            color: Colors.white.withOpacity(0.02),
                            child: const Center(
                              child: Text(
                                "Proof Image Not Available",
                                style: TextStyle(color: Colors.white24),
                              ),
                            ),
                          ),
                    ),
                  ),
                ],
              ),
            ),

            // Reject Reason (Only shows if rejected)
            if (status == "reject" && item.rejectReason != null) ...[
              SizedBox(height: 16.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: Colors.red.withOpacity(0.2)),
                ),
                child: Text(
                  "Reason: ${item.rejectReason}",
                  style: GoogleFonts.poppins(
                    color: Colors.redAccent,
                    fontSize: 13.sp,
                  ),
                ),
              ),
            ],
            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }

  Widget _infoTile({
    required IconData icon,
    required String label,
    required String value,
    bool showCopy = false,
    required BuildContext context,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white38, size: 18.sp),
          SizedBox(width: 12.w),
          Text(
            label,
            style: GoogleFonts.poppins(
              color: Colors.white38,
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Text(
                    value,
                    textAlign: TextAlign.right,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (showCopy) ...[
                  SizedBox(width: 6.w),
                  GestureDetector(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: value));
                      ShowMessage.success(context, "$value Copied!");
                    },
                    child: Icon(
                      Icons.copy_rounded,
                      color: Colors.white38,
                      size: 16.sp,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Divider(
      color: Colors.white.withOpacity(0.05),
      height: 1,
      indent: 16.w,
      endIndent: 16.w,
    );
  }
}
