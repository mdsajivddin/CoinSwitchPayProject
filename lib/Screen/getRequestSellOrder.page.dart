import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:payment_app/data/controller/getRequestSellOrderControlelr.dart';

class GetrequestSellOrderPage extends ConsumerStatefulWidget {
  const GetrequestSellOrderPage({super.key});

  @override
  ConsumerState<GetrequestSellOrderPage> createState() =>
      _GetrequestSellOrderPageState();
}

class _GetrequestSellOrderPageState
    extends ConsumerState<GetrequestSellOrderPage> {
  @override
  Widget build(BuildContext context) {
    // 1. Provider ko watch karna
    final apiState = ref.watch(getRequestSellOrderControlelr);

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // Modern dark background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Request Sell Orders",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
      ),
      body: apiState.when(
        // DATA LOADED STATE
        data: (response) {
          final orders = response.data?.list ?? [];

          if (orders.isEmpty) {
            return const Center(
              child: Text(
                "No data found",
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              return _buildOrderCard(orders[index]);
            },
          );
        },
        // LOADING STATE
        loading:
            () => const Center(
              child: CircularProgressIndicator(color: Color(0xFF3B82F6)),
            ),
        // ERROR STATE
        error: (error, stackTrace) {
          log(stackTrace.toString());
          log(error.toString());
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.redAccent,
                  size: 40,
                ),
                SizedBox(height: 10.h),
                Text(
                  "Error loading data",
                  style: GoogleFonts.poppins(color: Colors.white),
                ),
                TextButton(
                  onPressed: () => ref.refresh(getRequestSellOrderControlelr),
                  child: const Text("Retry"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // --- AAPKA DESIGN CARD ---
  Widget _buildOrderCard(dynamic order) {
    final bool isDisputed = order.dispute?.isDisputed ?? false;
    final bool isInr = order.walletType?.toUpperCase() == "INR";
    final DateTime createdDate = DateTime.fromMillisecondsSinceEpoch(
      order.createdAt ?? 0,
    );

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color:
              isDisputed
                  ? Colors.redAccent.withOpacity(0.3)
                  : Colors.white.withOpacity(0.05),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildBadge(
                text:
                    isDisputed
                        ? "DISPUTED"
                        : (order.status ?? "PENDING").toUpperCase(),
                color: isDisputed ? Colors.redAccent : const Color(0xFF3B82F6),
              ),
              Text(
                DateFormat('dd MMM, hh:mm a').format(createdDate),
                style: GoogleFonts.poppins(
                  color: Colors.white38,
                  fontSize: 11.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Container(
                height: 50.h,
                width: 50.w,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors:
                        isInr
                            ? [const Color(0xFF10B981), const Color(0xFF059669)]
                            : [
                              const Color(0xFF3B82F6),
                              const Color(0xFF2563EB),
                            ],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isInr ? Icons.currency_rupee : Icons.currency_bitcoin,
                  color: Colors.white,
                  size: 24.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.creator?.name ?? "Anonymous",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      "ID: #${order.id?.substring(order.id!.length - 8) ?? ""}",
                      style: GoogleFonts.poppins(
                        color: Colors.white30,
                        fontSize: 11.sp,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "₹${order.price}",
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "${order.amount} ${order.walletType}",
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF10B981),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (isDisputed) ...[
            SizedBox(height: 12.h),
            _buildDisputeNote(order.dispute?.reason ?? "No reason provided"),
          ],
        ],
      ),
    );
  }

  Widget _buildBadge({required String text, required Color color}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          color: color,
          fontSize: 10.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildDisputeNote(String reason) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10.r),
      decoration: BoxDecoration(
        color: Colors.redAccent.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: Colors.redAccent,
            size: 16.sp,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              "Dispute: $reason",
              style: GoogleFonts.poppins(
                color: Colors.redAccent,
                fontSize: 11.sp,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
