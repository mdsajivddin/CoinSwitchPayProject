import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class TransactionDetailsPage extends StatelessWidget {
  const TransactionDetailsPage({super.key});

  static const bgColor = Color(0xFF09111C);
  static const primaryGreen = Color(0xFF06CE8F);
  static const textGrey = Color(0xFFAEA3AD);
  static const cardBg = Color(0xFF111827);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title:  Text(
          'Bitcoin',
          style: GoogleFonts.poppins(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _header(),
            SizedBox(height: 24.h),
            _timeRange(),
            SizedBox(height: 16.h),
            _chartPlaceholder(),
            SizedBox(height: 24.h),
            _marketStats(),
            SizedBox(height: 24.h),
            _priceRange(),
          ],
        ),
      ),
    );
  }

  // ================= HEADER =================

  Widget _header() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30.r,
            backgroundColor: Colors.orange,
            child: const Icon(
              Icons.currency_bitcoin,
              color: Colors.white,
              size: 30,
            ),
          ),
          SizedBox(width: 16.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bitcoin',
                style: GoogleFonts.poppins(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                'BTC',
                style: GoogleFonts.poppins(fontSize: 14.sp, color: textGrey),
              ),
              SizedBox(height: 8.h),
              Text(
                '\$45,230.50',
                style: GoogleFonts.poppins(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: primaryGreen,
                ),
              ),
              Text(
                '+2.45%',
                style: GoogleFonts.poppins(
                  fontSize: 14.sp,
                  color: primaryGreen,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ================= TIME RANGE =================

  Widget _timeRange() {
    final ranges = ['1D', '7D', '30D', '90D', '1Y'];

    return SizedBox(
      height: 40.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: ranges.length,
        itemBuilder: (context, index) {
          final isSelected = index == 1;
          return Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: isSelected ? primaryGreen : cardBg,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color:
                      isSelected
                          ? primaryGreen
                          : Colors.white.withOpacity(0.05),
                ),
              ),
              child: Text(
                ranges[index],
                style: GoogleFonts.poppins(
                  fontSize: 12.sp,
                  color: isSelected ? bgColor : textGrey,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ================= CHART PLACEHOLDER =================

  Widget _chartPlaceholder() {
    return Container(
      height: 250.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.show_chart, size: 48, color: primaryGreen),
          SizedBox(height: 8.h),
          Text('Chart Preview', style: GoogleFonts.poppins(color: textGrey)),
        ],
      ),
    );
  }

  // ================= MARKET STATS =================

  Widget _marketStats() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Market Statistics',
          style: GoogleFonts.poppins(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(child: _statCard('Market Cap', '\$850B')),
            SizedBox(width: 12.w),
            Expanded(child: _statCard('24h Volume', '\$42B')),
          ],
        ),
      ],
    );
  }

  Widget _statCard(String title, String value) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(fontSize: 12.sp, color: textGrey),
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // ================= PRICE RANGE =================

  Widget _priceRange() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '24h Price Range',
          style: GoogleFonts.poppins(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(child: _priceCard('Low', '\$43,100', Colors.red)),
            SizedBox(width: 12.w),
            Expanded(child: _priceCard('High', '\$46,000', primaryGreen)),
          ],
        ),
      ],
    );
  }

  Widget _priceCard(String title, String value, Color color) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 12.sp,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
