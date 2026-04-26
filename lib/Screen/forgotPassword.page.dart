import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:payment_app/data/controller/fogtorSendOTPController.dart'; // typo? → probably forgotSendOTPController

class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ConsumerState<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage>
    with SingleTickerProviderStateMixin {
  final emailController = TextEditingController();
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
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final forgotState = ref.watch(forgotSendOTPCont);
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
          // Background gradient (same as login)
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
              padding: EdgeInsets.symmetric(
                horizontal: 24.w,
              ), // ← slightly reduced from 28
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

                            SizedBox(height: 40.h), // ← reduced
                            // Title & subtitle
                            Text(
                              "Forgot Password?",
                              style: GoogleFonts.poppins(
                                fontSize: 26.sp, // ← 30 → 26
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                letterSpacing: -0.5,
                              ),
                            ),
                            SizedBox(height: 10.h),

                            Text(
                              "Enter your registered email to receive\na secure OTP code",
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
                                horizontal: 20.w, // ← slightly reduced
                                vertical: 28.h,
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
                              child: FromField(
                                label: "Email",
                                hint: "hello@example.com",
                                controller: emailController,
                                prefixIcon: CupertinoIcons.mail,
                                validator: (value) {
                                  // 1. Check if empty
                                  if (value == null || value.isEmpty) {
                                    return "Email cannot be empty";
                                  }

                                  // 2. Email Regex Pattern
                                  final emailRegex = RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                                  );

                                  // 3. Full Validation
                                  if (!emailRegex.hasMatch(value)) {
                                    return "Enter a valid email (@gmail.com)";
                                  }

                                  return null; // Sab sahi hai!
                                },
                              ),
                            ),

                            SizedBox(height: 32.h), // ← reduced
                            // Generate OTP Button
                            GestureDetector(
                              onTap:
                                  isLoading
                                      ? null
                                      : () async {
                                        // if (formKey.currentState!.validate()) {
                                        //   ref
                                        //       .read(forgotSendOTPCont.notifier)
                                        //       .forgotSentOTP(
                                        //         context: context,
                                        //         email:
                                        //             emailController.text.trim(),
                                        //       );
                                        // }
                                        if (formKey.currentState!.validate()) {
                                          final email =
                                              emailController.text.trim();

                                          await ref
                                              .read(forgotSendOTPCont.notifier)
                                              .forgotSentOTP(
                                                context: context,
                                                email: email,
                                              );

                                          // Agar screen abhi bhi dikh rahi hai, tabhi kuch karein
                                          if (!mounted) return;
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
                                          ? SizedBox(
                                            width: 20.w,
                                            height: 20.h,
                                            child:
                                                const CircularProgressIndicator(
                                                  color: Colors.white,
                                                  strokeWidth: 2,
                                                ),
                                          )
                                          : Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                "GENERATE OTP",
                                                style: GoogleFonts.poppins(
                                                  fontSize:
                                                      14.5.sp, // ← 16.5 → 14.5
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.white,
                                                  letterSpacing: 1.0,
                                                ),
                                              ),
                                              SizedBox(width: 10.w),
                                              const Icon(
                                                Icons.arrow_forward_rounded,
                                                color: Colors.white,
                                                size: 20,
                                              ),
                                            ],
                                          ),
                                ),
                              ),
                            ),

                            SizedBox(height: 32.h),

                            // Back to login
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Remember your password? ",
                                  style: GoogleFonts.poppins(
                                    fontSize: 13.sp, // ← 14.5 → 13
                                    color: const Color(0xFF9CA3AF),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => Navigator.pop(context),
                                  child: Text(
                                    "Login",
                                    style: GoogleFonts.poppins(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF06CE8F),
                                      decoration: TextDecoration.underline,
                                      decorationThickness: 2.0,
                                      decorationColor: Color(0xFF06CE8F),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 20.h),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Updated LoginForm - matching the smaller sizes from your other pages
class FromField extends StatefulWidget {
  final String hint;
  final String label;
  final TextEditingController controller;
  final bool isPassword;
  final IconData prefixIcon;
  final String? Function(String?)? validator;

  const FromField({
    super.key,
    required this.hint,
    required this.label,
    required this.controller,
    this.isPassword = false,
    required this.prefixIcon,
    this.validator,
  });

  @override
  State<FromField> createState() => _FromFieldState();
}

class _FromFieldState extends State<FromField> {
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
      autovalidateMode: AutovalidateMode.onUserInteraction,
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
          size: 20.w, // smaller icon
        ),
        suffixIcon:
            widget.isPassword
                ? IconButton(
                  onPressed: () => setState(() => _isObscured = !_isObscured),
                  icon: Icon(
                    _isObscured ? CupertinoIcons.eye_slash : CupertinoIcons.eye,
                    color:
                        _isFocused
                            ? const Color(0xFF06CE8F)
                            : const Color(0xFF9CA3AF),
                    size: 18.w,
                  ),
                )
                : null,
        contentPadding: EdgeInsets.symmetric(
          vertical: 16.h, // ← slightly reduced
          horizontal: 18.w,
        ),
        labelStyle: GoogleFonts.poppins(
          color: _isFocused ? const Color(0xFF06CE8F) : const Color(0xFF9CA3AF),
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
          borderSide: const BorderSide(color: Color(0xFF06CE8F), width: 1.7),
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
