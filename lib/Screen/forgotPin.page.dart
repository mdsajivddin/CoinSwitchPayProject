// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:payment_app/config/network/api.network.dart';
// import 'package:payment_app/config/utils/pretty.dio.dart';
// import 'package:payment_app/config/utils/showMessage.dart';
// import 'package:payment_app/data/controller/forgotPinSendtOTPController.dart';
// import 'package:payment_app/data/model/forgotPinVerifyBody.dart';
// import 'package:payment_app/data/model/forgotPinVerifyRes.dart';
// import 'package:pin_code_fields/pin_code_fields.dart';

// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:payment_app/config/network/api.network.dart';
// import 'package:payment_app/config/utils/pretty.dio.dart';
// import 'package:payment_app/data/model/forgotPinVerifyBody.dart';

// class ForgotPinVerifyController
//     extends StateNotifier<AsyncValue<ForgotPinVerifyRes?>> {
//   final Ref ref;

//   ForgotPinVerifyController(this.ref) : super(const AsyncValue.data(null));

//   Future<void> verifyPin(ForgotPinVerifyBody body) async {
//     try {
//       state = const AsyncValue.loading();

//       final service = ApiNetwork(createDio());
//       final response = await service.forgotPinVerify(body);

//       if (response.code == 0 && response.error == false) {
//         state = AsyncValue.data(response);
//       } else {
//         state = AsyncValue.error(
//           response.message ?? "Verification Failed",
//           StackTrace.current,
//         );
//       }
//     } catch (e, st) {
//       state = AsyncValue.error(e, st);
//     }
//   }
// }

// final forgotPinVerifyProvider = StateNotifierProvider<
//   ForgotPinVerifyController,
//   AsyncValue<ForgotPinVerifyRes?>
// >((ref) {
//   return ForgotPinVerifyController(ref);
// });

// class ForgotPinPage extends ConsumerStatefulWidget {
//   const ForgotPinPage({super.key});

//   @override
//   ConsumerState<ForgotPinPage> createState() => _ForgotPinPageState();
// }

// class _ForgotPinPageState extends ConsumerState<ForgotPinPage> {
//   bool obscureNewPin = true;
//   bool obscureConfirmPin = true;

//   final otpController = TextEditingController();
//   final newPinController = TextEditingController();
//   final confirmPinController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();

//     Future.microtask(() {
//       ref.read(forgotPinSendOTPProvider.notifier).sendForgotPinOtp();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final sendOtpState = ref.watch(forgotPinSendOTPProvider);
//     final verifyState = ref.watch(forgotPinVerifyProvider);

//     ref.listen(forgotPinVerifyProvider, (previous, next) {
//       next.whenOrNull(
//         data: (data) {
//           ShowMessage.success(context, data!.message ?? "");
//           Navigator.pop(context);
//           Navigator.pop(context);
//         },
//         error: (e, _) {
//           ShowMessage.error(context, e.toString());
//         },
//       );
//     });

//     return Scaffold(
//       backgroundColor: const Color(0xFF050B18),
//       body: sendOtpState.when(
//         loading:
//             () => const Center(
//               child: CircularProgressIndicator(color: Colors.white),
//             ),
//         error:
//             (e, _) => Center(
//               child: Text(
//                 e.toString(),
//                 style: const TextStyle(color: Colors.white),
//               ),
//             ),
//         data: (data) {
//           return Center(
//             child: Container(
//               width: 0.9.sw,
//               padding: EdgeInsets.all(20.w),
//               decoration: BoxDecoration(
//                 color: const Color(0xFF0D1625),
//                 borderRadius: BorderRadius.circular(20.r),
//               ),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text(
//                     "Reset PIN",
//                     style: GoogleFonts.poppins(
//                       fontSize: 22.sp,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.white,
//                     ),
//                   ),

//                   SizedBox(height: 20.h),

//                   /// OTP
//                   PinCodeTextField(
//                     appContext: context,
//                     controller: otpController,
//                     length: 6,
//                     keyboardType: TextInputType.number,
//                     textStyle: TextStyle(color: Colors.white, fontSize: 18.sp),
//                     pinTheme: PinTheme(
//                       shape: PinCodeFieldShape.box,
//                       borderRadius: BorderRadius.circular(12.r),
//                       fieldHeight: 55.h,
//                       fieldWidth: 45.w,
//                       activeColor: Colors.tealAccent,
//                       inactiveColor: Colors.white24,
//                     ),
//                     onChanged: (value) {},
//                   ),

//                   SizedBox(height: 20.h),

//                   _buildPinField(
//                     controller: newPinController,
//                     label: "New PIN",
//                     obscure: obscureNewPin,
//                     onToggle:
//                         () => setState(() => obscureNewPin = !obscureNewPin),
//                   ),

//                   SizedBox(height: 20.h),

//                   _buildPinField(
//                     controller: confirmPinController,
//                     label: "Confirm PIN",
//                     obscure: obscureConfirmPin,
//                     onToggle:
//                         () => setState(
//                           () => obscureConfirmPin = !obscureConfirmPin,
//                         ),
//                   ),

//                   SizedBox(height: 30.h),

//                   ElevatedButton(
//                     onPressed:
//                         verifyState is AsyncLoading
//                             ? null
//                             : () {
//                               if (otpController.text.length != 6) {
//                                 ShowMessage.error(context, "Enter valid OTP");
//                                 return;
//                               }

//                               if (newPinController.text !=
//                                   confirmPinController.text) {
//                                 ShowMessage.error(
//                                   context,
//                                   "PIN does not match",
//                                 );
//                                 return;
//                               }

//                               final body = ForgotPinVerifyBody(
//                                 token: data.data!.token.toString(),
//                                 otp: otpController.text.trim(),
//                                 newPin: newPinController.text.trim(),
//                                 confirmPin: confirmPinController.text.trim(),
//                               );

//                               ref
//                                   .read(forgotPinVerifyProvider.notifier)
//                                   .verifyPin(body);
//                             },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFF06CE8F),
//                       minimumSize: Size(double.infinity, 50.h),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(30.r),
//                       ),
//                     ),
//                     child:
//                         verifyState is AsyncLoading
//                             ? const CircularProgressIndicator(
//                               color: Colors.black,
//                             )
//                             : const Text(
//                               "Verify & Reset",
//                               style: TextStyle(color: Colors.black),
//                             ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildPinField({
//     required TextEditingController controller,
//     required String label,
//     required bool obscure,
//     required VoidCallback onToggle,
//   }) {
//     return TextField(
//       controller: controller,
//       obscureText: obscure,
//       keyboardType: TextInputType.number,
//       style: const TextStyle(color: Colors.white),
//       decoration: InputDecoration(
//         labelText: label,
//         labelStyle: const TextStyle(color: Colors.white70),
//         filled: true,
//         fillColor: const Color(0xFF101C2E),
//         suffixIcon: IconButton(
//           icon: Icon(
//             obscure ? Icons.visibility_off : Icons.visibility,
//             color: Colors.white54,
//           ),
//           onPressed: onToggle,
//         ),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12.r),
//           borderSide: BorderSide.none,
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:payment_app/config/network/api.network.dart';
import 'package:payment_app/config/utils/pretty.dio.dart';
import 'package:payment_app/config/utils/showMessage.dart';
import 'package:payment_app/data/controller/forgotPinSendtOTPController.dart';
import 'package:payment_app/data/model/forgotPinVerifyBody.dart';
import 'package:payment_app/data/model/forgotPinVerifyRes.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class ForgotPinVerifyController
    extends StateNotifier<AsyncValue<ForgotPinVerifyRes?>> {
  final Ref ref;

  ForgotPinVerifyController(this.ref) : super(const AsyncValue.data(null));

  Future<void> verifyPin(ForgotPinVerifyBody body) async {
    try {
      state = const AsyncValue.loading();

      final service = ApiNetwork(createDio());
      final response = await service.forgotPinVerify(body);

      if (response.code == 0 && response.error == false) {
        state = AsyncValue.data(response);
      } else {
        state = AsyncValue.error(
          response.message ?? "Verification Failed",
          StackTrace.current,
        );
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final forgotPinVerifyProvider = StateNotifierProvider<
  ForgotPinVerifyController,
  AsyncValue<ForgotPinVerifyRes?>
>((ref) {
  return ForgotPinVerifyController(ref);
});

class ForgotPinPage extends ConsumerStatefulWidget {
  const ForgotPinPage({super.key});

  @override
  ConsumerState<ForgotPinPage> createState() => _ForgotPinPageState();
}

class _ForgotPinPageState extends ConsumerState<ForgotPinPage> {
  bool obscureNewPin = true;
  bool obscureConfirmPin = true;

  final otpController = TextEditingController();
  final newPinController = TextEditingController();
  final confirmPinController = TextEditingController();

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(forgotPinSendOTPProvider.notifier).sendForgotPinOtp();
    });
  }

  @override
  void dispose() {
    otpController.dispose();
    newPinController.dispose();
    confirmPinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sendOtpState = ref.watch(forgotPinSendOTPProvider);
    final verifyState = ref.watch(forgotPinVerifyProvider);

    ref.listen(forgotPinVerifyProvider, (previous, next) {
      next.whenOrNull(
        data: (data) {
          ShowMessage.success(context, data!.message ?? "");
          Navigator.pop(context);
          Navigator.pop(context);
        },
        error: (e, _) {
          ShowMessage.error(context, e.toString());
        },
      );
    });

    return Scaffold(
      backgroundColor: const Color(0xFF050B18),
      body: sendOtpState.when(
        loading:
            () => const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),

        error:
            (e, _) => Center(
              child: Text(
                e.toString(),
                style: const TextStyle(color: Colors.white),
              ),
            ),

        data: (data) {
          return Center(
            child: Container(
              width: 0.9.sw,
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: const Color(0xFF0D1625),
                borderRadius: BorderRadius.circular(20.r),
              ),

              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Reset PIN",
                    style: GoogleFonts.poppins(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),

                  SizedBox(height: 20.h),

                  /// OTP FIELD
                  PinCodeTextField(
                    key: const ValueKey("otp_field"),
                    autoDisposeControllers: false,
                    appContext: context,
                    controller: otpController,
                    length: 6,
                    keyboardType: TextInputType.number,
                    textStyle: TextStyle(color: Colors.white, fontSize: 18.sp),

                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(12.r),
                      fieldHeight: 55.h,
                      fieldWidth: 45.w,
                      activeColor: Colors.tealAccent,
                      inactiveColor: Colors.white24,
                    ),

                    onChanged: (value) {},
                  ),

                  SizedBox(height: 20.h),

                  /// NEW PIN
                  _buildPinField(
                    controller: newPinController,
                    label: "New PIN",
                    obscure: obscureNewPin,
                    onToggle: () {
                      setState(() {
                        obscureNewPin = !obscureNewPin;
                      });
                    },
                  ),

                  SizedBox(height: 20.h),

                  /// CONFIRM PIN
                  _buildPinField(
                    controller: confirmPinController,
                    label: "Confirm PIN",
                    obscure: obscureConfirmPin,
                    onToggle: () {
                      setState(() {
                        obscureConfirmPin = !obscureConfirmPin;
                      });
                    },
                  ),

                  SizedBox(height: 30.h),

                  /// VERIFY BUTTON
                  ElevatedButton(
                    onPressed:
                        verifyState is AsyncLoading
                            ? null
                            : () {
                              if (otpController.text.length != 6) {
                                ShowMessage.error(context, "Enter valid OTP");
                                return;
                              }

                              if (newPinController.text !=
                                  confirmPinController.text) {
                                ShowMessage.error(
                                  context,
                                  "PIN does not match",
                                );
                                return;
                              }

                              final body = ForgotPinVerifyBody(
                                token: data.data!.token.toString(),
                                otp: otpController.text.trim(),
                                newPin: newPinController.text.trim(),
                                confirmPin: confirmPinController.text.trim(),
                              );

                              ref
                                  .read(forgotPinVerifyProvider.notifier)
                                  .verifyPin(body);
                            },

                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF06CE8F),
                      minimumSize: Size(double.infinity, 50.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                    ),

                    child:
                        verifyState is AsyncLoading
                            ? const CircularProgressIndicator(
                              color: Colors.black,
                            )
                            : const Text(
                              "Verify & Reset",
                              style: TextStyle(color: Colors.black),
                            ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPinField({
    required TextEditingController controller,
    required String label,
    required bool obscure,
    required VoidCallback onToggle,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: TextInputType.number,
      style: const TextStyle(color: Colors.white),
      maxLength: 6,
      decoration: InputDecoration(
        counterText: "",
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),

        filled: true,
        fillColor: const Color(0xFF101C2E),

        suffixIcon: IconButton(
          icon: Icon(
            obscure ? Icons.visibility_off : Icons.visibility,
            color: Colors.white54,
          ),
          onPressed: onToggle,
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
