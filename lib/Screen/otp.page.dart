// import 'dart:async';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:payment_app/config/utils/showMessage.dart';
// import 'package:payment_app/data/controller/loginVerifyController.dart';
// import 'package:payment_app/data/controller/registerVerifyController.dart';
// import 'package:pin_code_fields/pin_code_fields.dart';

// class OtpPage extends ConsumerStatefulWidget {
//   final String token;
//   final String? name;
//   final String? email;
//   final String? pass;
//   const OtpPage({
//     super.key,
//     required this.token,
//     this.name,
//     this.email,
//     this.pass,
//   });

//   @override
//   ConsumerState<OtpPage> createState() => _OtpPageState();
// }

// class _OtpPageState extends ConsumerState<OtpPage> {
//   final GlobalKey<FormState> otpFormKey = GlobalKey<FormState>();
//   final TextEditingController otpController = TextEditingController();

//   Timer? _timer;
//   int _start = 60; // 1 minute = 60 seconds
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

//   // API Call logic
//   void handleVerify() async {
//     if (otpController.text.length == 6) {
//       await ref
//           .read(registerVerifyProvider.notifier)
//           .registerVerify(
//             token: widget.token,
//             otp: otpController.text.trim(),
//             context: context,
//           );
//       final state = ref.read(registerVerifyProvider);
//       if (state.value == null && !state.isLoading) {
//         otpController.clear();
//       }
//     } else {
//       ShowMessage.error(context, "Please enter 6 digit OTP");
//     }
//   }

//   void handleResendRegisterVerify() {
//     if (!_isTimerActive) {
//       ref
//           .read(resendRegisterVerfiProvider.notifier)
//           .resendRegister(
//             name: widget.name.toString(),
//             email: widget.email.toString(),
//             passw: widget.pass.toString(),
//             context: context,
//           );
//       startTimer();
//       ShowMessage.success(context, "OTP Resent successfully");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final registerVerifyState = ref.watch(registerVerifyProvider);
//     final isLoading = registerVerifyState is AsyncLoading;

//     return Scaffold(
//       backgroundColor: const Color(0xFF09111C),
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         backgroundColor: const Color(0xFF09111C),
//         elevation: 0,
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
//                     SizedBox(height: 40.h),

//                     // Title
//                     Text(
//                       "Verification Code",
//                       style: GoogleFonts.poppins(
//                         fontSize: 28.sp,
//                         fontWeight: FontWeight.w700,
//                         color: Colors.white,
//                         letterSpacing: -0.4,
//                       ),
//                     ),

//                     SizedBox(height: 12.h),

//                     // Subtitle (typo fixed + cleaner)
//                     Text(
//                       "We have sent a 6-digit code to your email",
//                       textAlign: TextAlign.center,
//                       style: GoogleFonts.poppins(
//                         fontSize: 14.sp,
//                         color: const Color(0xFF9CA3AF),
//                         height: 1.5,
//                       ),
//                     ),

//                     SizedBox(height: 50.h),

//                     // Image remove → premium secure icon with gradient & glow
//                     Container(
//                       width: 140.w,
//                       height: 140.w,
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
//                             blurRadius: 40,
//                             spreadRadius: 15,
//                           ),
//                           BoxShadow(
//                             color: Colors.black.withOpacity(0.35),
//                             blurRadius: 30,
//                             offset: const Offset(0, 12),
//                           ),
//                         ],
//                       ),
//                       child: Icon(
//                         Icons.verified_user_rounded, // secure verification icon
//                         size: 70.sp,
//                         color: Colors.white,
//                       ),
//                     ),

//                     SizedBox(height: 60.h),

//                     // OTP Input (slightly refined)
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
//                         fontSize: 22.sp,
//                         fontWeight: FontWeight.w700,
//                       ),
//                       pinTheme: PinTheme(
//                         shape: PinCodeFieldShape.box,
//                         borderRadius: BorderRadius.circular(14.r),
//                         fieldHeight: 56.h,
//                         fieldWidth: 50.w,
//                         borderWidth: 1.8,
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

//                     SizedBox(height: 50.h),

//                     // Verify Button
//                     SizedBox(
//                       width: double.infinity,
//                       height: 56.h,
//                       child: ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: const Color(0xFF06CE8F),
//                           disabledBackgroundColor: Colors.white10,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(30.r),
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
//                                     fontSize: 16.5.sp,
//                                     fontWeight: FontWeight.w700,
//                                     color: Colors.white,
//                                     letterSpacing: 1.3,
//                                   ),
//                                 ),
//                       ),
//                     ),

//                     SizedBox(height: 40.h),

//                     // Resend section
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           _isTimerActive
//                               ? "Resend code in "
//                               : "Didn't receive the code? ",
//                           style: GoogleFonts.poppins(
//                             fontSize: 14.sp,
//                             color: const Color(0xFF9CA3AF),
//                           ),
//                         ),
//                         SizedBox(width: 6.w),
//                         InkWell(
//                           onTap:
//                               (isLoading || _isTimerActive)
//                                   ? null
//                                   : handleResendRegisterVerify,
//                           child: Text(
//                             _isTimerActive
//                                 ? "00:${_start.toString().padLeft(2, '0')}"
//                                 : "Resend",
//                             style: GoogleFonts.poppins(
//                               fontSize: 14.sp,
//                               fontWeight: FontWeight.w700,
//                               color: const Color(0xFF06CE8F),
//                               decoration: TextDecoration.underline,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),

//                     SizedBox(height: 40.h),
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
import 'package:payment_app/config/utils/showMessage.dart';
import 'package:payment_app/data/controller/loginVerifyController.dart';
import 'package:payment_app/data/controller/registerVerifyController.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpPage extends ConsumerStatefulWidget {
  final String token;
  final String? name;
  final String? email;
  final String? pass;

  const OtpPage({
    super.key,
    required this.token,
    this.name,
    this.email,
    this.pass,
  });

  @override
  ConsumerState<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends ConsumerState<OtpPage> {
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
          .read(registerVerifyProvider.notifier)
          .registerVerify(
            token: widget.token,
            otp: otpController.text.trim(),
            context: context,
          );
      final state = ref.read(registerVerifyProvider);
      if (state.value == null && !state.isLoading) {
        otpController.clear();
      }
    } else {
      ShowMessage.error(context, "Please enter 6 digit OTP");
    }
  }

  void handleResendRegisterVerify() {
    if (!_isTimerActive) {
      ref
          .read(resendRegisterVerfiProvider.notifier)
          .resendRegister(
            name: widget.name.toString(),
            email: widget.email.toString(),
            passw: widget.pass.toString(),
            context: context,
          );
      startTimer();
      ShowMessage.success(context, "OTP Resent successfully");
    }
  }

  @override
  Widget build(BuildContext context) {
    final registerVerifyState = ref.watch(registerVerifyProvider);
    final isLoading = registerVerifyState is AsyncLoading;

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
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Form(
                key: otpFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 50.h),

                    // Title
                    Text(
                      "Verification Code",
                      style: GoogleFonts.poppins(
                        fontSize: 27.sp, // slightly smaller
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: -0.4,
                      ),
                    ),

                    SizedBox(height: 10.h),

                    // Subtitle
                    Text(
                      "We have sent a 6-digit code to your email",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 13.8.sp,
                        color: const Color(0xFF9CA3AF),
                        height: 1.45,
                      ),
                    ),

                    SizedBox(height: 55.h),

                    // Secure verification icon with glow
                    Container(
                      width: 130.w,
                      height: 130.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF06CE8F), Color(0xFF059A6A)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF06CE8F).withOpacity(0.45),
                            blurRadius: 38,
                            spreadRadius: 12,
                          ),
                          BoxShadow(
                            color: Colors.black.withOpacity(0.35),
                            blurRadius: 28,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.verified_user_rounded,
                        size: 65.sp,
                        color: Colors.white,
                      ),
                    ),

                    SizedBox(height: 55.h),

                    // OTP Input
                    PinCodeTextField(
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
                        fontSize: 21.sp,
                        fontWeight: FontWeight.w700,
                      ),
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(12.r),
                        fieldHeight: 54.h,
                        fieldWidth: 48.w,
                        borderWidth: 1.6,
                        activeColor: const Color(0xFF06CE8F),
                        selectedColor: const Color(0xFF06CE8F),
                        inactiveColor: const Color(0xFF1B8375).withOpacity(0.7),
                        activeFillColor: const Color(0xFF131C29),
                        selectedFillColor: const Color(0xFF131C29),
                        inactiveFillColor: const Color(
                          0xFF131C29,
                        ).withOpacity(0.45),
                      ),
                      enableActiveFill: true,
                    ),

                    SizedBox(height: 48.h),

                    // VERIFY OTP Button
                    SizedBox(
                      width: double.infinity,
                      height: 54.h,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF06CE8F),
                          disabledBackgroundColor: Colors.white10,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28.r),
                          ),
                          elevation: 0,
                        ),
                        onPressed: isLoading ? null : handleVerify,
                        child:
                            isLoading
                                ? const CupertinoActivityIndicator(
                                  color: Colors.white,
                                )
                                : Text(
                                  "VERIFY OTP",
                                  style: GoogleFonts.poppins(
                                    fontSize: 15.5.sp,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                      ),
                    ),

                    SizedBox(height: 36.h),

                    // Resend section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _isTimerActive
                              ? "Resend code in "
                              : "Didn't receive the code? ",
                          style: GoogleFonts.poppins(
                            fontSize: 13.5.sp,
                            color: const Color(0xFF9CA3AF),
                          ),
                        ),
                        SizedBox(width: 6.w),
                        InkWell(
                          onTap:
                              (isLoading || _isTimerActive)
                                  ? null
                                  : handleResendRegisterVerify,
                          child: Text(
                            _isTimerActive
                                ? "00:${_start.toString().padLeft(2, '0')}"
                                : "Resend",
                            style: GoogleFonts.poppins(
                              fontSize: 13.5.sp,
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

          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.4),
              child: const Center(
                child: CircularProgressIndicator(color: Color(0xFF06CE8F)),
              ),
            ),
        ],
      ),
    );
  }
}
