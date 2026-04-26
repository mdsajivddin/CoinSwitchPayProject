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
import 'package:payment_app/data/controller/profileController.dart';
import 'package:payment_app/data/controller/updateImageController.dart';
import 'package:payment_app/data/controller/updateProfileController.dart';

class UpdateProfilePage extends ConsumerStatefulWidget {
  const UpdateProfilePage({super.key});

  @override
  ConsumerState<UpdateProfilePage> createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends ConsumerState<UpdateProfilePage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  File? _image;
  String? _imageUrl;
  final ImagePicker _picker = ImagePicker();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  late AnimationController _animController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeIn));
    _animController.forward();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  void _loadData() {
    final profileData = ref.read(profileController);
    profileData.whenData((value) {
      setState(() {
        nameController.text = value.data?.user?.name ?? "";
        emailController.text = value.data?.user?.email ?? "";
        phoneController.text = value.data?.user?.mobile ?? "";
        _imageUrl = value.data?.user?.image;
      });
    });
  }

  // --- Image Logic ---
  Future<void> pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(
      source: source,
      imageQuality: 50,
    );
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final updateImageState = ref.watch(updateImageControllerProvider);
    final updateProfileState = ref.watch(updateProfileControllerProvider);
    final isLoading =
        updateImageState is AsyncLoading || updateProfileState is AsyncLoading;

    return Scaffold(
      backgroundColor: const Color(0xFF09111C),
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
        title: Text(
          "Edit Profile",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            fontSize: 18.sp,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Background Radial Gradient (Login Page Style)
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(-0.8, -0.7),
                radius: 1.3,
                colors: [Color(0xFF1A2A3A), Color(0xFF09111C)],
              ),
            ),
          ),

          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(height: 30.h),

                      // --- PROFILE IMAGE SECTION ---
                      _buildImagePickerSection(),

                      SizedBox(height: 40.h),

                      // --- GLASSMORPHISM CARD ---
                      Container(
                        padding: EdgeInsets.all(22.w),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(28.r),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.08),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            _buildInputField(
                              label: "Full Name",
                              hint: "Enter your name",
                              controller: nameController,
                              icon: CupertinoIcons.person,
                              isReadOnly: false,
                            ),
                            SizedBox(height: 20.h),

                            // Email Field (Protected)
                            _buildInputField(
                              label: "Email Address",
                              hint: "Your email",
                              controller: emailController,
                              icon: CupertinoIcons.mail,
                              isReadOnly: true,
                              onTap: () {
                                ShowMessage.error(
                                  context,
                                  "Email cannot be changed",
                                );
                              },
                            ),
                            SizedBox(height: 20.h),

                            // Email Field (Protected)
                            _buildInputField(
                              label: "Phone",
                              hint: "Your Phone",
                              controller: phoneController,
                              icon: Icons.call,
                              isReadOnly: true,
                              onTap: () {
                                ShowMessage.error(
                                  context,
                                  "Phone cannot be changed",
                                );
                              },
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 40.h),

                      // --- SAVE BUTTON (Glowing Style) ---
                      _buildSaveButton(isLoading),

                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ),
            ),
          ),

          if (isLoading)
            Container(
              color: Colors.black45,
              child: const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF06CE8F),
                  strokeWidth: 1.5,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildImagePickerSection() {
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
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF06CE8F).withOpacity(0.2),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 55.r,
              backgroundColor: const Color(0xFF0D1724),
              backgroundImage:
                  _image != null
                      ? FileImage(_image!)
                      : (_imageUrl != null && _imageUrl!.isNotEmpty)
                      ? NetworkImage(_imageUrl!) as ImageProvider
                      : null,
              child:
                  (_image == null && (_imageUrl == null || _imageUrl!.isEmpty))
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
              onTap: () => _showPickerOptions(),
              child: Container(
                height: 36.h,
                width: 36.h,
                decoration: BoxDecoration(
                  color: const Color(0xFF06CE8F),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF09111C), width: 3),
                ),
                child: Icon(Icons.camera_alt, size: 16.sp, color: Colors.white),
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

  Widget _buildInputField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required IconData icon,
    required bool isReadOnly,
    VoidCallback? onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12.sp,
            color: isReadOnly ? Colors.white60 : const Color(0xFF06CE8F),
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8.h),
        TextFormField(
          cursorColor: Colors.white,
          controller: controller,
          readOnly: isReadOnly,
          onTap: onTap,
          style: GoogleFonts.poppins(
            color: isReadOnly ? Colors.white60 : Colors.white,
            fontSize: 14.sp,
          ),
          decoration: InputDecoration(
            suffixIcon:
                isReadOnly
                    ? null
                    : const Icon(
                      Icons.edit_outlined,
                      size: 18,
                      color: Colors.grey,
                    ),
            prefixIcon: Icon(
              icon,
              color:
                  isReadOnly
                      ? Colors.white60
                      : const Color(0xFF06CE8F).withOpacity(0.6),
              size: 19.sp,
            ),
            hintText: hint,
            hintStyle: GoogleFonts.poppins(color: Colors.white60),
            filled: true,
            fillColor: Colors.black.withOpacity(0.2),
            contentPadding: EdgeInsets.symmetric(
              vertical: 16.h,
              horizontal: 16.w,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: BorderSide(color: Colors.white.withOpacity(0.05)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: const BorderSide(
                color: Color(0xFF06CE8F),
                width: 1.2,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton(bool isLoading) {
    return GestureDetector(
      onTap:
          isLoading
              ? null
              : () async {
                if (nameController.text.trim().isEmpty) {
                  ShowMessage.error(context, "Name is required");
                  return;
                }
                if (_image != null) {
                  await ref
                      .read(updateImageControllerProvider.notifier)
                      .uploadAndUpdateImage(
                        context: context,
                        imageFile: _image!,
                      );
                }
                await ref
                    .read(updateProfileControllerProvider.notifier)
                    .updateProfile(
                      name: nameController.text.trim(),
                      context: context,
                    );
              },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        height: 54.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(99),
          gradient: const LinearGradient(
            colors: [Color(0xFF06CE8F), Color(0xFF05B47A)],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF06CE8F).withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Center(
          child:
              isLoading
                  ? CupertinoActivityIndicator(color: Colors.white, radius: 15)
                  : Text(
                    "SAVE CHANGES",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w700,
                      fontSize: 14.sp,
                      color: Colors.white,
                      letterSpacing: 1.1,
                    ),
                  ),
        ),
      ),
    );
  }
}
