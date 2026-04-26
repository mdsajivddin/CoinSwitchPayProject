// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:payment_app/config/utils/showMessage.dart';
// import 'package:payment_app/data/controller/forgotPassController.dart';
// import 'package:pin_code_fields/pin_code_fields.dart';

// class ForgotPasswordOtpPage extends ConsumerStatefulWidget {
//   final String token;
//   const ForgotPasswordOtpPage({super.key, required this.token});

//   @override
//   ConsumerState<ForgotPasswordOtpPage> createState() =>
//       _ForgotPasswordOtpPageState();
// }

// class _ForgotPasswordOtpPageState extends ConsumerState<ForgotPasswordOtpPage>
//     with SingleTickerProviderStateMixin {
//   final TextEditingController otpController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final TextEditingController confirmController = TextEditingController();

//   final formKey = GlobalKey<FormState>();

//   late AnimationController _animController;
//   late Animation<double> _fadeAnimation;
//   late Animation<double> _scaleAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _animController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1200),
//     );

//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
//     );

//     _scaleAnimation = Tween<double>(begin: 0.92, end: 1.0).animate(
//       CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
//     );

//     _animController.forward();
//   }

//   @override
//   void dispose() {
//     _animController.dispose();
//     otpController.dispose();
//     passwordController.dispose();
//     confirmController.dispose();
//     _animController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final forgotState = ref.watch(forgotPassProvider);
//     final isLoading = forgotState is AsyncLoading;

//     return Scaffold(
//       resizeToAvoidBottomInset: true,
//       backgroundColor: const Color(0xFF09111C),
//       body: Stack(
//         children: [
//           // Background gradient (same as login & forgot page)
//           Container(
//             decoration: const BoxDecoration(
//               gradient: RadialGradient(
//                 center: Alignment(-0.9, -0.9),
//                 radius: 1.4,
//                 colors: [Color(0xFF1A2A3A), Color(0xFF09111C)],
//               ),
//             ),
//           ),

//           SafeArea(
//             child: Padding(
//               padding: EdgeInsets.symmetric(horizontal: 20.w),
//               child: SingleChildScrollView(
//                 physics: const BouncingScrollPhysics(),
//                 child: FadeTransition(
//                   opacity: _fadeAnimation,
//                   child: ScaleTransition(
//                     scale: _scaleAnimation,
//                     child: Form(
//                       key: formKey,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           SizedBox(height: 60.h),

//                           // Branding header
//                           Text(
//                             "CoinSwitchPay",
//                             style: GoogleFonts.poppins(
//                               fontSize: 40.sp,
//                               fontWeight: FontWeight.w800,
//                               color: Colors.white,
//                               letterSpacing: -1.2,
//                               shadows: [
//                                 Shadow(
//                                   color: const Color(
//                                     0xFF06CE8F,
//                                   ).withOpacity(0.3),
//                                   blurRadius: 20,
//                                   offset: const Offset(0, 6),
//                                 ),
//                               ],
//                             ),
//                           ),

//                           SizedBox(height: 8.h),

//                           Text(
//                             "India's Largest Crypto App",
//                             style: GoogleFonts.poppins(
//                               fontSize: 16.sp,
//                               fontWeight: FontWeight.w600,
//                               color: const Color(0xFF06CE8F),
//                               letterSpacing: 0.8,
//                             ),
//                           ),

//                           SizedBox(height: 40.h),

//                           // Title & subtitle
//                           Text(
//                             "Verify OTP",
//                             style: GoogleFonts.poppins(
//                               fontSize: 30.sp,
//                               fontWeight: FontWeight.w700,
//                               color: Colors.white,
//                               letterSpacing: -0.6,
//                             ),
//                           ),
//                           SizedBox(height: 12.h),

//                           Text(
//                             "Enter the 6-digit code sent to your email\nto reset your password",
//                             textAlign: TextAlign.center,
//                             style: GoogleFonts.poppins(
//                               fontSize: 15.sp,
//                               color: const Color(0xFF9CA3AF),
//                               height: 1.5,
//                             ),
//                           ),

//                           SizedBox(height: 45.h),

//                           // Glassmorphism card
//                           Container(
//                             width: double.infinity,
//                             padding: EdgeInsets.symmetric(
//                               horizontal: 20.w,
//                               vertical: 30.h,
//                             ),
//                             decoration: BoxDecoration(
//                               color: Colors.white.withOpacity(0.06),
//                               borderRadius: BorderRadius.circular(28.r),
//                               border: Border.all(
//                                 color: Colors.white.withOpacity(0.08),
//                                 width: 1.2,
//                               ),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.black.withOpacity(0.35),
//                                   blurRadius: 30,
//                                   offset: const Offset(0, 15),
//                                 ),
//                               ],
//                               gradient: LinearGradient(
//                                 begin: Alignment.topLeft,
//                                 end: Alignment.bottomRight,
//                                 colors: [
//                                   Colors.white.withOpacity(0.07),
//                                   Colors.white.withOpacity(0.03),
//                                 ],
//                               ),
//                             ),
//                             child: Column(
//                               children: [
//                                 // OTP Field (custom styling to match theme)
//                                 PinCodeTextField(
//                                   controller: otpController,
//                                   appContext: context,
//                                   length: 6,
//                                   keyboardType: TextInputType.number,
//                                   cursorColor: const Color(0xFF06CE8F),
//                                   textStyle: GoogleFonts.poppins(
//                                     fontSize: 22.sp,
//                                     fontWeight: FontWeight.w600,
//                                     color: Colors.white,
//                                   ),
//                                   pinTheme: PinTheme(
//                                     shape: PinCodeFieldShape.box,
//                                     borderRadius: BorderRadius.circular(16.r),
//                                     fieldHeight: 50.h,
//                                     fieldWidth: 45.w,
//                                     activeColor: const Color(0xFF06CE8F),
//                                     selectedColor: const Color(0xFF06CE8F),
//                                     inactiveColor: Colors.white.withOpacity(
//                                       0.12,
//                                     ),
//                                     activeFillColor: const Color(
//                                       0xFF131C29,
//                                     ).withOpacity(0.5),
//                                     selectedFillColor: const Color(
//                                       0xFF131C29,
//                                     ).withOpacity(0.5),
//                                     inactiveFillColor: const Color(
//                                       0xFF131C29,
//                                     ).withOpacity(0.3),
//                                     borderWidth: 1.4,
//                                   ),
//                                   enableActiveFill: true,
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   onChanged: (value) {},
//                                 ),

//                                 SizedBox(height: 20.h),

//                                 // Password Field (using same modern style)
//                                 LoginForm(
//                                   label: "New Password",
//                                   hint: "••••••••••",
//                                   controller: passwordController,
//                                   isPassword: true,
//                                   prefixIcon: CupertinoIcons.lock,
//                                   validator:
//                                       (v) =>
//                                           v!.length < 6
//                                               ? "Minimum 6 characters"
//                                               : null,
//                                 ),

//                                 SizedBox(height: 24.h),

//                                 // Confirm Password Field
//                                 LoginForm(
//                                   label: "Confirm Password",
//                                   hint: "••••••••••",
//                                   controller: confirmController,
//                                   isPassword: true,
//                                   prefixIcon: CupertinoIcons.lock,
//                                   validator: (v) {
//                                     if (v != passwordController.text) {
//                                       return "Passwords do not match";
//                                     }
//                                     return null;
//                                   },
//                                 ),
//                               ],
//                             ),
//                           ),

//                           SizedBox(height: 40.h),

//                           // Reset Button – same gradient style
//                           GestureDetector(
//                             onTap:
//                                 isLoading
//                                     ? null
//                                     : () {
//                                       if (formKey.currentState!.validate()) {
//                                         if (passwordController.text.trim() !=
//                                             confirmController.text.trim()) {
//                                           ShowMessage.error(
//                                             context,
//                                             "Passwords do not match",
//                                           );
//                                           return;
//                                         }

//                                         ref
//                                             .read(forgotPassProvider.notifier)
//                                             .forgotPasswrod(
//                                               context: context,
//                                               token: widget.token,
//                                               otp: otpController.text.trim(),
//                                               pass:
//                                                   passwordController.text
//                                                       .trim(),
//                                               confirmpass:
//                                                   confirmController.text.trim(),
//                                             );
//                                       }
//                                     },
//                             child: AnimatedContainer(
//                               duration: const Duration(milliseconds: 280),
//                               width: double.infinity,
//                               height: 58.h,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(999),
//                                 gradient: LinearGradient(
//                                   colors: [
//                                     const Color(0xFF06CE8F),
//                                     const Color(0xFF05B47A),
//                                   ],
//                                 ),
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: const Color(
//                                       0xFF06CE8F,
//                                     ).withOpacity(0.35),
//                                     blurRadius: 20,
//                                     offset: const Offset(0, 12),
//                                   ),
//                                 ],
//                               ),
//                               child: Center(
//                                 child:
//                                     isLoading
//                                         ? const CupertinoActivityIndicator(
//                                           color: Colors.white,
//                                         )
//                                         : Text(
//                                           "RESET PASSWORD",
//                                           style: GoogleFonts.poppins(
//                                             fontSize: 16.5.sp,
//                                             fontWeight: FontWeight.w700,
//                                             color: Colors.white,
//                                             letterSpacing: 1.1,
//                                           ),
//                                         ),
//                               ),
//                             ),
//                           ),

//                           SizedBox(height: 40.h),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),

//           // Full-screen loading overlay
//           if (isLoading)
//             Container(
//               color: Colors.black.withOpacity(0.35),
//               child: const Center(
//                 child: CircularProgressIndicator(color: Color(0xFF06CE8F)),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }

// // ─── Reuse the same modern LoginForm from LoginPage ───
// class LoginForm extends StatefulWidget {
//   final String hint;
//   final String label;
//   final TextEditingController controller;
//   final bool isPassword;
//   final IconData prefixIcon;
//   final String? Function(String?)? validator;

//   const LoginForm({
//     super.key,
//     required this.hint,
//     required this.label,
//     required this.controller,
//     this.isPassword = false,
//     required this.prefixIcon,
//     this.validator,
//   });

//   @override
//   State<LoginForm> createState() => _LoginFormState();
// }

// class _LoginFormState extends State<LoginForm> {
//   bool _isObscured = true;
//   bool _isFocused = false;

//   @override
//   Widget build(BuildContext context) {
//     return Focus(
//       onFocusChange: (hasFocus) => setState(() => _isFocused = hasFocus),
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 240),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(20.r),
//           boxShadow:
//               _isFocused
//                   ? [
//                     BoxShadow(
//                       color: const Color(0xFF06CE8F).withOpacity(0.18),
//                       blurRadius: 16,
//                       spreadRadius: 1,
//                     ),
//                   ]
//                   : [],
//         ),
//         child: TextFormField(
//           controller: widget.controller,
//           obscureText: widget.isPassword && _isObscured,
//           validator: widget.validator,
//           style: GoogleFonts.poppins(color: Colors.white, fontSize: 15.5.sp),
//           cursorColor: const Color(0xFF06CE8F),
//           decoration: InputDecoration(
//             labelText: widget.label,
//             hintText: widget.hint,
//             floatingLabelBehavior: FloatingLabelBehavior.auto,
//             filled: true,
//             fillColor: const Color(0xFF131C29).withOpacity(0.45),
//             prefixIcon: Icon(
//               widget.prefixIcon,
//               color:
//                   _isFocused
//                       ? const Color(0xFF06CE8F)
//                       : const Color(0xFF4ADE80).withOpacity(0.7),
//               size: 22,
//             ),
//             suffixIcon:
//                 widget.isPassword
//                     ? IconButton(
//                       onPressed:
//                           () => setState(() => _isObscured = !_isObscured),
//                       icon: Icon(
//                         _isObscured
//                             ? CupertinoIcons.eye_slash
//                             : CupertinoIcons.eye,
//                         color:
//                             _isFocused
//                                 ? const Color(0xFF06CE8F)
//                                 : const Color(0xFF9CA3AF),
//                         size: 20,
//                       ),
//                     )
//                     : null,
//             contentPadding: EdgeInsets.symmetric(
//               vertical: 18.h,
//               horizontal: 20.w,
//             ),
//             labelStyle: GoogleFonts.poppins(
//               color:
//                   _isFocused
//                       ? const Color(0xFF06CE8F)
//                       : const Color(0xFF9CA3AF),
//               fontSize: 14.5.sp,
//             ),
//             hintStyle: GoogleFonts.poppins(
//               color: const Color(0xFF6B7280),
//               fontSize: 14.5.sp,
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(20.r),
//               borderSide: BorderSide(
//                 color: Colors.white.withOpacity(0.08),
//                 width: 1.2,
//               ),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(20.r),
//               borderSide: const BorderSide(
//                 color: Color(0xFF06CE8F),
//                 width: 1.8,
//               ),
//             ),
//             errorBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(20.r),
//               borderSide: const BorderSide(color: Colors.redAccent, width: 1.2),
//             ),
//             focusedErrorBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(20.r),
//               borderSide: const BorderSide(color: Colors.redAccent, width: 1.8),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:payment_app/config/utils/showMessage.dart';
import 'package:payment_app/data/controller/forgotPassController.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class ForgotPasswordOtpPage extends ConsumerStatefulWidget {
  final String token;
  const ForgotPasswordOtpPage({super.key, required this.token});

  @override
  ConsumerState<ForgotPasswordOtpPage> createState() =>
      _ForgotPasswordOtpPageState();
}

class _ForgotPasswordOtpPageState extends ConsumerState<ForgotPasswordOtpPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController otpController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  late AnimationController _animController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    );

    _scaleAnimation = Tween<double>(begin: 0.92, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    );

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    otpController.dispose();
    passwordController.dispose();
    confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final forgotState = ref.watch(forgotPassProvider);
    final isLoading = forgotState is AsyncLoading;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFF09111C),
      appBar: AppBar(
        backgroundColor: const Color(0xFF09111C),
        toolbarHeight: 0,
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(-0.9, -0.9),
                radius: 1.4,
                colors: [Color(0xFF1A2A3A), Color(0xFF09111C)],
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Center(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: Form(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "CoinSwitchPay",
                              style: GoogleFonts.poppins(
                                fontSize: 32.sp, // ← 40 → 32
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: -1.0,
                                shadows: [
                                  Shadow(
                                    color: const Color(
                                      0xFF06CE8F,
                                    ).withOpacity(0.3),
                                    blurRadius: 20,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: 6.h),

                            Text(
                              "India's Largest Crypto App",
                              style: GoogleFonts.poppins(
                                fontSize: 13.sp, // ← 16 → 13
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF06CE8F),
                                letterSpacing: 0.5,
                              ),
                            ),

                            SizedBox(height: 36.h), // ← reduced
                            // Title & subtitle
                            Text(
                              "Verify OTP",
                              style: GoogleFonts.poppins(
                                fontSize: 26.sp, // ← 30 → 26
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                letterSpacing: -0.5,
                              ),
                            ),
                            SizedBox(height: 10.h),

                            Text(
                              "Enter the 6-digit code sent to your email\nto reset your password",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontSize: 13.5.sp, // ← 15 → 13.5
                                color: const Color(0xFF9CA3AF),
                                height: 1.45,
                              ),
                            ),

                            SizedBox(height: 40.h), // ← reduced
                            // Glassmorphism card
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                horizontal: 18.w, // slightly tighter
                                vertical: 26.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.06),
                                borderRadius: BorderRadius.circular(26.r),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.08),
                                  width: 1.1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.35),
                                    blurRadius: 30,
                                    offset: const Offset(0, 15),
                                  ),
                                ],
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.white.withOpacity(0.07),
                                    Colors.white.withOpacity(0.03),
                                  ],
                                ),
                              ),
                              child: Column(
                                children: [
                                  // OTP Field
                                  PinCodeTextField(
                                    controller: otpController,
                                    appContext: context,
                                    length: 6,
                                    keyboardType: TextInputType.number,
                                    cursorColor: const Color(0xFF06CE8F),
                                    textStyle: GoogleFonts.poppins(
                                      fontSize: 19.sp, // ← 22 → 19
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                    pinTheme: PinTheme(
                                      shape: PinCodeFieldShape.box,
                                      borderRadius: BorderRadius.circular(14.r),
                                      fieldHeight: 48.h, // ← 50 → 48
                                      fieldWidth: 42.w, // ← 45 → 42
                                      activeColor: const Color(0xFF06CE8F),
                                      selectedColor: const Color(0xFF06CE8F),
                                      inactiveColor: Colors.white.withOpacity(
                                        0.12,
                                      ),
                                      activeFillColor: const Color(
                                        0xFF131C29,
                                      ).withOpacity(0.5),
                                      selectedFillColor: const Color(
                                        0xFF131C29,
                                      ).withOpacity(0.5),
                                      inactiveFillColor: const Color(
                                        0xFF131C29,
                                      ).withOpacity(0.3),
                                      borderWidth: 1.4,
                                    ),
                                    enableActiveFill: true,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    onChanged: (value) {},
                                  ),

                                  SizedBox(height: 20.h),

                                  // Password Field
                                  LoginForm(
                                    label: "New Password",
                                    hint: "••••••••••",
                                    controller: passwordController,
                                    isPassword: true,
                                    prefixIcon: CupertinoIcons.lock,
                                    validator:
                                        (v) =>
                                            v!.length < 6
                                                ? "Minimum 6 characters"
                                                : null,
                                  ),

                                  SizedBox(height: 20.h), // ← reduced
                                  // Confirm Password Field
                                  LoginForm(
                                    label: "Confirm Password",
                                    hint: "••••••••••",
                                    controller: confirmController,
                                    isPassword: true,
                                    prefixIcon: CupertinoIcons.lock,
                                    validator: (v) {
                                      if (v != passwordController.text) {
                                        return "Passwords do not match";
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: 32.h), // ← reduced
                            // Reset Button
                            GestureDetector(
                              onTap:
                                  isLoading
                                      ? null
                                      : () {
                                        if (formKey.currentState!.validate()) {
                                          if (passwordController.text.trim() !=
                                              confirmController.text.trim()) {
                                            ShowMessage.error(
                                              context,
                                              "Passwords do not match",
                                            );
                                            return;
                                          }

                                          ref
                                              .read(forgotPassProvider.notifier)
                                              .forgotPasswrod(
                                                context: context,
                                                token: widget.token,
                                                otp: otpController.text.trim(),
                                                pass:
                                                    passwordController.text
                                                        .trim(),
                                                confirmpass:
                                                    confirmController.text
                                                        .trim(),
                                              );
                                        }
                                      },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 280),
                                width: double.infinity,
                                height: 52.h, // ← 58 → 52
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(999),
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF06CE8F),
                                      Color(0xFF05B47A),
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(
                                        0xFF06CE8F,
                                      ).withOpacity(0.35),
                                      blurRadius: 20,
                                      offset: const Offset(0, 12),
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
                                            "RESET PASSWORD",
                                            style: GoogleFonts.poppins(
                                              fontSize:
                                                  14.5.sp, // ← 16.5 → 14.5
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                              letterSpacing: 1.0,
                                            ),
                                          ),
                                ),
                              ),
                            ),

                            SizedBox(height: 32.h),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Loading overlay
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.35),
              child: const Center(
                child: CircularProgressIndicator(color: Color(0xFF06CE8F)),
              ),
            ),
        ],
      ),
    );
  }
}

// Updated LoginForm – matching the smaller sizes used across your app
class LoginForm extends StatefulWidget {
  final String hint;
  final String label;
  final TextEditingController controller;
  final bool isPassword;
  final IconData prefixIcon;
  final String? Function(String?)? validator;

  const LoginForm({
    super.key,
    required this.hint,
    required this.label,
    required this.controller,
    this.isPassword = false,
    required this.prefixIcon,
    this.validator,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool _isObscured = true;
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.isPassword && _isObscured,
      validator: widget.validator,
      style: GoogleFonts.poppins(
        color: Colors.white,
        fontSize: 14.sp, // ← 15.5 → 14
      ),
      cursorColor: const Color(0xFF06CE8F),
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        filled: true,
        fillColor: const Color(0xFF131C29).withOpacity(0.45),
        prefixIcon: Icon(
          widget.prefixIcon,
          color:
              _isFocused
                  ? const Color(0xFF06CE8F)
                  : const Color(0xFF4ADE80).withOpacity(0.7),
          size: 20.w,
        ),
        suffixIcon:
            widget.isPassword
                ? IconButton(
                  onPressed:
                      () => setState(() => _isObscured = !_isObscured),
                  icon: Icon(
                    _isObscured
                        ? CupertinoIcons.eye_slash
                        : CupertinoIcons.eye,
                    color:
                        _isFocused
                            ? const Color(0xFF06CE8F)
                            : const Color(0xFF9CA3AF),
                    size: 18.w,
                  ),
                )
                : null,
        contentPadding: EdgeInsets.symmetric(
          vertical: 16.h, // ← reduced
          horizontal: 18.w,
        ),
        labelStyle: GoogleFonts.poppins(
          color:
              _isFocused
                  ? const Color(0xFF06CE8F)
                  : const Color(0xFF9CA3AF),
          fontSize: 13.sp, // ← 14.5 → 13
        ),
        hintStyle: GoogleFonts.poppins(
          color: const Color(0xFF6B7280),
          fontSize: 13.sp,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.r),
          borderSide: BorderSide(
            color: Colors.white.withOpacity(0.08),
            width: 1.1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.r),
          borderSide: const BorderSide(
            color: Color(0xFF06CE8F),
            width: 1.7,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.r),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.r),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.7),
        ),
      ),
    );
  }
}
