import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:payment_app/Screen/kycScreen.dart';
import 'package:payment_app/config/auth/router/rightsliderFageRoute.dart';
import 'package:payment_app/data/controller/getKycController.dart';
import 'package:shimmer/shimmer.dart';

class GetKycPage extends ConsumerStatefulWidget {
  const GetKycPage({super.key});

  @override
  ConsumerState<GetKycPage> createState() => _GetKycPageState();
}

class _GetKycPageState extends ConsumerState<GetKycPage> {
  void _navigateToKycSubmit() {
    Navigator.pushReplacement(context, RightSlideFadeRoute(page: KycScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final kycState = ref.watch(getKycController);

    return Scaffold(
      backgroundColor: const Color(0xFF09111C),
      body: Stack(
        children: [
          _topGlow(),
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _appBar(),
              SliverToBoxAdapter(
                child: kycState.when(
                  data: (data) {
                    final kycData = data.data;

                    if (kycData == null) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _navigateToKycSubmit();
                      });
                      return _loadingState();
                    }

                    final status = kycData.status?.toLowerCase() ?? "";
                    final isRejected =
                        status == "reject" || status == "rejected";
                    final isApprove =
                        status == "approve" || status == "approved";

                    final date =
                        kycData.createdAt != null
                            ? DateFormat('dd MMM yyyy').format(
                              DateTime.fromMillisecondsSinceEpoch(
                                kycData.createdAt!.toInt(),
                              ),
                            )
                            : "N/A";

                    return Padding(
                      padding: EdgeInsets.all(20.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _statusBanner(status, isApprove, isRejected),

                          SizedBox(height: 25.h),

                          _sectionCard(
                            title: "User Information",
                            child: Column(
                              children: [
                                _infoRow("Name", kycData.name ?? "User"),
                                _infoRow("User ID", kycData.id ?? "N/A"),
                                _infoRow("Submitted On", date),
                              ],
                            ),
                          ),

                          SizedBox(height: 20.h),

                          _sectionCard(
                            title: "Documents",
                            child: Column(
                              children: [
                                _imageTile("Front Side", kycData.front ?? ""),
                                SizedBox(height: 15.h),
                                _imageTile("Back Side", kycData.back ?? ""),
                              ],
                            ),
                          ),

                          SizedBox(height: 20.h),

                          _sectionCard(
                            title: "Payment Proof",
                            child: _imageTile(
                              "Transaction Screenshot",
                              kycData.image ?? "",
                            ),
                          ),

                          SizedBox(height: 20.h),

                          _sectionCard(
                            title: "Transaction Details",
                            child: Column(
                              children: [
                                _infoRow("Hash", kycData.hash ?? "N/A"),
                                _infoRow(
                                  "Amount",
                                  "${kycData.amount ?? '0'} USD",
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 60.h),
                        ],
                      ),
                    );
                  },
                  loading: () => _shimmer(),
                  error:
                      (e, s) => Center(
                        child: Text(
                          "Error: $e",
                          style: const TextStyle(color: Colors.redAccent),
                        ),
                      ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ================= DESIGN =================

  Widget _topGlow() {
    return Positioned(
      top: -150,
      left: -100,
      child: Container(
        height: 300,
        width: 300,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFF06CE8F).withOpacity(0.08),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 120, sigmaY: 120),
          child: Container(),
        ),
      ),
    );
  }

  SliverAppBar _appBar() {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      title: Text(
        "KYC Overview",
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          fontSize: 18.sp,
          color: Colors.white,
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget _statusBanner(String status, bool isApprove, bool isRejected) {
    Color color =
        isApprove
            ? const Color(0xFF06CE8F)
            : isRejected
            ? Colors.redAccent
            : Colors.orangeAccent;

    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Row(
        children: [
          Icon(
            isApprove
                ? Icons.verified
                : isRejected
                ? Icons.cancel
                : Icons.timelapse,
            color: color,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              "Status: ${status.toUpperCase()}",
              style: GoogleFonts.poppins(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (isRejected)
            TextButton(
              onPressed: _navigateToKycSubmit,
              child: const Text(
                "EDIT",
                style: TextStyle(color: Colors.redAccent),
              ),
            ),
        ],
      ),
    );
  }

  Widget _sectionCard({required String title, required Widget child}) {
    return Container(
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              color: const Color(0xFF06CE8F),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 15.h),
          child,
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.poppins(color: Colors.white54)),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _imageTile(String label, String url) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16.r),
          child: Image.network(
            url,
            height: 180.h,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 12.sp, color: Colors.white70),
        ),
      ],
    );
  }

  Widget _loadingState() {
    return const Center(
      child: CircularProgressIndicator(color: Color(0xFF06CE8F)),
    );
  }

  Widget _shimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.white.withOpacity(0.05),
      highlightColor: Colors.white.withOpacity(0.1),
      child: Container(
        height: 500.h,
        margin: EdgeInsets.all(20.r),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(20.r),
        ),
      ),
    );
  }
}
