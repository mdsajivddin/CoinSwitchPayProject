import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:payment_app/Screen/forgotPassword.page.dart';
import 'package:payment_app/Screen/loginVerifyOtp.dart';
import 'package:payment_app/Screen/register.page.dart';
import 'package:payment_app/config/auth/router/rightsliderFageRoute.dart';
import 'package:payment_app/data/controller/loginController.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage>
    with SingleTickerProviderStateMixin {
  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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
    passwordController.dispose();
    super.dispose();
  }

  void handleLogin() {
    if (formKey.currentState!.validate()) {
      ref
          .read(loginProvider.notifier)
          .login(
            email: emailController.text.trim(),
            pass: passwordController.text.trim(),
            context: context,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(loginProvider);
    final isLoading = loginState is AsyncLoading;

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
              padding: EdgeInsets.symmetric(horizontal: 24.w),
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ClipOval(
                              child: Image.asset(
                                "assets/logo2.png",
                                width: 120.w,
                                height:
                                    120.w, // 👈 height = width (perfect circle)
                                fit: BoxFit.cover, // 👈 important
                              ),
                            ),
                            SizedBox(height: 20.h),
                            Text(
                              "CoinSwitchPay",
                              style: GoogleFonts.poppins(
                                fontSize: 30.sp, // ← 36 → 32
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
                            SizedBox(height: 4.h), // ← reduced
                            Text(
                              "India's largest criypto exchange",
                              style: GoogleFonts.poppins(
                                fontSize: 13.sp, // ← 14.5 → 13
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF06CE8F),
                                letterSpacing: 0.5,
                              ),
                            ),
                            SizedBox(height: 16.h), // ← reduced
                            // Welcome text
                            Text(
                              "Welcome Back",
                              style: GoogleFonts.poppins(
                                fontSize: 24.sp, // ← 28 → 25
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                letterSpacing: -0.4,
                              ),
                            ),

                            SizedBox(height: 8.h), // ← reduced

                            Text(
                              "Sign in to start your Criypto journey",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontSize: 13.sp, // ← 14 → 13
                                color: const Color(0xFF9CA3AF),
                                height: 1.4,
                              ),
                            ),

                            SizedBox(height: 36.h), // ← reduced
                            // Glassmorphism card
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                horizontal: 20.w,
                                vertical: 26.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.06),
                                borderRadius: BorderRadius.circular(24.r),
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
                                  LoginForm(
                                    label: "Email",
                                    hint: "Enter your email",
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
                                  SizedBox(height: 20.h), // ← reduced
                                  LoginForm(
                                    label: "Password",
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
                                ],
                              ),
                            ),

                            SizedBox(height: 12.h),

                            // Forgot password
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    RightSlideFadeRoute(
                                      page: const ForgotPasswordPage(),
                                    ),
                                  );
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: const Color(0xFF06CE8F),
                                ),
                                child: Text(
                                  "Forgot password?",
                                  style: GoogleFonts.poppins(
                                    fontSize: 12.5.sp, // ← 13 → 12.5
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: 20.h), // ← reduced
                            // Login Button
                            GestureDetector(
                              onTap: isLoading ? null : handleLogin,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 280),
                                width: double.infinity,
                                height: 52.h, // ← 56 → 52
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
                                            "LOGIN",
                                            style: GoogleFonts.poppins(
                                              fontSize:
                                                  14.5.sp, // ← 15.5 → 14.5
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                              letterSpacing: 1.0,
                                            ),
                                          ),
                                ),
                              ),
                            ),

                            SizedBox(height: 32.h), // ← reduced
                            // Sign up row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "New to CoinSwitchPay? ",
                                  style: GoogleFonts.poppins(
                                    fontSize: 13.sp, // ← 13.5 → 13
                                    color: const Color(0xFF9CA3AF),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                        builder: (_) => const RegisterPage(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    "Create Account",
                                    style: GoogleFonts.poppins(
                                      fontSize: 13.sp, // ← 13.5 → 13
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF06CE8F),
                                      decoration: TextDecoration.underline,
                                      decorationColor: Color(0xFF06CE8F),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 20.h), // ← reduced
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
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(color: Color(0xFF06CE8F)),
              ),
            ),
        ],
      ),
    );
  }
}

// ─── LoginForm ─── (font sizes reduced slightly)
class LoginForm extends StatefulWidget {
  final String hint;
  final String label;
  final TextEditingController controller;
  final bool isPassword;
  final IconData prefixIcon;
  final String? Function(String?)? validator;
  final TextInputType? inputType;
  final int? mxLength;
  final String? counterText;

  const LoginForm({
    super.key,
    required this.hint,
    required this.label,
    required this.controller,
    this.isPassword = false,
    required this.prefixIcon,
    this.validator,
    this.inputType,
    this.mxLength,
    this.counterText,
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
      keyboardType: widget.inputType,
      maxLength: widget.mxLength,
      controller: widget.controller,
      obscureText: widget.isPassword && _isObscured,
      validator: widget.validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: GoogleFonts.poppins(
        color: Colors.white,
        fontSize: 14.sp, // ← 14.8 → 14
      ),
      cursorColor: const Color(0xFF06CE8F),
      decoration: InputDecoration(
        counterText: widget.counterText,
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
          size: 20.w, // ← 21 → 20
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
                    size: 18.w, // ← 19 → 18
                  ),
                )
                : null,
        contentPadding: EdgeInsets.symmetric(
          vertical: 15.h, // ← 17 → 15
          horizontal: 16.w, // ← 18 → 16
        ),
        labelStyle: GoogleFonts.poppins(
          color: _isFocused ? const Color(0xFF06CE8F) : const Color(0xFF9CA3AF),
          fontSize: 13.sp, // ← 13.8 → 13
        ),
        hintStyle: GoogleFonts.poppins(
          color: const Color(0xFF6B7280),
          fontSize: 13.sp, // ← 13.8 → 13
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
