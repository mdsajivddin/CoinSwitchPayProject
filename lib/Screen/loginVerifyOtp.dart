// import 'dart:async';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:payment_app/config/utils/showMessage.dart';
// import 'package:payment_app/data/controller/loginVerifyController.dart';
// import 'package:pin_code_fields/pin_code_fields.dart';

// class LoginVerifyOtp extends ConsumerStatefulWidget {
//   final String token;
//   final String? email;
//   final String? pass;

//   const LoginVerifyOtp({super.key, required this.token, this.email, this.pass});

//   @override
//   ConsumerState<LoginVerifyOtp> createState() => _LoginVerifyOtpState();
// }

// class _LoginVerifyOtpState extends ConsumerState<LoginVerifyOtp> {
//   final GlobalKey<FormState> otpFormKey = GlobalKey<FormState>();
//   final TextEditingController otpController = TextEditingController();

//   Timer? _timer;
//   int _start = 60;
//   bool _isTimerActive = true;

//   @override
//   void initState() {
//     super.initState();
//     startTimer();
//   }

//   void startTimer() {
//     _isTimerActive = true;
//     _start = 60;
//     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (_start == 0) {
//         setState(() {
//           _timer?.cancel();
//           _isTimerActive = false;
//         });
//       } else {
//         setState(() {
//           _start--;
//         });
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _timer?.cancel();
//     otpController.dispose();
//     super.dispose();
//   }

//   void handleVerify() async {
//     if (otpController.text.length == 6) {
//       await ref
//           .read(loginVerifyProvider.notifier)
//           .loginVerify(
//             token: widget.token,
//             otp: otpController.text.trim(),
//             context: context,
//           );
//       final state = ref.read(loginVerifyProvider);
//       if (state.value == null && !state.isLoading) {
//         otpController.clear();
//       }
//     } else {
//       ShowMessage.error(context, "Please enter 6 digit OTP");
//     }
//   }

//   void handleResend() {
//     if (!_isTimerActive) {
//       ref
//           .read(resendProvider.notifier)
//           .resend(
//             email: widget.email.toString(),
//             pass: widget.pass.toString(),
//             context: context,
//           );
//       startTimer();
//       ShowMessage.success(context, "OTP Resent successfully");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final loginVerifyState = ref.watch(loginVerifyProvider);
//     final isLoading = loginVerifyState is AsyncLoading;

//     return Scaffold(
//       backgroundColor: const Color(0xFF09111C),
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         backgroundColor: const Color(0xFF09111C),
//         elevation: 0,
//         toolbarHeight: 0,
//       ),
//       body: Stack(
//         children: [
//           SingleChildScrollView(
//             physics: const BouncingScrollPhysics(),
//             child: Padding(
//               padding: EdgeInsets.symmetric(horizontal: 24.w),
//               child: Form(
//                 key: otpFormKey,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     SizedBox(height: 40.h), // ← reduced
//                     // Title
//                     Text(
//                       "Verification Code",
//                       style: GoogleFonts.poppins(
//                         fontSize: 24.sp, // ← 27 → 24
//                         fontWeight: FontWeight.w700,
//                         color: Colors.white,
//                         letterSpacing: -0.3,
//                       ),
//                     ),

//                     SizedBox(height: 8.h),

//                     // Subtitle
//                     Text(
//                       "Enter the 6-digit code sent to your email",
//                       textAlign: TextAlign.center,
//                       style: GoogleFonts.poppins(
//                         fontSize: 13.sp, // ← 13.8 → 13
//                         color: const Color(0xFF9CA3AF),
//                         height: 1.4,
//                       ),
//                     ),

//                     SizedBox(height: 48.h), // ← reduced
//                     // Secure icon with glow
//                     Container(
//                       width: 110.w, // ← 130 → 110
//                       height: 110.w,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         gradient: const LinearGradient(
//                           begin: Alignment.topLeft,
//                           end: Alignment.bottomRight,
//                           colors: [Color(0xFF06CE8F), Color(0xFF059A6A)],
//                         ),
//                         boxShadow: [
//                           BoxShadow(
//                             color: const Color(0xFF06CE8F).withOpacity(0.45),
//                             blurRadius: 38,
//                             spreadRadius: 12,
//                           ),
//                           BoxShadow(
//                             color: Colors.black.withOpacity(0.35),
//                             blurRadius: 28,
//                             offset: const Offset(0, 10),
//                           ),
//                         ],
//                       ),
//                       child: Icon(
//                         Icons.verified_user_rounded,
//                         size: 56.sp, // ← 65 → 56
//                         color: Colors.white,
//                       ),
//                     ),

//                     SizedBox(height: 48.h), // ← reduced
//                     // OTP Input
//                     PinCodeTextField(
//                       appContext: context,
//                       length: 6,
//                       controller: otpController,
//                       keyboardType: TextInputType.number,
//                       autoDisposeControllers: false,
//                       animationType: AnimationType.fade,
//                       onChanged: (v) {},
//                       cursorColor: const Color(0xFF06CE8F),
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       textStyle: GoogleFonts.poppins(
//                         color: Colors.white,
//                         fontSize: 19.sp, // ← 21 → 19
//                         fontWeight: FontWeight.w700,
//                       ),
//                       pinTheme: PinTheme(
//                         shape: PinCodeFieldShape.box,
//                         borderRadius: BorderRadius.circular(12.r),
//                         fieldHeight: 50.h, // ← 54 → 50
//                         fieldWidth: 44.w, // ← 48 → 44
//                         borderWidth: 1.5,
//                         activeColor: const Color(0xFF06CE8F),
//                         selectedColor: const Color(0xFF06CE8F),
//                         inactiveColor: const Color(0xFF1B8375).withOpacity(0.7),
//                         activeFillColor: const Color(0xFF131C29),
//                         selectedFillColor: const Color(0xFF131C29),
//                         inactiveFillColor: const Color(
//                           0xFF131C29,
//                         ).withOpacity(0.45),
//                       ),
//                       enableActiveFill: true,
//                     ),

//                     SizedBox(height: 42.h), // ← reduced
//                     // VERIFY OTP Button
//                     SizedBox(
//                       width: double.infinity,
//                       height: 50.h, // ← 54 → 50
//                       child: ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: const Color(0xFF06CE8F),
//                           disabledBackgroundColor: Colors.white10,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(28.r),
//                           ),
//                           elevation: 0,
//                         ),
//                         onPressed: isLoading ? null : handleVerify,
//                         child:
//                             isLoading
//                                 ? const CupertinoActivityIndicator(
//                                   color: Colors.white,
//                                 )
//                                 : Text(
//                                   "VERIFY OTP",
//                                   style: GoogleFonts.poppins(
//                                     fontSize: 14.5.sp, // ← 15.5 → 14.5
//                                     fontWeight: FontWeight.w700,
//                                     color: Colors.white,
//                                     letterSpacing: 1.1,
//                                   ),
//                                 ),
//                       ),
//                     ),

//                     SizedBox(height: 32.h),

//                     // Resend section
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           _isTimerActive
//                               ? "Resend code in "
//                               : "Didn't receive the code? ",
//                           style: GoogleFonts.poppins(
//                             fontSize: 13.sp, // ← 13.5 → 13
//                             color: const Color(0xFF9CA3AF),
//                           ),
//                         ),
//                         SizedBox(width: 6.w),
//                         InkWell(
//                           onTap:
//                               (isLoading || _isTimerActive)
//                                   ? null
//                                   : handleResend,
//                           child: Text(
//                             _isTimerActive
//                                 ? "00:${_start.toString().padLeft(2, '0')}"
//                                 : "Resend",
//                             style: GoogleFonts.poppins(
//                               fontSize: 13.sp,
//                               fontWeight: FontWeight.w700,
//                               color: const Color(0xFF06CE8F),
//                               decoration: TextDecoration.underline,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),

//                     SizedBox(height: 32.h), // ← reduced
//                   ],
//                 ),
//               ),
//             ),
//           ),

//           if (isLoading)
//             Container(
//               color: Colors.black.withOpacity(0.4),
//               child: const Center(
//                 child: CircularProgressIndicator(color: Color(0xFF06CE8F)),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:payment_app/Screen/home.page.dart';
import 'package:payment_app/config/auth/router/rightsliderFageRoute.dart';
import 'package:payment_app/config/utils/showMessage.dart';
import 'package:payment_app/data/controller/loginVerifyController.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class LoginVerifyOtp extends ConsumerStatefulWidget {
  final String token;
  final String? email;
  final String? pass;

  const LoginVerifyOtp({super.key, required this.token, this.email, this.pass});

  @override
  ConsumerState<LoginVerifyOtp> createState() => _LoginVerifyOtpState();
}

class _LoginVerifyOtpState extends ConsumerState<LoginVerifyOtp> {
  final GlobalKey<FormState> otpFormKey = GlobalKey<FormState>();
  final TextEditingController otpController = TextEditingController();

  Timer? _timer;
  int _start = 60;
  bool _isTimerActive = true;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _isTimerActive = true;
    _start = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        setState(() {
          _timer?.cancel();
          _isTimerActive = false;
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    otpController.dispose();
    super.dispose();
  }

  void handleVerify() async {
    if (otpController.text.length == 6) {
      await ref
          .read(loginVerifyProvider.notifier)
          .loginVerify(
            token: widget.token,
            otp: otpController.text.trim(),
            context: context,
          );
      final state = ref.read(loginVerifyProvider);
      if (state.value == null && !state.isLoading) {
        otpController.clear();
      }
    } else {
      ShowMessage.error(context, "Please enter 6 digit OTP");
    }
  }

  void handleResend() {
    if (!_isTimerActive) {
      ref
          .read(resendProvider.notifier)
          .resend(
            email: widget.email.toString(),
            pass: widget.pass.toString(),
            context: context,
          );
      startTimer();
      ShowMessage.success(context, "OTP Resent successfully");
    }
  }

  @override
  Widget build(BuildContext context) {
    final loginVerifyState = ref.watch(loginVerifyProvider);
    final isLoading = loginVerifyState is AsyncLoading;

    return Scaffold(
      backgroundColor: const Color(0xFF09111C),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF09111C),
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Form(
                  key: otpFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 64.w,
                        height: 64.w,
                        decoration: BoxDecoration(
                          color: const Color(0xFF06CE8F).withOpacity(0.12),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF06CE8F).withOpacity(0.3),
                            width: 1.2,
                          ),
                        ),
                        child: Icon(
                          Icons.shield_outlined,
                          size: 32.sp,
                          color: const Color(0xFF06CE8F),
                        ),
                      ),

                      SizedBox(height: 28.h),

                      // Title
                      Text(
                        "Verification Code",
                        style: GoogleFonts.poppins(
                          fontSize: 26.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: -0.4,
                        ),
                      ),

                      SizedBox(height: 12.h),

                      // Subtitle
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        child: Text(
                          "Enter the 6-digit code sent to your email",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 13.5.sp,
                            color: const Color(0xFF9CA3AF),
                            height: 1.4,
                          ),
                        ),
                      ),

                      SizedBox(height: 50.h),

                      // OTP Input - added subtle active glow
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: PinCodeTextField(
                          appContext: context,
                          length: 6,
                          controller: otpController,
                          keyboardType: TextInputType.number,
                          autoDisposeControllers: false,
                          animationType: AnimationType.fade,
                          onChanged: (v) {},
                          cursorColor: const Color(0xFF06CE8F),
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          textStyle: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w600,
                          ),
                          pinTheme: PinTheme(
                            shape: PinCodeFieldShape.box,
                            borderRadius: BorderRadius.circular(14.r),
                            fieldHeight: 54.h,
                            fieldWidth: 48.w,
                            borderWidth: 1.4,
                            activeColor: const Color(0xFF06CE8F),
                            selectedColor: const Color(0xFF06CE8F),
                            inactiveColor: Colors.white.withOpacity(0.12),
                            activeFillColor: const Color(0xFF131C29),
                            selectedFillColor: const Color(0xFF131C29),
                            inactiveFillColor: const Color(
                              0xFF131C29,
                            ).withOpacity(0.4),
                            errorBorderColor: Colors.redAccent,
                          ),
                          enableActiveFill: true,
                        ),
                      ),

                      SizedBox(height: 44.h),

                      // VERIFY Button - using same gradient as login/register
                      GestureDetector(
                        onTap: isLoading ? null : handleVerify,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: double.infinity,
                          height: 52.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(999),
                            gradient: const LinearGradient(
                              colors: [Color(0xFF06CE8F), Color(0xFF05B47A)],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF06CE8F).withOpacity(0.3),
                                blurRadius: 16,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Center(
                            child:
                                isLoading
                                    ? const CupertinoActivityIndicator(
                                      color: Colors.white,
                                    )
                                    : Text(
                                      "VERIFY OTP",
                                      style: GoogleFonts.poppins(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                        letterSpacing: 1.0,
                                      ),
                                    ),
                          ),
                        ),
                      ),

                      SizedBox(height: 36.h),

                      // Resend row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _isTimerActive
                                ? "Resend code in "
                                : "Didn't receive the code? ",
                            style: GoogleFonts.poppins(
                              fontSize: 13.sp,
                              color: const Color(0xFF9CA3AF),
                            ),
                          ),
                          SizedBox(width: 6.w),
                          InkWell(
                            onTap:
                                (isLoading || _isTimerActive)
                                    ? null
                                    : handleResend,
                            child: Text(
                              _isTimerActive
                                  ? "00:${_start.toString().padLeft(2, '0')}"
                                  : "Resend",
                              style: GoogleFonts.poppins(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF06CE8F),
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 40.h),
                    ],
                  ),
                ),
              ),
            ),
          ),

          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.45),
              child: const Center(
                child: CircularProgressIndicator(color: Color(0xFF06CE8F)),
              ),
            ),
        ],
      ),
    );
  }
}
