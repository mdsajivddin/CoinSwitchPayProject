// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:payment_app/config/utils/showMessage.dart';
// import 'package:payment_app/data/controller/profileController.dart';
// import 'package:payment_app/data/controller/withdrawTokenController.dart';

// class EnterpinPage extends ConsumerStatefulWidget {
//   final Function(String) onPinSubmitted;
//   final int amount;
//   final String walletType;

//   const EnterpinPage({
//     super.key,
//     required this.onPinSubmitted,
//     required this.amount,
//     required this.walletType,
//   });

//   @override
//   ConsumerState<EnterpinPage> createState() => _EnterpinPageState();
// }

// class _EnterpinPageState extends ConsumerState<EnterpinPage>
//     with SingleTickerProviderStateMixin {
//   String pin = "";
//   final int pinLength = 4;
//   bool _isProcessing = false;

//   late AnimationController _controller;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1500),
//     )..repeat();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   // PIN verification + match check + withdrawal call
//   Future<void> _processVerification() async {
//     if (_isProcessing || pin.length != pinLength) return;

//     setState(() => _isProcessing = true);

//     // 3 second delay (UX loading)
//     await Future.delayed(const Duration(seconds: 2));

//     if (!mounted) return;

//     await ref
//         .read(withdrawalTokenProvider.notifier)
//         .withdawalForToken(
//           context: context,
//           ammount: widget.amount,
//           pin: pin,
//           walletType: widget.walletType,
//         );
//     final state = ref.read(withdrawalTokenProvider);
//     if (state.value == null && !state.isLoading) {
//       setState(() {
//         pin = "";
//         _isProcessing = false;
//       });
//     }
//   }

//   void addDigit(String digit) {
//     if (pin.length < pinLength && !_isProcessing) {
//       HapticFeedback.lightImpact();
//       setState(() => pin += digit);
//     }
//   }

//   void removeDigit() {
//     if (pin.isNotEmpty && !_isProcessing) {
//       HapticFeedback.mediumImpact();
//       setState(() => pin = pin.substring(0, pin.length - 1));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isApiLoading = ref.watch(withdrawalTokenProvider) is AsyncLoading;
//     final isLoading = _isProcessing || isApiLoading;

//     return Scaffold(
//       backgroundColor: const Color(0xFF0F1113),
//       appBar: AppBar(
//         toolbarHeight: 0,
//         backgroundColor: const Color(0xFF09111C),
//       ),
//       body: Container(
//         width: double.infinity,
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [Color(0xFF161B22), Color(0xFF0B0D0F)],
//           ),
//         ),
//         child: SafeArea(
//           child: Column(
//             children: [
//               SizedBox(height: 40.h),
//               Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: Color(0xFF00E896).withOpacity(0.1),
//                   shape: BoxShape.circle,
//                 ),
//                 child: const Icon(
//                   Icons.lock_outline_rounded,
//                   color: Color(0xFF00E896),
//                   size: 32,
//                 ),
//               ),
//               const SizedBox(height: 24),
//               Text(
//                 "Security PIN",
//                 style: GoogleFonts.poppins(
//                   fontSize: 22.sp,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//               SizedBox(height: 8.h),
//               Text(
//                 "Enter your 4-digit code",
//                 style: GoogleFonts.poppins(
//                   color: Colors.white38,
//                   fontSize: 14.sp,
//                 ),
//               ),

//               SizedBox(height: 40.h),

//               /// PIN Dots Display
//               SizedBox(
//                 height: 60,
//                 child: AnimatedSwitcher(
//                   duration: const Duration(milliseconds: 300),
//                   child:
//                       isLoading
//                           ? const SpinKitThreeBounce(
//                             color: Color(0xFF06CE8F),
//                             size: 30.0,
//                           )
//                           : Row(
//                             key: const ValueKey("dots"),
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: List.generate(
//                               pinLength,
//                               (index) => _buildDot(index),
//                             ),
//                           ),
//                 ),
//               ),

//               const Spacer(),

//               /// Keypad
//               Opacity(
//                 opacity: isLoading ? 0.5 : 1.0,
//                 child: AbsorbPointer(
//                   absorbing: isApiLoading,
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 40),
//                     child: Column(
//                       children: [
//                         _buildRow(['1', '2', '3']),
//                         _buildRow(['4', '5', '6']),
//                         _buildRow(['7', '8', '9']),
//                         _buildSpecialRow(),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),

//               SizedBox(height: 40.h),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildRow(List<String> items) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: items.map((val) => _buildNumberButton(val)).toList(),
//       ),
//     );
//   }

//   Widget _buildSpecialRow() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           _buildIconButton(
//             Icons.backspace_outlined,
//             removeDigit,
//             Colors.white24,
//           ),
//           _buildNumberButton("0"),
//           _buildIconButton(
//             Icons.check_circle_rounded,
//             pin.length == pinLength && !_isProcessing
//                 ? _processVerification
//                 : null,
//             pin.length == pinLength && !_isProcessing
//                 ? const Color(0xFF06CE8F)
//                 : Colors.white10,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildNumberButton(String text) {
//     return Material(
//       color: Colors.transparent,
//       child: InkWell(
//         onTap: () => addDigit(text),
//         borderRadius: BorderRadius.circular(20),
//         child: Container(
//           height: 70,
//           width: 75,
//           decoration: BoxDecoration(
//             color: Colors.white.withOpacity(0.04),
//             borderRadius: BorderRadius.circular(20),
//             border: Border.all(color: Colors.white.withOpacity(0.05)),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.2),
//                 blurRadius: 5,
//                 offset: const Offset(0, 3),
//               ),
//             ],
//           ),
//           alignment: Alignment.center,
//           child: Text(
//             text,
//             style: GoogleFonts.poppins(
//               fontSize: 28,
//               color: Colors.white,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildIconButton(IconData icon, VoidCallback? onTap, Color color) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(15.r),
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 300),
//         padding: const EdgeInsets.all(12),

//         height: 65.h,
//         width: 80.w,
//         alignment: Alignment.center,
//         child: Icon(icon, color: color, size: 28.sp),
//       ),
//     );
//   }

//   Widget _buildDot(int index) {
//     bool active = index < pin.length;
//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 200),
//       margin: const EdgeInsets.symmetric(horizontal: 12),
//       width: 18,
//       height: 18,
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         color: active ? const Color(0xFF06CE8F) : Colors.white.withOpacity(0.1),
//         border: Border.all(
//           color: active ? Color(0xFF06CE8F) : Colors.white24,
//           width: 2,
//         ),
//         boxShadow:
//             active
//                 ? [
//                   BoxShadow(
//                     color: const Color(0xFF06CE8F).withOpacity(0.3),
//                     blurRadius: 8,
//                     spreadRadius: 1,
//                   ),
//                 ]
//                 : [],
//       ),
//     );
//   }
// }

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:payment_app/config/utils/showMessage.dart';
import 'package:payment_app/data/controller/profileController.dart';
import 'package:payment_app/data/controller/withdrawTokenController.dart';

class EnterpinPage extends ConsumerStatefulWidget {
  final Function(String)? onPinSubmitted;
  final int? amount;
  final String? walletType;

  const EnterpinPage({
    super.key,
     this.onPinSubmitted,
     this.amount,
     this.walletType,
  });

  @override
  ConsumerState<EnterpinPage> createState() => _EnterpinPageState();
}

class _EnterpinPageState extends ConsumerState<EnterpinPage>
    with SingleTickerProviderStateMixin {
  String pin = "";
  final int pinLength = 4;
  bool _isProcessing = false;

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _processVerification() async {
    if (_isProcessing || pin.length != pinLength) return;

    setState(() => _isProcessing = true);

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    await ref
        .read(withdrawalTokenProvider.notifier)
        .withdawalForToken(
          context: context,
          ammount: widget.amount ?? 0,
          pin: pin,
          walletType: widget.walletType ?? "",
        );

    final state = ref.read(withdrawalTokenProvider);
    if (state.value == null && !state.isLoading) {
      setState(() {
        pin = "";
        _isProcessing = false;
      });
    }
  }

  void addDigit(String digit) {
    if (pin.length < pinLength && !_isProcessing) {
      HapticFeedback.lightImpact();
      setState(() => pin += digit);
    }
  }

  void removeDigit() {
    if (pin.isNotEmpty && !_isProcessing) {
      HapticFeedback.mediumImpact();
      setState(() => pin = pin.substring(0, pin.length - 1));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isApiLoading = ref.watch(withdrawalTokenProvider) is AsyncLoading;
    final isLoading = _isProcessing || isApiLoading;

    return Scaffold(
      backgroundColor: const Color(0xFF0F1113),
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: const Color(0xFF09111C),
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF161B22), Color(0xFF0B0D0F)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 30.h),

              // Lock icon - slightly smaller & cleaner look
              Container(
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: const Color(0xFF00E896).withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.lock_outline_rounded,
                  color: const Color(0xFF00E896),
                  size: 36.sp,
                ),
              ),

              SizedBox(height: 28.h),

              Text(
                "Enter PIN",
                style: GoogleFonts.poppins(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),

              SizedBox(height: 6.h),

              Text(
                "Enter your 4-digit security code",
                style: GoogleFonts.poppins(
                  fontSize: 14.sp,
                  color: Colors.white70,
                  fontWeight: FontWeight.w400,
                ),
              ),

              SizedBox(height: 30.h),

              // PIN dots – more modern & compact
              SizedBox(
                height: 64.h,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 280),
                  child:
                      isLoading
                          ? const SpinKitThreeBounce(
                            color: Color(0xFF06CE8F),
                            size: 28.0,
                          )
                          : Row(
                            key: const ValueKey("dots"),
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              pinLength,
                              (index) => _buildDot(index),
                            ),
                          ),
                ),
              ),

              const Spacer(),

              // Keypad – better spacing & size
              Opacity(
                opacity: isLoading ? 0.45 : 1.0,
                child: AbsorbPointer(
                  absorbing: isApiLoading,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 36.w),
                    child: Column(
                      children: [
                        _buildRow(['1', '2', '3']),
                        _buildRow(['4', '5', '6']),
                        _buildRow(['7', '8', '9']),
                        _buildSpecialRow(),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRow(List<String> items) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: items.map((val) => _buildNumberButton(val)).toList(),
      ),
    );
  }

  Widget _buildSpecialRow() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildIconButton(
            Icons.backspace_outlined,
            removeDigit,
            Colors.white38,
          ),
          _buildNumberButton("0"),
          _buildIconButton(
            Icons.check_circle_rounded,
            pin.length == pinLength && !_isProcessing
                ? _processVerification
                : null,
            pin.length == pinLength && !_isProcessing
                ? const Color(0xFF06CE8F)
                : Colors.white12,
          ),
        ],
      ),
    );
  }

  Widget _buildNumberButton(String text) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => addDigit(text),
        borderRadius: BorderRadius.circular(20.r),
        splashColor: const Color(0xFF06CE8F).withOpacity(0.12),
        child: Container(
          height: 70,
          width: 75,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.04),
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(color: Colors.white.withOpacity(0.06)),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 28.sp,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback? onTap, Color color) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20.r),
      splashColor: const Color(0xFF06CE8F).withOpacity(0.15),
      child: Container(
        height: 78.h,
        width: 78.w,
        alignment: Alignment.center,
        child: Icon(icon, color: color, size: 30.sp),
      ),
    );
  }

  Widget _buildDot(int index) {
    final bool active = index < pin.length;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: EdgeInsets.symmetric(horizontal: 14.w),
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: active ? const Color(0xFF06CE8F) : Colors.white.withOpacity(0.1),
        border: Border.all(
          color: active ? const Color(0xFF06CE8F) : Colors.white24,
          width: 1.8,
        ),
        boxShadow:
            active
                ? [
                  BoxShadow(
                    color: Color(0xFF06CE8F).withOpacity(0.3),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ]
                : [],
      ),
    );
  }
}
