import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:payment_app/data/controller/deleteBankController.dart';
import 'package:payment_app/data/controller/updateBankStatusController.dart';

class BankDetilsPage extends ConsumerStatefulWidget {
  final String bankName;
  final String bankAccount;
  final String holderName;
  final String ifscOde;
  final String brantchName;
  final bool isDisable;
  final String bankID;

  const BankDetilsPage({
    super.key,
    required this.bankName,
    required this.bankAccount,
    required this.holderName,
    required this.ifscOde,
    required this.brantchName,
    required this.isDisable,
    required this.bankID,
  });

  @override
  ConsumerState<BankDetilsPage> createState() => _BankDetilsPageState();
}

class _BankDetilsPageState extends ConsumerState<BankDetilsPage> {
  late bool isActive;

  @override
  void initState() {
    super.initState();
    isActive = !widget.isDisable;
  }

  void _showDeleteSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1C2633),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
      ),
      builder: (bottomSheetContext) {
        return Container(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              SizedBox(height: 20.h),
              Icon(
                CupertinoIcons.exclamationmark_triangle,
                color: Colors.redAccent,
                size: 48.sp,
              ),
              SizedBox(height: 16.h),
              Text(
                "Remove Bank Account?",
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                "Are you sure you want to remove ${widget.bankName} account ending in ${widget.bankAccount.characters.takeLast(4)}?",
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.white54,
                  fontSize: 14.sp,
                ),
              ),
              SizedBox(height: 24.h),
              Row(
                children: [
                  Expanded(
                    child: _buildButton(
                      label: "Cancel",
                      icon: Icons.close,
                      color: Colors.white.withOpacity(0.05),
                      textColor: Colors.white,
                      onTap: () => Navigator.pop(bottomSheetContext),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _buildButton(
                      label: "Remove",
                      icon: CupertinoIcons.trash,
                      color: Colors.redAccent,
                      textColor: Colors.white,
                      onTap: () {
                        Navigator.pop(bottomSheetContext);
                        ref
                            .read(deleteBankProvider.notifier)
                            .deleteBank(
                              context: context,
                              bankId: widget.bankID,
                            );
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Yeh watch ab "AsyncLoading" ko detect kar payega
    final deleteBankState = ref.watch(deleteBankProvider);
    final bool isLoading = deleteBankState is AsyncLoading;

    return Scaffold(
      backgroundColor: const Color(0xFF09111C),
      appBar: AppBar(
        backgroundColor: const Color(0xFF09111C),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: Text(
          "Bank Details",
          style: GoogleFonts.plusJakartaSans(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 18.sp,
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            child: Column(
              children: [
                _headerCard(),
                SizedBox(height: 24.h),
                _detailsCard(),
                SizedBox(height: 40.h),
                _buildButton(
                  label: "Remove Bank Account",
                  icon: CupertinoIcons.trash,
                  color: Colors.redAccent.withOpacity(0.1),
                  textColor: Colors.redAccent,
                  isOutline: true,
                  onTap: () => _showDeleteSheet(context),
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),

          // LOADING OVERLAY (Ab dikhega kyunki controller state AsyncLoading hai)
          if (isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 40.w,
                      vertical: 20.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1C2633),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 24.w,
                          width: 24.w,
                          child: const CircularProgressIndicator(
                            strokeWidth: 3,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.redAccent,
                            ),
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Text(
                          "Deleting...",
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // --- UI WIDGETS (Header & Details remain same) ---

  Widget _headerCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(22.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors:
              isActive
                  ? [const Color(0xFF06CE8F), const Color(0xFF00A370)]
                  : [const Color(0xFF323F4B), const Color(0xFF1F2933)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Row(
        children: [
          Container(
            height: 64.w,
            width: 64.w,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(18.r),
            ),
            child: const Icon(
              CupertinoIcons.building_2_fill,
              color: Colors.white,
              size: 32,
            ),
          ),
          SizedBox(width: 18.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.bankName,
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  widget.bankAccount,
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: 15.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailsCard() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: const Color(0xFF1C2633),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Account Information",
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 20.h),
          const Divider(color: Colors.white10, height: 1),
          SizedBox(height: 20.h),
          _detailRow("Account Holder", widget.holderName),
          _detailRow("IFSC Code", widget.ifscOde, copy: true),
          _detailRow("Branch Name", widget.brantchName),
          Padding(
            padding: EdgeInsets.only(top: 8.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Account Status",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14.sp,
                        color: Colors.white54,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      isActive ? "Active for payments" : "Currently disabled",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11.sp,
                        color:
                            isActive ? const Color(0xFF06CE8F) : Colors.white24,
                      ),
                    ),
                  ],
                ),
                Transform.scale(
                  scale: 0.85,
                  child: CupertinoSwitch(
                    value: isActive,
                    activeColor: const Color(0xFF06CE8F),
                    onChanged: (bool value) {
                      // Hum 'isActive' pass kar rahe hain dialog ko
                      _showStatusDialog(
                        context,
                        isActive,
                        widget.bankAccount,
                        widget.bankID,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value, {bool copy = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 18.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14.sp,
              color: Colors.white54,
              fontWeight: FontWeight.w500,
            ),
          ),
          Row(
            children: [
              Text(
                value,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              if (copy) ...[
                SizedBox(width: 8.w),
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: value));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Copied to clipboard"),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                  child: Icon(
                    CupertinoIcons.doc_on_doc,
                    size: 16.sp,
                    color: const Color(0xFF06CE8F),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required String label,
    required IconData icon,
    required Color color,
    required Color textColor,
    required VoidCallback onTap,
    bool isOutline = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 56.h,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(18.r),
          border:
              isOutline ? Border.all(color: textColor.withOpacity(0.3)) : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: textColor, size: 20.sp),
            SizedBox(width: 10.w),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                color: textColor,
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showStatusDialog(
    BuildContext context,
    bool currentActiveState, // Agar bank chalu hai to ye 'true' hoga
    String upi,
    String id,
  ) {
    // Agar chalu (true) hai to action "Disable" ka dikhayenge
    final bool isEnablingAction = !currentActiveState;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Consumer(
            builder: (context, ref, child) {
              final updateState = ref.watch(updateBankStatusProvider);
              final bool isLoading = updateState is AsyncLoading;
              return Container(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 30),
                decoration: BoxDecoration(
                  color: const Color(0xFF131B26),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(30.r),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      isEnablingAction
                          ? "Enable Bank Account?"
                          : "Disable Bank Account?",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text(
                              "Cancel",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  isEnablingAction
                                      ? const Color(0xFF06CE8F)
                                      : Colors.redAccent,
                            ),
                            onPressed:
                                isLoading
                                    ? null
                                    : () async {
                                      await ref
                                          .read(
                                            updateBankStatusProvider.notifier,
                                          )
                                          .updateBankStatus(
                                            context: context,
                                            bankId: id,
                                            isDisable: currentActiveState,
                                          );

                                      if (context.mounted) {
                                        setState(() {
                                          isActive = !currentActiveState;
                                        });

                                        Navigator.pop(context);
                                      }
                                    },
                            child:
                                isLoading
                                    ? SizedBox(
                                      width: 20.w,
                                      height: 20.h,
                                      child: const CircularProgressIndicator(
                                        color: Colors.black,
                                        strokeWidth: 1.5,
                                      ),
                                    )
                                    : Text(
                                      isEnablingAction ? "Enable" : "Disable",
                                      style: const TextStyle(
                                        color: Colors.black,
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
          ),
    );
  }
}
