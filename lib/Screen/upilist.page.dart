// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:payment_app/Screen/addBankAccount,page.dart';
// import 'package:payment_app/Screen/addUpiAccount.page.dart';
// import 'package:payment_app/Screen/bankDetils.page.dart';
// import 'package:payment_app/config/auth/router/rightsliderFageRoute.dart';
// import 'package:payment_app/data/controller/deleteUpiController.dart';
// import 'package:payment_app/data/controller/getAllBankController.dart';
// import 'package:payment_app/data/controller/getUpiController.dart';
// import 'package:payment_app/data/controller/updateUpiStatusController.dart';
// import 'package:payment_app/data/model/getUpiModel.dart';

// class UpiListPage extends ConsumerStatefulWidget {
//   const UpiListPage({super.key});

//   @override
//   ConsumerState<UpiListPage> createState() => _UpiListPageState();
// }

// class _UpiListPageState extends ConsumerState<UpiListPage>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;

//   @override
//   void initState() {
//     super.initState();
//     // 2 Tabs: Bank Account aur UPI Account
//     _tabController = TabController(length: 2, vsync: this);
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF060E17),
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         foregroundColor: Colors.white,
//         title: Text(
//           "Manage Accounts",
//           style: GoogleFonts.plusJakartaSans(
//             color: Colors.white,
//             fontWeight: FontWeight.w700,
//             fontSize: 20.sp,
//           ),
//         ),
//         centerTitle: true,
//         bottom: TabBar(
//           controller: _tabController,
//           indicatorColor: const Color(0xFF06CE8F),
//           indicatorWeight: 3,
//           labelColor: const Color(0xFF06CE8F),
//           unselectedLabelColor: Colors.white54,
//           tabs: const [Tab(text: "Bank Account"), Tab(text: "UPI Account")],
//         ),
//       ),
//       body: TabBarView(
//         controller: _tabController,
//         children: [
//           // 1st Tab: Bank Accounts (Aap yahan apna Bank logic add kar sakte hain)
//           _buildBankListView(),
//           // 2nd Tab: UPI Accounts (Aapka existing Riverpod logic)
//           _upiListView(),
//         ],
//       ),
//     );
//   }

//   // ================= BANK LIST TAB =================
//   Widget _buildBankListView() {
//     final bankListProvider = ref.watch(getBankListProvider);
//     // ─── DUMMY DATA LIST ───
//     final List<Map<String, String>> dummyBanks = [
//       {
//         "bankName": "HDFC Bank Ltd",
//         "accountNumber": "XXXXXXXX5678",
//         "ifscCode": "HDFC0001234",
//       },
//       {
//         "bankName": "ICICI Bank",
//         "accountNumber": "XXXXXXXX1122",
//         "ifscCode": "ICIC0000543",
//       },
//       {
//         "bankName": "State Bank of India",
//         "accountNumber": "XXXXXXXX9900",
//         "ifscCode": "SBIN0004321",
//       },
//     ];

//     return Column(
//       children: [
//         Expanded(
//           child: bankListProvider.when(
//             data: (data) {
//               return data.data!.isEmpty
//                   ? Center(
//                     child: Text(
//                       "No Bank Details Found!",
//                       style: GoogleFonts.plusJakartaSans(
//                         color: Colors.white54,
//                         fontSize: 16.sp,
//                       ),
//                     ),
//                   )
//                   : ListView.builder(
//                     padding: EdgeInsets.symmetric(
//                       horizontal: 20.w,
//                       vertical: 10.h,
//                     ),
//                     itemCount: data.data!.length,
//                     itemBuilder: (context, index) {
//                       final bank = data.data![index];
//                       // Aapka Updated BankCard Design yahan call hoga
//                       return InkWell(
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             RightSlideFadeRoute(
//                               page: BankDetilsPage(
//                                 bankAccount: bank.accountNumber.toString(),
//                                 bankID: bank.id.toString(),
//                                 bankName: bank.bankName.toString(),
//                                 brantchName: bank.branchName.toString(),
//                                 holderName: bank.accountHolderName.toString(),
//                                 ifscOde: bank.ifscCode.toString(),
//                                 isDisable: bank.isDisable ?? false,
//                               ),
//                             ),
//                           );
//                         },
//                         child: Container(
//                           margin: EdgeInsets.only(bottom: 15.h),
//                           padding: EdgeInsets.all(16.w),
//                           decoration: BoxDecoration(
//                             color: const Color(0xFF1C2633),
//                             borderRadius: BorderRadius.circular(20.r),
//                             border: Border.all(
//                               color: Colors.white.withOpacity(0.05),
//                             ),
//                           ),
//                           child: Row(
//                             children: [
//                               Container(
//                                 height: 48.h,
//                                 width: 48.w,
//                                 decoration: BoxDecoration(
//                                   color: const Color(
//                                     0xFF06CE8F,
//                                   ).withOpacity(0.1),
//                                   borderRadius: BorderRadius.circular(12.r),
//                                 ),
//                                 child: const Icon(
//                                   CupertinoIcons.building_2_fill,
//                                   color: Color(0xFF06CE8F),
//                                 ),
//                               ),
//                               SizedBox(width: 14.w),
//                               Expanded(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       bank.bankName ?? "",
//                                       style: GoogleFonts.plusJakartaSans(
//                                         color: Colors.white,
//                                         fontWeight: FontWeight.w600,
//                                         fontSize: 15.sp,
//                                       ),
//                                     ),
//                                     SizedBox(height: 4.h),
//                                     Text(
//                                       "${bank.accountNumber}  •  ${bank.ifscCode}",
//                                       style: GoogleFonts.plusJakartaSans(
//                                         color: Colors.white54,
//                                         fontSize: 12.sp,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               Icon(
//                                 CupertinoIcons.chevron_right,
//                                 color: Colors.white24,
//                                 size: 16.sp,
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   );
//             },
//             error: (error, stackTrace) {
//               return Center(
//                 child: Text(
//                   error.toString(),
//                   style: TextStyle(color: Colors.white),
//                 ),
//               );
//             },
//             loading:
//                 () => Center(
//                   child: CircularProgressIndicator(color: Colors.white),
//                 ),
//           ),
//         ),
//         Padding(
//           padding: EdgeInsets.only(bottom: 20.h),
//           child: _buildAddButton(isBank: true),
//         ),
//       ],
//     );
//   }

//   // ================= UPI LIST TAB (Original Logic) =================
//   Widget _upiListView() {
//     final upiProvider = ref.watch(getUpiController);
//     return Column(
//       children: [
//         Expanded(
//           child: upiProvider.when(
//             data: (snp) {
//               if (snp.data == null || snp.data!.isEmpty) {
//                 return _buildEmptyState(context);
//               }
//               return ListView.builder(
//                 padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
//                 itemCount: snp.data!.length,
//                 physics: const BouncingScrollPhysics(),
//                 itemBuilder: (context, index) {
//                   final upi = snp.data![index];
//                   return _upiCard(data: upi);
//                 },
//               );
//             },
//             error:
//                 (error, stackTrace) => Center(
//                   child: Text(
//                     "Error: $error",
//                     style: const TextStyle(color: Colors.white),
//                   ),
//                 ),
//             loading:
//                 () => const Center(
//                   child: CircularProgressIndicator(color: Color(0xFF06CE8F)),
//                 ),
//           ),
//         ),
//         _buildAddButton(isBank: false),
//       ],
//     );
//   }

//   Widget _buildEmptyState(BuildContext context) {
//     return Center(
//       child: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 40.w),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               height: 100.h,
//               width: 100.h,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: const Color(0xFF06CE8F).withOpacity(0.05),
//                 border: Border.all(
//                   color: const Color(0xFF06CE8F).withOpacity(0.1),
//                   width: 2,
//                 ),
//               ),
//               child: Icon(
//                 Icons.account_balance_wallet_rounded,
//                 color: const Color(0xFF06CE8F),
//                 size: 40.sp,
//               ),
//             ),
//             SizedBox(height: 24.h),
//             Text(
//               "No UPI Accounts Yet",
//               style: GoogleFonts.plusJakartaSans(
//                 color: Colors.white,
//                 fontSize: 18.sp,
//                 fontWeight: FontWeight.w800,
//               ),
//             ),
//             SizedBox(height: 12.h),
//             Text(
//               "Link your UPI ID to enjoy seamless payments.",
//               textAlign: TextAlign.center,
//               style: TextStyle(color: Colors.white54, fontSize: 13.sp),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _upiCard({required Datum data}) {
//     final deleteState = ref.watch(deleteUpiProvider);
//     final bool isDeleting = deleteState.deletingId == data.id;
//     final bool isDisabled = data.isDisable ?? false;
//     final String upi = data.upi ?? "";
//     final String name =
//         data.name ?? "User Name"; // <-- Yahan Name field add kiya
//     final String id = data.id.toString();

//     return Container(
//       margin: EdgeInsets.only(bottom: 18.h),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(24.r),
//         color: isDisabled ? const Color(0xFF131B26) : const Color(0xFF1C2633),
//         border: Border.all(
//           color:
//               isDisabled
//                   ? Colors.white.withOpacity(0.03)
//                   : Colors.white.withOpacity(0.08),
//         ),
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(24.r),
//         child: Column(
//           children: [
//             Padding(
//               padding: EdgeInsets.all(18.w),
//               child: Row(
//                 children: [
//                   Container(
//                     padding: EdgeInsets.all(12.w),
//                     decoration: const BoxDecoration(
//                       color: Colors.black26,
//                       shape: BoxShape.circle,
//                     ),
//                     child: Icon(
//                       Icons.qr_code_2_rounded,
//                       color: isDisabled ? Colors.grey : const Color(0xFF06CE8F),
//                       size: 24.sp,
//                     ),
//                   ),
//                   SizedBox(width: 16.w),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // --- Account Holder Name Added Here ---
//                         Text(
//                           name.toUpperCase(),
//                           style: GoogleFonts.plusJakartaSans(
//                             color:
//                                 isDisabled
//                                     ? Colors.grey
//                                     : const Color(0xFF06CE8F),
//                             fontWeight: FontWeight.w800,
//                             fontSize: 11.sp,
//                             letterSpacing: 0.5,
//                           ),
//                         ),
//                         SizedBox(height: 2.h),
//                         Text(
//                           upi,
//                           style: GoogleFonts.plusJakartaSans(
//                             color: isDisabled ? Colors.grey : Colors.white,
//                             fontWeight: FontWeight.w700,
//                             fontSize: 15.sp,
//                           ),
//                         ),
//                         SizedBox(height: 4.h),
//                         Text(
//                           isDisabled ? "INACTIVE" : "ACTIVE",
//                           style: TextStyle(
//                             color:
//                                 isDisabled
//                                     ? Colors.grey
//                                     : const Color(0xFF06CE8F),
//                             fontSize: 10.sp,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Transform.scale(
//                     scale: 0.8,
//                     child: CupertinoSwitch(
//                       value: !isDisabled,
//                       activeColor: const Color(0xFF06CE8F),
//                       onChanged:
//                           (val) =>
//                               _showStatusDialog(context, isDisabled, upi, id),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             if (!isDisabled) ...[
//               Divider(color: Colors.white.withOpacity(0.05), height: 1),
//               InkWell(
//                 onTap:
//                     isDeleting
//                         ? null
//                         : () => ref
//                             .read(deleteUpiProvider.notifier)
//                             .deleteUpi(context: context, id: id),
//                 child: Container(
//                   padding: EdgeInsets.symmetric(vertical: 12.h),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       if (isDeleting)
//                         const SizedBox(
//                           height: 16,
//                           width: 16,
//                           child: CircularProgressIndicator(strokeWidth: 2),
//                         )
//                       else
//                         Icon(
//                           Icons.delete_outline,
//                           color: Colors.redAccent.withOpacity(0.7),
//                           size: 18.sp,
//                         ),
//                       SizedBox(width: 8.w),
//                       Text(
//                         "Remove Account",
//                         style: TextStyle(
//                           color: Colors.redAccent.withOpacity(0.7),
//                           fontSize: 13.sp,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }

//   // Dynamic Add Button (Bank aur UPI ke liye alag text/navigation)
//   Widget _buildAddButton({required bool isBank}) {
//     return Padding(
//       padding: EdgeInsets.fromLTRB(24.w, 10.h, 24.w, 30.h),
//       child: InkWell(
//         onTap: () {
//           if (isBank) {
//             Navigator.push(
//               context,
//               RightSlideFadeRoute(page: const AddBankAccountPage()),
//             );
//           } else {
//             Navigator.push(
//               context,
//               RightSlideFadeRoute(page: const AddUpiAccountPage()),
//             );
//           }
//         },
//         borderRadius: BorderRadius.circular(18.r),
//         child: Container(
//           width: double.infinity,
//           height: 56.h,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(18.r),
//             gradient: const LinearGradient(
//               colors: [Color(0xFF06CE8F), Color(0xFF00A370)],
//             ),
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Icon(Icons.add_circle_outline, color: Colors.black),
//               SizedBox(width: 10.w),
//               Text(
//                 isBank ? "Add Bank Account" : "Add New UPI Account",
//                 style: GoogleFonts.plusJakartaSans(
//                   color: Colors.black,
//                   fontSize: 15.sp,
//                   fontWeight: FontWeight.w700,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void _showStatusDialog(
//     BuildContext context,
//     bool currentIsDisabled,
//     String upi,
//     String id,
//   ) {
//     final bool isEnablingAction = currentIsDisabled;
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       builder:
//           (context) => Consumer(
//             builder: (context, ref, child) {
//               final updateState = ref.watch(updateUpiStatusProvider);
//               final bool isLoading = updateState is AsyncLoading;
//               return Container(
//                 padding: const EdgeInsets.fromLTRB(24, 20, 24, 30),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFF131B26),
//                   borderRadius: BorderRadius.vertical(
//                     top: Radius.circular(30.r),
//                   ),
//                 ),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Text(
//                       isEnablingAction ? "Enable UPI ID?" : "Disable UPI ID?",
//                       style: GoogleFonts.plusJakartaSans(
//                         fontSize: 18.sp,
//                         fontWeight: FontWeight.w700,
//                         color: Colors.white,
//                       ),
//                     ),
//                     const SizedBox(height: 24),
//                     Row(
//                       children: [
//                         Expanded(
//                           child: OutlinedButton(
//                             onPressed: () => Navigator.pop(context),
//                             child: const Text(
//                               "Cancel",
//                               style: TextStyle(color: Colors.white),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 12),
//                         Expanded(
//                           child: ElevatedButton(
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor:
//                                   isEnablingAction
//                                       ? const Color(0xFF06CE8F)
//                                       : Colors.redAccent,
//                             ),
//                             onPressed:
//                                 isLoading
//                                     ? null
//                                     : () async {
//                                       await ref
//                                           .read(
//                                             updateUpiStatusProvider.notifier,
//                                           )
//                                           .updateUpiStatus(
//                                             context: context,
//                                             upiId: id,
//                                             isDisable: !currentIsDisabled,
//                                           );
//                                     },
//                             child:
//                                 isLoading
//                                     ? const CircularProgressIndicator()
//                                     : Text(
//                                       isEnablingAction ? "Enable" : "Disable",
//                                       style: const TextStyle(
//                                         color: Colors.black,
//                                       ),
//                                     ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               );
//             },
//           ),
//     );
//   }
// }

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:payment_app/Screen/addBankAccount,page.dart';
import 'package:payment_app/Screen/addUpiAccount.page.dart';
import 'package:payment_app/Screen/bankDetils.page.dart';
import 'package:payment_app/config/auth/router/rightsliderFageRoute.dart';
import 'package:payment_app/data/controller/deleteUpiController.dart';
import 'package:payment_app/data/controller/getAllBankController.dart';
import 'package:payment_app/data/controller/getUpiController.dart';
import 'package:payment_app/data/controller/updateUpiStatusController.dart';
import 'package:payment_app/data/model/getUpiModel.dart';

class UpiListPage extends ConsumerStatefulWidget {
  const UpiListPage({super.key});

  @override
  ConsumerState<UpiListPage> createState() => _UpiListPageState();
}

class _UpiListPageState extends ConsumerState<UpiListPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF09111C), // Add Bank jaisa background
      body: Stack(
        children: [
          // Background Gradient matching Add Bank Page
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
            child: Column(
              children: [
                _buildHeader(context),
                _buildTabBar(),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [_buildBankListView(), _upiListView()],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
          ),
          const Spacer(),
          Text(
            "Manage Accounts",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 18.sp,
            ),
          ),
          const Spacer(),
          SizedBox(width: 40.w),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return TabBar(
      controller: _tabController,
      indicatorColor: const Color(0xFF06CE8F),
      indicatorWeight: 3,
      labelColor: const Color(0xFF06CE8F),
      unselectedLabelColor: Colors.white.withOpacity(0.4),
      labelStyle: GoogleFonts.poppins(
        fontWeight: FontWeight.w600,
        fontSize: 14.sp,
      ),
      tabs: const [Tab(text: "Bank Account"), Tab(text: "UPI Account")],
    );
  }

  // ================= BANK LIST TAB =================
  Widget _buildBankListView() {
    final bankListProvider = ref.watch(getBankListProvider);
    return Column(
      children: [
        Expanded(
          child: bankListProvider.when(
            data: (data) {
              return data.data!.isEmpty
                  ? Center(
                    child: Text(
                      "No Bank Details Found!",
                      style: GoogleFonts.poppins(
                        color: Colors.white54,
                        fontSize: 16.sp,
                      ),
                    ),
                  )
                  : ListView.builder(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 20.h,
                    ),
                    itemCount: data.data!.length,
                    itemBuilder: (context, index) {
                      final bank = data.data![index];
                      return _buildCommonCard(
                        onTap: () {
                          Navigator.push(
                            context,
                            RightSlideFadeRoute(
                              page: BankDetilsPage(
                                bankAccount: bank.accountNumber.toString(),
                                bankID: bank.id.toString(),
                                bankName: bank.bankName.toString(),
                                brantchName: bank.branchName.toString(),
                                holderName: bank.accountHolderName.toString(),
                                ifscOde: bank.ifscCode.toString(),
                                isDisable: bank.isDisable ?? false,
                              ),
                            ),
                          );
                        },
                        icon: CupertinoIcons.building_2_fill,
                        title: bank.bankName ?? "",
                        subtitle: "${bank.accountNumber}  •  ${bank.ifscCode}",
                        isDisable: bank.isDisable ?? false,
                      );
                    },
                  );
            },
            error:
                (error, stack) => Center(
                  child: Text(
                    error.toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
            loading:
                () => const Center(
                  child: CircularProgressIndicator(color: Color(0xFF06CE8F)),
                ),
          ),
        ),
        _buildAddButton(isBank: true),
      ],
    );
  }

  // ================= UPI LIST TAB =================
  Widget _upiListView() {
    final upiProvider = ref.watch(getUpiController);
    return Column(
      children: [
        Expanded(
          child: upiProvider.when(
            data: (snp) {
              if (snp.data == null || snp.data!.isEmpty)
                return _buildEmptyState();
              return ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                itemCount: snp.data!.length,
                itemBuilder:
                    (context, index) => _upiCard(data: snp.data![index]),
              );
            },
            error:
                (error, stack) => Center(
                  child: Text(
                    "Error: $error",
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
            loading:
                () => const Center(
                  child: CircularProgressIndicator(color: Color(0xFF06CE8F)),
                ),
          ),
        ),
        _buildAddButton(isBank: false),
      ],
    );
  }

  Widget _buildCommonCard({
    required VoidCallback onTap,
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isDisable,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 15.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(
            0.05,
          ), // Add Bank page ke input field jaisa color
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: Colors.white.withOpacity(0.08)),
        ),
        child: Row(
          children: [
            Container(
              height: 48.h,
              width: 48.w,
              decoration: BoxDecoration(
                color: const Color(0xFF06CE8F).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(icon, color: const Color(0xFF06CE8F)),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 15.sp,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      color: Colors.white54,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              CupertinoIcons.chevron_right,
              color: Colors.white24,
              size: 16.sp,
            ),
          ],
        ),
      ),
    );
  }

  Widget _upiCard({required Datum data}) {
    final deleteState = ref.watch(deleteUpiProvider);
    final bool isDeleting = deleteState.deletingId == data.id;
    final bool isDisabled = data.isDisable ?? false;

    return Container(
      margin: EdgeInsets.only(bottom: 18.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),
        color: Colors.white.withOpacity(0.05), // Add Bank Page style
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(18.w),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: const BoxDecoration(
                    color: Colors.black26,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.qr_code_2_rounded,
                    color: isDisabled ? Colors.grey : const Color(0xFF06CE8F),
                    size: 24.sp,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        (data.name ?? "User Name").toUpperCase(),
                        style: GoogleFonts.poppins(
                          color:
                              isDisabled
                                  ? Colors.grey
                                  : const Color(0xFF06CE8F),
                          fontWeight: FontWeight.w800,
                          fontSize: 11.sp,
                          letterSpacing: 0.5,
                        ),
                      ),
                      Text(
                        data.upi ?? "",
                        style: GoogleFonts.poppins(
                          color: isDisabled ? Colors.grey : Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 15.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                Transform.scale(
                  scale: 0.8,
                  child: CupertinoSwitch(
                    value: !isDisabled,
                    activeColor: const Color(0xFF06CE8F),
                    onChanged:
                        (val) => _showStatusDialog(
                          context,
                          isDisabled,
                          data.upi ?? "",
                          data.id.toString(),
                        ),
                  ),
                ),
              ],
            ),
          ),
          if (!isDisabled) ...[
            Divider(color: Colors.white.withOpacity(0.05), height: 1),
            InkWell(
              onTap:
                  isDeleting
                      ? null
                      : () => ref
                          .read(deleteUpiProvider.notifier)
                          .deleteUpi(context: context, id: data.id.toString()),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (isDeleting)
                      const SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    else
                      Icon(
                        Icons.delete_outline,
                        color: Colors.redAccent.withOpacity(0.7),
                        size: 18.sp,
                      ),
                    SizedBox(width: 8.w),
                    Text(
                      "Remove Account",
                      style: GoogleFonts.poppins(
                        color: Colors.redAccent.withOpacity(0.7),
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAddButton({required bool isBank}) {
    return Padding(
      padding: EdgeInsets.fromLTRB(24.w, 10.h, 24.w, 30.h),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            RightSlideFadeRoute(
              page:
                  isBank
                      ? const AddBankAccountPage()
                      : const AddUpiAccountPage(),
            ),
          );
        },
        borderRadius: BorderRadius.circular(18.r),
        child: Container(
          width: double.infinity,
          height: 56.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18.r),
            gradient: const LinearGradient(
              colors: [Color(0xFF06CE8F), Color(0xFF00A370)],
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.add_circle_outline, color: Colors.black),
              SizedBox(width: 10.w),
              Text(
                isBank ? "Add Bank Account" : "Add New UPI Account",
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.account_balance_wallet_rounded,
            color: const Color(0xFF06CE8F),
            size: 40.sp,
          ),
          SizedBox(height: 16.h),
          Text(
            "No UPI Accounts Yet",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  void _showStatusDialog(
    BuildContext context,
    bool currentIsDisabled,
    String upi,
    String id,
  ) {
    final bool isEnablingAction = currentIsDisabled;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Consumer(
            builder: (context, ref, child) {
              final updateState = ref.watch(updateUpiStatusProvider);
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
                      isEnablingAction ? "Enable UPI ID?" : "Disable UPI ID?",
                      style: GoogleFonts.poppins(
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
                                            updateUpiStatusProvider.notifier,
                                          )
                                          .updateUpiStatus(
                                            context: context,
                                            upiId: id,
                                            isDisable: !currentIsDisabled,
                                          );
                                    },
                            child:
                                isLoading
                                    ? const CircularProgressIndicator()
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
