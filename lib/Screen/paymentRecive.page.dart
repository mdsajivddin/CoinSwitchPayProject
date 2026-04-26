import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:payment_app/Screen/home.page.dart';
import 'package:payment_app/config/auth/router/rightsliderFageRoute.dart';

class PaymentReceivedPage extends StatelessWidget {
  const PaymentReceivedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF09111C),
      body: Stack(
        children: [
          // Background Theme Gradient
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
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // --- Success Illustration (Based on your image) ---
                        _buildSuccessIllustration(),

                        SizedBox(height: 40.h),

                        // --- Main Heading ---
                        Text(
                          "Payment Received!",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                        ),

                        SizedBox(height: 12.h),

                        // --- Subtext ---
                        Text(
                          "The buyer has completed the payment. Please verify your bank account and release USDT to them.",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            color: const Color(0xFF9CA3AF),
                            fontSize: 13.sp,
                            height: 1.6,
                          ),
                        ),

                        SizedBox(height: 50.h),

                        // --- Help Link ---
                        Text(
                          "Contact Support if any issue",
                          style: GoogleFonts.poppins(
                            color: const Color(0xFF06CE8F).withOpacity(0.8),
                            fontSize: 13.sp,
                            decoration: TextDecoration.underline,
                          ),
                        ),

                        SizedBox(height: 30.h),

                        // --- Main Action Button (Release) ---
                        _buildReleaseButton(context),

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

  Widget _buildAppBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "P2P Sell Order",
            style: GoogleFonts.poppins(
              color: Colors.white70,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessIllustration() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Pulsing Circles
        Container(
          height: 180.w,
          width: 180.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFF06CE8F).withOpacity(0.1),
              width: 2,
            ),
          ),
        ),
        Container(
          height: 140.w,
          width: 140.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFF06CE8F).withOpacity(0.2),
              width: 2,
            ),
          ),
        ),
        // Cash/Icon Center
        Container(
          height: 100.w,
          width: 100.w,
          decoration: BoxDecoration(
            color: const Color(0xFF06CE8F).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            CupertinoIcons.money_dollar_circle_fill,
            color: Color(0xFF06CE8F),
            size: 60,
          ),
        ),
        // Small Checkmark Badge
        Positioned(
          bottom: 15,
          right: 15,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: Color(0xFF06CE8F),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, color: Colors.white, size: 20),
          ),
        ),
      ],
    );
  }

  Widget _buildReleaseButton(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 56.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        gradient: const LinearGradient(
          colors: [Color(0xFF06CE8F), Color(0xFF05B47A)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF06CE8F).withOpacity(0.4),
            blurRadius: 25,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(context, RightSlideFadeRoute(page: SuccessPage()));
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
        child: Text(
          "RELEASE USDT",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 16.sp,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }
}

class SuccessPage extends StatelessWidget {
  const SuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF09111C),
      body: Stack(
        children: [
          // Background Gradient (Same as Login Page)
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(0, -0.3),
                radius: 1.2,
                colors: [Color(0xFF1A2A3A), Color(0xFF09111C)],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 2),

                  // --- Success Animated Illustration ---
                  _buildSuccessIllustration(),

                  SizedBox(height: 50.h),

                  // --- Heading ---
                  Text(
                    "USDT Released Successfully!",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  SizedBox(height: 15.h),

                  // --- Description ---
                  Text(
                    "The transaction is complete. You have successfully released USDT to the buyer.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF9CA3AF),
                      fontSize: 14.sp,
                      height: 1.5,
                    ),
                  ),

                  const Spacer(flex: 2),

                  // --- Done Button (Same Emerald Theme) ---
                  _buildDoneButton(context),

                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessIllustration() {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer Glow Rings
          Container(
            height: 200.w,
            width: 200.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF06CE8F).withOpacity(0.05),
                width: 1,
              ),
            ),
          ),
          Container(
            height: 160.w,
            width: 160.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF06CE8F).withOpacity(0.1),
                width: 1,
              ),
            ),
          ),
          // Main Green Circle with Tick
          Container(
            height: 110.w,
            width: 110.w,
            decoration: BoxDecoration(
              color: const Color(0xFF06CE8F),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF06CE8F).withOpacity(0.4),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Icon(Icons.check_rounded, color: Colors.white, size: 65.sp),
          ),
          // Decorative Stars/Sparkles (Using Icons as placeholders)
          Positioned(
            top: 20,
            right: 30,
            child: Icon(Icons.star, color: Colors.white24, size: 12.sp),
          ),
          Positioned(
            bottom: 40,
            left: 20,
            child: Icon(Icons.star, color: Colors.white24, size: 10.sp),
          ),
          Positioned(
            top: 60,
            left: 10,
            child: Icon(Icons.star, color: Colors.white24, size: 8.sp),
          ),
        ],
      ),
    );
  }

  Widget _buildDoneButton(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 56.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        gradient: const LinearGradient(
          colors: [Color(0xFF06CE8F), Color(0xFF05B47A)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF06CE8F).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushAndRemoveUntil(
            context,
            RightSlideFadeRoute(page: HomeBottomNav()),
            (route) => false,
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
        child: Text(
          "Done",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 16.sp,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
}
