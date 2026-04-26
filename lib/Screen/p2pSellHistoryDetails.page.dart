import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:payment_app/config/network/api.network.dart';
import 'package:payment_app/config/utils/pretty.dio.dart';
import 'package:payment_app/config/utils/showMessage.dart';
import 'package:payment_app/data/controller/getp2pTrasationSellController.dart';

import 'package:payment_app/data/model/getP2pTransatinSellModel.dart';
import 'package:payment_app/data/model/raiseDisputeBodyModel.dart';
import 'package:payment_app/data/model/realeaseAmountAccRejectBody.dart';

class P2pSellHistoryDetailsPage extends ConsumerStatefulWidget {
  final Datum sellData;

  const P2pSellHistoryDetailsPage({super.key, required this.sellData});

  @override
  ConsumerState<P2pSellHistoryDetailsPage> createState() =>
      _P2pSellHistoryDetailsPageState();
}

class _P2pSellHistoryDetailsPageState
    extends ConsumerState<P2pSellHistoryDetailsPage> {
  final TextEditingController _reasonController = TextEditingController();
  bool _isDisputeLoading = false;
  String getFormattedDate(int? timestamp) {
    if (timestamp == null) return "N/A";

    // Check if timestamp is in seconds (10 digits) or millis (13 digits)
    // If it's seconds, multiply by 1000
    int finalTimestamp =
        timestamp.toString().length == 10 ? timestamp * 1000 : timestamp;

    DateTime date = DateTime.fromMillisecondsSinceEpoch(finalTimestamp);
    return DateFormat('dd MMM yyyy, hh:mm a').format(date);
  }

  void _showDisputeBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF161B22),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder:
          (context) => StatefulBuilder(
            builder: (context, setSheetState) {
              return Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                  left: 20.w,
                  right: 20.w,
                  top: 20.h,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Raise a Dispute",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(
                            Icons.close,
                            color: Colors.grey,
                            size: 22.sp,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      "Please provide a valid reason for the dispute. Our team will review it within 24 hours.",
                      style: TextStyle(color: Colors.grey, fontSize: 13.sp),
                    ),
                    SizedBox(height: 20.h),
                    TextField(
                      controller: _reasonController,
                      maxLines: 4,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Enter your reason here...",
                        hintStyle: const TextStyle(color: Colors.grey),
                        fillColor: const Color(0xFF0D1117),
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: const BorderSide(
                            color: Colors.redAccent,
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    SizedBox(
                      width: double.infinity,
                      height: 50.h,
                      child: ElevatedButton(
                        onPressed:
                            _isDisputeLoading
                                ? null
                                : () async {
                                  if (_reasonController.text.trim().isEmpty) {
                                    ShowMessage.success(
                                      context,
                                      "Please enter reason",
                                    );
                                    return;
                                  }
                                  setSheetState(() => _isDisputeLoading = true);
                                  final body = RaiseDsiputeBodyModel(
                                    orderId: widget.sellData.id,
                                    reason: _reasonController.text.trim(),
                                  );
                                  try {
                                    final service = ApiNetwork(createDio());
                                    final response = await service.raiseDispute(
                                      body,
                                    );
                                    if (response.code == 0 ||
                                        response.error == false) {
                                      // ref
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                      ShowMessage.success(
                                        context,
                                        response.message ?? "",
                                      );
                                    } else {
                                      ShowMessage.error(
                                        context,
                                        response.message ?? "",
                                      );
                                    }
                                  } catch (e) {
                                    log(e.toString());
                                  } finally {
                                    // Stop Loading
                                    if (mounted) {
                                      setSheetState(
                                        () => _isDisputeLoading = false,
                                      );
                                    }
                                  }
                                },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          disabledBackgroundColor: Colors.redAccent.withOpacity(
                            0.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child:
                            _isDisputeLoading
                                ? SizedBox(
                                  height: 20.h,
                                  width: 20.h,
                                  child: const CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                                : Text(
                                  "Submit Dispute",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 14.sp,
                                  ),
                                ),
                      ),
                    ),
                    SizedBox(height: 30.h),
                  ],
                ),
              );
            },
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String displayDate = getFormattedDate(widget.sellData.createdAt);
    final image = widget.sellData.image;

    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white, size: 20.sp),
        title: Text(
          "P2P Details",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(p2pSellProvider);
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              SizedBox(height: 10.h),
              _buildBuyingAmountCard(),
              SizedBox(height: 16.h),
              _buildInfoSection(
                title: "ORDER INFO",
                icon: Icons.tag,
                children: [
                  _buildInfoRow(
                    "ORDER ID",
                    widget.sellData.orderId.toString(),
                    isCopyable: true,
                  ),
                  _buildInfoRow("NAME", widget.sellData.name ?? "N/A"),
                  _buildInfoRow("WALLET", widget.sellData.walletType ?? "N/A"),
                  _buildInfoRow("UTR", widget.sellData.hash ?? "N/A"),
                  _buildInfoRow("CREATED", displayDate),
                ],
              ),
              SizedBox(height: 16.h),
              _buildCounterPartySection(),
              SizedBox(height: 16.h),
              _buildDynamicPaymentMethods(),
              SizedBox(height: 16.h),

              if (image != null && image.isNotEmpty)
                _buildPaymentProofSection(),
              SizedBox(height: 100.h),
            ],
          ),
        ),
      ),
      bottomSheet:
          (widget.sellData.status == "process")
              ? Container(
                color: const Color(0xFF0D1117),
                padding: EdgeInsets.fromLTRB(
                  16.w,
                  10.h,
                  16.w,
                  20.h,
                ), // Bottom padding thoda badha diya responsive ke liye
                child: _buildRaiseDisputeButton(context, ref),
              )
              : null,
    );
  }

  Widget _buildBuyingAmountCard() {
    final data = widget.sellData;
    double amount = double.tryParse(data.amount.toString()) ?? 0;
    double rate = double.tryParse(data.rate.toString()) ?? 0;
    double total = amount * rate;

    final String status = (data.status ?? "").toString().toLowerCase();

    // ✅ Default values
    Color statusColor = Colors.white54;
    String statusText = "Requested";

    switch (status) {
      case "pending":
        statusColor = const Color(0xFFF59E0B);
        statusText = "Pending";
        break;

      case "process":
      case "processing":
        statusColor = const Color(0xFF3B82F6);
        statusText = "Processing";
        break;

      case "approve":
        statusColor = const Color(0xFF00FF9D);
        statusText = "Complete";
        break;

      case "reject":
        statusColor = const Color(0xFFEF4444);
        statusText = "Rejected";
        break;

      case "cancel":
        statusColor = const Color(0xFF9CA3AF);
        statusText = "Cancelled";
        break;

      case "expired":
        statusColor = const Color(0xFFEF4444);
        statusText = "Expired";
        break;
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 10.w),
      decoration: BoxDecoration(
        color: const Color(0xFF161B22),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          Text(
            "BUYING AMOUNT",
            style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              fontSize: 12.sp,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            "$amount ${data.walletType ?? ''}",
            style: TextStyle(
              color: const Color(0xFF00FF88),
              fontSize: 28.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            "@ ₹${rate.toStringAsFixed(2)}/unit · Total ≈ ₹${total.toStringAsFixed(2)}",
            style: TextStyle(color: Colors.grey, fontSize: 13.sp),
          ),
          SizedBox(height: 16.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              statusText,
              style: TextStyle(
                color: statusColor,
                fontWeight: FontWeight.w600,
                fontSize: 11.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDynamicPaymentMethods() {
    final methods = widget.sellData.paymentMethods;
    if (methods == null || methods.isEmpty) return const SizedBox.shrink();

    return _buildInfoSection(
      title: "PAYMENT METHODS",
      icon: Icons.account_balance_wallet_outlined,
      children:
          methods.map((m) {
            // Logic to check if UPI or Bank
            bool isUpi = m.methodType?.toLowerCase().contains('upi') ?? false;

            return Column(
              children: [
                const Divider(color: Colors.white10),
                _buildInfoRow("TYPE", m.methodType ?? "N/A"),
                if (isUpi) ...[
                  _buildInfoRow("NAME", m.label ?? "N/A", isCopyable: true),
                  _buildInfoRow(
                    "UPI ID",
                    m.details?.upiId ?? "N/A",
                    isCopyable: true,
                  ),
                ] else ...[
                  _buildInfoRow(
                    "HOLDER NAME",
                    m.details?.accountHolderName ?? "N/A",
                  ),
                  _buildInfoRow("BANK", m.details?.bankName ?? "N/A"),
                  _buildInfoRow(
                    "A/C NO",
                    m.details?.accountNumber ?? "N/A",
                    isCopyable: true,
                  ),
                  _buildInfoRow(
                    "IFSC",
                    m.details?.ifscCode ?? "N/A",
                    isCopyable: true,
                  ),
                ],
              ],
            );
          }).toList(),
    );
  }

  Widget _buildCounterPartySection() {
    final cp = widget.sellData.counterParty;
    return _buildInfoSection(
      title: "COUNTERPARTY",
      icon: Icons.person_outline,
      children: [
        _buildInfoRow("NAME", cp?.name ?? "N/A"),
        _buildInfoRow("EMAIL", cp?.email ?? "N/A"),
      ],
    );
  }

  Widget _buildInfoSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF161B22),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                Icon(icon, color: Colors.grey, size: 16.sp),
                SizedBox(width: 8.w),
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 11.sp,
                  ),
                ),
              ],
            ),
          ),
          ...children,
          SizedBox(height: 8.h),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isCopyable = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey, fontSize: 12.sp)),
          Flexible(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    value,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // if (isCopyable) ...[
                //   SizedBox(width: 6.w),
                //   GestureDetector(
                //     onTap: () {
                //       Clipboard.setData(ClipboardData(text: value));
                //       ScaffoldMessenger.of(context).showSnackBar(
                //         const SnackBar(
                //           content: Text("Copied to clipboard"),
                //           duration: Duration(seconds: 1),
                //         ),
                //       );
                //     },
                //     child: Icon(
                //       Icons.copy,
                //       color: const Color(0xFF00FF88),
                //       size: 14.sp,
                //     ),
                //   ),
                // ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentProofSection() {
    final proofImg = widget.sellData.image;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF161B22),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "PAYMENT PROOF",
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 11.sp,
                  ),
                ),
                if (proofImg != null)
                  InkWell(
                    onTap: () {
                      _showFullScreenImage(context, proofImg);
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.open_in_new,
                          color: const Color(0xFF00FF88),
                          size: 14.sp,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          "Open",
                          style: TextStyle(
                            color: const Color(0xFF00FF88),
                            fontWeight: FontWeight.bold,
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child:
                  proofImg != null && proofImg.isNotEmpty
                      ? Image.network(
                        proofImg,
                        height: 180.h,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            width: double.infinity,
                            height: 180.h,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 1.5,
                              ),
                            ),
                          );
                        },
                        errorBuilder:
                            (context, error, stackTrace) =>
                                _buildImagePlaceholder(),
                      )
                      : _buildImagePlaceholder(),
            ),
          ),
        ],
      ),
    );
  }

  void _showFullScreenImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      barrierDismissible: true, // Screen ke bahar click karne se band ho jayega
      builder:
          (context) => Dialog(
            backgroundColor:
                Colors.transparent, // Background transparent rakha hai
            insetPadding: EdgeInsets.zero, // Poori screen cover karne ke liye
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Pinch to Zoom feature ke saath image
                InteractiveViewer(
                  minScale: 0.5,
                  maxScale: 5.0,
                  child:
                      imageUrl.isNotEmpty
                          ? Image.network(
                            imageUrl,
                            width: double.infinity,
                            height: double.infinity,
                            fit:
                                BoxFit
                                    .contain, // Poori image dikhegi bina katti hui
                          )
                          : const Icon(
                            Icons.broken_image,
                            color: Colors.white,
                            size: 50,
                          ),
                ),
                // Close Button (Top Right)
                Positioned(
                  top: 40.h,
                  right: 20.w,
                  child: IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      height: 180.h,
      width: double.infinity,
      color: Colors.white10,
      child: Icon(
        Icons.image_not_supported,
        color: Colors.white24,
        size: 40.sp,
      ),
    );
  }

  Widget _buildRaiseDisputeButton(BuildContext context, WidgetRef ref) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _showActionDialog(context, ref),
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          width: double.infinity,
          height: 54.h,
          decoration: BoxDecoration(
            color: Color(0xFF06CE8F),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.done, color: Colors.white, size: 18.sp),
              SizedBox(width: 8.w),
              Text(
                "Release Order",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showActionDialog(BuildContext context, WidgetRef ref) {
    String selectedAction = ""; // "accept" or "reject"
    bool isLoading = false; // Loading state manage karne ke liye
    final TextEditingController reasonController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible:
          !isLoading, // Loading ke waqt dialog bahar se band na ho
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF161B22),
              insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
                side: BorderSide(color: Colors.white.withOpacity(0.05)),
              ),
              title: Text(
                "Order Action",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              content: SizedBox(
                width: 1.sw,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // --- INITIAL STATE ---
                    if (selectedAction == "") ...[
                      Text(
                        "Choose an action for this transaction:",
                        style: GoogleFonts.poppins(
                          color: Colors.white60,
                          fontSize: 13.sp,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 24.h),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF00E676),
                                padding: EdgeInsets.symmetric(vertical: 14.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                              ),
                              onPressed:
                                  () => setDialogState(
                                    () => selectedAction = "accept",
                                  ),
                              child: Text(
                                "Accept",
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFF05351),
                                padding: EdgeInsets.symmetric(vertical: 14.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                              ),
                              onPressed:
                                  () => setDialogState(
                                    () => selectedAction = "reject",
                                  ),
                              child: Text(
                                "Reject",
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],

                    // --- ACCEPT SECTION ---
                    if (selectedAction == "accept") ...[
                      Icon(
                        Icons.check_circle_rounded,
                        color: const Color(0xFF00E676),
                        size: 54.sp,
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        "Are you sure you want to accept?",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 14.sp,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 24.h),
                      Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed:
                                  isLoading
                                      ? null
                                      : () => setDialogState(
                                        () => selectedAction = "",
                                      ),
                              child: Text(
                                "Cancel",
                                style: GoogleFonts.poppins(
                                  color: Colors.white38,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF00E676),
                                padding: EdgeInsets.symmetric(vertical: 14.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                              ),
                              onPressed:
                                  isLoading
                                      ? null
                                      : () async {
                                        setDialogState(() => isLoading = true);
                                        try {
                                          final body =
                                              ReleaseAmountRejectOrApproveBody(
                                                orderId: widget.sellData.id,
                                                status: "approve",
                                              );
                                          final service = ApiNetwork(
                                            createDio(),
                                          );
                                          final response = await service
                                              .releaseAmountRejectOrApprove(
                                                body,
                                              );

                                          if (response.code == 0 &&
                                              response.error == false) {
                                            ShowMessage.success(
                                              context,
                                              response.message ?? "Success",
                                            );
                                            ref.invalidate(p2pSellProvider);
                                            Navigator.pop(
                                              context,
                                            ); // Close Dialog
                                            Navigator.pop(
                                              context,
                                            ); // Close Page
                                          } else {
                                            ShowMessage.error(
                                              context,
                                              response.message ?? "Error",
                                            );
                                          }
                                        } catch (e, st) {
                                          log(st.toString());
                                          log(e.toString());
                                          ShowMessage.error(
                                            context,
                                            "${e} Something went wrong",
                                          );
                                        } finally {
                                          if (context.mounted)
                                            setDialogState(
                                              () => isLoading = false,
                                            );
                                        }
                                      },
                              child:
                                  isLoading
                                      ? SizedBox(
                                        height: 20.h,
                                        width: 20.h,
                                        child: const CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                      : Text(
                                        "Confirm",
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14.sp,
                                        ),
                                      ),
                            ),
                          ),
                        ],
                      ),
                    ],

                    // --- REJECT SECTION ---
                    if (selectedAction == "reject") ...[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Reason for Rejection",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                      SizedBox(height: 12.h),
                      TextField(
                        controller: reasonController,
                        maxLines: 3,
                        enabled: !isLoading,
                        style: TextStyle(color: Colors.white, fontSize: 14.sp),
                        decoration: InputDecoration(
                          hintText: "Enter rejection reason...",
                          hintStyle: TextStyle(
                            color: Colors.white24,
                            fontSize: 12.sp,
                          ),
                          fillColor: const Color(0xFF0D1117),
                          filled: true,
                          contentPadding: EdgeInsets.all(12.w),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: const BorderSide(
                              color: Color(0xFFF05351),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 24.h),
                      Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed:
                                  isLoading
                                      ? null
                                      : () => setDialogState(
                                        () => selectedAction = "",
                                      ),
                              child: Text(
                                "Back",
                                style: GoogleFonts.poppins(
                                  color: Colors.white38,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFF05351),
                                padding: EdgeInsets.symmetric(vertical: 14.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                              ),
                              onPressed:
                                  isLoading
                                      ? null
                                      : () async {
                                        if (reasonController.text.isEmpty) {
                                          ShowMessage.error(
                                            context,
                                            "Please enter a reason",
                                          );
                                          return;
                                        }
                                        setDialogState(() => isLoading = true);
                                        try {
                                          final body =
                                              ReleaseAmountRejectOrApproveBody(
                                                orderId: widget.sellData.id,
                                                status: "reject",
                                                rejectReason:
                                                    reasonController
                                                        .text, // Assuming reason field exists
                                              );
                                          final service = ApiNetwork(
                                            createDio(),
                                          );
                                          final response = await service
                                              .releaseAmountRejectOrApprove(
                                                body,
                                              );

                                          if (response.code == 0 &&
                                              response.error == false) {
                                            ShowMessage.success(
                                              context,
                                              response.message ?? "Success",
                                            );
                                            ref.invalidate(
                                              p2pBuyHistoryProvider,
                                            );
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                          } else {
                                            ShowMessage.error(
                                              context,
                                              response.message ?? "Error",
                                            );
                                          }
                                        } catch (e) {
                                          ShowMessage.error(
                                            context,
                                            "Something went wrong",
                                          );
                                        } finally {
                                          if (context.mounted)
                                            setDialogState(
                                              () => isLoading = false,
                                            );
                                        }
                                      },
                              child:
                                  isLoading
                                      ? SizedBox(
                                        height: 20.h,
                                        width: 20.h,
                                        child: const CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                      : Text(
                                        "Submit",
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14.sp,
                                        ),
                                      ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
