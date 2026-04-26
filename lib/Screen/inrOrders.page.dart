import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart'; // Date formatting ke liye (add in pubspec.yaml)
import 'package:payment_app/data/controller/getPendingSellOrpderController.dart';

class InrOrdersPage extends ConsumerStatefulWidget {
  const InrOrdersPage({super.key});

  @override
  ConsumerState<InrOrdersPage> createState() => _InrOrdersPageState();
}

class _InrOrdersPageState extends ConsumerState<InrOrdersPage> {
  @override
  Widget build(BuildContext context) {
    final pendingSellOrderState = ref.watch(getPendingSellOrdersControlelr);

    return Scaffold(
      backgroundColor: const Color(0xFF09111C),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          "Marketplace Orders",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: pendingSellOrderState.when(
        data: (data) {
          // Response se list nikalna
          // final orders = data['data']['list'] as List? ?? [];
          final orders = data.data!.list ?? [];
          if (orders.isEmpty) {
            return _buildEmptyState();
          }

          return ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            itemCount: orders.length,
            itemBuilder: (_, i) {
              final order = orders[i];
              final String orderId = order.id ?? "";
              //final String creatorName = order.creator!.name ?? "Unknown";
              final double amount = (order.amount ?? 0).toDouble();
              final double price = (order.price ?? 0).toDouble();
              final String status = order.status ?? "pending";
              final String walletType = order.walletType ?? "USDT";

              return Container(
                margin: EdgeInsets.only(bottom: 16.h),
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(24.r),
                  border: Border.all(color: Colors.white.withOpacity(0.08)),
                ),
                child: Column(
                  children: [
                    // Header: User Info and Status
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 14.r,
                              backgroundColor: const Color(
                                0xFF06CE8F,
                              ).withOpacity(0.2),
                              child: Text(
                              "  creatorName[0].toUpperCase()",
                                style: TextStyle(
                                  color: const Color(0xFF06CE8F),
                                  fontSize: 10.sp,
                                ),
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              "creatorName",
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 13.sp,
                              ),
                            ),
                          ],
                        ),
                        _buildStatusChip(status),
                      ],
                    ),

                    Divider(
                      color: Colors.white.withOpacity(0.05),
                      height: 24.h,
                    ),

                    // Main Details
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Total Price",
                              style: GoogleFonts.poppins(
                                color: Colors.white38,
                                fontSize: 11.sp,
                              ),
                            ),
                            Text(
                              "₹${price.toStringAsFixed(2)}",
                              style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "Amount to Receive",
                              style: GoogleFonts.poppins(
                                color: Colors.white38,
                                fontSize: 11.sp,
                              ),
                            ),
                            Text(
                              "$amount $walletType",
                              style: GoogleFonts.montserrat(
                                color: const Color(0xFF3B82F6),
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    SizedBox(height: 16.h),

                    // Actions
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Order ID: ...${orderId.substring(orderId.length - 6)}",
                            style: GoogleFonts.poppins(
                              color: Colors.white24,
                              fontSize: 10.sp,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF06CE8F),
                            foregroundColor: Colors.black,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 24.w,
                              vertical: 8.h,
                            ),
                          ),
                          child: Text(
                            "BUY NOW",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 12.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
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
              child: CircularProgressIndicator(color: Color(0xFF06CE8F)),
            ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        status.toUpperCase(),
        style: GoogleFonts.poppins(
          color: Colors.orangeAccent,
          fontSize: 9.sp,
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
          Icon(Icons.inventory_2_outlined, color: Colors.white10, size: 64.r),
          SizedBox(height: 16.h),
          Text(
            "No Pending Orders",
            style: GoogleFonts.poppins(color: Colors.white38),
          ),
        ],
      ),
    );
  }
}
