import 'dart:async';
import 'dart:developer';
import 'dart:ui';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:payment_app/Screen/deposit.page.dart';
import 'package:payment_app/Screen/drawerPage.dart';
import 'package:payment_app/Screen/notification.page.dart';
import 'package:payment_app/Screen/p2p.page.dart';
import 'package:payment_app/Screen/suport.page.dart';
import 'package:payment_app/Screen/wallet.page.dart';
import 'package:payment_app/Screen/sell.page.dart';
import 'package:payment_app/config/auth/router/rightsliderFageRoute.dart';
import 'package:payment_app/data/controller/getBannerController.dart';
import 'package:payment_app/data/controller/getFoundController.dart';
import 'package:payment_app/data/controller/profileController.dart';
import 'package:payment_app/data/controller/updateProfileController.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:shimmer/shimmer.dart';

class HomeBottomNav extends StatefulWidget {
  final int initialIndex;
  const HomeBottomNav({super.key, this.initialIndex = 0});

  @override
  State<HomeBottomNav> createState() => _HomeBottomNavState();
}

class _HomeBottomNavState extends State<HomeBottomNav> {
  // int _currentIndex = 0;
  late int _currentIndex;

  final List<Widget> _screens = const [
    HomePage(),
    P2pPage(),
    DepositPage(),
    SellPage(),
    WalletPage(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: const Color(0xFF070B11),
      body: _screens[_currentIndex],
      bottomNavigationBar: _buildPremiumNavBar(),
    );
  }

  Widget _buildPremiumNavBar() {
    return Container(
      height: 80.h,
      margin: EdgeInsets.fromLTRB(14.w, 0, 14.w, 14.h),
      decoration: BoxDecoration(
        color: const Color(0xFF131B27).withOpacity(0.94),
        borderRadius: BorderRadius.circular(26.r),
        border: Border.all(color: Colors.white.withOpacity(0.07), width: 0.8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.38),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedItemColor: const Color(0xFF06CE8F),
            unselectedItemColor: const Color(0xFF5A6677),
            selectedFontSize: 11.sp,
            unselectedFontSize: 11.sp,
            iconSize: 24.sp,
            selectedLabelStyle: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              height: 1.0,
            ),
            unselectedLabelStyle: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
              height: 1.0,
            ),
            onTap: (index) => setState(() => _currentIndex = index),
            items: [
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.house_fill),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.swap_horiz_outlined),
                label: 'P2P',
              ),
              // BottomNavigationBarItem(
              //   icon: Icon(CupertinoIcons.plus_circle_fill),
              //   label: 'Deposit',
              // ),
              BottomNavigationBarItem(
                icon: _buildDepositIcon(false),
                activeIcon: _buildDepositIcon(true),
                label: 'Deposit',
              ),

              BottomNavigationBarItem(
                icon: Icon(Icons.trending_up_outlined),
                label: 'Sell',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.wallet_outlined),
                label: 'Wallet',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDepositIcon(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: EdgeInsets.all(isActive ? 4 : 2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [Color(0xFF06CE8F), Color(0xFF05B47A)],
        ),
        boxShadow: [
          if (isActive)
            BoxShadow(
              color: const Color(0xFF06CE8F).withOpacity(0.6),
              blurRadius: 12,
              spreadRadius: 2,
            ),
        ],
      ),
      child: Icon(CupertinoIcons.plus, color: Colors.white, size: 20.sp),
    );
  }
}

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _topCurrentIndex = 0;
  int _bottomCurrentIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    Future.microtask(() {
      ref.refresh(profileProvider);
      ref.refresh(getFoundProvider);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var box = Hive.box("userdata");
    final bannerAsyncTop = ref.watch(bannerTopProvider);
    final bannerAsyncBottom = ref.watch(bannerBottomProvider);
    final getFoundState = ref.watch(getFoundProvider);
    final profileState = ref.watch(profileProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF09111C),
      drawer: Drawer(
        width: MediaQuery.of(context).size.width,
        child: const DrawerPage(),
      ),
      body: Stack(
        children: [
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
              child: Column(
                children: [
                  SizedBox(height: 20.h),
                  _buildHeader(),
                  SizedBox(height: 30.h),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        ref.read(profileProvider.notifier).getProfileData();
                        ref.read(bannerTopProvider.notifier).getBannersTop();
                        ref
                            .read(bannerBottomProvider.notifier)
                            .getBannersBottom();
                        ref.read(getFoundProvider.notifier).getFoundTransfer();
                      },
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Column(
                          children: [
                            bannerAsyncTop.when(
                              data:
                                  (bannerData) => _buildBannerSlider(
                                    bannerData,
                                    isTop: true,
                                  ),
                              error: (e, s) => _buildErrorWidget(e.toString()),
                              loading: () => _buildBannerShimmer(),
                            ),

                            SizedBox(height: 25.h),

                            /// 🔹 Balance Cards (Shimmer logic could be added if these were async)
                            profileState.when(
                              data: (data) {
                                final totalWithdraw =
                                    data?.data?.stats?.todayWithdraw ?? 0.0;
                                final remainBalance =
                                    data?.data?.stats?.remainBalance ?? 0.0;

                                final usdt = data?.data?.wallet?.usdt ?? 0.0;
                                final token = data?.data?.wallet?.token ?? 0.0;

                                final total = usdt + token;
                                return Row(
                                  children: [
                                    Expanded(
                                      child: balanceCard(
                                        "REMAINING BALANCE",
                                        "₹ ${remainBalance.toStringAsFixed(2)}",
                                      ),
                                    ),
                                    SizedBox(width: 12.w),
                                    Expanded(
                                      child: balanceCard(
                                        "TODAY'S WITHDRAW",
                                        "₹ ${totalWithdraw.toStringAsFixed(1)}",
                                      ),
                                    ),
                                  ],
                                );
                              },
                              error:
                                  (e, s) => Text(
                                    e.toString(),
                                    style: TextStyle(color: Colors.yellow),
                                  ),
                              loading: () => _buildBannerShimmer(),
                            ),

                            SizedBox(height: 30.h),

                            /// 🔹 Fund Transfer with Shimmer
                            getFoundState.when(
                              // data: (data) {
                              //   final upi = data?.data?.upi ?? 0;
                              //   final imps = data?.data?.imps ?? 0;
                              //   final cdm = data?.data?.cdm ?? 0;
                              //   final rtgs = data?.data?.rtgs ?? 0;
                              //   return Container(
                              //     padding: EdgeInsets.symmetric(
                              //       vertical: 20.h,
                              //       horizontal: 10.w,
                              //     ),
                              //     decoration: BoxDecoration(
                              //       color: Colors.white.withOpacity(0.05),
                              //       borderRadius: BorderRadius.circular(22.r),
                              //       border: Border.all(
                              //         color: Colors.white.withOpacity(0.08),
                              //       ),
                              //     ),
                              //     child: Column(
                              //       crossAxisAlignment:
                              //           CrossAxisAlignment.start,
                              //       children: [
                              //         Text(
                              //           "Fund Transfer Options",
                              //           style: GoogleFonts.poppins(
                              //             color: Colors.white,
                              //             fontSize: 14.sp,
                              //             fontWeight: FontWeight.w600,
                              //           ),
                              //         ),
                              //         Divider(
                              //           color: Colors.white10,
                              //           thickness: 1.h,
                              //         ),
                              //         SizedBox(height: 10.h),
                              //         transferTile(
                              //           "assets/upi.png",
                              //           "UPI",
                              //           "Unified Payment Interface",
                              //           "${data!.data?.upi ?? ""} INR",
                              //           "20 minutes to 1 hour",
                              //         ),
                              //         Divider(
                              //           color: Colors.white10,
                              //           thickness: 1.h,
                              //         ),
                              //         transferTile(
                              //           "assets/imps.png",
                              //           "IMPS",
                              //           "Immediate payment Service",
                              //           "${data.data?.imps ?? 0} INR",
                              //           "30 minutes to 1 hour",
                              //         ),
                              //         Divider(
                              //           color: Colors.white10,
                              //           thickness: 1.h,
                              //         ),
                              //         transferTile(
                              //           "assets/cdm.jpeg",
                              //           "CDM",
                              //           "Cash Deposite Machine",
                              //           "${data.data?.cdm ?? 0} INR",
                              //           "1 hour to 2 hour",
                              //         ),
                              //         Divider(
                              //           color: Colors.white10,
                              //           thickness: 1.h,
                              //         ),
                              //         transferTile(
                              //           "assets/rtgs.png",
                              //           "RTGS",
                              //           "Real Time Gross Settement",
                              //           "${data.data?.rtgs ?? 0} INR",
                              //           "10 minutes to 30 minutes",
                              //         ),
                              //       ],
                              //     ),
                              //   );
                              // },
                              data: (data) {
                                num parseAmount(dynamic value) {
                                  if (value == null) return 0;

                                  if (value is num) return value;

                                  if (value is String) {
                                    return num.tryParse(value) ?? 0;
                                  }

                                  return 0;
                                }

                                final upi = parseAmount(data?.data?.upi);
                                final imps = parseAmount(data?.data?.imps);
                                final cdm = parseAmount(data?.data?.cdm);
                                final rtgs = parseAmount(data?.data?.rtgs);

                                if (upi <= 0 &&
                                    imps <= 0 &&
                                    cdm <= 0 &&
                                    rtgs <= 0) {
                                  return Center(
                                    child: Text(
                                      "No transfer options available",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  );
                                }

                                return Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 20.h,
                                    horizontal: 10.w,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.05),
                                    borderRadius: BorderRadius.circular(22.r),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.08),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Fund Transfer Options",
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Divider(color: Colors.white10),

                                      if (upi > 0) ...[
                                        SizedBox(height: 10.h),
                                        transferTile(
                                          "assets/upi.png",
                                          "UPI",
                                          "Unified Payment Interface",
                                          "$upi INR",
                                          "20 minutes to 1 hour",
                                        ),
                                        Divider(color: Colors.white10),
                                      ],

                                      if (imps > 0) ...[
                                        transferTile(
                                          "assets/imps.png",
                                          "IMPS",
                                          "Immediate payment Service",
                                          "$imps INR",
                                          "30 minutes to 1 hour",
                                        ),
                                        Divider(color: Colors.white10),
                                      ],

                                      if (cdm > 0) ...[
                                        transferTile(
                                          "assets/cdm.jpeg",
                                          "CDM",
                                          "Cash Deposit Machine",
                                          "$cdm INR",
                                          "1 hour to 2 hour",
                                        ),
                                        Divider(color: Colors.white10),
                                      ],

                                      if (rtgs > 0) ...[
                                        transferTile(
                                          "assets/rtgs.png",
                                          "RTGS",
                                          "Real Time Gross Settlement",
                                          "$rtgs INR",
                                          "10 minutes to 30 minutes",
                                        ),
                                      ],
                                    ],
                                  ),
                                );
                              },
                              error: (e, s) {
                                log(s.toString());
                                return Text(
                                  e.toString(),
                                  style: TextStyle(color: Colors.white),
                                );
                              },
                              loading: () => _buildTransferShimmer(),
                            ),

                            SizedBox(height: 25.h),

                            bannerAsyncBottom.when(
                              data:
                                  (bannerData) => _buildBannerSlider(
                                    bannerData,
                                    isTop: false,
                                  ),
                              error:
                                  (e, s) => Text(
                                    e.toString(),
                                    style: TextStyle(color: Colors.white),
                                  ),
                              loading: () => _buildBannerShimmer(),
                            ),
                            SizedBox(height: 40.h),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildHeader() {
    final box = ref.watch(userBoxProvider);
    final imageUrl = box.get("image");
    final name = box.get("name") ?? "User";

    final profileState = ref.watch(profileProvider);

    return profileState.when(
      data: (data) {
        final apiImage = data?.data?.user?.image;

        final finalImage =
            (apiImage != null && apiImage.isNotEmpty) ? apiImage : imageUrl;
        final count = data?.data?.notificationCount ?? 0;

        return Row(
          children: [
            /// Profile Avatar
            Builder(
              builder: (context) {
                return InkWell(
                  onTap: () => Scaffold.of(context).openDrawer(),
                  child: Row(
                    children: [
                      Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
                      CircleAvatar(
                        radius: 22.r,
                        backgroundColor: Colors.grey.shade200,
                        backgroundImage:
                            finalImage != null && finalImage.isNotEmpty
                                ? NetworkImage(finalImage)
                                : null,
                        child:
                            finalImage == null || finalImage.isEmpty
                                ? Text(
                                  name[0].toUpperCase(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                )
                                : null,
                      ),
                    ],
                  ),
                );
              },
            ),

            SizedBox(width: 12.w),

            /// User Name
            Text(
              // name,
              data!.data!.user!.userName ?? "User",
              style: GoogleFonts.poppins(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),

            const Spacer(),

            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(builder: (context) => ChatBotPage()),
                );
              },
              child: Container(
                height: 44.h,
                width: 44.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0F1A29), Color(0xFF182435)],
                  ),
                  border: Border.all(color: Colors.white.withOpacity(0.06)),
                ),
                child: Center(
                  child: Icon(
                    Icons.headset_mic_outlined,
                    color: const Color(0xFF06CE8F),
                    size: 22.sp,
                  ),
                ),
              ),
            ),
            SizedBox(width: 10.w),

            /// Notification Icon
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  RightSlideFadeRoute(page: const NotificationPage()),
                ).then((value) {
                  return ref.read(profileProvider.notifier).getProfileData();
                });
              },
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  /// Icon Background
                  Container(
                    height: 44.h,
                    width: 44.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Color(0xFF0F1A29), Color(0xFF182435)],
                      ),
                      border: Border.all(color: Colors.white.withOpacity(0.06)),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.notifications_none,
                        color: const Color(0xFF06CE8F),
                        size: 22.sp,
                      ),
                    ),
                  ),

                  /// Red Badge
                  if (count > 0)
                    Positioned(
                      right: -2,
                      top: -2,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 4.w,
                          vertical: 2.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(color: Colors.black, width: 1.5),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 16.w,
                          minHeight: 16.h,
                        ),
                        child: Center(
                          child: Text(
                            count > 99 ? "99+" : count.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 8.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        );
      },

      /// Shimmer Loading
      loading: () => _headerShimmer(),

      error: (error, stackTrace) {
        return Text(
          error.toString(),
          style: const TextStyle(color: Colors.white),
        );
      },
    );
  }

  Widget _headerShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade800,
      highlightColor: Colors.grey.shade700,
      child: Row(
        children: [
          Container(
            height: 44.h,
            width: 44.h,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
          ),
          SizedBox(width: 12.w),
          Container(height: 14.h, width: 120.w, color: Colors.white),
          const Spacer(),
          Container(
            height: 44.h,
            width: 44.h,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildNotificationHeader() {
  //   return Row(
  //     children: [
  //       Text(
  //         "Recent Notifications",
  //         style: GoogleFonts.poppins(
  //           fontSize: 14.sp,
  //           fontWeight: FontWeight.w600,
  //           color: Colors.white,
  //         ),
  //       ),
  //       SizedBox(width: 6.w),
  //       const Icon(
  //         Icons.notifications_none,
  //         size: 18,
  //         color: Color(0xFF06CE8F),
  //       ),
  //     ],
  //   );
  // }

  Widget _buildBannerSlider(dynamic bannerData, {required bool isTop}) {
    if (bannerData.data == null || bannerData.data!.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: bannerData.data!.length,
          itemBuilder: (context, index, realIndex) {
            final item = bannerData.data![index];
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.r),
                child: Image.network(
                  item.image ?? "",
                  fit: BoxFit.fill,
                  width: double.infinity,
                  errorBuilder:
                      (c, e, s) => Container(
                        color: Colors.white10,
                        child: const Icon(
                          Icons.broken_image,
                          color: Colors.white,
                        ),
                      ),
                ),
              ),
            );
          },
          options: CarouselOptions(
            height: 150.h,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 3),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            autoPlayCurve: Curves.easeInOut,
            enlargeCenterPage: false,
            viewportFraction: 1.0,
            enableInfiniteScroll: true,
            onPageChanged: (index, reason) {
              setState(() {
                if (isTop) {
                  _topCurrentIndex = index;
                } else {
                  _bottomCurrentIndex = index;
                }
              });
            },
          ),
        ),

        SizedBox(height: 8.h),

        /// 🔵 Indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(bannerData.data!.length, (index) {
            final currentIndex = isTop ? _topCurrentIndex : _bottomCurrentIndex;

            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              width: currentIndex == index ? 20.w : 8.w,
              height: 8.h,
              decoration: BoxDecoration(
                color:
                    currentIndex == index
                        ? const Color(0xFF06CE8F) // aapke theme ka green
                        : Colors.grey.shade400,
                borderRadius: BorderRadius.circular(20.r),
              ),
            );
          }),
        ),
      ],
    );
  }

  // --- SHIMMER WIDGETS ---

  Widget _buildBannerShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.white.withOpacity(0.05),
      highlightColor: Colors.white.withOpacity(0.1),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 12.w),
        height: 150.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.r),
        ),
      ),
    );
  }

  Widget _buildTransferShimmer() {
    return glassCard(
      child: Shimmer.fromColors(
        baseColor: Colors.white.withOpacity(0.05),
        highlightColor: Colors.white.withOpacity(0.1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(
            5,
            (index) => Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Container(width: 200.w, height: 12.h, color: Colors.white),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorWidget(String error) {
    return Center(
      child: Text(error, style: const TextStyle(color: Colors.redAccent)),
    );
  }

  Widget glassCard({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          padding: EdgeInsets.all(20.w),
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

  Widget balanceCard(String title, String amount, {String? subtitle}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          padding: EdgeInsets.only(
            top: 20.h,
            left: 15.w,
            right: 15.w,
            bottom: 10.h,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(22.r),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  color: const Color(0xFF9CA3AF),
                  fontSize: 12.sp,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                amount,
                style: GoogleFonts.poppins(
                  color: const Color(0xFF06CE8F),
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (subtitle != null) ...[
                SizedBox(height: 4.h),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF64748B),
                    fontSize: 10.sp,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget transferTile(
    String image,
    String title,
    String subtitle,
    String amount,
    String time,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 5.h), // 👈 6 → 5
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: Image.asset(
                    image,
                    width: 50.w, // 👈 55 → 50
                    height: 50.h,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              SizedBox(width: 8.w),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontSize: 12.sp, // 👈 added (slightly smaller)
                    ),
                  ),

                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 11.sp, // 👈 12 → 11
                    ),
                  ),

                  Text(
                    time,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 9.sp, // 👈 10 → 9
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              amount,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 11.sp, // 👈 12 → 11
                fontWeight: FontWeight.w500,
              ),
            ),

            Text(
              "Per USDT",
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 10.sp, // 👈 12 → 10
              ),
            ),
          ],
        ),
      ],
    );
  }
}
