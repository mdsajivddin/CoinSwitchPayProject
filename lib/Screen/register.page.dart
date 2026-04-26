import 'dart:developer';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:payment_app/Screen/login.page.dart';
import 'package:payment_app/config/auth/router/rightsliderFageRoute.dart';
import 'package:payment_app/data/controller/registerController.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage>
    with SingleTickerProviderStateMixin {
  final formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController tranasactionPimController =
      TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController referralController = TextEditingController();

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
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    mobileController.dispose();
    tranasactionPimController.dispose();
    referralController.dispose();
    super.dispose();
  }

  void handleRegister() {
    if (formKey.currentState!.validate()) {
      ref
          .read(userControllerProvider.notifier)
          .userRegister(
            name: nameController.text.trim(),
            email: emailController.text.trim(),
            passw: passwordController.text.trim(),
            mobile: "+91${mobileController.text.trim()}",
            transactionPin: tranasactionPimController.text.trim(),
            refByCode: referralController.text.trim(),
            confirmPassword: confirmPasswordController.text.trim(),
            context: context,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final registerState = ref.watch(userControllerProvider);
    final isLoading = registerState is AsyncLoading;

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
              child: SingleChildScrollView(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 40.h), // ← reduced from 50
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

                          SizedBox(height: 4.h),

                          Text(
                            "India's largest criypto exchange ",
                            style: GoogleFonts.poppins(
                              fontSize: 13.sp, // ← 14.5 → 13
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF06CE8F),
                              letterSpacing: 0.5,
                            ),
                          ),

                          SizedBox(height: 20.h), // ← reduced

                          Text(
                            "Sign up to start your criypto journey",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 13.sp, // ← 14 → 13
                              color: const Color(0xFF9CA3AF),
                              height: 1.4,
                            ),
                          ),

                          SizedBox(height: 36.h), // ← reduced
                          // Glassmorphism Card
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                              horizontal: 20.w, // ← slightly reduced
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
                                  label: "Full Name",
                                  hint: "John Doe",
                                  controller: nameController,
                                  prefixIcon: CupertinoIcons.person,
                                  validator: (v) {
                                    if (v == null || v.trim().isEmpty) {
                                      return "Name is required";
                                    }
                                    if (v.trim().length < 3) {
                                      return "Name must be at least 3 characters";
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 20.h),
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
                                SizedBox(height: 20.h),
                                CoustomPhone(
                                  label: "Mobile Number",
                                  hint: "Mobile Number",
                                  controller: mobileController,
                                  prefixIcon: Icons.call,
                                  mxLength: 10,
                                  counterText: "",
                                  inputType: TextInputType.number,
                                  validator: (v) {
                                    if (v == null || v.trim().isEmpty) {
                                      return "Mobile Number is required";
                                    }
                                    if (v.trim().length < 10) {
                                      return "Minimum 10 characters";
                                    }
                                    return null;
                                  },
                                ),

                                SizedBox(height: 20.h),
                                LoginForm(
                                  label: "Set Tranaction  Pin",
                                  hint: "••••••••••",
                                  controller: tranasactionPimController,
                                  isPassword: true,
                                  prefixIcon: CupertinoIcons.lock,
                                  mxLength: 6,
                                  counterText: "",
                                  validator:
                                      (v) =>
                                          v!.length < 6
                                              ? "Minimum 6 characters"
                                              : null,
                                  inputType: TextInputType.number,
                                ),

                                SizedBox(height: 20.h),
                                LoginForm(
                                  label: "Password",
                                  hint: "••••••••••",
                                  controller: passwordController,
                                  isPassword: true,
                                  prefixIcon: CupertinoIcons.lock,
                                  validator: (v) {
                                    if (v == null || v.isEmpty) {
                                      return "Password is required";
                                    }

                                    // 1. Minimum 8 characters
                                    if (v.length < 8) {
                                      return "Minimum 8 characters required";
                                    }

                                    // 2. Check for Uppercase letter
                                    if (!v.contains(RegExp(r'[A-Z]'))) {
                                      return "Must include at least one uppercase letter";
                                    }

                                    // 3. Check for Lowercase letter
                                    if (!v.contains(RegExp(r'[a-z]'))) {
                                      return "Must include at least one lowercase letter";
                                    }

                                    // 4. Check for Number
                                    if (!v.contains(RegExp(r'[0-9]'))) {
                                      return "Must include at least one number";
                                    }

                                    // 5. Check for Special Character
                                    if (!v.contains(
                                      RegExp(r'[!@#$%^&*(),.?":{}|<>+-]'),
                                    )) {
                                      return "Must include at least one special character";
                                    }

                                    return null; // Sab validations pass ho gayi!
                                  },
                                ),
                                SizedBox(height: 20.h),
                                LoginForm(
                                  label: "Confirm Password",
                                  hint: "••••••••••",
                                  controller: confirmPasswordController,
                                  isPassword: true,
                                  prefixIcon: CupertinoIcons.lock,
                                  validator: (v) {
                                    // 1. Check if empty
                                    if (v == null || v.isEmpty) {
                                      return "Please confirm your password";
                                    }

                                    // 2. Minimum length check
                                    if (v.length < 8) {
                                      return "Minimum 8 characters";
                                    }

                                    // 3. Match check (Sabse important)
                                    if (v != passwordController.text) {
                                      return "Passwords do not match";
                                    }

                                    return null; // Match ho gaya!
                                  },
                                ),

                                SizedBox(height: 20.h),
                                LoginForm(
                                  label: "Referral Code",
                                  hint: "Enter referral code",
                                  controller: referralController,
                                  prefixIcon: CupertinoIcons.gift,
                                  validator:
                                      (v) =>
                                          v!.isEmpty
                                              ? "Referral Code is required"
                                              : null,
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 28.h), // ← reduced
                          // SIGN UP Button
                          GestureDetector(
                            onTap: isLoading ? null : handleRegister,
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
                                          "SIGN UP",
                                          style: GoogleFonts.poppins(
                                            fontSize: 14.5.sp, // ← 15.5 → 14.5
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                            letterSpacing: 1.0,
                                          ),
                                        ),
                              ),
                            ),
                          ),

                          SizedBox(height: 32.h), // ← reduced
                          // Already have account
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Already have an account? ",
                                style: GoogleFonts.poppins(
                                  fontSize: 13.sp, // ← 13.5 → 13
                                  color: const Color(0xFF9CA3AF),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    RightSlideFadeRoute(
                                      page: const LoginPage(),
                                    ),
                                  );
                                },
                                child: Text(
                                  "Sign In",
                                  style: GoogleFonts.poppins(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF06CE8F),
                                    decoration: TextDecoration.underline,
                                    decorationColor: const Color(
                                      0xFF06CE8F,
                                    ).withOpacity(0.5),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 32.h), // ← reduced
                        ],
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
              color: Colors.black.withOpacity(0.2),
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
class CoustomPhone extends StatefulWidget {
  final String hint;
  final String label;
  final TextEditingController controller;
  final bool isPassword;
  final IconData prefixIcon;
  final String? Function(String?)? validator;
  final TextInputType? inputType;
  final int? mxLength;
  final String? counterText;

  const CoustomPhone({
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
  State<CoustomPhone> createState() => _CoustomPhoneState();
}

class _CoustomPhoneState extends State<CoustomPhone> {
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
        prefixText: "+91-", // 👈 ye add karo
        prefixStyle: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
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
