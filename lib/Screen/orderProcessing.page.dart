// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:payment_app/Screen/home.page.dart';
// import 'package:payment_app/config/auth/router/rightsliderFageRoute.dart';

// class OrderProcessingPage extends StatelessWidget {
//   final String amount;
//   final String walletType;
//   final String rate;
//   final String totalAmount;
//   final String paymentMethod;
//   final String upiId;
//   final String orderId;
//   final String status;
//   final dynamic createdAt;
//   OrderProcessingPage({super.key});

//   // 🎨 Colors based on your SellPage design
//   final Color bgColor = const Color(0xFF09111C);

//   final Color accentIndigo = const Color(0xFF4F6EF7);

//   final Color cardColor = Colors.white.withOpacity(0.05);

//   final Color textGrey = const Color(0xFF9CA3AF);

//   final Color successGreen = const Color(0xFF06CE8F);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: bgColor,
//       body: Stack(
//         children: [
//           /// 🔹 Background Radial Gradient (Matching SellPage)
//           Container(
//             decoration: const BoxDecoration(
//               gradient: RadialGradient(
//                 center: Alignment(-0.9, -0.9),
//                 radius: 1.5,
//                 colors: [Color(0xFF1A2A3A), Color(0xFF09111C)],
//               ),
//             ),
//           ),

//           SafeArea(
//             child: Column(
//               children: [
//                 /// 🔹 Custom App Bar
//                 Padding(
//                   padding: EdgeInsets.symmetric(
//                     horizontal: 16.w,
//                     vertical: 10.h,
//                   ),
//                   child: Row(
//                     children: [
//                       IconButton(
//                         icon: const Icon(
//                           Icons.arrow_back_ios_new,
//                           color: Colors.white,
//                         ),
//                         onPressed: () => Navigator.pop(context),
//                       ),
//                       const Spacer(),
//                       Text(
//                         "Order Processing",
//                         style: GoogleFonts.poppins(
//                           fontSize: 18.sp,
//                           fontWeight: FontWeight.w600,
//                           color: Colors.white,
//                         ),
//                       ),
//                       const Spacer(),
//                       SizedBox(width: 40.w),
//                     ],
//                   ),
//                 ),

//                 Expanded(
//                   child: SingleChildScrollView(
//                     physics: const BouncingScrollPhysics(),
//                     padding: EdgeInsets.symmetric(horizontal: 20.w),
//                     child: Column(
//                       children: [
//                         SizedBox(height: 10.h),

//                         /// 🔹 Main Dark Glass Card
//                         glassCard(
//                           child: Column(
//                             children: [
//                               /// Success Icon with Glow
//                               Container(
//                                 padding: EdgeInsets.all(16.r),
//                                 decoration: BoxDecoration(
//                                   color: successGreen.withOpacity(0.1),
//                                   shape: BoxShape.circle,
//                                 ),
//                                 child: Icon(
//                                   Icons.check_circle_rounded,
//                                   color: successGreen,
//                                   size: 60.sp,
//                                 ),
//                               ),
//                               SizedBox(height: 20.h),
//                               Text(
//                                 "Sell Order Created",
//                                 style: GoogleFonts.poppins(
//                                   fontSize: 22.sp,
//                                   fontWeight: FontWeight.w600,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                               SizedBox(height: 10.h),

//                               Text(
//                                 "Your 1,500 USDT has been sold.\nPayment will be processed shortly.",
//                                 textAlign: TextAlign.center,
//                                 style: GoogleFonts.poppins(
//                                   fontSize: 13.sp,
//                                   color: textGrey,
//                                   height: 1.5,
//                                 ),
//                               ),

//                               SizedBox(height: 40.h),

//                               /// 🔹 Timeline Implementation
//                               timelineRow(
//                                 title: "Order Created",
//                                 subtitle: "Apr 24, 2024, 10:03 AM",
//                                 icon: Icons.check_circle,
//                                 iconColor: accentIndigo,
//                                 isLast: false,
//                                 isActive: true,
//                               ),
//                               timelineRow(
//                                 title: "Processing Payment",
//                                 subtitle: "UPI within 1 hour",
//                                 icon: Icons.pending,
//                                 iconColor: Colors.orangeAccent,
//                                 isLast: false,
//                                 isActive: true,
//                               ),
//                               timelineRow(
//                                 title: "Payment Sent",
//                                 subtitle: "Pending confirmation",
//                                 icon: Icons.radio_button_off,
//                                 iconColor: textGrey,
//                                 isLast: true,
//                                 isActive: false,
//                               ),
//                             ],
//                           ),
//                         ),

//                         SizedBox(height: 40.h),

//                         /// 🔹 Done Button (Matching SellPage Gradient)
//                         InkWell(
//                           onTap: () {
//                             Navigator.pushAndRemoveUntil(
//                               context,
//                               RightSlideFadeRoute(page: HomeBottomNav()),
//                               (route) => false,
//                             );
//                           },
//                           child: Container(
//                             height: 55.h,
//                             width: double.infinity,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(30.r),
//                               gradient: const LinearGradient(
//                                 colors: [Color(0xFF06CE8F), Color(0xFF06CE8F)],
//                               ),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: const Color(0xFF06CE8F),
//                                   blurRadius: 15,
//                                   offset: const Offset(0, 8),
//                                 ),
//                               ],
//                             ),
//                             child: Center(
//                               child: Text(
//                                 "Done",
//                                 style: GoogleFonts.poppins(
//                                   fontSize: 16.sp,
//                                   fontWeight: FontWeight.w600,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                         SizedBox(height: 20.h),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   /// 🔹 Glassmorphism Card (Updated for Dark Theme)
//   Widget glassCard({required Widget child}) {
//     return Container(
//       width: double.infinity,
//       padding: EdgeInsets.all(24.w),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.05),
//         borderRadius: BorderRadius.circular(24.r),
//         border: Border.all(color: Colors.white.withOpacity(0.08)),
//       ),
//       child: child,
//     );
//   }

//   /// 🔹 Timeline Row Component
//   Widget timelineRow({
//     required String title,
//     required String subtitle,
//     required IconData icon,
//     required Color iconColor,
//     required bool isLast,
//     required bool isActive,
//   }) {
//     return IntrinsicHeight(
//       child: Row(
//         children: [
//           Column(
//             children: [
//               Icon(icon, color: iconColor, size: 24.sp),
//               if (!isLast)
//                 Expanded(
//                   child: VerticalDivider(
//                     color:
//                         isActive
//                             ? iconColor.withOpacity(0.5)
//                             : textGrey.withOpacity(0.2),
//                     thickness: 2,
//                     indent: 4,
//                     endIndent: 4,
//                   ),
//                 ),
//             ],
//           ),
//           SizedBox(width: 15.w),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: GoogleFonts.poppins(
//                     fontSize: 15.sp,
//                     fontWeight: FontWeight.w600,
//                     color: isActive ? Colors.white : textGrey,
//                   ),
//                 ),
//                 Text(
//                   subtitle,
//                   style: GoogleFonts.poppins(fontSize: 12.sp, color: textGrey),
//                 ),
//                 if (!isLast) SizedBox(height: 30.h),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:ui';
import 'package:dotlottie_loader/dotlottie_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:payment_app/Screen/home.page.dart';
import 'package:payment_app/config/auth/router/rightsliderFageRoute.dart';

class OrderProcessingPage extends StatelessWidget {
  final String amount;
  final String walletType;
  final String rate;
  final String totalAmount;
  final String paymentMethod;
  final String upiId;
  final String orderId;
  final String status;
  final dynamic createdAt;

  const OrderProcessingPage({
    super.key,
    required this.amount,
    required this.walletType,
    required this.rate,
    required this.totalAmount,
    required this.paymentMethod,
    required this.upiId,
    required this.orderId,
    required this.status,
    required this.createdAt,
  });

  final Color bgColor = const Color(0xFF09111C);
  final Color accentIndigo = const Color(0xFF4F6EF7);
  final Color textGrey = const Color(0xFF9CA3AF);
  final Color successGreen = const Color(0xFF06CE8F);

  @override
  Widget build(BuildContext context) {
    /// Convert timestamp to date
    DateTime date = DateTime.fromMillisecondsSinceEpoch(createdAt ?? 0);

    String formattedDate =
        "${date.day}-${date.month}-${date.year}  ${date.hour}:${date.minute}";

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;

        Navigator.pushAndRemoveUntil(
          context,
          RightSlideFadeRoute(page: HomeBottomNav()),
          (route) => false,
        );
      },
      child: Scaffold(
        backgroundColor: bgColor,
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

            SafeArea(
              child: Column(
                children: [
                  /// Header
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 10.h,
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              RightSlideFadeRoute(page: HomeBottomNav()),
                              (route) => false,
                            );
                          },
                        ),
                        const Spacer(),
                        Text(
                          "Order Processing",
                          style: GoogleFonts.poppins(
                            fontSize: 18.sp,
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
                        children: [
                          SizedBox(height: 10.h),

                          glassCard(
                            child: Column(
                              children: [
                                /// Success Icon
                                // Container(
                                //   padding: EdgeInsets.all(16.r),
                                //   decoration: BoxDecoration(
                                //     color: successGreen.withOpacity(0.1),
                                //     shape: BoxShape.circle,
                                //   ),
                                //   child: Icon(
                                //     Icons.check_circle_rounded,
                                //     color: successGreen,
                                //     size: 60.sp,
                                //   ),
                                // ),
                                Container(
                                  height: 120.h,
                                  width: 120.w,
                                  decoration: BoxDecoration(
                                    color: successGreen.withOpacity(0.08),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: DotLottieLoader.fromAsset(
                                      "assets/animations/success_payment.lottie",
                                      frameBuilder: (ctx, dotlottie) {
                                        if (dotlottie != null) {
                                          return Lottie.memory(
                                            dotlottie.animations.values.single,
                                            width: 90.w,
                                            height: 90.h,
                                            repeat: false,
                                          );
                                        } else {
                                          return const SizedBox();
                                        }
                                      },
                                    ),
                                  ),
                                ),

                                SizedBox(height: 20.h),

                                Text(
                                  "Sell Order Created",
                                  style: GoogleFonts.poppins(
                                    fontSize: 22.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),

                                SizedBox(height: 10.h),

                                /// Sell Message
                                Text(
                                  "Your $amount $walletType has been sold.\nPayment will be processed shortly.",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    fontSize: 13.sp,
                                    color: textGrey,
                                    height: 1.5,
                                  ),
                                ),

                                SizedBox(height: 20.h),

                                /// Order ID
                                Text(
                                  "Order ID : $orderId",
                                  style: GoogleFonts.poppins(
                                    fontSize: 12.sp,
                                    color: Colors.white70,
                                  ),
                                ),

                                SizedBox(height: 30.h),

                                /// Timeline
                                timelineRow(
                                  title: "Order Created",
                                  subtitle: formattedDate,
                                  icon: Icons.check_circle,
                                  iconColor: accentIndigo,
                                  isLast: false,
                                  isActive: true,
                                ),

                                timelineRow(
                                  title: "Processing Payment",
                                  subtitle: "$paymentMethod ($upiId)",
                                  icon: Icons.pending,
                                  iconColor: Colors.orangeAccent,
                                  isLast: false,
                                  isActive: true,
                                ),

                                timelineRow(
                                  title: "Payment Sent",
                                  subtitle: "Pending confirmation",
                                  icon: Icons.radio_button_off,
                                  iconColor: textGrey,
                                  isLast: true,
                                  isActive: false,
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 40.h),

                          /// Done Button
                          InkWell(
                            onTap: () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                RightSlideFadeRoute(page: HomeBottomNav()),
                                (route) => false,
                              );
                            },
                            child: Container(
                              height: 55.h,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30.r),
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF06CE8F),
                                    Color(0xFF06CE8F),
                                  ],
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  "Done",
                                  style: GoogleFonts.poppins(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
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
      ),
    );
  }

  /// Glass Card
  Widget glassCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: child,
    );
  }

  /// Timeline
  Widget timelineRow({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required bool isLast,
    required bool isActive,
  }) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Column(
            children: [
              Icon(icon, color: iconColor, size: 24.sp),
              if (!isLast)
                Expanded(
                  child: VerticalDivider(
                    color:
                        isActive ? iconColor.withOpacity(0.5) : Colors.white24,
                    thickness: 2,
                    indent: 4,
                    endIndent: 4,
                  ),
                ),
            ],
          ),
          SizedBox(width: 15.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: isActive ? Colors.white : Colors.white54,
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    fontSize: 12.sp,
                    color: Colors.white54,
                  ),
                ),
                if (!isLast) SizedBox(height: 30.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
