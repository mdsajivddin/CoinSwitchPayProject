import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:payment_app/Screen/buyOrderScreen.dart'; // Date formatting ke liye

class RequestDetailsPage extends StatelessWidget {
  final dynamic order; // Aapka Order Model yahan aayega

  const RequestDetailsPage({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    // Date formatting
    final String formattedDate = DateFormat(
      'dd MMM yyyy, hh:mm a',
    ).format(DateTime.fromMillisecondsSinceEpoch(order.createdAt ?? 0));

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // Deep dark theme
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Order Details",
          style: GoogleFonts.poppins(fontSize: 18.sp, color: Colors.white),
        ),
        centerTitle: true,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.r),
        child: Column(
          children: [
            /// 1. Status Badge & Icon
            _buildStatusHeader(order.status ?? "pending"),
            SizedBox(height: 24.h),

            /// 2. Main Amount Card
            _buildAmountCard(
              order.price.toDouble(),
              order.amount.toDouble(),
              order.walletType ?? "USDT",
            ),
            SizedBox(height: 24.h),

            /// 3. Information Section
            _buildInfoSection("Transaction Details", [
              _buildInfoTile("Order ID", "#${order.id}", isCopyable: true),
              _buildInfoTile("Created At", formattedDate),
              _buildInfoTile("Wallet Type", order.walletType ?? "N/A"),
              _buildInfoTile("Seller Address", order.sellerAddress ?? "N/A"),
            ]),

            SizedBox(height: 16.h),

            /// 4. Creator Section
            _buildInfoSection("Creator Details", [
              _buildInfoTile("Name", order.creator?.name ?? "Unknown"),
              _buildInfoTile("Email", order.creator?.email ?? "N/A"),
            ]),

            SizedBox(height: 16.h),

            /// 5. Dispute Status (Important)
            if (order.dispute != null)
              _buildDisputeCard(order.dispute.isDisputed),

            SizedBox(height: 30.h),

            /// Buy Button
            ElevatedButton(
              onPressed:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => BuyOrderScreen(
                            orderId: order.id,
                            sellerAddress: order.sellerAddress ?? "N/A",
                          ),
                    ),
                  ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(
                  0xFF06CE8F,
                ), // Buy ke liye Green theme
                minimumSize: Size(double.infinity, 55.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.r),
                ),
                elevation: 0,
              ),
              child: Text(
                "Buy Now",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- UI Components ---

  Widget _buildStatusHeader(String status) {
    Color color = status == "pending" ? Colors.orange : Colors.green;
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: color.withOpacity(0.5)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(radius: 4.r, backgroundColor: color),
              SizedBox(width: 8.w),
              Text(
                status.toUpperCase(),
                style: GoogleFonts.poppins(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAmountCard(double price, double amount, String type) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.r),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Text(
            "Total Price",
            style: GoogleFonts.poppins(color: Colors.white70, fontSize: 14.sp),
          ),
          SizedBox(height: 8.h),
          Text(
            "₹$price",
            style: GoogleFonts.montserrat(
              color: Colors.white,
              fontSize: 32.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          Divider(height: 32.h, color: Colors.white10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSubAmount("Amount", "$amount"),
              _buildSubAmount("Asset", type),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSubAmount(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(color: Colors.white38, fontSize: 12.sp),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 4.w, bottom: 8.h),
          child: Text(
            title,
            style: GoogleFonts.poppins(
              color: Colors.white70,
              fontWeight: FontWeight.w600,
              fontSize: 14.sp,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(12.r),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.03),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildInfoTile(String label, String value, {bool isCopyable = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(color: Colors.white38, fontSize: 13.sp),
          ),
          Flexible(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    value,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (isCopyable) ...[
                  SizedBox(width: 8.w),
                  Icon(Icons.copy, color: Colors.blue, size: 16.sp),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDisputeCard(bool isDisputed) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color:
            isDisputed
                ? Colors.red.withOpacity(0.1)
                : Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Icon(
            isDisputed
                ? Icons.warning_amber_rounded
                : Icons.verified_user_outlined,
            color: isDisputed ? Colors.red : Colors.green,
          ),
          SizedBox(width: 12.w),
          Text(
            isDisputed ? "This order is under dispute" : "No active disputes",
            style: GoogleFonts.poppins(
              color: isDisputed ? Colors.red : Colors.green,
              fontSize: 13.sp,
            ),
          ),
        ],
      ),
    );
  }
}
