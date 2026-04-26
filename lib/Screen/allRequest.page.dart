import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:payment_app/Screen/requestDetails.page.dart';
import 'package:payment_app/data/controller/getPendingSellOrpderController.dart'; // Date format ke liye: flutter pub add intl

class AllRequestsScreen extends ConsumerWidget {
  const AllRequestsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendingSellOrderState = ref.watch(getPendingSellOrdersControlelr);

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // Dark Theme Background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "All Requests",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 18.sp,
          ),
        ),
        centerTitle: true,
      ),
      body: pendingSellOrderState.when(
        data: (data) {
          final orders = data.data?.list ?? [];

          if (orders.isEmpty) {
            return _buildEmptyState();
          }

          return ListView.builder(
            itemCount: orders.length,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              final order = orders[index];
              final String orderId = order.id ?? "";
              final String walletType = order.walletType ?? "USDT";
              final String status = order.status ?? "pending";

              // Date Formatting
              final DateTime date = DateTime.fromMillisecondsSinceEpoch(
                order.createdAt ?? 0,
              );
              final String formattedDate = DateFormat(
                'dd MMM yyyy, hh:mm a',
              ).format(date);

              return GestureDetector(
                onTap: () {
                  // Navigate to Detail Screen jo humne pehle banayi thi
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RequestDetailsPage(order: order),
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: 16.h),
                  padding: EdgeInsets.all(16.r),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: Colors.white.withOpacity(0.08)),
                  ),
                  child: Column(
                    children: [
                      // Top Row: User & Amount
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 18.r,
                                backgroundColor: const Color(
                                  0xFF3B82F6,
                                ).withOpacity(0.2),
                                child: Text(
                                  "U",
                                  style: TextStyle(
                                    color: const Color(0xFF3B82F6),
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Unknown",
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                  Text(
                                    "ID: #${orderId.substring(orderId.length - 6)}",
                                    style: GoogleFonts.poppins(
                                      color: Colors.white38,
                                      fontSize: 10.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "₹${order.price}",
                                style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.sp,
                                ),
                              ),
                              Text(
                                "${order.amount} $walletType",
                                style: GoogleFonts.poppins(
                                  color: const Color(0xFF06CE8F),
                                  fontSize: 11.sp,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      SizedBox(height: 12.h),
                      const Divider(color: Colors.white10, thickness: 1),
                      SizedBox(height: 8.h),

                      // Bottom Row: Date & Status Chip
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today_outlined,
                                color: Colors.white38,
                                size: 12.sp,
                              ),
                              SizedBox(width: 6.w),
                              Text(
                                formattedDate,
                                style: GoogleFonts.poppins(
                                  color: Colors.white38,
                                  fontSize: 11.sp,
                                ),
                              ),
                            ],
                          ),
                          _buildStatusChip(status),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        error:
            (error, _) => Center(
              child: Text(
                "Error: $error",
                style: const TextStyle(color: Colors.red),
              ),
            ),
        loading:
            () => const Center(
              child: CircularProgressIndicator(color: Color(0xFF3B82F6)),
            ),
      ),
    );
  }

  // Modern Status Chip
  Widget _buildStatusChip(String status) {
    Color color = status == "pending" ? Colors.orange : Colors.green;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Text(
        status.toUpperCase(),
        style: GoogleFonts.poppins(
          color: color,
          fontSize: 10.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.layers_clear_outlined, size: 80.r, color: Colors.white10),
          SizedBox(height: 16.h),
          Text(
            "No requests found",
            style: GoogleFonts.poppins(color: Colors.white38),
          ),
        ],
      ),
    );
  }
}
