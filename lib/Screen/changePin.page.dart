// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:payment_app/Screen/forgotPin.page.dart';
// import 'package:payment_app/config/auth/router/rightsliderFageRoute.dart';
// import 'package:payment_app/config/network/api.network.dart';
// import 'package:payment_app/config/utils/pretty.dio.dart';
// import 'package:payment_app/config/utils/showMessage.dart';
// import 'package:payment_app/data/model/chagePinBodyModel.dart';

// class ChangePinPage extends StatefulWidget {
//   const ChangePinPage({super.key});

//   @override
//   State<ChangePinPage> createState() => _ChangePinPageState();
// }

// class _ChangePinPageState extends State<ChangePinPage> {
//   bool isLoading = false;
//   final _formKey = GlobalKey<FormState>();

//   final oldPinController = TextEditingController();
//   final newPinController = TextEditingController();
//   final confirmPinController = TextEditingController();

//   // ✅ Separate obscure states
//   bool obscureOldPin = true;
//   bool obscureNewPin = true;
//   bool obscureConfirmPin = true;

//   @override
//   void dispose() {
//     oldPinController.dispose();
//     newPinController.dispose();
//     confirmPinController.dispose();
//     super.dispose();
//   }

//   Future<void> _handleUpdate() async {
//     if (!_formKey.currentState!.validate()) return;

//     final body = ChangePinBodyModel(
//       oldPin: oldPinController.text.trim(),
//       newPin: newPinController.text.trim(),
//       confirmPin: confirmPinController.text.trim(),
//     );

//     setState(() => isLoading = true);

//     try {
//       final service = ApiNetwork(createDio());
//       final response = await service.chanegePin(body);

//       if (response.code == 0 || response.error == false) {
//         ShowMessage.success(
//           context,
//           response.message ?? "PIN Updated Successfully",
//         );
//         if (mounted) Navigator.pop(context);
//       } else {
//         ShowMessage.error(context, response.message ?? "Failed to update PIN");
//       }
//     } catch (e) {
//       log("Error updating PIN: ${e.toString()}");
//       ShowMessage.error(context, "Something went wrong");
//     } finally {
//       if (mounted) setState(() => isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF0D1117),
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         iconTheme: const IconThemeData(color: Colors.white),
//         title: const Text(
//           "Change Transaction PIN",
//           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Container(
//           padding: const EdgeInsets.all(20),
//           decoration: BoxDecoration(
//             color: const Color(0xFF161B22),
//             borderRadius: BorderRadius.circular(16),
//             border: Border.all(color: Colors.white10),
//           ),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               children: [
//                 _buildPinField(
//                   label: "Old PIN",
//                   controller: oldPinController,
//                   obscure: obscureOldPin,
//                   onToggle: () {
//                     setState(() {
//                       obscureOldPin = !obscureOldPin;
//                     });
//                   },
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return "Please enter Old PIN";
//                     }

//                     return null;
//                   },
//                 ),

//                 _buildPinField(
//                   label: "New PIN",
//                   controller: newPinController,
//                   obscure: obscureNewPin,
//                   onToggle: () {
//                     setState(() {
//                       obscureNewPin = !obscureNewPin;
//                     });
//                   },
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return "Please enter New PIN";
//                     }
//                     if (value.length != 6) {
//                       return "New PIN must be exactly 6 digits";
//                     }
//                     if (value == oldPinController.text) {
//                       return "New PIN must be different from Old PIN";
//                     }
//                     return null;
//                   },
//                 ),

//                 _buildPinField(
//                   label: "Confirm PIN",
//                   controller: confirmPinController,
//                   obscure: obscureConfirmPin,
//                   onToggle: () {
//                     setState(() {
//                       obscureConfirmPin = !obscureConfirmPin;
//                     });
//                   },
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return "Please confirm PIN";
//                     }
//                     if (value.length != 6) {
//                       return "Confirm PIN must be exactly 6 digits";
//                     }
//                     if (value != newPinController.text) {
//                       return "PINs do not match";
//                     }
//                     return null;
//                   },
//                 ),

//                 Align(
//                   alignment: Alignment.centerRight,
//                   child: TextButton(
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         RightSlideFadeRoute(page: ForgotPinPage()),
//                       );
//                     },
//                     child: const Text(
//                       "Forgot PIN?",
//                       style: TextStyle(
//                         color: Color(0xFF00D094),
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 24),

//                 SizedBox(
//                   width: double.infinity,
//                   height: 55,
//                   child: ElevatedButton(
//                     onPressed: isLoading ? null : _handleUpdate,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFF00D094),
//                       disabledBackgroundColor: const Color(
//                         0xFF00D094,
//                       ).withOpacity(0.3),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(30),
//                       ),
//                     ),
//                     child:
//                         isLoading
//                             ? SizedBox(
//                               height: 20,
//                               width: 20,
//                               child: CircularProgressIndicator(
//                                 color: Colors.white,
//                                 strokeWidth: 2,
//                               ),
//                             )
//                             : const Text(
//                               "Update PIN",
//                               style: TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildPinField({
//     required String label,
//     required TextEditingController controller,
//     required bool obscure,
//     required VoidCallback onToggle,
//     required String? Function(String?) validator,
//     bool isConfirmField = false,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
//         const SizedBox(height: 8),

//         TextFormField(
//           controller: controller,
//           obscureText: obscure,
//           keyboardType: TextInputType.number,
//           style: const TextStyle(color: Colors.white),
//           maxLength: 6,
//           inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//           decoration: InputDecoration(
//             counterText: "",
//             hintText: "Enter 6 digit PIN",
//             hintStyle: const TextStyle(color: Colors.white24, fontSize: 14),
//             suffixIcon: IconButton(
//               icon: Icon(
//                 obscure
//                     ? Icons.visibility_off_outlined
//                     : Icons.visibility_outlined,
//                 color: Colors.grey,
//                 size: 20,
//               ),
//               onPressed: onToggle,
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: const BorderSide(color: Colors.white12),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: const BorderSide(color: Color(0xFF00D094)),
//             ),
//             errorBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: const BorderSide(color: Colors.redAccent),
//             ),
//             focusedErrorBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: const BorderSide(color: Colors.redAccent),
//             ),
//           ),
//           validator: validator,
//         ),

//         const SizedBox(height: 16),
//       ],
//     );
//   }
// }

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:payment_app/Screen/forgotPin.page.dart';
import 'package:payment_app/config/auth/router/rightsliderFageRoute.dart';
import 'package:payment_app/config/network/api.network.dart';
import 'package:payment_app/config/utils/pretty.dio.dart';
import 'package:payment_app/config/utils/showMessage.dart';
import 'package:payment_app/data/model/chagePinBodyModel.dart';

class ChangePinPage extends StatefulWidget {
  const ChangePinPage({super.key});

  @override
  State<ChangePinPage> createState() => _ChangePinPageState();
}

class _ChangePinPageState extends State<ChangePinPage> {
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();

  // ✅ Controllers initialized safely
  late final TextEditingController oldPinController;
  late final TextEditingController newPinController;
  late final TextEditingController confirmPinController;

  bool obscureOldPin = true;
  bool obscureNewPin = true;
  bool obscureConfirmPin = true;

  @override
  void initState() {
    super.initState();
    oldPinController = TextEditingController();
    newPinController = TextEditingController();
    confirmPinController = TextEditingController();
  }

  @override
  void dispose() {
    // ✅ Preventing the "used after being disposed" error
    oldPinController.dispose();
    newPinController.dispose();
    confirmPinController.dispose();
    super.dispose();
  }

  Future<void> _handleUpdate() async {
    // Hide keyboard
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    final body = ChangePinBodyModel(
      oldPin: oldPinController.text.trim(),
      newPin: newPinController.text.trim(),
      confirmPin: confirmPinController.text.trim(),
    );

    if (mounted) setState(() => isLoading = true);

    try {
      final service = ApiNetwork(createDio());
      final response = await service.chanegePin(body);

      if (!mounted) return;

      if (response.code == 0 || response.error == false) {
        ShowMessage.success(
          context,
          response.message ?? "PIN Updated Successfully",
        );
        Navigator.pop(context);
      } else {
        ShowMessage.error(context, response.message ?? "Failed to update PIN");
      }
    } catch (e) {
      log("Error updating PIN: ${e.toString()}");
      if (mounted)
        ShowMessage.error(context, "Something went wrong. Please try again.");
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
            size: 18.sp,
          ),
        ),
        title: Text(
          "Change Transaction PIN",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 18.sp,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
          child: Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: const Color(0xFF161B22),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: Colors.white.withOpacity(0.05)),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPinField(
                    label: "Old 6-Digit PIN",
                    hint: "Enter your current PIN",
                    controller: oldPinController,
                    obscure: obscureOldPin,
                    onToggle:
                        () => setState(() => obscureOldPin = !obscureOldPin),
                    validator: (v) {
                      if (v == null || v.isEmpty)
                        return "Current PIN is required";
                      if (v.length < 6) return "Must be 6 digits";
                      return null;
                    },
                  ),
                  SizedBox(height: 10.h),
                  _buildPinField(
                    label: "New 6-Digit PIN",
                    hint: "Enter new security PIN",
                    controller: newPinController,
                    obscure: obscureNewPin,
                    onToggle:
                        () => setState(() => obscureNewPin = !obscureNewPin),
                    validator: (v) {
                      if (v == null || v.isEmpty) return "New PIN is required";
                      if (v.length < 6) return "PIN must be 6 digits";
                      if (v == oldPinController.text)
                        return "New PIN cannot be same as old";
                      return null;
                    },
                  ),
                  SizedBox(height: 10.h),
                  _buildPinField(
                    label: "Confirm New PIN",
                    hint: "Re-enter new PIN",
                    controller: confirmPinController,
                    obscure: obscureConfirmPin,
                    onToggle:
                        () => setState(
                          () => obscureConfirmPin = !obscureConfirmPin,
                        ),
                    validator: (v) {
                      if (v != newPinController.text)
                        return "PINs do not match";
                      return null;
                    },
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      // onPressed:
                      //     () => Navigator.push(
                      //       context,
                      //       RightSlideFadeRoute(page: const ForgotPinPage()),
                      //     ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              backgroundColor: const Color(
                                0xFF121517,
                              ), // Dark background color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              contentPadding: const EdgeInsets.all(24.0),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    'FORGOT PIN',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  const Text(
                                    'OTP has been sent to your registered email.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  Row(
                                    children: [
                                      // Cancel Button
                                      Expanded(
                                        child: OutlinedButton(
                                          onPressed:
                                              () => Navigator.pop(context),
                                          style: OutlinedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 16,
                                            ),
                                            side: const BorderSide(
                                              color: Colors.grey,
                                              width: 0.5,
                                            ),
                                            shape: const StadiumBorder(),
                                          ),
                                          child: const Text(
                                            'Cancel',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      // Send OTP Button
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () {
                                            // Add logic here
                                            Navigator.pop(context);
                                            Navigator.push(
                                              context,
                                              RightSlideFadeRoute(
                                                page: const ForgotPinPage(),
                                              ),
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color(
                                              0xFF00C897,
                                            ), // Green color
                                            foregroundColor: Colors.black,
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 16,
                                            ),
                                            shape: const StadiumBorder(),
                                            elevation: 0,
                                          ),
                                          child: const Text(
                                            'Send OTP',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      style: TextButton.styleFrom(padding: EdgeInsets.zero),
                      child: Text(
                        "Forgot PIN?",
                        style: TextStyle(
                          color: const Color(0xFF00D094),
                          fontWeight: FontWeight.w600,
                          fontSize: 13.sp,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 25.h),
                  SizedBox(
                    width: double.infinity,
                    height: 52.h,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _handleUpdate,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00D094),
                        disabledBackgroundColor: const Color(
                          0xFF00D094,
                        ).withOpacity(0.3),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child:
                          isLoading
                              ? SizedBox(
                                height: 20.h,
                                width: 20.h,
                                child: const CircularProgressIndicator(
                                  color: Colors.black,
                                  strokeWidth: 2.5,
                                ),
                              )
                              : Text(
                                "Update PIN",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPinField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required bool obscure,
    required VoidCallback onToggle,
    required String? Function(String?) validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            color: Colors.grey[400],
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8.h),
        TextFormField(
          controller: controller,
          obscureText: obscure,
          keyboardType: TextInputType.number,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
            letterSpacing: 2.0,
          ),
          maxLength: 6,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          cursorColor: const Color(0xFF00D094),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: Colors.white24,
              fontSize: 14.sp,
              letterSpacing: 0,
            ),
            counterText: "",
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 16.h,
            ),
            fillColor: const Color(0xFF0D1117),
            filled: true,
            suffixIcon: IconButton(
              icon: Icon(
                obscure
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: Colors.grey,
                size: 20.sp,
              ),
              onPressed: onToggle,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: Colors.white10),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(
                color: Color(0xFF00D094),
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: Colors.redAccent, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
            ),
            errorStyle: TextStyle(color: Colors.redAccent, fontSize: 11.sp),
          ),
          validator: validator,
        ),
      ],
    );
  }
}
