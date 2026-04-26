import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:payment_app/config/utils/showMessage.dart';
import 'package:payment_app/data/controller/requestBuyOrderControlelr.dart';
import 'package:qr_flutter/qr_flutter.dart'; // QR Generator package

class BuyOrderScreen extends ConsumerStatefulWidget {
  final String orderId;
  final String sellerAddress;

  const BuyOrderScreen({
    super.key,
    required this.orderId,
    required this.sellerAddress,
  });

  @override
  ConsumerState<BuyOrderScreen> createState() => _BuyOrderScreenState();
}

class _BuyOrderScreenState extends ConsumerState<BuyOrderScreen> {
  final TextEditingController _hashController = TextEditingController();
  File? screenshotImage;
  final ImagePicker _picker = ImagePicker();

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

  Future<void> pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(
      source: source,
      imageQuality: 60,
    );
    if (pickedFile != null) {
      File compressed = await compressImage(File(pickedFile.path));
      setState(() {
        screenshotImage = compressed;
      });
    }
  }

  void showImagePicker() {
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
                  pickImage(ImageSource.camera);
                },
                child: const Text("Camera"),
              ),
              CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pop(context);
                  pickImage(ImageSource.gallery);
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
    final state = ref.watch(requestBuyOrderProvider);
    final isLoading = state is AsyncLoading;
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          "Complete Payment",
          style: GoogleFonts.poppins(fontSize: 18.sp, color: Colors.white),
        ),
        centerTitle: true,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.r),
        child: Column(
          children: [
            /// 1. QR Code Section
            Container(
              padding: EdgeInsets.all(20.r),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25.r),
              ),
              child: QrImageView(
                data: widget.sellerAddress,
                version: QrVersions.auto,
                size: 200.0.r,
                gapless: false,
              ),
            ),
            SizedBox(height: 15.h),
            Text(
              "Scan to Pay",
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 5.h),
            SelectableText(
              widget.sellerAddress,
              style: GoogleFonts.poppins(
                color: Colors.white38,
                fontSize: 12.sp,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 30.h),
            const Divider(color: Colors.white10),
            SizedBox(height: 20.h),

            /// 2. Payment Form
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Submit Transaction Details",
                style: GoogleFonts.poppins(
                  color: Colors.white70,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(height: 15.h),

            // Hash/Transaction ID Input
            TextField(
              controller: _hashController,
              style: const TextStyle(color: Colors.white),
              decoration: _inputDecoration(
                "Enter Transaction Hash / ID",
                Icons.tag,
              ),
            ),
            SizedBox(height: 15.h),

            // Image Upload Placeholder
            InkWell(
              onTap: () {
                showImagePicker();
              },
              child: Container(
                height: 120.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(15.r),
                  border: Border.all(
                    color: Colors.white10,
                    style: BorderStyle.solid,
                  ),
                  image:
                      screenshotImage != null
                          ? DecorationImage(
                            image: FileImage(screenshotImage!),
                            fit: BoxFit.cover,
                          )
                          : null,
                ),
                child:
                    screenshotImage == null
                        ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                CupertinoIcons.cloud_upload,
                                color: Color(0xFF06CE8F).withOpacity(0.5),
                                size: 28.sp,
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                "screenshot",
                                style: GoogleFonts.poppins(
                                  fontSize: 11.sp,
                                  color: Colors.white38,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        )
                        : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.cloud_upload_outlined,
                              color: Colors.blueAccent,
                              size: 30.sp,
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              "Upload Payment Screenshot",
                              style: GoogleFonts.poppins(
                                color: Colors.white38,
                                fontSize: 12.sp,
                              ),
                            ),
                          ],
                        ),
              ),
            ),

            SizedBox(height: 30.h),

            /// 3. Submit Button
            ElevatedButton(
              onPressed: () {
                if (screenshotImage == null) {
                  ShowMessage.error(context, "Plese selct image screenshot");
                  return;
                }
                ref
                    .read(requestBuyOrderProvider.notifier)
                    .submitPayment(
                      orderId: widget.orderId,
                      hash: _hashController.text.trim(),
                      imagePath: screenshotImage!,
                      context: context,
                    );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3B82F6),
                minimumSize: Size(double.infinity, 55.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.r),
                ),
              ),
              child:
                  isLoading
                      ? Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                      : Text(
                        "Submit Payment",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                          color: Colors.white,
                        ),
                      ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white24),
      prefixIcon: Icon(icon, color: Colors.white38, size: 20.sp),
      filled: true,
      fillColor: Colors.white.withOpacity(0.05),
      contentPadding: EdgeInsets.symmetric(vertical: 18.h),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15.r),
        borderSide: const BorderSide(color: Colors.white10),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15.r),
        borderSide: const BorderSide(color: Color(0xFF3B82F6)),
      ),
    );
  }
}
