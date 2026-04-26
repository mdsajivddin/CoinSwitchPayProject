// import 'dart:io';

// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:payment_app/config/utils/globalKey.dart';
// import 'package:shimmer/main.dart';

// class NoInternetPage extends StatefulWidget {
//   const NoInternetPage({super.key});

//   @override
//   State<NoInternetPage> createState() => _NoInternetPageState();
// }

// class _NoInternetPageState extends State<NoInternetPage> {
//   // 1. Check Internet Function (Class ke andar define kiya)
//   Future<bool> _checkInternet() async {
//     try {
//       final result = await InternetAddress.lookup('google.com');
//       return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
//     } catch (_) {
//       return false;
//     }
//   }

//   // 2. Retry Logic
//   Future<void> _retry(BuildContext context) async {
//     bool hasInternet = await _checkInternet();

//     if (hasInternet) {
//       // Agar internet aa gaya hai to screen hata do
//       if (Navigator.canPop(context)) {
//         Navigator.pop(context);
//       }
//     } else {
//       // Agar abhi bhi nahi hai to user ko feedback do
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(
//             "Still no connection. Please try again!",
//             style: TextStyle(color: Colors.white), // White text
//           ),
//           duration: Duration(seconds: 2),
//           backgroundColor: Color(0xFFE53935), // Red background
//           behavior: SnackBarBehavior.floating,
//           margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(18),
//           ),
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         exit(0); // App close
//       },
//       child: Scaffold(
//         backgroundColor: const Color(0xFF09111C),
//         body: Center(
//           child: Padding(
//             padding: EdgeInsets.symmetric(horizontal: 20.w),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(
//                   Icons.wifi_off,
//                   color: Colors.white.withOpacity(0.5),
//                   size: 80.sp,
//                 ),

//                 SizedBox(height: 20.h),

//                 Text(
//                   "No Internet Connection",
//                   style: GoogleFonts.poppins(
//                     color: Colors.white,
//                     fontSize: 18.sp,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),

//                 SizedBox(height: 8.h),

//                 Text(
//                   "Please check your connection and try again",
//                   style: GoogleFonts.poppins(
//                     color: Colors.white.withOpacity(0.5),
//                     fontSize: 13.sp,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),

//                 SizedBox(height: 30.h),

//                 ElevatedButton(
//                   onPressed: () => _retry(context),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFF06CE8F),
//                     padding: EdgeInsets.symmetric(
//                       horizontal: 30.w,
//                       vertical: 12.h,
//                     ),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12.r),
//                     ),
//                   ),
//                   child: Text(
//                     "Retry",
//                     style: GoogleFonts.poppins(
//                       color: Colors.black,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class NoInternetPage extends StatefulWidget {
  const NoInternetPage({super.key});

  @override
  State<NoInternetPage> createState() => _NoInternetPageState();
}

class _NoInternetPageState extends State<NoInternetPage> {
  // --- Functionality Unchanged ---
  Future<bool> _checkInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  Future<void> _retry(BuildContext context) async {
    bool hasInternet = await _checkInternet();
    if (hasInternet) {
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Still no connection. Please try again!",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          duration: const Duration(seconds: 2),
          backgroundColor: const Color(0xFFE53935),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(20.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.r),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        exit(0);
      },
      child: Scaffold(
        // Updated Background with subtle gradient
        body: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF0F172A), // Deep Slate
                Color(0xFF09111C), // Your Original Dark Color
              ],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Visual Element: Glowing Icon
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: 140.r,
                        width: 140.r,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF06CE8F).withOpacity(0.05),
                        ),
                      ),
                      Container(
                        height: 100.r,
                        width: 100.r,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF06CE8F).withOpacity(0.1),
                        ),
                        child: Icon(
                          Icons.wifi_off_rounded,
                          color: const Color(
                            0xFF06CE8F,
                          ), // Using your brand color
                          size: 50.sp,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 40.h),

                  // Header Text
                  Text(
                    "Oops! No Internet",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),

                  SizedBox(height: 12.h),

                  // Sub-text
                  Text(
                    "We can't find an active internet connection.\nPlease check your Wi-Fi or Mobile Data.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 14.sp,
                      height: 1.5,
                    ),
                  ),

                  SizedBox(height: 40.h),

                  // Modernized Retry Button
                  SizedBox(
                    width:
                        double.infinity, // Full width button for better reach
                    height: 54.h,
                    child: ElevatedButton(
                      onPressed: () => _retry(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF06CE8F),
                        foregroundColor: Colors.black,
                        elevation: 8,
                        shadowColor: const Color(0xFF06CE8F).withOpacity(0.3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                      ),
                      child: Text(
                        "Try Again",
                        style: GoogleFonts.poppins(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 20.h),

                  // Secondary Action (Optional look)
                  TextButton(
                    onPressed: () => exit(0),
                    child: Text(
                      "Exit App",
                      style: GoogleFonts.poppins(
                        color: Colors.white.withOpacity(0.4),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
