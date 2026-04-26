import 'dart:developer';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:image_picker/image_picker.dart';
import 'package:payment_app/Screen/addUpiAccount.page.dart';
import 'package:payment_app/Screen/agentship.page.dart';
import 'package:payment_app/Screen/inrToTokenBuyHistory.page.dart';
import 'package:payment_app/Screen/invite.page.dart';
import 'package:payment_app/Screen/login.page.dart';
import 'package:payment_app/Screen/p2pBuySellTransationHistory.page.dart';
import 'package:payment_app/Screen/p2pHistory.page.dart';
import 'package:payment_app/Screen/changePin.page.dart';
import 'package:payment_app/Screen/suport.page.dart';
import 'package:payment_app/Screen/tokenToInrSellHistory.page.dart';
import 'package:payment_app/Screen/usdtDepositeHistory.page.dart';
import 'package:payment_app/Screen/updateProfile.page.dart';
import 'package:payment_app/Screen/upilist.page.dart';
import 'package:payment_app/Screen/usdtToSellInrDetailsHistory.page.dart';
import 'package:payment_app/Screen/usdtToSellInrHistory.page.dart';
import 'package:payment_app/config/auth/router/rightsliderFageRoute.dart';
import 'package:payment_app/config/network/api.network.dart';
import 'package:payment_app/config/utils/pretty.dio.dart';
import 'package:payment_app/config/utils/showMessage.dart';
import 'package:payment_app/data/controller/profileController.dart';
import 'package:shimmer/shimmer.dart';

class DrawerPage extends ConsumerStatefulWidget {
  const DrawerPage({super.key});

  @override
  ConsumerState<DrawerPage> createState() => _DrawerPageState();
}

class _DrawerPageState extends ConsumerState<DrawerPage> {
  File? _image;
  String? _imageUrl;
  final ImagePicker _picker = ImagePicker();

  bool _isUploading = false;

  @override
  Widget build(BuildContext context) {
    var box = Hive.box("userdata");
    final profileState = ref.watch(profileController);
    return Scaffold(
      backgroundColor: const Color(0xFF09111C),
      body: Stack(
        children: [
          /// 🔹 Background Gradient (Same as other screens)
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
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 15.h),

                    /// 🔹 Top Bar
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          "Profile",
                          style: GoogleFonts.poppins(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        const Spacer(),
                        // const Icon(Icons.settings, color: Colors.white),
                      ],
                    ),

                    SizedBox(height: 20.h),

                    /// 🔹 Profile Info Card
                    profileState.when(
                      data: (data) {
                        final profile = data.data;
                        final serverImageUrl = profile?.user?.image;
                        return glassCard(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  _buildImagePickerSection(serverImageUrl),
                                  SizedBox(width: 15.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          // "Ajay Sharma",
                                          profile!.user!.name ?? "User",
                                          style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: 20.h),

                              infoText("${profile.user!.mobile ?? ""}"),
                              infoText(profile.user!.email ?? ""),
                              SizedBox(height: 10.h),

                              dividerLine(),

                              SizedBox(height: 10.h),
                              // glassMiniCard(
                              //   "ID. ${profile.user?.userName ?? "adfa"}",
                              //   Icons.copy,
                              // ),
                              Material(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(14.r),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(14.r),
                                  splashColor: const Color(
                                    0xFF06CE8F,
                                  ).withOpacity(0.2),
                                  highlightColor: Colors.white.withOpacity(
                                    0.05,
                                  ),
                                  onTap: () {
                                    Clipboard.setData(
                                      ClipboardData(
                                        text: profile.user?.userName ?? "",
                                      ),
                                    );
                                    ShowMessage.success(
                                      context,
                                      "Username copied",
                                    );
                                  },
                                  child: Ink(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12.w,
                                      vertical: 12.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.04),
                                      borderRadius: BorderRadius.circular(14.r),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            "ID. ${profile.user?.userName ?? "adfa"}",
                                            style: GoogleFonts.poppins(
                                              color: Colors.white,
                                              fontSize: 12.sp,
                                            ),
                                          ),
                                        ),
                                        Icon(
                                          Icons.copy,
                                          size: 16,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      error:
                          (error, stackTrace) =>
                              Center(child: Text(error.toString())),
                      loading: () => profileShimmer(context),
                    ),
                    SizedBox(height: 25.h),
                    menuItem(
                      Icons.card_giftcard,
                      "Invite & Earn",
                      callback: () {
                        Navigator.push(
                          context,
                          RightSlideFadeRoute(page: InvitePage()),
                        );
                      },
                      showNew: false,
                    ),

                    /// 🔹 Menu List
                    menuItem(
                      Icons.account_balance_wallet_outlined,
                      "Payment Methods",
                      callback: () {
                        Navigator.push(
                          context,
                          RightSlideFadeRoute(page: UpiListPage()),
                        );
                      },
                    ),
                    menuItem(
                      Icons.file_download_outlined,
                      // "USDT Deposite History",
                      "USDT Deposite Transaction",
                      callback: () {
                        Navigator.push(
                          context,
                          RightSlideFadeRoute(page: USDTDepositeHistoryPage()),
                        );
                      },
                    ),
                    menuItem(
                      Icons.currency_exchange,
                      // "USDT To INR Selling History ",
                      "USDT Selling History",
                      callback: () {
                        Navigator.push(
                          context,
                          RightSlideFadeRoute(page: UsdtToSellInrHistoryPage()),
                        );
                      },
                    ),
                    menuItem(
                      Icons.shopping_cart_outlined,
                      // "INR TO Token buy history",
                      "Token Buy Transaction",
                      callback: () {
                        Navigator.push(
                          context,
                          RightSlideFadeRoute(page: InrToTokenBuyHistoryPage()),
                        );
                      },
                    ),
                    menuItem(
                      Icons.sell_outlined,
                      // "Token TO INR selling history",
                      "Token Selling History",
                      callback: () {
                        Navigator.push(
                          context,
                          RightSlideFadeRoute(
                            page: TokenToInrSellHistoryPage(),
                          ),
                        );
                      },
                    ),
                    menuItem(
                      Icons.handshake_outlined,
                      // "P2P Buy/SellHistory",
                      "P2P Transaction",
                      callback: () {
                        Navigator.push(
                          context,
                          RightSlideFadeRoute(
                            page: P2pBuySellTransationHistoryPage(),
                          ),
                        );
                      },
                    ),
                    menuItem(
                      Icons.account_balance_wallet_outlined,
                      "Agentship Program",
                      callback: () {
                        Navigator.push(
                          context,
                          RightSlideFadeRoute(page: AgentshipPage()),
                        );
                      },
                    ),
                    menuItem(
                      Icons.enhanced_encryption_outlined,
                      "Change Transaction PIN",
                      callback: () {
                        Navigator.push(
                          context,
                          RightSlideFadeRoute(page: ChangePinPage()),
                        );
                      },
                    ),

                    menuItem(
                      Icons.headset_mic_outlined,
                      "Support",
                      callback: () {
                        // Navigator.push(
                        //   context,
                        //   RightSlideFadeRoute(page: SupportPage()),
                        // );
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => ChatBotPage(),
                          ),
                        );
                      },
                    ),

                    /// 🔹 Logout
                    menuItem(
                      Icons.logout,
                      "Logout",
                      isLogout: true,
                      callback: () {
                        // box.clear();
                        // Navigator.pushAndRemoveUntil(
                        //   context,
                        //   RightSlideFadeRoute(page: LoginPage()),
                        //   (route) => false,
                        // );
                        LogoutDialog.show(context);
                      },
                    ),

                    SizedBox(height: 30.h),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePickerSection(String? networkImageUrl) {
    return Center(
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFF06CE8F), Color(0xFF1A2A3A)],
                begin: Alignment.topLeft,
              ),
            ),
            child: CircleAvatar(
              radius: 35,
              backgroundColor: const Color(0xFF0D1724),
              // Pehle local selected image check karein, fir network image
              backgroundImage:
                  _image != null
                      ? FileImage(_image!)
                      : (networkImageUrl != null && networkImageUrl.isNotEmpty)
                      ? NetworkImage(networkImageUrl) as ImageProvider
                      : null,
              child:
                  _isUploading
                      ? const CircularProgressIndicator(
                        color: Color(0xFF06CE8F),
                        strokeWidth: 2,
                      )
                      : (_image == null &&
                          (networkImageUrl == null || networkImageUrl.isEmpty))
                      ? Icon(
                        CupertinoIcons.person_fill,
                        size: 45.sp,
                        color: Colors.white24,
                      )
                      : null,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: _isUploading ? null : () => _showPickerOptions(),
              child: Container(
                height: 30.h,
                width: 30.h,
                decoration: BoxDecoration(
                  color: const Color(0xFF06CE8F),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF09111C), width: 2),
                ),
                child: Icon(Icons.camera_alt, size: 14.sp, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showPickerOptions() {
    showCupertinoModalPopup(
      context: context,
      builder:
          (context) => CupertinoActionSheet(
            actions: [
              CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pop(context);
                  pickImage(ImageSource.camera);
                },
                child: const Text("Take Photo"),
              ),
              CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pop(context);
                  pickImage(ImageSource.gallery);
                },
                child: const Text("Choose from Gallery"),
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

  // --- Updated Pick Image Logic ---
  Future<void> pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(
      source: source,
      imageQuality: 25,
      maxWidth: 1000,
    );

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      // Important: Pick hone ke BAAD hi upload call karein
      await uploadImage();
    }
  }

  // --- Updated Upload & Update Logic ---

  Future<void> uploadImage() async {
    if (_image == null || _isUploading) return;

    setState(() => _isUploading = true);

    try {
      final apiClient = ApiNetwork(createDio());
      final uploadResponse = await apiClient.uploadImage(_image!);

      // Check if upload was successful
      if (uploadResponse.error == false &&
          uploadResponse.data?.imageUrl != null) {
        String newUrl = uploadResponse.data!.imageUrl!.toString();

        final updateResponse = await apiClient.updateImage(newUrl);

        if (updateResponse.error == false) {
          ref.invalidate(profileController);
          ref.read(profileProvider.notifier).getProfileData();
          setState(() {
            _image = null;
          });
          ShowMessage.success(context, "Profile picture updated!");
        } else {
          _handleError(context, updateResponse.message ?? "Update failed");
        }
      } else {
        _handleError(context, uploadResponse.message ?? "Upload failed");
      }
    } catch (e) {
      // 413 Error handle karne ke liye specific message
      if (e.toString().contains("413")) {
        _handleError(
          context,
          "File size bahut badi hai. Please dusri photo try karein.",
        );
      } else {
        _handleError(context, "Server error: Image upload nahi ho paya");
      }
      log("Image Upload Error: $e");
    } finally {
      setState(() => _isUploading = false);
    }
  }

  void _handleError(BuildContext context, String msg) {
    ShowMessage.error(context, msg);
  }

  /// 🔹 Glass Card
  Widget glassCard({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          padding: EdgeInsets.all(18.w),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(22.r),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
          ),
          child: child,
        ),
      ),
    );
  }

  Widget menuItem(
    IconData icon,
    String title, {
    bool isLogout = false,
    bool showNew = false,
    required VoidCallback callback,
  }) {
    return InkWell(
      onTap: callback,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: Colors.white.withOpacity(0.06)),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isLogout ? Colors.redAccent : const Color(0xFF06CE8F),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  color: isLogout ? Colors.redAccent : Colors.white,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (showNew)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  "NEW",
                  style: GoogleFonts.poppins(
                    fontSize: 10.sp,
                    color: Colors.white,
                  ),
                ),
              ),
            if (!showNew) const Icon(Icons.chevron_right, color: Colors.white),
          ],
        ),
      ),
    );
  }

  Widget infoText(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: GoogleFonts.poppins(color: Colors.white, fontSize: 12.sp),
      ),
    );
  }

  Widget dividerLine() {
    return Container(height: 1, color: Colors.white.withOpacity(0.08));
  }
}

Widget profileShimmer(BuildContext context) {
  return Container(
    padding: EdgeInsets.all(18.w),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.05),
      borderRadius: BorderRadius.circular(22.r),
      border: Border.all(color: Colors.white.withOpacity(0.08)),
    ),
    child: Shimmer.fromColors(
      baseColor: Colors.white.withOpacity(0.05),
      highlightColor: Colors.white.withOpacity(0.12),
      child: Column(
        children: [
          Row(
            children: [
              // Avatar Shimmer
              CircleAvatar(radius: 32, backgroundColor: Colors.white),
              SizedBox(width: 15.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name Line
                    Container(
                      width: 120.w,
                      height: 16.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    // Verified Tag Shimmer
                    Container(
                      width: 70.w,
                      height: 20.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                    ),
                  ],
                ),
              ),
              // Edit Icon Shimmer
              Container(
                width: 34.w,
                height: 34.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          // Info Lines (Mobile, Email, ID)
          shimmerLine(width: 150.w),
          SizedBox(height: 10.h),
          shimmerLine(width: 180.w),

          SizedBox(height: 10.h),
          shimmerLine(width: 130.w),
          SizedBox(height: 10.h),
          // Bottom Mini Card Shimmer
          Container(
            height: 45.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14.r),
            ),
          ),
        ],
      ),
    ),
  );
}

// Helper for Shimmer Lines
Widget shimmerLine({required double width}) {
  return Align(
    alignment: Alignment.centerLeft,
    child: Container(
      width: width,
      height: 12.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4.r),
      ),
    ),
  );
}

class LogoutDialog extends StatelessWidget {
  const LogoutDialog({super.key});

  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => const LogoutDialog(),
    );
  }

  //   Future<void> handleLogout(BuildContext context, WidgetRef ref) async {
  //   /// 🔌 Socket disconnect
  //   socketService.socket?.disconnect();
  //   socketService.socket?.clearListeners();

  //   /// 🧠 Clear Dio (Retrofit base)
  //   final dio = createDio();
  //   dio.options.headers.clear();
  //   dio.interceptors.clear();

  //   /// 💾 Clear Hive
  //   await Hive.close();
  //   await Hive.deleteFromDisk();

  //   /// 🔄 Reset Riverpod
  //   ref.invalidateAll();

  //   /// 🔁 Navigate to login
  //   Navigator.pushAndRemoveUntil(
  //     context,
  //     MaterialPageRoute(builder: (_) => LoginScreen()),
  //     (route) => false,
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      // Background ko blur karne ke liye
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.r),
        ),
        backgroundColor: const Color(0xFF0F172A), // Deep Navy Blue
        child: Container(
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF1E293B),
                const Color(0xFF0F172A).withOpacity(0.8),
              ],
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon with Neon Glow
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: const Color(0xFF06CE8F).withOpacity(0.1),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF06CE8F).withOpacity(0.2),
                  ),
                ),
                child: Icon(
                  Icons.logout_rounded,
                  color: const Color(0xFF06CE8F),
                  size: 32.sp,
                ),
              ),
              SizedBox(height: 20.h),

              // Title
              Text(
                "Logout Confirmation",
                style: GoogleFonts.poppins(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 12.h),

              // Subtitle
              Text(
                "Are you sure you want to log out? You will need to login again to access your wallet.",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 13.sp,
                  color: const Color(0xFF9CA3AF),
                  height: 1.5,
                ),
              ),
              SizedBox(height: 30.h),

              // Buttons
              Row(
                children: [
                  // Cancel Button
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          side: BorderSide(color: Colors.white10),
                        ),
                      ),
                      child: Text(
                        "Cancel",
                        style: GoogleFonts.poppins(
                          color: Colors.white70,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),

                  // Confirm Logout Button
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF06CE8F).withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          var box = Hive.box("userdata");
                          Navigator.pop(context);
                          box.clear();
                          Navigator.pushAndRemoveUntil(
                            context,
                            RightSlideFadeRoute(page: LoginPage()),
                            (route) => false,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF06CE8F),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: Text(
                          "Logout",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
