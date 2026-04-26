// import 'dart:io';
// import 'dart:ui';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_image_compress/flutter_image_compress.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:payment_app/config/utils/showMessage.dart';
// import 'package:payment_app/data/controller/createOrUpdateKycController.dart';

// class KycScreen extends ConsumerStatefulWidget {
//   const KycScreen({super.key});

//   @override
//   ConsumerState<KycScreen> createState() => _KycScreenState();
// }

// class _KycScreenState extends ConsumerState<KycScreen>
//     with SingleTickerProviderStateMixin {
//   final TextEditingController nameController = TextEditingController();
//   File? frontImage;
//   File? backImage;
//   final ImagePicker _picker = ImagePicker();

//   late AnimationController _animController;
//   late Animation<double> _fadeAnimation;

//   // --- Matching Login Page Theme Colors ---
//   static const Color accentColor = Color(0xFF06CE8F); // CoinSwitch Green
//   static const Color bgColor = Color(0xFF09111C); // Dark Blue
//   static const Color cardColor = Color(0xFF1A2A3A); // Lighter Blue

//   @override
//   void initState() {
//     super.initState();
//     _animController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1000),
//     );
//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
//     );
//     _animController.forward();
//   }

//   @override
//   void dispose() {
//     _animController.dispose();
//     nameController.dispose();
//     super.dispose();
//   }

//   // --- Logic Functions ---
//   Future<File> compressImage(File file) async {
//     final result = await FlutterImageCompress.compressAndGetFile(
//       file.path,
//       "${file.parent.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg",
//       quality: 40,
//       minWidth: 800,
//       minHeight: 800,
//     );
//     return File(result!.path);
//   }

//   Future<void> pickImage(ImageSource source, bool isFront) async {
//     final XFile? pickedFile = await _picker.pickImage(
//       source: source,
//       imageQuality: 60,
//     );
//     if (pickedFile != null) {
//       File compressed = await compressImage(File(pickedFile.path));
//       setState(() {
//         if (isFront) {
//           frontImage = compressed;
//         } else {
//           backImage = compressed;
//         }
//       });
//     }
//   }

//   void showImagePicker(bool isFront) {
//     showCupertinoModalPopup(
//       context: context,
//       builder:
//           (context) => CupertinoActionSheet(
//             title: Text(
//               isFront ? "Front Side of ID" : "Back Side of ID",
//               style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
//             ),
//             actions: [
//               CupertinoActionSheetAction(
//                 onPressed: () {
//                   Navigator.pop(context);
//                   pickImage(ImageSource.camera, isFront);
//                 },
//                 child: const Text("Camera"),
//               ),
//               CupertinoActionSheetAction(
//                 onPressed: () {
//                   Navigator.pop(context);
//                   pickImage(ImageSource.gallery, isFront);
//                 },
//                 child: const Text("Gallery"),
//               ),
//             ],
//             cancelButton: CupertinoActionSheetAction(
//               isDestructiveAction: true,
//               onPressed: () => Navigator.pop(context),
//               child: const Text("Cancel"),
//             ),
//           ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final state = ref.watch(kycProvider);
//     final isLoading = state.isLoading;

//     return Scaffold(
//       backgroundColor: bgColor,
//       extendBodyBehindAppBar: true,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: Padding(
//           padding: EdgeInsets.all(8.w),
//           child: CircleAvatar(
//             backgroundColor: Colors.white.withOpacity(0.05),
//             child: IconButton(
//               icon: const Icon(Icons.arrow_back, color: Colors.white, size: 16),
//               onPressed: () => Navigator.pop(context),
//             ),
//           ),
//         ),
//         centerTitle: true,
//         title: Text(
//           "Identity Verification",
//           style: GoogleFonts.poppins(
//             fontSize: 16.sp,
//             fontWeight: FontWeight.w600,
//             color: Colors.white,
//           ),
//         ),
//       ),
//       body: Stack(
//         children: [
//           // --- Matching Login Page Radial Gradient ---
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
//             child: FadeTransition(
//               opacity: _fadeAnimation,
//               child: SingleChildScrollView(
//                 padding: EdgeInsets.symmetric(horizontal: 24.w),
//                 physics: const BouncingScrollPhysics(),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     SizedBox(height: 20.h),
//                     _buildHeaderSection(),
//                     SizedBox(height: 35.h),

//                     // --- STEP 1 ---
//                     _buildStepHeader("1", "Full Name"),
//                     SizedBox(height: 12.h),
//                     _buildTextField(),

//                     SizedBox(height: 30.h),

//                     // --- STEP 2 ---
//                     _buildStepHeader("2", "Upload Documents"),
//                     SizedBox(height: 8.h),
//                     Text(
//                       "Make sure all details are readable on the document.",
//                       style: GoogleFonts.poppins(
//                         fontSize: 12.sp,
//                         color: Colors.white38,
//                       ),
//                     ),
//                     SizedBox(height: 20.h),

//                     Row(
//                       children: [
//                         Expanded(
//                           child: _buildImagePickerBox(
//                             "FRONT VIEW",
//                             frontImage,
//                             true,
//                           ),
//                         ),
//                         SizedBox(width: 16.w),
//                         Expanded(
//                           child: _buildImagePickerBox(
//                             "BACK VIEW",
//                             backImage,
//                             false,
//                           ),
//                         ),
//                       ],
//                     ),

//                     SizedBox(height: 30.h),
//                     _buildGuidelines(),
//                     SizedBox(height: 40.h),
//                     _buildSubmitButton(isLoading),
//                     SizedBox(height: 40.h),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildHeaderSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           "Let's Verify Your ID",
//           style: GoogleFonts.poppins(
//             fontSize: 25.sp,
//             fontWeight: FontWeight.w800,
//             color: Colors.white,
//             height: 1.1,
//             letterSpacing: -1,
//           ),
//         ),
//         SizedBox(height: 12.h),
//         Text(
//           "Complete KYC to unlock full access.",
//           style: GoogleFonts.poppins(color: Colors.white54, fontSize: 14.sp),
//         ),
//       ],
//     );
//   }

//   Widget _buildStepHeader(String step, String title) {
//     return Row(
//       children: [
//         Container(
//           width: 24,
//           height: 24,
//           decoration: BoxDecoration(
//             color: accentColor.withOpacity(0.15),
//             shape: BoxShape.circle,
//           ),
//           alignment: Alignment.center,
//           child: Text(
//             step,
//             style: GoogleFonts.poppins(
//               color: accentColor,
//               fontSize: 12.sp,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//         SizedBox(width: 10.w),
//         Text(
//           title,
//           style: GoogleFonts.poppins(
//             color: Colors.white,
//             fontSize: 15.sp,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildTextField() {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.06),
//         borderRadius: BorderRadius.circular(20.r),
//         border: Border.all(color: Colors.white.withOpacity(0.08)),
//       ),
//       child: TextField(
//         controller: nameController,
//         style: GoogleFonts.poppins(color: Colors.white, fontSize: 14.sp),
//         cursorColor: accentColor,
//         decoration: InputDecoration(
//           border: InputBorder.none,
//           hintText: "Enter full name as per ID",
//           hintStyle: GoogleFonts.poppins(
//             color: Colors.white24,
//             fontSize: 14.sp,
//           ),
//           prefixIcon: const Icon(
//             CupertinoIcons.person_crop_rectangle,
//             color: accentColor,
//             size: 20,
//           ),
//           contentPadding: EdgeInsets.symmetric(
//             vertical: 18.h,
//             horizontal: 15.w,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildImagePickerBox(String title, File? file, bool isFront) {
//     return GestureDetector(
//       onTap: () => showImagePicker(isFront),
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 300),
//         height: 160.h,
//         decoration: BoxDecoration(
//           color:
//               file != null
//                   ? Colors.transparent
//                   : Colors.white.withOpacity(0.05),
//           borderRadius: BorderRadius.circular(24.r),
//           border: Border.all(
//             color:
//                 file != null
//                     ? accentColor.withOpacity(0.5)
//                     : Colors.white.withOpacity(0.08),
//             width: 1.5,
//           ),
//           image:
//               file != null
//                   ? DecorationImage(image: FileImage(file), fit: BoxFit.cover)
//                   : null,
//         ),
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(22.r),
//           child: BackdropFilter(
//             filter: ImageFilter.blur(
//               sigmaX: file != null ? 0 : 5,
//               sigmaY: file != null ? 0 : 5,
//             ),
//             child: Container(
//               color: file != null ? Colors.black26 : Colors.transparent,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   if (file == null) ...[
//                     Icon(
//                       CupertinoIcons.camera_viewfinder,
//                       color: Colors.white38,
//                       size: 32.sp,
//                     ),
//                     SizedBox(height: 12.h),
//                   ] else ...[
//                     const Icon(
//                       Icons.check_circle,
//                       color: accentColor,
//                       size: 40,
//                     ),
//                   ],
//                   Text(
//                     title,
//                     style: GoogleFonts.poppins(
//                       fontSize: 10.sp,
//                       color: file != null ? Colors.white : Colors.white54,
//                       fontWeight: FontWeight.bold,
//                       letterSpacing: 1.2,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildGuidelines() {
//     return Container(
//       padding: EdgeInsets.all(16.r),
//       decoration: BoxDecoration(
//         color: const Color(0xFF06CE8F).withOpacity(0.05),
//         borderRadius: BorderRadius.circular(16.r),
//         border: Border.all(color: const Color(0xFF06CE8F).withOpacity(0.1)),
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Icon(
//             Icons.security_rounded,
//             color: Color(0xFF06CE8F),
//             size: 20,
//           ),
//           SizedBox(width: 12.w),
//           Expanded(
//             child: Text(
//               "Your data is encrypted and stored securely. We only use it for identity verification purposes.",
//               style: GoogleFonts.poppins(
//                 color: Colors.white60,
//                 fontSize: 11.sp,
//                 height: 1.4,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSubmitButton(bool isLoading) {
//     return InkWell(
//       onTap: isLoading ? null : _handleSubmit,
//       borderRadius: BorderRadius.circular(999),
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 300),
//         width: double.infinity,
//         height: 54.h,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(999),
//           gradient: LinearGradient(
//             colors:
//                 isLoading
//                     ? [Colors.grey.shade800, Colors.grey.shade900]
//                     : [accentColor, const Color(0xFF05B47A)],
//           ),
//           boxShadow: [
//             if (!isLoading)
//               BoxShadow(
//                 color: accentColor.withOpacity(0.35),
//                 blurRadius: 20,
//                 offset: const Offset(0, 10),
//               ),
//           ],
//         ),
//         child: Center(
//           child:
//               isLoading
//                   ? const CupertinoActivityIndicator(color: Colors.white)
//                   : Text(
//                     "SUBMIT VERIFICATION",
//                     style: GoogleFonts.poppins(
//                       fontSize: 14.sp,
//                       fontWeight: FontWeight.w700,
//                       color: Colors.white,
//                       letterSpacing: 1.0,
//                     ),
//                   ),
//         ),
//       ),
//     );
//   }

//   void _handleSubmit() {
//     if (frontImage == null ||
//         backImage == null ||
//         nameController.text.isEmpty) {
//       ShowMessage.error(context, "Please complete all fields");
//       return;
//     }
//     ref
//         .read(kycProvider.notifier)
//         .submitKyc(
//           frontImage: frontImage!,
//           backImage: backImage!,
//           name: nameController.text.trim(),
//           context: context,
//         );
//   }
// }

import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:payment_app/config/utils/showMessage.dart';
import 'package:payment_app/data/controller/createOrUpdateKycController.dart';

class KycScreen extends ConsumerStatefulWidget {
  const KycScreen({super.key});

  @override
  ConsumerState<KycScreen> createState() => _KycScreenState();
}

class _KycScreenState extends ConsumerState<KycScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final amountController = TextEditingController();
  final hashController = TextEditingController();

  File? frontImage;
  File? backImage;
  File? screenshotImage;
  final ImagePicker _picker = ImagePicker();

  late AnimationController _animController;
  late Animation<double> _fadeAnimation;

  static const Color accentColor = Color(0xFF06CE8F);
  static const Color bgColor = Color(0xFF09111C);

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    nameController.dispose();
    amountController.dispose();
    hashController.dispose();
    super.dispose();
  }

  // --- Logic Functions ---
  Future<File> compressImage(File file) async {
    final result = await FlutterImageCompress.compressAndGetFile(
      file.path,
      "${file.parent.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg",
      quality: 40,
      minWidth: 800,
      minHeight: 800,
    );
    return File(result!.path);
  }

  Future<void> pickImage(ImageSource source, String type) async {
    final XFile? pickedFile = await _picker.pickImage(
      source: source,
      imageQuality: 60,
    );
    if (pickedFile != null) {
      File compressed = await compressImage(File(pickedFile.path));
      setState(() {
        if (type == "front") {
          frontImage = compressed;
        } else if (type == "back") {
          backImage = compressed;
        } else if (type == "screenshot") {
          screenshotImage = compressed;
        }
      });
    }
  }

  void showImagePicker(String type) {
    showCupertinoModalPopup(
      context: context,
      builder:
          (context) => CupertinoActionSheet(
            title: Text(
              "Select Image Source",
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
            actions: [
              CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pop(context);
                  pickImage(ImageSource.camera, type);
                },
                child: const Text("Camera"),
              ),
              CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pop(context);
                  pickImage(ImageSource.gallery, type);
                },
                child: const Text("Gallery"),
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              isDestructiveAction: true,
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(kycProvider);
    final isLoading = state.isLoading;

    return Scaffold(
      backgroundColor: bgColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: EdgeInsets.all(8.w),
          child: CircleAvatar(
            backgroundColor: Colors.white.withOpacity(0.05),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 16),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        centerTitle: true,
        title: Text(
          "Identity Verification",
          style: GoogleFonts.poppins(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Stack(
          children: [
            // Dynamic Background
            Positioned(
              top: -100,
              left: -50,
              child: _buildBlurCircle(accentColor.withOpacity(0.08), 250),
            ),
            Positioned(
              bottom: -50,
              right: -50,
              child: _buildBlurCircle(const Color(0xFF1A2A3A), 300),
            ),

            SafeArea(
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverPadding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 10.h,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        _buildHeaderSection(),
                        SizedBox(height: 30.h),

                        // Input Section with Glass Card
                        _buildGlassCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSectionHeader(
                                CupertinoIcons.doc_plaintext,
                                "Transaction Details",
                              ),
                              SizedBox(height: 20.h),

                              // Full Name
                              _buildEnhancedInput(
                                nameController,
                                "Full Name",
                                "Enter your full name",
                                CupertinoIcons.person_crop_circle,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return "Please enter full name";
                                  }
                                  if (value.trim().length < 3) {
                                    return "Name is too short";
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 20.h),

                              // Amount
                              _buildEnhancedInput(
                                amountController,
                                "Amount",
                                "Enter amount",
                                CupertinoIcons.money_dollar_circle,
                                isNumber: true,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return "Please enter amount";
                                  }
                                  final amount = double.tryParse(value.trim());
                                  if (amount == null) {
                                    return "Enter valid number";
                                  }
                                  if (amount <= 0) {
                                    return "Amount must be greater than 0";
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 20.h),

                              // Transaction Hash / ID
                              _buildEnhancedInput(
                                hashController,
                                "Txn Hash / ID",
                                "Enter transaction hash",
                                CupertinoIcons.barcode,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return "Please enter transaction hash";
                                  }
                                  // Optional: you can add length/checksum validation later
                                  if (value.trim().length < 8) {
                                    return "Hash seems too short";
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 20.h),
                            ],
                          ),
                        ),

                        SizedBox(height: 24.h),

                        // ID Section
                        _buildGlassCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSectionHeader(
                                CupertinoIcons.person_badge_minus,
                                "Identity Proof",
                              ),
                              SizedBox(height: 20.h),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildImagePickerTile(
                                      "Front Side",
                                      frontImage,
                                      'front',
                                    ),
                                  ),
                                  SizedBox(width: 15.w),
                                  Expanded(
                                    child: _buildImagePickerTile(
                                      "Back Side",
                                      backImage,
                                      'back',
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 24.h),

                        // Screenshot Section
                        _buildGlassCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSectionHeader(
                                CupertinoIcons.camera_viewfinder,
                                "Payment Confirmation",
                              ),
                              SizedBox(height: 20.h),
                              _buildImagePickerTile(
                                "Upload Payment Screenshot",
                                screenshotImage,
                                'screenshot',
                                isWide: true,
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 36.h),
                        _buildSubmitButton(isLoading),
                        SizedBox(height: 50.h),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBlurCircle(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
        child: Container(),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Verify KYC",
          style: GoogleFonts.poppins(
            fontSize: 32.sp,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        Text(
          "Secure your account with identity proof",
          style: GoogleFonts.poppins(
            fontSize: 14.sp,
            color: Colors.white60,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: accentColor, size: 20.sp),
        SizedBox(width: 10.w),
        Text(
          title.toUpperCase(),
          style: GoogleFonts.poppins(
            fontSize: 12.sp,
            fontWeight: FontWeight.w700,
            color: accentColor,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }

  Widget _buildGlassCard({required Widget child}) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(28.r),
        border: Border.all(color: Colors.white.withOpacity(0.07)),
      ),
      child: child,
    );
  }

  Widget _buildEnhancedInput(
    TextEditingController controller,
    String label,
    String hint,
    IconData prefixIcon, {
    bool isNumber = false,
    String? Function(String?)? validator, // ← added for validation
  }) {
    bool _isFocused = false;

    return StatefulBuilder(
      builder: (context, setLocalState) {
        return Focus(
          onFocusChange: (hasFocus) {
            setLocalState(() => _isFocused = hasFocus);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 240),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              boxShadow:
                  _isFocused
                      ? [
                        BoxShadow(
                          color: const Color(0xFF06CE8F).withOpacity(0.18),
                          blurRadius: 16,
                          spreadRadius: 1,
                        ),
                      ]
                      : [],
            ),
            child: TextFormField(
              // ← Changed from TextField to TextFormField
              controller: controller,
              keyboardType:
                  isNumber ? TextInputType.number : TextInputType.text,
              cursorColor: const Color(0xFF06CE8F),
              style: GoogleFonts.poppins(color: Colors.white, fontSize: 14.sp),
              validator: validator, // ← using passed validator
              autovalidateMode:
                  AutovalidateMode.onUserInteraction, // ← shows error live
              decoration: InputDecoration(
                labelText: label,
                hintText: hint,
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                filled: true,
                fillColor: const Color(0xFF131C29).withOpacity(0.45),
                prefixIcon: Icon(
                  prefixIcon,
                  color:
                      _isFocused
                          ? const Color(0xFF06CE8F)
                          : const Color(0xFF4ADE80).withOpacity(0.7),
                  size: 20.w,
                ),
                contentPadding: EdgeInsets.symmetric(
                  vertical: 15.h,
                  horizontal: 16.w,
                ),
                labelStyle: GoogleFonts.poppins(
                  color:
                      _isFocused
                          ? const Color(0xFF06CE8F)
                          : const Color(0xFF9CA3AF),
                  fontSize: 13.sp,
                ),
                hintStyle: GoogleFonts.poppins(
                  color: const Color(0xFF6B7280),
                  fontSize: 13.sp,
                ),
                // Borders
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
                  borderSide: const BorderSide(
                    color: Colors.redAccent,
                    width: 1.1,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.r),
                  borderSide: const BorderSide(
                    color: Colors.redAccent,
                    width: 1.7,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildImagePickerTile(
    String label,
    File? image,
    String type, {
    bool isWide = false,
  }) {
    return GestureDetector(
      onTap: () => showImagePicker(type),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: isWide ? 110.h : 130.h,
        decoration: BoxDecoration(
          color:
              image != null
                  ? Colors.transparent
                  : Colors.black.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: image != null ? accentColor : Colors.white.withOpacity(0.1),
            width: 1.5,
          ),
          image:
              image != null
                  ? DecorationImage(image: FileImage(image), fit: BoxFit.cover)
                  : null,
        ),
        child:
            image == null
                ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        CupertinoIcons.cloud_upload,
                        color: accentColor.withOpacity(0.5),
                        size: 28.sp,
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        label,
                        style: GoogleFonts.poppins(
                          fontSize: 11.sp,
                          color: Colors.white38,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                )
                : Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.6),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  alignment: Alignment.bottomRight,
                  padding: const EdgeInsets.all(10),
                  child: const Icon(
                    Icons.check_circle,
                    color: accentColor,
                    size: 24,
                  ),
                ),
      ),
    );
  }

  Widget _buildSubmitButton(bool isLoading) {
    return InkWell(
      onTap: isLoading ? null : _handleSubmit,
      borderRadius: BorderRadius.circular(20.r),
      child: Container(
        width: double.infinity,
        height: 56.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          gradient: const LinearGradient(
            colors: [accentColor, Color(0xFF00A870)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: accentColor.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Center(
          child:
              isLoading
                  ? SizedBox(
                    width: 20,
                    height: 20,
                    child: Center(
                      child: const CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 1.5,
                      ),
                    ),
                  )
                  : Text(
                    "SUBMIT FOR VERIFICATION",
                    style: GoogleFonts.poppins(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: 1.1,
                    ),
                  ),
        ),
      ),
    );
  }

  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (frontImage == null) {
      ShowMessage.error(context, "Please select front image");
      return;
    }
    if (backImage == null) {
      ShowMessage.error(context, "Please select back image");
      return;
    }
    if (screenshotImage == null) {
      ShowMessage.error(context, "Please select screenshotImage image");
      return;
    }
    ref
        .read(kycProvider.notifier)
        .submitKyc(
          frontImage: frontImage!,
          backImage: backImage!,
          name: nameController.text.trim(),
          amount: amountController.text.trim(),
          hash: hashController.text.trim(),
          screenshot: screenshotImage!,
          context: context,
        );
  }
}
