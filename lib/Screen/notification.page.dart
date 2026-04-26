import 'dart:developer';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:payment_app/Screen/inrToTokenBuyDetailsHistory.page.dart';
import 'package:payment_app/Screen/p2pBuySellHistoryDetails.dart';
import 'package:payment_app/Screen/usdtToSellInrDetailsHistory.page.dart';
import 'package:payment_app/config/auth/router/rightsliderFageRoute.dart';
import 'package:payment_app/data/controller/notificationListController.dart';

class NotificationPage extends ConsumerStatefulWidget {
  const NotificationPage({super.key});

  @override
  ConsumerState<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends ConsumerState<NotificationPage> {
  String formatDate(int? timestamp) {
    if (timestamp == null) return "";

    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return DateFormat("d/M/yyyy").format(date);
  }

  String formatTime(int? timestamp) {
    if (timestamp == null) return "";

    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return DateFormat("hh:mm a").format(date);
  }

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   ref.invalidate(readNotificationController);
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    final notificationListState = ref.watch(notificationListController);
    final readNotificationState = ref.watch(readNotificationController);
    return Scaffold(
      backgroundColor: const Color(0xFF09111C),
      appBar: AppBar(
        backgroundColor: const Color(0xFF09111C),
        foregroundColor: Colors.white,
        title: Text(
          "Notifications",
          style: GoogleFonts.poppins(
            fontSize: 22.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            notificationListState.when(
              data: (data) {
                final listData = data.data?.list ?? [];

                /// ✅ EMPTY CHECK
                if (listData.isEmpty) {
                  return Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.notifications_off_rounded,
                            size: 60.sp,
                            color: Colors.white24,
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            "No Notifications",
                            style: GoogleFonts.poppins(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white70,
                            ),
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            "You're all caught up 🎉",
                            style: GoogleFonts.poppins(
                              fontSize: 12.sp,
                              color: Colors.white38,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return Expanded(
                  child: ListView.builder(
                    itemCount: data.data!.list!.length,
                    itemBuilder: (context, index) {
                      final list = data.data!.list![index];
                      return InkWell(
                        onTap: () {
                          if (list.orderModel == "Transaction") {
                            Navigator.push(
                              context,
                              RightSlideFadeRoute(
                                page: InrToTokenBuyDetailsHistoryPage(
                                  id: list.orderId.toString(),
                                ),
                              ),
                            );
                          } else if (list.orderModel == "Sell") {
                            Navigator.push(
                              context,
                              RightSlideFadeRoute(
                                page: UsdtToSellInrDetailsHistoryPage(
                                  id: list.orderId.toString(),
                                ),
                              ),
                            );
                          } else if (list.orderModel == "P2PTransaction") {
                            Navigator.push(
                              context,
                              RightSlideFadeRoute(
                                page: P2pBuySellHistoryDetails(
                                  id: list.orderId.toString(),
                                ),
                              ),
                            );
                          }
                        },
                        child: NotificationCard(
                          title: list.name ?? "",
                          message: list.msg ?? "",
                          date: formatDate(list.createdAt),
                          time: formatTime(list.createdAt),
                        ),
                      );
                    },
                  ),
                );
              },
              error: (error, stackTrace) {
                log(stackTrace.toString());
                return Center(child: Text(error.toString()));
              },
              loading:
                  () => Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final String title;
  final String message;
  final String date;
  final String time;

  const NotificationCard({
    super.key,
    required this.title,
    required this.message,
    required this.date,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22.r),
        gradient: const LinearGradient(
          colors: [Color(0xFF182435), Color(0xFF0F1A29)],
        ),
        border: Border.all(color: Colors.white.withOpacity(.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Title Row
          Row(
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),

              SizedBox(width: 6.w),

              /// Blue Dot
              Container(
                height: 7.h,
                width: 7.h,
                decoration: const BoxDecoration(
                  color: Color(0xFF3B82F6),
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),

          SizedBox(height: 10.h),

          /// Message
          Text(
            message,
            style: GoogleFonts.poppins(
              fontSize: 13.sp,
              color: Colors.white70,
              height: 1.5,
            ),
          ),

          SizedBox(height: 14.h),

          Divider(color: Colors.white.withOpacity(.08)),

          SizedBox(height: 10.h),

          /// Date Time Row
          Row(
            children: [
              Icon(Icons.access_time, color: Colors.white38, size: 15.sp),

              SizedBox(width: 6.w),

              Text(
                date,
                style: GoogleFonts.poppins(
                  fontSize: 12.sp,
                  color: Colors.white38,
                ),
              ),

              SizedBox(width: 10.w),

              Container(
                height: 4.h,
                width: 4.h,
                decoration: const BoxDecoration(
                  color: Colors.white24,
                  shape: BoxShape.circle,
                ),
              ),

              SizedBox(width: 10.w),

              Text(
                time,
                style: GoogleFonts.poppins(
                  fontSize: 12.sp,
                  color: Colors.white38,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
