// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:payment_app/data/controller/addBankController.dart';

// class AddBankAccountPage extends ConsumerStatefulWidget {
//   const AddBankAccountPage({super.key});

//   @override
//   ConsumerState<AddBankAccountPage> createState() => _AddBankAccountPageState();
// }

// class _AddBankAccountPageState extends ConsumerState<AddBankAccountPage> {
//   final TextEditingController accountHolderNameCtr = TextEditingController();
//   final TextEditingController accountNumberCtr = TextEditingController();
//   final TextEditingController bankNameCtr = TextEditingController();
//   final TextEditingController branchNameCtr = TextEditingController();
//   final TextEditingController ifscodeCtr = TextEditingController();

//   final _formKey = GlobalKey<FormState>();

//   @override
//   void dispose() {
//     accountHolderNameCtr.dispose();
//     accountNumberCtr.dispose();
//     bankNameCtr.dispose();
//     branchNameCtr.dispose();
//     ifscodeCtr.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final bankState = ref.watch(addBankProvider);
//     final isLoading = bankState is AsyncLoading;

//     return Scaffold(
//       // HomePage jaisa dark theme
//       backgroundColor: const Color(0xFF09111C),
//       body: Stack(
//         children: [
//           // Background Gradient matching HomePage
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
//             child: Column(
//               children: [
//                 _buildAppBar(context),
//                 Expanded(
//                   child: SingleChildScrollView(
//                     physics: const BouncingScrollPhysics(),
//                     padding: EdgeInsets.symmetric(
//                       horizontal: 24.w,
//                       vertical: 10.h,
//                     ),
//                     child: Form(
//                       key: _formKey,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           _buildInputLabel("Bank Name"),
//                           _buildTextField(
//                             bankNameCtr,
//                             "Enter Bank Name",
//                             validator:
//                                 (value) =>
//                                     (value == null || value.isEmpty)
//                                         ? "Please enter bank name"
//                                         : null,
//                           ),

//                           SizedBox(height: 18.h),
//                           _buildInputLabel("Account Number"),
//                           _buildTextField(
//                             accountNumberCtr,
//                             "Enter account number",
//                             isNumber: true,
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return "Account number is required";
//                               }

//                               return null;
//                             },
//                           ),

//                           SizedBox(height: 18.h),
//                           _buildInputLabel("IFSC Code"),
//                           _buildTextField(
//                             ifscodeCtr,
//                             "Enter IFSC Code",
//                             autoCaps: true,
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return "IFSC code is required";
//                               }
//                               return null;
//                             },
//                           ),

//                           SizedBox(height: 18.h),
//                           _buildInputLabel("Branch Name"),
//                           _buildTextField(
//                             branchNameCtr,
//                             "Enter branch name",
//                             validator:
//                                 (value) =>
//                                     (value == null || value.isEmpty)
//                                         ? "Please enter branch name"
//                                         : null,
//                           ),
//                           SizedBox(height: 18.h),
//                           _buildInputLabel("Account Holder Name"),
//                           _buildTextField(
//                             accountHolderNameCtr,
//                             "Enter name as per bank",
//                             validator: (value) {
//                               if (value == null || value.trim().isEmpty) {
//                                 return "Account holder name is required";
//                               }
//                               if (value.trim().length < 3) {
//                                 return "Name must be at least 3 characters";
//                               }
//                               return null;
//                             },
//                           ),

//                           SizedBox(height: 40.h),

//                           // Action Button
//                           _buildSaveButton(isLoading),
//                           SizedBox(height: 30.h),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildAppBar(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
//       child: Row(
//         children: [
//           IconButton(
//             onPressed: () => Navigator.pop(context),
//             icon: const Icon(
//               Icons.arrow_back_ios_new,
//               color: Colors.white,
//               size: 20,
//             ),
//           ),
//           const Spacer(),
//           Text(
//             "Add Bank Account",
//             style: GoogleFonts.poppins(
//               fontWeight: FontWeight.w700,
//               fontSize: 18.sp,
//               color: Colors.white,
//             ),
//           ),
//           const Spacer(),
//           SizedBox(width: 40.w), // Balance for centering
//         ],
//       ),
//     );
//   }

//   Widget _buildInputLabel(String label) {
//     return Padding(
//       padding: EdgeInsets.only(bottom: 8.h, left: 4.w),
//       child: Text(
//         label,
//         style: GoogleFonts.poppins(
//           color: Colors.white.withOpacity(0.6),
//           fontSize: 13.sp,
//           fontWeight: FontWeight.w500,
//         ),
//       ),
//     );
//   }

//   Widget _buildTextField(
//     TextEditingController controller,
//     String hint, {
//     bool isNumber = false,
//     bool autoCaps = false,
//     String? Function(String?)? validator,
//   }) {
//     return TextFormField(
//       controller: controller,
//       keyboardType: isNumber ? TextInputType.number : TextInputType.text,
//       textCapitalization:
//           autoCaps ? TextCapitalization.characters : TextCapitalization.none,
//       style: GoogleFonts.poppins(color: Colors.white, fontSize: 15.sp),
//       validator: validator,
//       autovalidateMode: AutovalidateMode.onUserInteraction,
//       decoration: InputDecoration(
//         hintText: hint,
//         hintStyle: TextStyle(
//           color: Colors.white.withOpacity(0.15),
//           fontSize: 14.sp,
//         ),
//         filled: true,
//         fillColor: Colors.white.withOpacity(0.05),
//         contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
//         errorStyle: const TextStyle(color: Colors.redAccent),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(15.r),
//           borderSide: BorderSide(color: Colors.white.withOpacity(0.08)),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(15.r),
//           borderSide: const BorderSide(color: Color(0xFF06CE8F), width: 1.2),
//         ),
//         errorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(15.r),
//           borderSide: const BorderSide(color: Colors.redAccent, width: 0.8),
//         ),
//         focusedErrorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(15.r),
//           borderSide: const BorderSide(color: Colors.redAccent, width: 1.2),
//         ),
//       ),
//     );
//   }

//   Widget _buildSaveButton(bool isLoading) {
//     return InkWell(
//       onTap:
//           isLoading
//               ? null
//               : () {
//                 if (_formKey.currentState!.validate()) {
//                   ref
//                       .read(addBankProvider.notifier)
//                       .createBank(
//                         context: context,
//                         holdername: accountHolderNameCtr.text.trim(),
//                         accountnumber: accountNumberCtr.text.trim(),
//                         banktname: bankNameCtr.text.trim(),
//                         branchname: branchNameCtr.text.trim(),
//                         ifscode: ifscodeCtr.text.trim().toUpperCase(),
//                       );
//                 }
//               },
//       child: Container(
//         width: double.infinity,
//         height: 54.h,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(15.r),
//           gradient: LinearGradient(
//             colors:
//                 isLoading
//                     ? [Colors.grey.shade800, Colors.grey.shade900]
//                     : [const Color(0xFF06CE8F), const Color(0xFF00A370)],
//           ),
//           boxShadow: [
//             if (!isLoading)
//               BoxShadow(
//                 color: const Color(0xFF06CE8F).withOpacity(0.2),
//                 blurRadius: 10,
//                 offset: const Offset(0, 5),
//               ),
//           ],
//         ),
//         child: Center(
//           child:
//               isLoading
//                   ? SizedBox(
//                     height: 20.h,
//                     width: 20.h,
//                     child: const CircularProgressIndicator(
//                       color: Colors.white,
//                       strokeWidth: 2,
//                     ),
//                   )
//                   : Text(
//                     "Save Bank Account",
//                     style: GoogleFonts.poppins(
//                       color: Colors.black,
//                       fontSize: 16.sp,
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:payment_app/data/controller/addBankController.dart';

class AddBankAccountPage extends ConsumerStatefulWidget {
  const AddBankAccountPage({super.key});

  @override
  ConsumerState<AddBankAccountPage> createState() => _AddBankAccountPageState();
}

class _AddBankAccountPageState extends ConsumerState<AddBankAccountPage> {
  final TextEditingController accountHolderNameCtr = TextEditingController();
  final TextEditingController accountNumberCtr = TextEditingController();
  final TextEditingController bankNameCtr = TextEditingController();
  final TextEditingController branchNameCtr = TextEditingController();
  final TextEditingController ifscodeCtr = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    accountHolderNameCtr.dispose();
    accountNumberCtr.dispose();
    bankNameCtr.dispose();
    branchNameCtr.dispose();
    ifscodeCtr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bankState = ref.watch(addBankProvider);
    final isLoading = bankState is AsyncLoading;

    return Scaffold(
      backgroundColor: const Color(0xFF09111C),
      body: Stack(
        children: [
          /// Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(-0.9, -0.9),
                radius: 1.5,
                colors: [Color(0xFF1A2A3A), Color(0xFF09111C)],
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                _buildAppBar(context),

                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 10.h,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Container(
                        padding: EdgeInsets.all(18.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25.r),
                          color: Colors.white.withOpacity(0.04),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.08),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.4),
                              blurRadius: 25,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildInputLabel("Bank Name"),
                            _buildTextField(
                              bankNameCtr,
                              "Enter Bank Name",
                              validator:
                                  (value) =>
                                      (value == null || value.isEmpty)
                                          ? "Please enter bank name"
                                          : null,
                            ),

                            SizedBox(height: 18.h),

                            _buildInputLabel("Account Number"),
                            _buildTextField(
                              accountNumberCtr,
                              "Enter account number",
                              isNumber: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Account number is required";
                                }
                                return null;
                              },
                            ),

                            SizedBox(height: 18.h),

                            _buildInputLabel("IFSC Code"),
                            _buildTextField(
                              ifscodeCtr,
                              "Enter IFSC Code",
                              autoCaps: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "IFSC code is required";
                                }
                                return null;
                              },
                            ),

                            SizedBox(height: 18.h),

                            _buildInputLabel("Branch Name"),
                            _buildTextField(
                              branchNameCtr,
                              "Enter branch name",
                              validator:
                                  (value) =>
                                      (value == null || value.isEmpty)
                                          ? "Please enter branch name"
                                          : null,
                            ),

                            SizedBox(height: 18.h),

                            _buildInputLabel("Account Holder Name"),
                            _buildTextField(
                              accountHolderNameCtr,
                              "Enter name as per bank",
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return "Account holder name is required";
                                }
                                if (value.trim().length < 3) {
                                  return "Name must be at least 3 characters";
                                }
                                return null;
                              },
                            ),

                            SizedBox(height: 35.h),

                            _buildSaveButton(isLoading),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 🔹 AppBar (Improved)
  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
          const Spacer(),
          Text(
            "Add Bank Account",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w700,
              fontSize: 17.sp,
              color: Colors.white,
            ),
          ),
          const Spacer(),
          SizedBox(width: 40.w),
        ],
      ),
    );
  }

  Widget _buildInputLabel(String label) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h, left: 4.w),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          color: Colors.white.withOpacity(0.65),
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  /// 🔹 Premium Input Field
  Widget _buildTextField(
    TextEditingController controller,
    String hint, {
    bool isNumber = false,
    bool autoCaps = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      textCapitalization:
          autoCaps ? TextCapitalization.characters : TextCapitalization.none,
      style: GoogleFonts.poppins(color: Colors.white, fontSize: 14.sp),
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: Colors.white.withOpacity(0.2),
          fontSize: 13.sp,
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.03),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 15.h),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: BorderSide.none,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.07)),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: const BorderSide(color: Color(0xFF06CE8F), width: 1.2),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
      ),
    );
  }

  /// 🔹 Premium Button
  Widget _buildSaveButton(bool isLoading) {
    return InkWell(
      borderRadius: BorderRadius.circular(16.r),
      onTap:
          isLoading
              ? null
              : () {
                if (_formKey.currentState!.validate()) {
                  ref
                      .read(addBankProvider.notifier)
                      .createBank(
                        context: context,
                        holdername: accountHolderNameCtr.text.trim(),
                        accountnumber: accountNumberCtr.text.trim(),
                        banktname: bankNameCtr.text.trim(),
                        branchname: branchNameCtr.text.trim(),
                        ifscode: ifscodeCtr.text.trim().toUpperCase(),
                      );
                }
              },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: double.infinity,
        height: 54.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          gradient: LinearGradient(
            colors:
                isLoading
                    ? [Colors.grey.shade800, Colors.grey.shade900]
                    : [const Color(0xFF06CE8F), const Color(0xFF00A370)],
          ),
          boxShadow: [
            if (!isLoading)
              BoxShadow(
                color: const Color(0xFF06CE8F).withOpacity(0.25),
                blurRadius: 15,
                offset: const Offset(0, 6),
              ),
          ],
        ),
        child: Center(
          child:
              isLoading
                  ? SizedBox(
                    height: 22.h,
                    width: 22.h,
                    child: const CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                  : Text(
                    "Save Bank Account",
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
        ),
      ),
    );
  }
}
