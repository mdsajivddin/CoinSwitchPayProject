// import 'dart:ui';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart';
// // Apne controller ka sahi path dein
// import 'package:payment_app/data/controller/profileController.dart';

// class AssetDetailsPage extends ConsumerWidget {
//   const AssetDetailsPage({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final profileState = ref.watch(profileController);

//     return Scaffold(
//       backgroundColor: const Color(0xFF09111C),
//       body: Stack(
//         children: [
//           _buildBackgroundGlow(Alignment.topRight, const Color(0xFF06CE8F)),
//           _buildBackgroundGlow(Alignment.bottomLeft, const Color(0xFF3B82F6)),

//           profileState.when(
//             data: (data) {
//               final wallet = data.data?.wallet;

//               // Data extraction from your JSON structure
//               double inrBalance = (wallet?.balance ?? 0).toDouble();
//               double tokenBalance = (wallet?.tokens ?? 0).toDouble();
//               double frozen = (wallet?.freezeBalance ?? 0).toDouble();
//               double totalNetWorth =
//                   inrBalance +
//                   tokenBalance; // Adjust if token has different rate

//               return CustomScrollView(
//                 physics: const BouncingScrollPhysics(),
//                 slivers: [
//                   _buildAppBar(context),
//                   SliverToBoxAdapter(
//                     child: Padding(
//                       padding: EdgeInsets.all(20.w),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           _buildTotalAssetsHero(totalNetWorth),
//                           SizedBox(height: 30.h),
//                           _buildSectionLabel("ASSET BREAKDOWN"),
//                           SizedBox(height: 15.h),

//                           // INR Wallet Card
//                           _buildAssetItem(
//                             "Available INR",
//                             "Main Fiat Balance",
//                             "₹ ${inrBalance.toStringAsFixed(2)}",
//                             CupertinoIcons.money_rubl_circle,
//                             const Color(0xFF06CE8F),
//                           ),

//                           // Token Card
//                           _buildAssetItem(
//                             "My Tokens",
//                             "Platform Utility Tokens",
//                             "${tokenBalance.toStringAsFixed(0)} TKN",
//                             CupertinoIcons.bitcoin_circle,
//                             const Color(0xFF3B82F6),
//                           ),

//                           // Freeze Balance Card
//                           _buildAssetItem(
//                             "Frozen Assets",
//                             "Locked/Pending Amount",
//                             "₹ ${frozen.toStringAsFixed(2)}",
//                             CupertinoIcons.lock_shield,
//                             Colors.orangeAccent,
//                           ),

//                           // SizedBox(height: 30.h),
//                           // _buildSectionLabel("QUICK ACTIONS"),
//                           // SizedBox(height: 15.h),
//                           // _buildQuickActionsRow(),
//                           SizedBox(height: 30.h),
//                           _buildSectionLabel("ACCOUNT STATUS"),
//                           _buildInfoTile("Wallet ID", wallet?.id ?? "N/A"),
//                           _buildInfoTile(
//                             "Account Type",
//                             data.data?.user?.isKyc == true
//                                 ? "Verified Merchant"
//                                 : "Personal",
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               );
//             },
//             loading:
//                 () => const Center(
//                   child: CircularProgressIndicator(color: Color(0xFF06CE8F)),
//                 ),
//             error:
//                 (e, s) => Center(
//                   child: Text(
//                     "Error: $e",
//                     style: const TextStyle(color: Colors.white),
//                   ),
//                 ),
//           ),
//         ],
//       ),
//     );
//   }

//   // --- UI Components ---

//   Widget _buildTotalAssetsHero(double total) {
//     return Container(
//       width: double.infinity,
//       padding: EdgeInsets.symmetric(vertical: 30.h),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.03),
//         borderRadius: BorderRadius.circular(30.r),
//         border: Border.all(color: Colors.white.withOpacity(0.05)),
//       ),
//       child: Column(
//         children: [
//           Text(
//             "ESTIMATED NET WORTH",
//             style: GoogleFonts.poppins(
//               color: Colors.white54,
//               fontSize: 11.sp,
//               letterSpacing: 1.5,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           SizedBox(height: 10.h),
//           Text(
//             "₹ ${total.toStringAsFixed(2)}",
//             style: GoogleFonts.montserrat(
//               color: Colors.white,
//               fontSize: 36.sp,
//               fontWeight: FontWeight.w800,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildAssetItem(
//     String title,
//     String subtitle,
//     String value,
//     IconData icon,
//     Color color,
//   ) {
//     return Container(
//       margin: EdgeInsets.only(bottom: 15.h),
//       padding: EdgeInsets.all(18.r),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.04),
//         borderRadius: BorderRadius.circular(24.r),
//         border: Border.all(color: Colors.white.withOpacity(0.06)),
//       ),
//       child: Row(
//         children: [
//           Container(
//             padding: EdgeInsets.all(12.r),
//             decoration: BoxDecoration(
//               color: color.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(15.r),
//             ),
//             child: Icon(icon, color: color, size: 24.r),
//           ),
//           SizedBox(width: 15.w),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: GoogleFonts.poppins(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 14.sp,
//                   ),
//                 ),
//                 Text(
//                   subtitle,
//                   style: GoogleFonts.poppins(
//                     color: Colors.white38,
//                     fontSize: 11.sp,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Text(
//             value,
//             style: GoogleFonts.montserrat(
//               color: Colors.white,
//               fontWeight: FontWeight.w700,
//               fontSize: 15.sp,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildQuickActionsRow() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: [
//         _actionButton("Add Cash", Icons.add_to_photos_outlined),
//         _actionButton("Withdraw", Icons.file_upload_outlined),
//         _actionButton("Swap", Icons.swap_horizontal_circle_outlined),
//       ],
//     );
//   }

//   Widget _actionButton(String label, IconData icon) {
//     return Column(
//       children: [
//         Container(
//           height: 60.r,
//           width: 60.r,
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [
//                 const Color(0xFF06CE8F).withOpacity(0.2),
//                 Colors.transparent,
//               ],
//               begin: Alignment.topLeft,
//             ),
//             shape: BoxShape.circle,
//             border: Border.all(color: const Color(0xFF06CE8F).withOpacity(0.3)),
//           ),
//           child: Icon(icon, color: const Color(0xFF06CE8F), size: 24.r),
//         ),
//         SizedBox(height: 10.h),
//         Text(
//           label,
//           style: GoogleFonts.poppins(
//             color: Colors.white70,
//             fontSize: 11.sp,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildInfoTile(String label, String value) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 8.h),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             label,
//             style: GoogleFonts.poppins(color: Colors.white38, fontSize: 13.sp),
//           ),
//           Text(
//             value,
//             style: GoogleFonts.poppins(
//               color: Colors.white,
//               fontSize: 13.sp,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSectionLabel(String text) {
//     return Text(
//       text,
//       style: GoogleFonts.poppins(
//         fontSize: 11.sp,
//         fontWeight: FontWeight.w800,
//         color: const Color(0xFF06CE8F),
//         letterSpacing: 1.2,
//       ),
//     );
//   }

//   Widget _buildBackgroundGlow(Alignment alignment, Color color) {
//     return Align(
//       alignment: alignment,
//       child: Container(
//         height: 250.r,
//         width: 250.r,
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           color: color.withOpacity(0.06),
//         ),
//         child: BackdropFilter(
//           filter: ImageFilter.blur(sigmaX: 90, sigmaY: 90),
//           child: Container(),
//         ),
//       ),
//     );
//   }

//   Widget _buildAppBar(BuildContext context) {
//     return SliverAppBar(
//       pinned: true,
//       backgroundColor: const Color(0xFF09111C),
//       elevation: 0,
//       leading: IconButton(
//         icon: const Icon(Icons.arrow_back, color: Colors.white),
//         onPressed: () => Navigator.pop(context),
//       ),
//       title: Text(
//         "Portfolio Details",
//         style: GoogleFonts.poppins(
//           fontWeight: FontWeight.w600,
//           fontSize: 17.sp,
//           color: Colors.white,
//         ),
//       ),
//       centerTitle: true,
//     );
//   }
// }
