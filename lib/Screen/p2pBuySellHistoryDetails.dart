// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:intl/intl.dart';
// import 'package:payment_app/config/network/api.network.dart';
// import 'package:payment_app/config/utils/pretty.dio.dart';
// import 'package:payment_app/config/utils/showMessage.dart';
// import 'package:payment_app/data/controller/getP2pByIdController.dart';

// import 'package:payment_app/data/model/getP2pTransationBuyModel.dart';
// import 'package:payment_app/data/model/raiseDisputeBodyModel.dart';

// class P2pBuySellHistoryDetails extends ConsumerStatefulWidget {
//   final String id;

//   const P2pBuySellHistoryDetails({super.key, required this.id});

//   @override
//   ConsumerState<P2pBuySellHistoryDetails> createState() =>
//       _P2pBuySellHistoryDetailsState();
// }

// class _P2pBuySellHistoryDetailsState
//     extends ConsumerState<P2pBuySellHistoryDetails> {
//   final TextEditingController _reasonController = TextEditingController();
//   bool _isDisputeLoading = false;
//   String getFormattedDate(int? timestamp) {
//     if (timestamp == null) return "N/A";

//     // Check if timestamp is in seconds (10 digits) or millis (13 digits)
//     // If it's seconds, multiply by 1000
//     int finalTimestamp =
//         timestamp.toString().length == 10 ? timestamp * 1000 : timestamp;

//     DateTime date = DateTime.fromMillisecondsSinceEpoch(finalTimestamp);
//     return DateFormat('dd MMM yyyy, hh:mm a').format(date);
//   }

//   void _showDisputeBottomSheet(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: const Color(0xFF161B22),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
//       ),
//       builder:
//           (context) => StatefulBuilder(
//             builder: (context, setSheetState) {
//               return Padding(
//                 padding: EdgeInsets.only(
//                   bottom: MediaQuery.of(context).viewInsets.bottom,
//                   left: 20.w,
//                   right: 20.w,
//                   top: 20.h,
//                 ),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           "Raise a Dispute",
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 18.sp,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         IconButton(
//                           onPressed: () => Navigator.pop(context),
//                           icon: Icon(
//                             Icons.close,
//                             color: Colors.grey,
//                             size: 22.sp,
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 10.h),
//                     Text(
//                       "Please provide a valid reason for the dispute. Our team will review it within 24 hours.",
//                       style: TextStyle(color: Colors.grey, fontSize: 13.sp),
//                     ),
//                     SizedBox(height: 20.h),
//                     TextField(
//                       controller: _reasonController,
//                       maxLines: 4,
//                       style: const TextStyle(color: Colors.white),
//                       decoration: InputDecoration(
//                         hintText: "Enter your reason here...",
//                         hintStyle: const TextStyle(color: Colors.grey),
//                         fillColor: const Color(0xFF0D1117),
//                         filled: true,
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12.r),
//                           borderSide: BorderSide.none,
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12.r),
//                           borderSide: const BorderSide(
//                             color: Colors.redAccent,
//                             width: 1,
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 20.h),
//                     SizedBox(
//                       width: double.infinity,
//                       height: 50.h,
//                       child: ElevatedButton(
//                         onPressed:
//                             _isDisputeLoading
//                                 ? null
//                                 : () async {
//                                   if (_reasonController.text.trim().isEmpty) {
//                                     ShowMessage.success(
//                                       context,
//                                       "Please enter reason",
//                                     );
//                                     return;
//                                   }
//                                   setSheetState(() => _isDisputeLoading = true);
//                                   final body = RaiseDsiputeBodyModel(
//                                     orderId: id.toString(),
//                                     reason: _reasonController.text.trim(),
//                                   );
//                                   try {
//                                     final service = ApiNetwork(createDio());
//                                     final response = await service.raiseDispute(
//                                       body,
//                                     );
//                                     if (response.code == 0 ||
//                                         response.error == false) {
//                                       Navigator.pop(context);
//                                       Navigator.pop(context);
//                                       ShowMessage.success(
//                                         context,
//                                         response.message ?? "",
//                                       );
//                                     } else {
//                                       ShowMessage.error(
//                                         context,
//                                         response.message ?? "",
//                                       );
//                                     }
//                                   } catch (e) {
//                                     log(e.toString());
//                                   } finally {
//                                     // Stop Loading
//                                     if (mounted) {
//                                       setSheetState(
//                                         () => _isDisputeLoading = false,
//                                       );
//                                     }
//                                   }
//                                 },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.redAccent,
//                           disabledBackgroundColor: Colors.redAccent.withOpacity(
//                             0.5,
//                           ),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12.r),
//                           ),
//                         ),
//                         child:
//                             _isDisputeLoading
//                                 ? SizedBox(
//                                   height: 20.h,
//                                   width: 20.h,
//                                   child: const CircularProgressIndicator(
//                                     color: Colors.white,
//                                     strokeWidth: 2,
//                                   ),
//                                 )
//                                 : Text(
//                                   "Submit Dispute",
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.white,
//                                     fontSize: 14.sp,
//                                   ),
//                                 ),
//                       ),
//                     ),
//                     SizedBox(height: 30.h),
//                   ],
//                 ),
//               );
//             },
//           ),
//     );
//   }

//   String? id;

//   @override
//   Widget build(BuildContext context) {
//     // String displayDate = getFormattedDate(buyData.createdAt);
//     final getP2pByIdState = ref.watch(getP2pByIdController('id'));
//     return Scaffold(
//       backgroundColor: const Color(0xFF0D1117),
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         centerTitle: true,
//         iconTheme: IconThemeData(color: Colors.white, size: 20.sp),
//         title: Text(
//           "P2P Details",
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 18.sp,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//       ),
//       body: getP2pByIdState.when(
//         data: (data) {
//           final buyData = data.data;
//           id = buyData?.id;
//           double amount = double.tryParse(buyData?.amount.toString() ?? "") ?? 0;
//           double rate = double.tryParse(buyData?.rate.toString() ?? "") ?? 0;
//           double total = amount * rate;
//           final proofImg = buyData?.image;
//           final methods = buyData?.paymentMethods;
//           if (methods == null || methods.isEmpty) {
//             return const SizedBox.shrink();
//           }

//           return SingleChildScrollView(
//             padding: EdgeInsets.symmetric(horizontal: 16.w),
//             child: Column(
//               children: [
//                 SizedBox(height: 10.h),

//                 Container(
//                   width: double.infinity,
//                   padding: EdgeInsets.symmetric(
//                     vertical: 24.h,
//                     horizontal: 10.w,
//                   ),
//                   decoration: BoxDecoration(
//                     color: const Color(0xFF161B22),
//                     borderRadius: BorderRadius.circular(24.r),
//                     border: Border.all(color: Colors.white10),
//                   ),
//                   child: Column(
//                     children: [
//                       Text(
//                         "BUYING AMOUNT",
//                         style: TextStyle(
//                           color: Colors.grey,
//                           fontWeight: FontWeight.bold,
//                           letterSpacing: 1.2,
//                           fontSize: 12.sp,
//                         ),
//                       ),
//                       SizedBox(height: 8.h),
//                       Text(
//                         "$amount ${buyData?.walletType ?? ''}",
//                         style: TextStyle(
//                           color: const Color(0xFF00FF88),
//                           fontSize: 28.sp,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       SizedBox(height: 4.h),
//                       Text(
//                         "@ ₹${rate.toStringAsFixed(2)}/unit · Total ≈ ₹${total.toStringAsFixed(2)}",
//                         style: TextStyle(color: Colors.grey, fontSize: 13.sp),
//                       ),
//                       SizedBox(height: 16.h),
//                       Container(
//                         padding: EdgeInsets.symmetric(
//                           horizontal: 16.w,
//                           vertical: 6.h,
//                         ),
//                         decoration: BoxDecoration(
//                           color: Colors.orange.withOpacity(0.15),
//                           borderRadius: BorderRadius.circular(20.r),
//                         ),
//                         child: Text(
//                           buyData?.status ?? "Requested",
//                           style: TextStyle(
//                             color: Colors.orange,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 11.sp,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 16.h),
//                 _buildInfoSection(
//                   title: "ORDER INFO",
//                   icon: Icons.tag,
//                   children: [
//                     _buildInfoRow(
//                       "ORDER ID",
//                       buyData!.id.toString(),
//                       isCopyable: true,
//                     ),
//                     _buildInfoRow("NAME", buyData.name ?? "N/A"),
//                     _buildInfoRow("WALLET", buyData.walletType ?? "N/A"),
//                     _buildInfoRow(
//                       "CREATED",
//                       getFormattedDate(buyData.createdAt),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 16.h),
//                 // _buildCounterPartySection(buyData),
//                 _buildInfoSection(
//                   title: "COUNTERPARTY",
//                   icon: Icons.person_outline,
//                   children: [
//                     _buildInfoRow("NAME", buyData.counterPartyModel ?? "N/A"),
//                     _buildInfoRow("EMAIL", buyData.creatorModel ?? "N/A"),
//                   ],
//                 ),
//                 SizedBox(height: 16.h),
//                 // _buildDynamicPaymentMethods(),
//                 _buildInfoSection(
//                   title: "PAYMENT METHODS",
//                   icon: Icons.account_balance_wallet_outlined,
//                   children:
//                       methods.map((m) {
//                         // Logic to check if UPI or Bank
//                         bool isUpi =
//                             m.methodType?.toLowerCase().contains('upi') ??
//                             false;

//                         return Column(
//                           children: [
//                             const Divider(color: Colors.white10),
//                             _buildInfoRow("TYPE", m.methodType ?? "N/A"),
//                             if (isUpi)
//                               _buildInfoRow(
//                                 "UPI ID",
//                                 m.details?.upiId ?? "N/A",
//                                 isCopyable: true,
//                               )
//                             else ...[
//                               _buildInfoRow(
//                                 "BANK",
//                                 m.details?.bankName ?? "N/A",
//                               ),
//                               _buildInfoRow(
//                                 "A/C NO",
//                                 m.details?.accountNumber ?? "N/A",
//                                 isCopyable: true,
//                               ),
//                               _buildInfoRow(
//                                 "IFSC",
//                                 m.details?.ifscCode ?? "N/A",
//                                 isCopyable: true,
//                               ),
//                             ],
//                           ],
//                         );
//                       }).toList(),
//                 ),
//                 SizedBox(height: 16.h),
//                 // _buildPaymentProofSection(),
//                 Container(
//                   width: double.infinity,
//                   decoration: BoxDecoration(
//                     color: const Color(0xFF161B22),
//                     borderRadius: BorderRadius.circular(16.r),
//                     border: Border.all(color: Colors.white12),
//                   ),
//                   child: Column(
//                     children: [
//                       Padding(
//                         padding: EdgeInsets.all(16.w),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               "PAYMENT PROOF",
//                               style: TextStyle(
//                                 color: Colors.grey,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 11.sp,
//                               ),
//                             ),
//                             if (proofImg != null)
//                               InkWell(
//                                 onTap: () {
//                                   _showFullScreenImage(context, proofImg);
//                                 },
//                                 child: Row(
//                                   children: [
//                                     Icon(
//                                       Icons.open_in_new,
//                                       color: const Color(0xFF00FF88),
//                                       size: 14.sp,
//                                     ),
//                                     SizedBox(width: 4.w),
//                                     Text(
//                                       "Open",
//                                       style: TextStyle(
//                                         color: const Color(0xFF00FF88),
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 12.sp,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                           ],
//                         ),
//                       ),
//                       Padding(
//                         padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(12.r),
//                           child:
//                               proofImg != null && proofImg.isNotEmpty
//                                   ? Image.network(
//                                     proofImg,
//                                     height: 180.h,
//                                     width: double.infinity,
//                                     fit: BoxFit.cover,
//                                     errorBuilder:
//                                         (context, error, stackTrace) =>
//                                             _buildImagePlaceholder(),
//                                   )
//                                   : _buildImagePlaceholder(),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 100.h),
//               ],
//             ),
//           );
//         },
//         error: (error, stackTrace) {
//           log(stackTrace.toString());
//           return Center(child: Text(error.toString()));
//         },
//         loading:
//             () => Center(child: CircularProgressIndicator(color: Colors.white)),
//       ),
//       bottomSheet: Container(
//         color: const Color(0xFF0D1117),
//         padding: EdgeInsets.all(16.w),
//         child: _buildRaiseDisputeButton(context),
//       ),
//     );
//   }

//   Widget _buildInfoSection({
//     required String title,
//     required IconData icon,
//     required List<Widget> children,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//         color: const Color(0xFF161B22),
//         borderRadius: BorderRadius.circular(16.r),
//         border: Border.all(color: Colors.white12),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: EdgeInsets.all(16.w),
//             child: Row(
//               children: [
//                 Icon(icon, color: Colors.grey, size: 16.sp),
//                 SizedBox(width: 8.w),
//                 Text(
//                   title,
//                   style: TextStyle(
//                     color: Colors.grey,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 11.sp,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           ...children,
//           SizedBox(height: 8.h),
//         ],
//       ),
//     );
//   }

//   Widget _buildInfoRow(String label, String value, {bool isCopyable = false}) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(label, style: TextStyle(color: Colors.grey, fontSize: 12.sp)),
//           Flexible(
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Flexible(
//                   child: Text(
//                     value,
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 13.sp,
//                       fontWeight: FontWeight.w600,
//                     ),
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//                 if (isCopyable) ...[
//                   SizedBox(width: 6.w),
//                   GestureDetector(
//                     onTap: () {
//                       Clipboard.setData(ClipboardData(text: value));
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                           content: Text("Copied to clipboard"),
//                           duration: Duration(seconds: 1),
//                         ),
//                       );
//                     },
//                     child: Icon(
//                       Icons.copy,
//                       color: const Color(0xFF00FF88),
//                       size: 14.sp,
//                     ),
//                   ),
//                 ],
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showFullScreenImage(BuildContext context, String imageUrl) {
//     showDialog(
//       context: context,
//       barrierDismissible: true, // Screen ke bahar click karne se band ho jayega
//       builder:
//           (context) => Dialog(
//             backgroundColor:
//                 Colors.transparent, // Background transparent rakha hai
//             insetPadding: EdgeInsets.zero, // Poori screen cover karne ke liye
//             child: Stack(
//               alignment: Alignment.center,
//               children: [
//                 // Pinch to Zoom feature ke saath image
//                 InteractiveViewer(
//                   minScale: 0.5,
//                   maxScale: 5.0,
//                   child:
//                       imageUrl.isNotEmpty
//                           ? Image.network(
//                             imageUrl,
//                             width: double.infinity,
//                             height: double.infinity,
//                             fit:
//                                 BoxFit
//                                     .contain, // Poori image dikhegi bina katti hui
//                           )
//                           : const Icon(
//                             Icons.broken_image,
//                             color: Colors.white,
//                             size: 50,
//                           ),
//                 ),
//                 // Close Button (Top Right)
//                 Positioned(
//                   top: 40.h,
//                   right: 20.w,
//                   child: IconButton(
//                     icon: const Icon(
//                       Icons.close,
//                       color: Colors.white,
//                       size: 30,
//                     ),
//                     onPressed: () => Navigator.pop(context),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//     );
//   }

//   Widget _buildImagePlaceholder() {
//     return Container(
//       height: 180.h,
//       width: double.infinity,
//       color: Colors.white10,
//       child: Icon(
//         Icons.image_not_supported,
//         color: Colors.white24,
//         size: 40.sp,
//       ),
//     );
//   }

//   Widget _buildRaiseDisputeButton(BuildContext context) {
//     return Material(
//       color: Colors.transparent,
//       child: InkWell(
//         onTap: () => _showDisputeBottomSheet(context),
//         borderRadius: BorderRadius.circular(12.r),
//         child: Container(
//           width: double.infinity,
//           height: 54.h,
//           decoration: BoxDecoration(
//             color: Colors.red.withOpacity(0.1),
//             borderRadius: BorderRadius.circular(12.r),
//             border: Border.all(color: Colors.redAccent.withOpacity(0.3)),
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(Icons.security, color: Colors.redAccent, size: 18.sp),
//               SizedBox(width: 8.w),
//               Text(
//                 "Raise Dispute",
//                 style: TextStyle(
//                   color: Colors.redAccent,
//                   fontSize: 15.sp,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:payment_app/config/network/api.network.dart';
import 'package:payment_app/config/utils/pretty.dio.dart';
import 'package:payment_app/config/utils/showMessage.dart';
import 'package:payment_app/data/controller/getP2pByIdController.dart';

import 'package:payment_app/data/model/getP2pTransationBuyModel.dart';
import 'package:payment_app/data/model/raiseDisputeBodyModel.dart';

class P2pBuySellHistoryDetails extends ConsumerStatefulWidget {
  final String id;

  const P2pBuySellHistoryDetails({super.key, required this.id});

  @override
  ConsumerState<P2pBuySellHistoryDetails> createState() =>
      _P2pBuySellHistoryDetailsState();
}

class _P2pBuySellHistoryDetailsState
    extends ConsumerState<P2pBuySellHistoryDetails> {
  final TextEditingController _reasonController = TextEditingController();
  bool _isDisputeLoading = false;

  String getFormattedDate(int? timestamp) {
    if (timestamp == null) return "N/A";

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
                                    orderId: widget.id,
                                    reason: _reasonController.text.trim(),
                                  );
                                  try {
                                    final service = ApiNetwork(createDio());
                                    final response = await service.raiseDispute(
                                      body,
                                    );
                                    if (response.code == 0 ||
                                        response.error == false) {
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                      ShowMessage.success(
                                        context,
                                        response.message ??
                                            "Dispute raised successfully",
                                      );
                                    } else {
                                      ShowMessage.error(
                                        context,
                                        response.message ??
                                            "Failed to raise dispute",
                                      );
                                    }
                                  } catch (e) {
                                    log("Dispute error: $e");
                                  } finally {
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
                                ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
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
    final getP2pByIdState = ref.watch(getP2pByIdController(widget.id));

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
      body: getP2pByIdState.when(
        data: (response) {
          final buyData = response.data;
          final status = buyData?.status?.toString().toLowerCase() ?? "";

          Color statusColor;
          String statusText;

          switch (status.toLowerCase()) {
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
              statusText = "Complete"; // 👈 yahi change chahiye tha
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

            default:
              statusColor = Colors.white54;
              statusText = status;
          }

          if (buyData == null) {
            return const Center(
              child: Text(
                "No transaction data available",
                style: TextStyle(color: Colors.white70),
              ),
            );
          }

          final amount =
              double.tryParse(buyData.amount?.toString() ?? '0') ?? 0;
          final rate = double.tryParse(buyData.rate?.toString() ?? '0') ?? 0;
          final total = amount * rate;
          final proofImg = buyData.image; // ← most common location
          final methods = buyData.paymentMethods ?? [];

          final primaryPayment =
              (methods.isNotEmpty)
                  ? methods.firstWhere(
                    (m) => m.isPrimary == true,
                    orElse: () => methods[0],
                  )
                  : null;

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              children: [
                SizedBox(height: 10.h),

                // Buying Amount Card
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    vertical: 24.h,
                    horizontal: 10.w,
                  ),
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
                        "$amount ${buyData.walletType ?? ''}",
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
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Text(
                          statusText ?? "Requested",
                          style: TextStyle(
                            color: statusColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 11.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),

                // ORDER INFO
                _buildInfoSection(
                  title: "ORDER INFO",
                  icon: Icons.tag,
                  children: [
                    _buildInfoRow(
                      "ORDER ID",
                      buyData.orderId ?? "-",
                      isCopyable: true,
                    ),
                    _buildInfoRow("NAME", buyData.name ?? "N/A"),
                    _buildInfoRow("WALLET", buyData.walletType ?? "N/A"),
                    _buildInfoRow("UTR", buyData.hash ?? "N/A"),
                    _buildInfoRow(
                      "CREATED",
                      getFormattedDate(buyData.createdAt),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),

                // COUNTERPARTY
                _buildInfoSection(
                  title: "COUNTERPARTY",
                  icon: Icons.person_outline,
                  children: [
                    _buildInfoRow("NAME", buyData.counterParty!.name ?? "N/A"),
                    _buildInfoRow(
                      "EMAIL",
                      buyData.counterParty!.email ?? "N/A",
                    ),
                  ],
                ),
                SizedBox(height: 16.h),

                // PAYMENT METHODS
                // if (methods.isNotEmpty)
                //   _buildInfoSection(
                //     title: "PAYMENT METHODS",
                //     icon: Icons.account_balance_wallet_outlined,
                //     children:
                //         methods.map((m) {
                //           final isUpi =
                //               m.methodType?.toLowerCase().contains('upi') ??
                //               false;

                //           return Column(
                //             children: [
                //               const Divider(color: Colors.white10),
                //               _buildInfoRow("TYPE", m.methodType ?? "N/A"),
                //               if (isUpi)
                //                 _buildInfoRow(
                //                   "UPI ID",
                //                   m.details?.upiId ?? "N/A",
                //                   isCopyable: true,
                //                 )
                //               else ...[
                //                 _buildInfoRow(
                //                   "BANK",
                //                   m.details?.bankName ?? "N/A",
                //                 ),
                //                 _buildInfoRow(
                //                   "A/C NO",
                //                   m.details?.accountNumber ?? "N/A",
                //                   isCopyable: true,
                //                 ),
                //                 _buildInfoRow(
                //                   "IFSC",
                //                   m.details?.ifsc ?? "N/A",
                //                   isCopyable: true,
                //                 ),
                //               ],
                //             ],
                //           );
                //         }).toList(),
                //   ),
                // PAYMENT METHODS
                if (primaryPayment != null)
                  _buildInfoSection(
                    title: "PAYMENT METHOD",
                    icon: Icons.account_balance_wallet_outlined,
                    children: [
                      Builder(
                        builder: (_) {
                          final m = primaryPayment;

                          final isUpi =
                              m.methodType?.toLowerCase().contains('upi') ??
                              false;

                          return Column(
                            children: [
                              _buildInfoRow("TYPE", m.methodType ?? "N/A"),

                              if (isUpi) ...[
                                _buildInfoRow(
                                  "NAME",
                                  m.label ?? "N/A",
                                  isCopyable: true,
                                ),
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
                                _buildInfoRow(
                                  "BANK",
                                  m.details?.bankName ?? "N/A",
                                ),
                                _buildInfoRow(
                                  "A/C NO",
                                  m.details?.accountNumber ?? "N/A",
                                  isCopyable: true,
                                ),
                                _buildInfoRow(
                                  "IFSC",
                                  m.details?.ifsc ?? "N/A",
                                  isCopyable: true,
                                ),
                                _buildInfoRow(
                                  "BRANCH",
                                  m.details?.branchName ?? "N/A",
                                ),
                              ],
                            ],
                          );
                        },
                      ),
                    ],
                  ),

                SizedBox(height: 16.h),

                // PAYMENT PROOF
                Container(
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
                            if (proofImg != null && proofImg.isNotEmpty)
                              InkWell(
                                onTap:
                                    () =>
                                        _showFullScreenImage(context, proofImg),
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
                              (proofImg != null && proofImg.isNotEmpty)
                                  ? Image.network(
                                    proofImg,
                                    height: 180.h,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            _buildImagePlaceholder(),
                                  )
                                  : _buildImagePlaceholder(),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 100.h),
              ],
            ),
          );
        },
        error: (error, stackTrace) {
          log("Error loading P2P details: $error\n$stackTrace");
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                "Failed to load details\n$error",
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.redAccent),
              ),
            ),
          );
        },
        loading:
            () => const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
      ),
      bottomSheet: Container(
        color: const Color(0xFF0D1117),
        padding: EdgeInsets.all(16.w),
        child: _buildRaiseDisputeButton(context),
      ),
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

  void _showFullScreenImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder:
          (context) => Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: EdgeInsets.zero,
            child: Stack(
              alignment: Alignment.center,
              children: [
                InteractiveViewer(
                  minScale: 0.5,
                  maxScale: 5.0,
                  child:
                      imageUrl.isNotEmpty
                          ? Image.network(
                            imageUrl,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.contain,
                          )
                          : const Icon(
                            Icons.broken_image,
                            color: Colors.white,
                            size: 50,
                          ),
                ),
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

  Widget _buildRaiseDisputeButton(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _showDisputeBottomSheet(context),
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          width: double.infinity,
          height: 54.h,
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.redAccent.withOpacity(0.3)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.security, color: Colors.redAccent, size: 18.sp),
              SizedBox(width: 8.w),
              Text(
                "Raise Dispute",
                style: TextStyle(
                  color: Colors.redAccent,
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

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }
}
