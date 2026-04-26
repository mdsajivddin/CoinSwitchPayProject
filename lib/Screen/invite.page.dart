import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';
import 'package:payment_app/config/utils/showMessage.dart';
import 'package:payment_app/data/controller/getRefralController.dart';
import 'package:payment_app/data/controller/profileController.dart';

class InvitePage extends ConsumerStatefulWidget {
  const InvitePage({super.key});

  @override
  ConsumerState<InvitePage> createState() => _InvitePageState();
}

class _InvitePageState extends ConsumerState<InvitePage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  // Exact Colors from your provided Image design
  final Color bgColor = const Color(0xFF09111C);
  final Color cardInnerBg = const Color(0xFF0D1C26).withOpacity(0.8);
  final Color accentColor = const Color(0xFF06CE8F);
  final Color fieldBg = const Color(0xFF0A141D);

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String appDownloadUrl = "https://coinswitchpay.com/coin-switch-pay.apk";

  void _shareReferral(String code, String link) {
    final String message = """
Welcome to COINSWITCHPAY 🚀
INDIA'S leading crypto exchange 💱

P2P trading | INR to Token trading
USDT sell via all payment methods:
UPI, IMPS, RTGS, CDM

🎁 Sign up with my code and get:
1000 Tokens + 10 USDT bonus on your first deposit!

Referral Commission: 1%

👉 Use my referral code: $code

🔗 Sign up / Registration:
$link

📲 Download the App:
$appDownloadUrl

🚀 Start trading now and earn rewards!
""";

    Share.share(message, subject: "Join CoinSwitchPay & Earn Rewards 🚀");
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileProvider);
    final getRefralState = ref.watch(referralChainProvider);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "My Referrals",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
          ),
        ),
        actions: [
          // "1 REFERRED" Badge from image
          getRefralState.when(
            data:
                (data) => _buildTopBadge(
                  "${data.message?.data?.length ?? 0} REFERRED",
                ),
            error: (_, __) => const SizedBox(),
            loading: () => _buildTopBadge("..."),
          ),
          SizedBox(width: 15.w),
        ],
      ),
      body: profileState.when(
        data: (profileData) {
          final user = profileData?.data?.user;
          final referralCode = user?.referralCode ?? "N/A";
          final referralLink = "https://coinswitchpay.com/refer/$referralCode";

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              children: [
                SizedBox(height: 10.h),

                /// --- TOP REFERRAL BOX (As per Image) ---
                Container(
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0D1C26), // Dark teal/blue shade
                    borderRadius: BorderRadius.circular(24.r),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8.w),
                            decoration: BoxDecoration(
                              color: accentColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Icon(
                              Icons.group_add_outlined,
                              color: accentColor,
                              size: 24.sp,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Your Referral",
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.sp,
                                ),
                              ),
                              Text(
                                "Share & earn together",
                                style: GoogleFonts.poppins(
                                  color: Colors.white54,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                      Text(
                        "Your Referral",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            "Earn ",
                            style: GoogleFonts.poppins(
                              color: Colors.white54,
                              fontSize: 12.sp,
                            ),
                          ),
                          Text(
                            "1% Commission",
                            style: GoogleFonts.poppins(
                              color: accentColor,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 15.h),
                      _buildCopyField("REFERRAL CODE", referralCode, false),
                      SizedBox(height: 15.h),
                      _buildCopyField("REFERRAL LINK", referralLink, true),

                      SizedBox(height: 20.h),

                      /// Share Referral Button
                      SizedBox(
                        width: double.infinity,
                        height: 50.h,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            _shareReferral(referralCode, referralLink);
                          },
                          icon: const Icon(
                            Icons.share_outlined,
                            color: Colors.black,
                          ),
                          label: Text(
                            "Share Referral",
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: accentColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14.r),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20.h),

                /// --- SEARCH BAR ---
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  decoration: BoxDecoration(
                    color: fieldBg,
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged:
                        (v) => setState(() => _searchQuery = v.toLowerCase()),
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      icon: const Icon(Icons.search, color: Colors.white54),
                      hintText: "Search by name, email or mobile...",
                      hintStyle: TextStyle(
                        color: Colors.white38,
                        fontSize: 14.sp,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),

                SizedBox(height: 20.h),

                /// --- REFERRAL LIST ---
                getRefralState.when(
                  data: (referdata) {
                    final list =
                        (referdata.message?.data ?? []).where((item) {
                          return (item.name?.toLowerCase() ?? "").contains(
                                _searchQuery,
                              ) ||
                              (item.mobile ?? "").contains(_searchQuery);
                        }).toList();

                    if (list.isEmpty) return _buildEmptyState();

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: list.length,
                      itemBuilder:
                          (context, index) => _buildUserCard(list[index]),
                    );
                  },
                  error:
                      (e, s) => Text(
                        "Error loading list",
                        style: TextStyle(color: Colors.red.shade300),
                      ),
                  loading: () => _buildShimmerEffect(),
                ),
                SizedBox(height: 30.h),
              ],
            ),
          );
        },
        error:
            (e, s) => const Center(
              child: Text(
                "Error fetching profile",
                style: TextStyle(color: Colors.white),
              ),
            ),
        loading:
            () => const Center(
              child: CircularProgressIndicator(color: Color(0xFF06CE8F)),
            ),
      ),
    );
  }

  Widget _buildTopBadge(String text) {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: accentColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: accentColor.withOpacity(0.3)),
        ),
        child: Text(
          text,
          style: GoogleFonts.poppins(
            color: accentColor,
            fontSize: 11.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildCopyField(String label, String value, bool isLink) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            color: Colors.white54,
            fontSize: 10.sp,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: fieldBg,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          child: Row(
            children: [
              if (isLink) Icon(Icons.link, color: Colors.white38, size: 18.sp),
              if (isLink) SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  value,
                  style: GoogleFonts.poppins(
                    color: isLink ? Colors.white38 : accentColor,
                    fontSize: isLink ? 13.sp : 20.sp,
                    fontWeight: isLink ? FontWeight.normal : FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: value));
                  ShowMessage.success(context, "Copied!");
                },
                child: Icon(Icons.copy, color: Colors.white54, size: 20.sp),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUserCard(dynamic item) {
    bool isActive = item.isDisable == false;
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1C26),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Container(
            height: 50.w,
            width: 50.w,
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.person_outline, color: accentColor),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      item.name ?? "User",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15.sp,
                      ),
                    ),
                    SizedBox(width: 5.w),
                    const Icon(
                      Icons.verified_user_outlined,
                      size: 14,
                      color: Colors.white38,
                    ),
                  ],
                ),
                Text(
                  item.mobile ?? "",
                  style: TextStyle(color: Colors.white54, fontSize: 12.sp),
                ),
                Text(
                  item.email ?? "",
                  style: TextStyle(color: Colors.white54, fontSize: 12.sp),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildTopBadge(item.referralCode ?? "N/A"),
              SizedBox(height: 8.h),

              Text(
                item.createdAt != null
                    ? DateTime.fromMillisecondsSinceEpoch(
                      item.createdAt!,
                    ).toString().split(' ')[0]
                    : "",
                style: TextStyle(color: Colors.white38, fontSize: 10.sp),
              ),
              SizedBox(height: 4.h),
              Text(
                isActive ? "Active" : "Inactive",
                style: TextStyle(
                  color: isActive ? accentColor : Colors.redAccent,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerEffect() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 3,
      itemBuilder:
          (context, index) => Shimmer.fromColors(
            baseColor: Colors.white10,
            highlightColor: Colors.white24,
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              height: 90.h,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(20.r),
              ),
            ),
          ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: EdgeInsets.only(top: 40.h),
      child: Text(
        "No referrals found",
        style: TextStyle(color: Colors.white38, fontSize: 14.sp),
      ),
    );
  }
}
