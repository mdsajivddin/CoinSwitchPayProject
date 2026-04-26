import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:payment_app/data/controller/createUpiController.dart';

class AddUpiAccountPage extends ConsumerStatefulWidget {
  const AddUpiAccountPage({super.key});

  @override
  ConsumerState<AddUpiAccountPage> createState() => _AddUpiAccountPageState();
}

class _AddUpiAccountPageState extends ConsumerState<AddUpiAccountPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final upiIdController = TextEditingController();
  final nameController = TextEditingController();

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
    upiIdController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final upiState = ref.watch(createUpiProvider);
    final isLoading = upiState is AsyncLoading;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFF1A2A3A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A2A3A),
        automaticallyImplyLeading: true,
        foregroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 56,
        title: Text(
          "Add UPI ID",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 19.sp,
            letterSpacing: -0.3,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Background gradient (matching login page style)
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
              padding: EdgeInsets.symmetric(horizontal: 28.w),
              child: SingleChildScrollView(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 30.h),

                          // Icon with subtle glow
                          Container(
                            padding: EdgeInsets.all(22.w),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFF06CE8F).withOpacity(0.12),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFF06CE8F,
                                  ).withOpacity(0.25),
                                  blurRadius: 24,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Icon(
                              CupertinoIcons.qrcode_viewfinder,
                              color: const Color(0xFF06CE8F),
                              size: 48.sp,
                            ),
                          ),

                          SizedBox(height: 28.h),

                          // Main heading
                          Text(
                            "Link Your UPI ID",
                            style: GoogleFonts.poppins(
                              fontSize: 28.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: -0.6,
                            ),
                          ),

                          SizedBox(height: 10.h),

                          Text(
                            "Enter your UPI address to enable instant\npayments & withdrawals",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 14.5.sp,
                              color: const Color(0xFF9CA3AF),
                              height: 1.5,
                            ),
                          ),

                          SizedBox(height: 50.h),

                          // ─── Glassmorphism Input Card ───
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                              horizontal: 24.w,
                              vertical: 32.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.06),
                              borderRadius: BorderRadius.circular(28.r),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.08),
                                width: 1.2,
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                UpiInputField(
                                  controller: nameController,
                                  isLoading: isLoading,
                                  labelText: "Account Holder Name",
                                  hintText: "Enter full name",
                                  icon: CupertinoIcons.person,
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return "Please enter account holder name";
                                    }
                                    return null;
                                  },
                                ),

                                SizedBox(height: 15.h),

                                // --- UPI ID Field ---
                                UpiInputField(
                                  controller: upiIdController,
                                  isLoading: isLoading,
                                  labelText: "UPI ID",
                                  hintText: "yourname@upi",
                                  icon: CupertinoIcons.at,
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return "Please enter your UPI ID";
                                    }
                                    if (!value.contains('@')) {
                                      return "Invalid UPI format (e.g. name@upi)";
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 50.h),

                          // Confirm Button (same style as Login)
                          GestureDetector(
                            onTap:
                                isLoading
                                    ? null
                                    : () {
                                      if (_formKey.currentState!.validate()) {
                                        ref
                                            .read(createUpiProvider.notifier)
                                            .createUpi(
                                              context: context,
                                              upi: upiIdController.text.trim(),
                                              name: nameController.text.trim(),
                                            );
                                      }
                                    },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 280),
                              width: double.infinity,
                              height: 58.h,
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
                                          "ADD UPI ID",
                                          style: GoogleFonts.poppins(
                                            fontSize: 16.5.sp,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                            letterSpacing: 1.1,
                                          ),
                                        ),
                              ),
                            ),
                          ),

                          SizedBox(height: 40.h),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Full-screen loading overlay when needed
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

// ─── Reusable UPI Input Field with focus glow ───
class UpiInputField extends StatefulWidget {
  final TextEditingController controller;
  final bool isLoading;
  final String labelText;
  final String hintText;
  final IconData icon;
  final String? Function(String?)? validator;

  const UpiInputField({
    super.key,
    required this.controller,
    required this.isLoading,
    required this.labelText,
    required this.hintText,
    required this.icon,
    this.validator,
  });

  @override
  State<UpiInputField> createState() => _UpiInputFieldState();
}

class _UpiInputFieldState extends State<UpiInputField> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (hasFocus) => setState(() => _isFocused = hasFocus),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 240),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          boxShadow:
              _isFocused
                  ? [
                    BoxShadow(
                      color: const Color(0xFF06CE8F).withOpacity(0.20),
                      blurRadius: 16,
                      spreadRadius: 1,
                    ),
                  ]
                  : [],
        ),
        child: TextFormField(
          controller: widget.controller,
          enabled: !widget.isLoading,
          style: GoogleFonts.poppins(color: Colors.white, fontSize: 15.5.sp),
          cursorColor: const Color(0xFF06CE8F),
          validator: widget.validator,
          decoration: InputDecoration(
            labelText: widget.labelText,
            hintText: widget.hintText,
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            filled: true,
            fillColor: const Color(0xFF131C29).withOpacity(0.45),
            prefixIcon: Icon(
              widget.icon,
              color:
                  _isFocused
                      ? const Color(0xFF06CE8F)
                      : const Color(0xFF4ADE80).withOpacity(0.7),
              size: 22,
            ),
            contentPadding: EdgeInsets.symmetric(
              vertical: 18.h,
              horizontal: 20.w,
            ),
            labelStyle: GoogleFonts.poppins(
              color:
                  _isFocused
                      ? const Color(0xFF06CE8F)
                      : const Color(0xFF9CA3AF),
              fontSize: 14.5.sp,
            ),
            hintStyle: GoogleFonts.poppins(
              color: const Color(0xFF6B7280),
              fontSize: 14.5.sp,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.r),
              borderSide: BorderSide(
                color: Colors.white.withOpacity(0.08),
                width: 1.2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.r),
              borderSide: const BorderSide(
                color: Color(0xFF06CE8F),
                width: 1.8,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.r),
              borderSide: const BorderSide(color: Colors.redAccent, width: 1.2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.r),
              borderSide: const BorderSide(color: Colors.redAccent, width: 1.8),
            ),
          ),
        ),
      ),
    );
  }
}
