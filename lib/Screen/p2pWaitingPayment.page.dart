// // import 'package:flutter/cupertino.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_screenutil/flutter_screenutil.dart';
// // import 'package:google_fonts/google_fonts.dart';
// // import 'package:payment_app/Screen/paymentRecive.page.dart';
// // import 'package:payment_app/config/auth/router/rightsliderFageRoute.dart';

// // class P2pWaitingPaymentPage extends StatelessWidget {
// //   const P2pWaitingPaymentPage({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: const Color(0xFF09111C),
// //       body: Stack(
// //         children: [
// //           // Background Gradient matching the app theme
// //           Container(
// //             decoration: const BoxDecoration(
// //               gradient: RadialGradient(
// //                 center: Alignment(-0.8, -0.8),
// //                 radius: 1.5,
// //                 colors: [Color(0xFF1A2A3A), Color(0xFF09111C)],
// //               ),
// //             ),
// //           ),
// //           SafeArea(
// //             child: Column(
// //               children: [
// //                 _buildAppBar(),
// //                 Expanded(
// //                   child: SingleChildScrollView(
// //                     physics: const BouncingScrollPhysics(),
// //                     padding: EdgeInsets.symmetric(horizontal: 24.w),
// //                     child: Column(
// //                       children: [
// //                         SizedBox(height: 20.h),

// //                         // --- Illustration Section ---
// //                         _buildIllustrationSection(),

// //                         SizedBox(height: 30.h),

// //                         // --- Status Message ---
// //                         Text(
// //                           "Waiting for Buyer's Payment...",
// //                           textAlign: TextAlign.center,
// //                           style: GoogleFonts.poppins(
// //                             color: Colors.white,
// //                             fontSize: 18.sp,
// //                             fontWeight: FontWeight.w700,
// //                           ),
// //                         ),
// //                         SizedBox(height: 10.h),
// //                         Text(
// //                           "Please wait while BTCX India completes the payment. You will be notified once the transfer is done.",
// //                           textAlign: TextAlign.center,
// //                           style: GoogleFonts.poppins(
// //                             color: const Color(0xFF9CA3AF),
// //                             fontSize: 12.sp,
// //                             height: 1.5,
// //                           ),
// //                         ),

// //                         SizedBox(height: 32.h),

// //                         // --- Order Details Card ---
// //                         _buildOrderDetailsCard(),

// //                         SizedBox(height: 20.h),

// //                         // --- Receiving Account Info (Glassmorphism) ---
// //                         _buildAccountInfoCard(),

// //                         SizedBox(height: 40.h),

// //                         // --- Action Button (Dispute) ---
// //                         _buildDisputeButton(context),

// //                         SizedBox(height: 16.h),
// //                         TextButton(
// //                           onPressed: () {},
// //                           child: Text(
// //                             "Contact Support",
// //                             style: GoogleFonts.poppins(
// //                               color: const Color(0xFF06CE8F),
// //                               fontWeight: FontWeight.w600,
// //                               fontSize: 14.sp,
// //                               decoration: TextDecoration.underline,
// //                             ),
// //                           ),
// //                         ),
// //                         SizedBox(height: 20.h),
// //                       ],
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildAppBar() {
// //     return Padding(
// //       padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
// //       child: Row(
// //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //         children: [
// //           Text(
// //             "  P2P Sell Order",
// //             style: GoogleFonts.poppins(
// //               color: Colors.white,
// //               fontSize: 17.sp,
// //               fontWeight: FontWeight.w700,
// //             ),
// //           ),
// //           Container(
// //             padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
// //             decoration: BoxDecoration(
// //               color: Colors.white.withOpacity(0.05),
// //               borderRadius: BorderRadius.circular(10.r),
// //             ),
// //             child: Row(
// //               children: [
// //                 const Icon(
// //                   CupertinoIcons.timer,
// //                   color: Color(0xFF06CE8F),
// //                   size: 16,
// //                 ),
// //                 Text(
// //                   " 14:43 left",
// //                   style: GoogleFonts.poppins(
// //                     color: Colors.white70,
// //                     fontSize: 12.sp,
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildIllustrationSection() {
// //     return Container(
// //       height: 180.h,
// //       width: double.infinity,
// //       decoration: BoxDecoration(
// //         shape: BoxShape.circle,
// //         color: const Color(0xFF06CE8F).withOpacity(0.03),
// //       ),
// //       child: Center(
// //         child: Stack(
// //           alignment: Alignment.center,
// //           children: [
// //             // Outer glowing ring
// //             Container(
// //               height: 140.h,
// //               width: 140.h,
// //               decoration: BoxDecoration(
// //                 shape: BoxShape.circle,
// //                 border: Border.all(
// //                   color: const Color(0xFF06CE8F).withOpacity(0.1),
// //                   width: 2,
// //                 ),
// //               ),
// //             ),
// //             // Placeholder for the person icon/illustration
// //             const Icon(
// //               CupertinoIcons.person_crop_circle_fill,
// //               size: 100,
// //               color: Color(0xFF06CE8F),
// //             ),
// //             const Positioned(
// //               right: 10,
// //               top: 10,
// //               child: Icon(
// //                 CupertinoIcons.hourglass,
// //                 color: Colors.white38,
// //                 size: 24,
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildOrderDetailsCard() {
// //     return Container(
// //       padding: EdgeInsets.all(18.w),
// //       decoration: BoxDecoration(
// //         color: Colors.white.withOpacity(0.04),
// //         borderRadius: BorderRadius.circular(16.r),
// //         border: Border.all(color: Colors.white.withOpacity(0.06)),
// //       ),
// //       child: Column(
// //         children: [
// //           _infoRow("Order ID:", "P2P46758329"),
// //           SizedBox(height: 12.h),
// //           _infoRow("Amount to Receive:", "₹ 158,400", isEmerald: true),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildAccountInfoCard() {
// //     return Container(
// //       width: double.infinity,
// //       padding: EdgeInsets.all(18.w),
// //       decoration: BoxDecoration(
// //         color: const Color(0xFF131C29).withOpacity(0.6),
// //         borderRadius: BorderRadius.circular(20.r),
// //         border: Border.all(color: const Color(0xFF06CE8F).withOpacity(0.15)),
// //       ),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Text(
// //             "Receiving Account:",
// //             style: GoogleFonts.poppins(
// //               color: const Color(0xFF06CE8F),
// //               fontWeight: FontWeight.w600,
// //               fontSize: 13.sp,
// //             ),
// //           ),
// //           const Divider(color: Colors.white10, height: 20),
// //           _accountRow("Bank:", "HDFC Bank"),
// //           _accountRow("Holder Name:", "Suresh Patel"),
// //           _accountRow("Account No:", "123456789101"),
// //           _accountRow("IFSC Code:", "HDFC0001234"),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _infoRow(String label, String value, {bool isEmerald = false}) {
// //     return Row(
// //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //       children: [
// //         Text(
// //           label,
// //           style: GoogleFonts.poppins(color: Colors.white54, fontSize: 13.sp),
// //         ),
// //         Text(
// //           value,
// //           style: GoogleFonts.poppins(
// //             color: isEmerald ? const Color(0xFF06CE8F) : Colors.white,
// //             fontWeight: FontWeight.w600,
// //             fontSize: 14.sp,
// //           ),
// //         ),
// //       ],
// //     );
// //   }

// //   Widget _accountRow(String label, String value) {
// //     return Padding(
// //       padding: EdgeInsets.symmetric(vertical: 4.h),
// //       child: Row(
// //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //         children: [
// //           Text(
// //             label,
// //             style: GoogleFonts.poppins(color: Colors.white38, fontSize: 12.sp),
// //           ),
// //           Text(
// //             value,
// //             style: GoogleFonts.poppins(
// //               color: Colors.white,
// //               fontSize: 12.sp,
// //               fontWeight: FontWeight.w500,
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildDisputeButton(BuildContext context) {
// //     return SizedBox(
// //       width: double.infinity,
// //       height: 54.h,
// //       child: OutlinedButton(
// //         onPressed: () {
// //           Navigator.push(
// //             context,
// //             RightSlideFadeRoute(page: PaymentReceivedPage()),
// //           );
// //         },
// //         style: OutlinedButton.styleFrom(
// //           side: const BorderSide(
// //             color: Color(0xFFEF4444),
// //             width: 1.5,
// //           ), // Red color for warning
// //           shape: RoundedRectangleBorder(
// //             borderRadius: BorderRadius.circular(15.r),
// //           ),
// //         ),
// //         child: Text(
// //           "RAISE DISPUTE",
// //           style: GoogleFonts.poppins(
// //             color: const Color(0xFFEF4444),
// //             fontWeight: FontWeight.w700,
// //             fontSize: 15.sp,
// //             letterSpacing: 1.1,
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:payment_app/Screen/paymentRecive.page.dart';
// import 'package:payment_app/config/auth/router/rightsliderFageRoute.dart';
// import 'package:payment_app/data/model/p2pSaveSellRequestResModel.dart';

// class P2pWaitingPaymentPage extends StatelessWidget {
//   final Data orderData;

//   const P2pWaitingPaymentPage({super.key, required this.orderData});

//   @override
//   Widget build(BuildContext context) {
//     /// Safe payment method extraction
//     final paymentMethod =
//         orderData.paymentMethods != null && orderData.paymentMethods!.isNotEmpty
//             ? orderData.paymentMethods!.first
//             : null;

//     final methodType = paymentMethod?.methodType ?? "";

//     return Scaffold(
//       backgroundColor: const Color(0xFF09111C),
//       body: SafeArea(
//         child: Column(
//           children: [
//             _buildAppBar(),
//             Expanded(
//               child: SingleChildScrollView(
//                 padding: EdgeInsets.symmetric(horizontal: 24.w),
//                 child: Column(
//                   children: [
//                     SizedBox(height: 20.h),

//                     /// Order Details
//                     _buildOrderDetailsCard(),

//                     SizedBox(height: 20.h),

//                     /// Payment Info Card
//                     _buildPaymentCard(methodType, paymentMethod),

//                     SizedBox(height: 40.h),

//                     /// Dispute Button
//                     _buildDisputeButton(context),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // ---------------- APP BAR ----------------

//   Widget _buildAppBar() {
//     return Padding(
//       padding: EdgeInsets.all(16.w),
//       child: Text(
//         "P2P Sell Order",
//         style: GoogleFonts.poppins(
//           color: Colors.white,
//           fontSize: 18.sp,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     );
//   }

//   // ---------------- ORDER CARD ----------------

//   Widget _buildOrderDetailsCard() {
//     return Container(
//       padding: EdgeInsets.all(18.w),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.04),
//         borderRadius: BorderRadius.circular(16.r),
//       ),
//       child: Column(
//         children: [
//           _infoRow("Order ID:", orderData.id ?? ""),
//           SizedBox(height: 10.h),
//           _infoRow("Amount:", "₹ ${orderData.amount ?? 0}", isGreen: true),
//           SizedBox(height: 10.h),
//           _infoRow("Rate:", "${orderData.rate ?? 0}"),
//           SizedBox(height: 10.h),
//           _infoRow("Status:", orderData.status ?? ""),
//         ],
//       ),
//     );
//   }

//   // ---------------- PAYMENT CARD ----------------

//   Widget _buildPaymentCard(String methodType, PaymentMethod? paymentMethod) {
//     return Container(
//       padding: EdgeInsets.all(18.w),
//       decoration: BoxDecoration(
//         color: const Color(0xFF131C29),
//         borderRadius: BorderRadius.circular(16.r),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             "Receiving Account",
//             style: GoogleFonts.poppins(
//               color: const Color(0xFF06CE8F),
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           const Divider(color: Colors.white24),

//           if (paymentMethod == null)
//             const Text(
//               "No Payment Method Available",
//               style: TextStyle(color: Colors.white54),
//             ),

//           /// 🔥 UPI Section
//           if (methodType == "UPI") ...[
//             _accountRow("Method:", "UPI"),
//             _accountRow(
//               "Holder Name:",
//               paymentMethod?.details?.holderName ?? "",
//             ),
//             _accountRow("UPI ID:", paymentMethod?.details?.upiId ?? ""),
//           ],

//           /// 🔥 BANK Section
//           if (methodType == "BANK") ...[
//             _accountRow("Method:", "Bank Transfer"),
//             _accountRow("Bank Name:", paymentMethod?.details?.bankName ?? ""),
//             _accountRow(
//               "Holder Name:",
//               paymentMethod?.details?.holderName ?? "",
//             ),
//             _accountRow(
//               "Account No:",
//               paymentMethod?.details?.accountNumber ?? "",
//             ),
//             _accountRow("IFSC:", paymentMethod?.details?.ifscCode ?? ""),
//           ],
//         ],
//       ),
//     );
//   }

//   // ---------------- COMMON ROW ----------------

//   Widget _infoRow(String label, String value, {bool isGreen = false}) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(label, style: GoogleFonts.poppins(color: Colors.white54)),
//         Text(
//           value,
//           style: GoogleFonts.poppins(
//             color: isGreen ? const Color(0xFF06CE8F) : Colors.white,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _accountRow(String label, String value) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 6.h),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(label, style: GoogleFonts.poppins(color: Colors.white38)),
//           Flexible(
//             child: Text(
//               value,
//               textAlign: TextAlign.right,
//               style: GoogleFonts.poppins(
//                 color: Colors.white,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // ---------------- DISPUTE BUTTON ----------------

//   Widget _buildDisputeButton(BuildContext context) {
//     return SizedBox(
//       width: double.infinity,
//       height: 50.h,
//       child: OutlinedButton(
//         onPressed: () {
//           Navigator.push(
//             context,
//             RightSlideFadeRoute(page: PaymentReceivedPage()),
//           );
//         },
//         style: OutlinedButton.styleFrom(
//           side: const BorderSide(color: Colors.red),
//         ),
//         child: const Text("RAISE DISPUTE", style: TextStyle(color: Colors.red)),
//       ),
//     );
//   }
// }

import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:payment_app/Screen/paymentRecive.page.dart';
import 'package:payment_app/config/auth/router/rightsliderFageRoute.dart';
import 'package:payment_app/config/network/api.network.dart';
import 'package:payment_app/config/utils/pretty.dio.dart';
import 'package:payment_app/config/utils/showMessage.dart';
import 'package:payment_app/data/model/p2pSaveSellRequestResModel.dart';
import 'package:payment_app/data/model/raiseDisputeBodyModel.dart';
import 'package:payment_app/data/model/realeaseAmountAccRejectBody.dart';

class P2pWaitingPaymentPage extends StatefulWidget {
  final Data orderData;

  const P2pWaitingPaymentPage({super.key, required this.orderData});

  @override
  State<P2pWaitingPaymentPage> createState() => _P2pWaitingPaymentPageState();
}

class _P2pWaitingPaymentPageState extends State<P2pWaitingPaymentPage> {
  bool showConfirmButtons = false;
  final reasonController = TextEditingController();
  bool isAcceptLoading = false;

  @override
  Widget build(BuildContext context) {
    /// Safe Payment Method Extraction
    final paymentMethod =
        widget.orderData.paymentMethods != null &&
                widget.orderData.paymentMethods!.isNotEmpty
            ? widget.orderData.paymentMethods!.first
            : null;

    final methodType = paymentMethod?.methodType ?? "";

    return Scaffold(
      backgroundColor: const Color(0xFF09111C),
      body: Stack(
        children: [
          /// Background Gradient
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
            child: Column(
              children: [
                _buildAppBar(),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Column(
                      children: [
                        SizedBox(height: 20.h),

                        /// Illustration
                        _buildIllustrationSection(),

                        SizedBox(height: 30.h),

                        /// Status Text
                        Text(
                          "Waiting for Buyer's Payment...",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          "Please wait while payment is being processed. You will be notified once completed.",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            color: const Color(0xFF9CA3AF),
                            fontSize: 12.sp,
                            height: 1.5,
                          ),
                        ),

                        SizedBox(height: 32.h),

                        /// Order Details
                        _buildOrderDetailsCard(),

                        SizedBox(height: 20.h),

                        /// Receiving Account Info
                        _buildAccountInfoCard(methodType, paymentMethod),

                        SizedBox(height: 40.h),

                        /// Dispute Button
                        _buildDisputeButton(context),
                        SizedBox(height: 20.h),
                        Column(
                          children: [
                            /// Release Amount Button
                            if (!showConfirmButtons)
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      showConfirmButtons = true;
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                  ),
                                  child: const Text(
                                    "Release Amount",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),

                            /// Accept Reject Buttons
                            if (showConfirmButtons)
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(20),
                                            ),
                                          ),
                                          builder: (context) {
                                            bool isLoading = false;

                                            return StatefulBuilder(
                                              builder: (context, setState) {
                                                return Padding(
                                                  padding: EdgeInsets.only(
                                                    left: 20,
                                                    right: 20,
                                                    top: 20,
                                                    bottom:
                                                        MediaQuery.of(
                                                          context,
                                                        ).viewInsets.bottom +
                                                        20,
                                                  ),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      const Text(
                                                        "Reject Reason",
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),

                                                      const SizedBox(
                                                        height: 16,
                                                      ),

                                                      TextField(
                                                        controller:
                                                            reasonController,
                                                        maxLines: 3,
                                                        decoration: InputDecoration(
                                                          hintText:
                                                              "Enter rejection reason",
                                                          border: OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  10,
                                                                ),
                                                          ),
                                                        ),
                                                      ),

                                                      const SizedBox(
                                                        height: 20,
                                                      ),

                                                      SizedBox(
                                                        width: double.infinity,
                                                        child: ElevatedButton(
                                                          onPressed:
                                                              isLoading
                                                                  ? null
                                                                  : () async {
                                                                    if (reasonController
                                                                        .text
                                                                        .trim()
                                                                        .isEmpty) {
                                                                      ShowMessage.error(
                                                                        context,
                                                                        "Please enter reason",
                                                                      );
                                                                      return;
                                                                    }

                                                                    setState(() {
                                                                      isLoading =
                                                                          true;
                                                                    });

                                                                    try {
                                                                      final body = ReleaseAmountRejectOrApproveBody(
                                                                        orderId:
                                                                            widget.orderData.id,
                                                                        status:
                                                                            "reject",
                                                                        rejectReason:
                                                                            reasonController.text.trim(),
                                                                      );

                                                                      final service =
                                                                          ApiNetwork(
                                                                            createDio(),
                                                                          );

                                                                      final response =
                                                                          await service.releaseAmountRejectOrApprove(
                                                                            body,
                                                                          );

                                                                      if (response.code ==
                                                                              0 &&
                                                                          response.error ==
                                                                              false) {
                                                                        Navigator.pop(
                                                                          context,
                                                                        );

                                                                        ShowMessage.success(
                                                                          context,
                                                                          response.message ??
                                                                              "Rejected",
                                                                        );
                                                                      } else {
                                                                        ShowMessage.error(
                                                                          context,
                                                                          response.message ??
                                                                              "Something went wrong",
                                                                        );
                                                                      }
                                                                    } catch (
                                                                      e
                                                                    ) {
                                                                      ShowMessage.error(
                                                                        context,
                                                                        "Network error occurred",
                                                                      );
                                                                    } finally {
                                                                      if (context
                                                                          .mounted) {
                                                                        setState(() {
                                                                          isLoading =
                                                                              false;
                                                                        });
                                                                      }
                                                                    }
                                                                  },
                                                          style: ElevatedButton.styleFrom(
                                                            padding:
                                                                const EdgeInsets.symmetric(
                                                                  vertical: 14,
                                                                ),
                                                          ),
                                                          child:
                                                              isLoading
                                                                  ? const SizedBox(
                                                                    height: 20,
                                                                    width: 20,
                                                                    child: CircularProgressIndicator(
                                                                      strokeWidth:
                                                                          2,
                                                                      color:
                                                                          Colors
                                                                              .white,
                                                                    ),
                                                                  )
                                                                  : const Text(
                                                                    "Submit",
                                                                  ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 14,
                                        ),
                                      ),
                                      child: const Text("Reject"),
                                    ),
                                  ),

                                  const SizedBox(width: 12),

                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed:
                                          isAcceptLoading
                                              ? null
                                              : () async {
                                                setState(() {
                                                  isAcceptLoading = true;
                                                });

                                                try {
                                                  final body =
                                                      ReleaseAmountRejectOrApproveBody(
                                                        orderId:
                                                            widget.orderData.id,
                                                        status: "approve",
                                                      );

                                                  final service = ApiNetwork(
                                                    createDio(),
                                                  );

                                                  final response = await service
                                                      .releaseAmountRejectOrApprove(
                                                        body,
                                                      );

                                                  if (response.code == 0 &&
                                                      response.error == false) {
                                                    ShowMessage.success(
                                                      context,
                                                      response.message ??
                                                          "Approved",
                                                    );

                                                    // Navigator.push(
                                                    //   context,
                                                    //   RightSlideFadeRoute(
                                                    //     page: PaymentReceivedPage(),
                                                    //   ),
                                                    // );
                                                  } else {
                                                    ShowMessage.error(
                                                      context,
                                                      response.message ??
                                                          "Something went wrong",
                                                    );
                                                  }
                                                } catch (e) {
                                                  ShowMessage.error(
                                                    context,
                                                    "Network error occurred",
                                                  );
                                                } finally {
                                                  if (mounted) {
                                                    setState(() {
                                                      isAcceptLoading = false;
                                                    });
                                                  }
                                                }
                                              },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 14,
                                        ),
                                      ),
                                      child:
                                          isAcceptLoading
                                              ? const SizedBox(
                                                height: 20,
                                                width: 20,
                                                child:
                                                    CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                      color: Colors.white,
                                                    ),
                                              )
                                              : const Text("Accept"),
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),

                        SizedBox(height: 16.h),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            "Contact Support",
                            style: GoogleFonts.poppins(
                              color: const Color(0xFF06CE8F),
                              fontWeight: FontWeight.w600,
                              fontSize: 14.sp,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                        SizedBox(height: 20.h),
                      ],
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

  // ---------------- APP BAR ----------------
  Widget _buildAppBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "P2P Sell Order",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 17.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Row(
              children: [
                const Icon(
                  CupertinoIcons.timer,
                  color: Color(0xFF06CE8F),
                  size: 16,
                ),
                Text(
                  "15:00",
                  style: GoogleFonts.poppins(
                    color: Colors.white70,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- ORDER CARD ----------------
  Widget _buildOrderDetailsCard() {
    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Column(
        children: [
          _infoRow("Order ID:", widget.orderData.id ?? ""),
          SizedBox(height: 12.h),
          _infoRow(
            "Amount to Receive:",
            "₹ ${widget.orderData.amount ?? 0}",
            isEmerald: true,
          ),
          SizedBox(height: 12.h),
          _infoRow("Rate:", "${widget.orderData.rate ?? 0}"),
          SizedBox(height: 12.h),
          _infoRow("Status:", widget.orderData.status ?? ""),
        ],
      ),
    );
  }

  // ---------------- ACCOUNT CARD ----------------
  Widget _buildAccountInfoCard(
    String methodType,
    PaymentMethod? paymentMethod,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: const Color(0xFF131C29).withOpacity(0.6),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: const Color(0xFF06CE8F).withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Receiving Account:",
            style: GoogleFonts.poppins(
              color: const Color(0xFF06CE8F),
              fontWeight: FontWeight.w600,
              fontSize: 13.sp,
            ),
          ),
          const Divider(color: Colors.white10, height: 20),

          if (paymentMethod == null)
            const Text(
              "No Payment Method Available",
              style: TextStyle(color: Colors.white54),
            ),

          if (methodType == "UPI") ...[
            _accountRow("Method:", "UPI"),
            _accountRow(
              "Holder Name:",
              paymentMethod?.details?.holderName ?? "",
            ),
            _accountRow("UPI ID:", paymentMethod?.details?.upiId ?? ""),
          ],

          if (methodType == "BANK") ...[
            _accountRow("Method:", "Bank Transfer"),
            _accountRow("Bank Name:", paymentMethod?.details?.bankName ?? ""),
            _accountRow(
              "Holder Name:",
              paymentMethod?.details?.holderName ?? "",
            ),
            _accountRow(
              "Account No:",
              paymentMethod?.details?.accountNumber ?? "",
            ),
            _accountRow("IFSC Code:", paymentMethod?.details?.ifscCode ?? ""),
          ],
        ],
      ),
    );
  }

  // ---------------- COMMON ROWS ----------------
  Widget _infoRow(String label, String value, {bool isEmerald = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(color: Colors.white54, fontSize: 13.sp),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            color: isEmerald ? const Color(0xFF06CE8F) : Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 14.sp,
          ),
        ),
      ],
    );
  }

  Widget _accountRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(color: Colors.white38, fontSize: 12.sp),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- DISPUTE BUTTON ----------------
  Widget _buildDisputeButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54.h,
      child: OutlinedButton(
        onPressed: () {
          // Navigator.push(
          //   context,
          //   RightSlideFadeRoute(page: PaymentReceivedPage()),
          // );
          _showDisputeBottomSheet(context);
        },
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Color(0xFFEF4444), width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.r),
          ),
        ),
        child: Text(
          "RAISE DISPUTE",
          style: GoogleFonts.poppins(
            color: const Color(0xFFEF4444),
            fontWeight: FontWeight.w700,
            fontSize: 15.sp,
            letterSpacing: 1.1,
          ),
        ),
      ),
    );
  }

  Widget _buildIllustrationSection() {
    return Container(
      height: 180.h,
      width: double.infinity,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF06CE8F).withOpacity(0.03),
      ),
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Outer glowing ring
            Container(
              height: 140.h,
              width: 140.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF06CE8F).withOpacity(0.1),
                  width: 2,
                ),
              ),
            ),
            // Placeholder for the person icon/illustration
            const Icon(
              CupertinoIcons.person_crop_circle_fill,
              size: 100,
              color: Color(0xFF06CE8F),
            ),
            const Positioned(
              right: 10,
              top: 10,
              child: Icon(
                CupertinoIcons.hourglass,
                color: Colors.white38,
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDisputeBottomSheet(BuildContext context) {
    final TextEditingController reasonController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: EdgeInsets.only(
            left: 20.w,
            right: 20.w,
            top: 20.h,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20.h,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFF131C29),
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.r)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Drag Indicator
              Center(
                child: Container(
                  height: 4.h,
                  width: 40.w,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
              ),
              SizedBox(height: 20.h),

              /// Title
              Text(
                "Raise Dispute",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 20.h),

              /// Reason Field
              Text(
                "Reason",
                style: GoogleFonts.poppins(
                  color: Colors.white70,
                  fontSize: 13.sp,
                ),
              ),
              SizedBox(height: 8.h),

              TextField(
                controller: reasonController,
                maxLines: 4,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Enter dispute reason...",
                  hintStyle: const TextStyle(color: Colors.white38),
                  filled: true,
                  fillColor: const Color(0xFF09111C),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              SizedBox(height: 25.h),

              /// Submit Button
              SizedBox(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton(
                  onPressed: () async {
                    if (reasonController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Please enter reason")),
                      );
                      return;
                    }
                    final body = RaiseDsiputeBodyModel(
                      orderId: widget.orderData.id,
                      reason: reasonController.text.trim(),
                    );
                    try {
                      final service = ApiNetwork(createDio());
                      final response = await service.raiseDispute(body);
                      if (response.code == 0 || response.error == false) {
                        Navigator.pop(context);
                        // Navigator.push(
                        //   context,
                        //   RightSlideFadeRoute(page: PaymentReceivedPage()),
                        // );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Dispute submitted successfully"),
                          ),
                        );
                      } else {
                        ShowMessage.error(context, response.message ?? "");
                      }
                    } catch (e) {
                      log(e.toString());
                    }

                    // 👉 Yaha API call laga sakte ho
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEF4444),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                  ),
                  child: Text(
                    "SUBMIT DISPUTE",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
