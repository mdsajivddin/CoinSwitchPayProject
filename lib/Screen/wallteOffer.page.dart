import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class WallteOfferPage extends StatelessWidget {
  const WallteOfferPage({super.key});

  // ===== COLORS =====
  static const bgCard = Color(0xFF111827);
  static const primaryGreen = Color(0xFF06CE8F);
  static const textGrey = Color(0xFF9CA3AF);
  static const borderColor = Color(0xFF1F2937);

  @override
  Widget build(BuildContext context) {
    // 👉 Dummy offers (UI only)
    final offers = [
      {
        "title": "Zero Fee Withdrawal",
        "subtitle": "Withdraw without any extra charges",
        "badge": "LIMITED",
      },
      {
        "title": "5% Bonus Cashback",
        "subtitle": "Get bonus on USDT withdrawal",
        "badge": "HOT",
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),

        /// TITLE
         Text(
          "Offers",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 6),

         Text(
          "Pick an offer to get started",
          style: GoogleFonts.poppins(color: textGrey),
        ),

        const SizedBox(height: 16),

        /// EMPTY STATE
        if (offers.isEmpty) _emptyState(context),

        /// OFFERS LIST
        if (offers.isNotEmpty)
          Column(
            children:
                offers.map((offer) {
                  return _offerCard(
                    title: offer["title"]!,
                    subtitle: offer["subtitle"]!,
                    badge: offer["badge"]!,
                  );
                }).toList(),
          ),
      ],
    );
  }

  // ================= EMPTY STATE =================

  Widget _emptyState(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: bgCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        children:  [
          Icon(Icons.local_offer_outlined, size: 48, color: textGrey),
          SizedBox(height: 12),
          Text(
            "No offers available",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 6),
          Text(
            "Check back later for new offers",
            style: GoogleFonts.poppins(color: textGrey),
          ),
        ],
      ),
    );
  }

  // ================= OFFER CARD =================

  Widget _offerCard({
    required String title,
    required String subtitle,
    required String badge,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: bgCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          /// ICON
          Container(
            height: 42,
            width: 42,
            decoration: BoxDecoration(
              color: primaryGreen.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.local_offer, color: primaryGreen),
          ),

          const SizedBox(width: 12),

          /// TEXT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style:  GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style:  GoogleFonts.poppins(
                    color: textGrey,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          /// BADGE
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: primaryGreen,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              badge,
              style:  GoogleFonts.poppins(
                color: Colors.black,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
