// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:payment_app/Screen/login.page.dart';
// import 'package:payment_app/config/auth/router/rightsliderFageRoute.dart'; // adjust path if needed

// class SplashPage extends StatefulWidget {
//   const SplashPage({super.key});

//   @override
//   State<SplashPage> createState() => _SplashPageState();
// }

// class _SplashPageState extends State<SplashPage>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _scaleAnimation;
//   late Animation<double> _opacityAnimation;
//   late Animation<double> _pulseAnimation;

//   @override
//   void initState() {
//     super.initState();

//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 2200),
//     );

//     _scaleAnimation = Tween<double>(
//       begin: 0.65,
//       end: 1.0,
//     ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

//     _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(
//         parent: _controller,
//         curve: const Interval(0.3, 1.0, curve: Curves.easeOutCubic),
//       ),
//     );

//     _pulseAnimation = Tween<double>(begin: 0.92, end: 1.08).animate(
//       CurvedAnimation(
//         parent: _controller,
//         curve: const Interval(0.6, 1.0, curve: Curves.easeInOut),
//       ),
//     );

//     _controller.forward();

//     Timer(const Duration(seconds: 4), () {
//       if (mounted) {
//         Navigator.pushAndRemoveUntil(
//           context,
//           RightSlideFadeRoute(page: LoginPage()),
//           (route) => false,
//         );
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFFFFFFF),
//       body: Stack(
//         alignment: Alignment.center,
//         children: [
//           // Modern subtle background accent (softer & larger)
//           Positioned(
//             // top: -80.h,
//             // left: -80.w,
//             child: ScaleTransition(
//               scale: _pulseAnimation,
//               child: Container(
//                 width: 380.w,
//                 height: 380.w,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   gradient: RadialGradient(
//                     center: Alignment.topLeft,
//                     radius: 0.9,
//                     colors: [
//                       const Color(0xFF06CE8F).withOpacity(0.10),
//                       const Color(0xFF06CE8F).withOpacity(0.04),
//                       Colors.transparent,
//                     ],
//                     stops: const [0.0, 0.5, 1.0],
//                   ),
//                 ),
//               ),
//             ),
//           ),

//           // Centered main content
//           Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               // Animated logo with combined scale + fade + subtle pulse
//               FadeTransition(
//                 opacity: _opacityAnimation,
//                 child: ScaleTransition(
//                   scale: _scaleAnimation,
//                   child: Container(
//                     padding: EdgeInsets.all(20.w),
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: Colors.white,
//                       boxShadow: [
//                         BoxShadow(
//                           color: const Color(0xFF06CE8F).withOpacity(0.08),
//                           blurRadius: 60,
//                           spreadRadius: 5,
//                           offset: const Offset(0, 20),
//                         ),
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.03),
//                           blurRadius: 30,
//                           offset: const Offset(0, 10),
//                         ),
//                       ],
//                     ),
//                     child: ClipOval(
//                       child: Image.asset(
//                         "assets/logoGif/bigoldtv.gif",
//                         // "assets/logoGif/bigdigit.gif",
//                         // "assets/logoGif/bigzoom.gif",
//                         height: 220.w,
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),

//           // Minimal bottom loading area
//           Positioned(
//             bottom: 80.h,
//             child: FadeTransition(
//               opacity: _opacityAnimation,
//               child: Column(
//                 children: [
//                   SizedBox(
//                     width: 36.w,
//                     height: 36.w,
//                     child: CircularProgressIndicator(
//                       strokeWidth: 3,
//                       valueColor: const AlwaysStoppedAnimation<Color>(
//                         Color(0xFF06CE8F),
//                       ),
//                       backgroundColor: const Color(
//                         0xFF06CE8F,
//                       ).withOpacity(0.15),
//                     ),
//                   ),
//                   SizedBox(height: 24.h),
//                   Text(
//                     "Loading Secure Wallet...",
//                     style: GoogleFonts.poppins(
//                       fontSize: 13.sp,
//                       fontWeight: FontWeight.w500,
//                       color: Colors.grey.shade600,
//                       letterSpacing: 0.8,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:payment_app/Screen/login.page.dart';
import 'package:payment_app/config/auth/router/rightsliderFageRoute.dart'; // अपना सही path डालना

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.65,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    _pulseAnimation = Tween<double>(begin: 0.92, end: 1.08).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.6, 1.0, curve: Curves.easeInOut),
      ),
    );

    // Animation जैसे ही complete हो → तुरंत नेविगेट
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            RightSlideFadeRoute(page: const LoginPage()),
            (route) => false,
          );
        }
      }
    });

    // Animation शुरू करो
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: Stack(
        alignment: Alignment.center,
        children: [
          // Background subtle pulse circle
          Positioned(
            child: ScaleTransition(
              scale: _pulseAnimation,
              child: Container(
                width: 380.w,
                height: 380.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    center: Alignment.topLeft,
                    radius: 0.9,
                    colors: [
                      const Color(0xFF06CE8F).withOpacity(0.10),
                      const Color(0xFF06CE8F).withOpacity(0.04),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ),
          ),

          // Main logo + animation
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FadeTransition(
                opacity: _opacityAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Container(
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF06CE8F).withOpacity(0.08),
                          blurRadius: 60,
                          spreadRadius: 5,
                          offset: const Offset(0, 20),
                        ),
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 30,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        "assets/logoGif/bigoldtv.gif",
                        height: 220.w,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Bottom loading indicator + text
          Positioned(
            bottom: 80.h,
            child: FadeTransition(
              opacity: _opacityAnimation,
              child: Column(
                children: [
                  SizedBox(
                    width: 36.w,
                    height: 36.w,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFF06CE8F),
                      ),
                      backgroundColor: Color(0xFF06CE8F).withOpacity(0.15),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Text(
                    "Loading Secure Wallet...",
                    style: GoogleFonts.poppins(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade600,
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
