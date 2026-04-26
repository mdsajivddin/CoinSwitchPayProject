import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class P2PHistoryPage extends StatelessWidget {
  const P2PHistoryPage({super.key});

  static const Color bgColor = Color(0xFF09111C);
  static const Color cardColor = Color(0xFF111A2E);
  static const Color primaryGreen = Color(0xFF06CE8F);
  static const Color primaryRed = Color(0xFFFF5252);
  static const Color textGrey = Color(0xFF9CA3AF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "P2P Trade History",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list_rounded, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        itemCount: 8,
        itemBuilder: (context, index) {
          // Dummy logic: Even index Buy, Odd index Sell
          bool isBuy = index % 2 == 0;
          String status = index == 3 ? "Cancelled" : "Completed";
          return _p2pCard(isBuy, status);
        },
      ),
    );
  }

  Widget _p2pCard(bool isBuy, String status) {
    Color typeColor = isBuy ? primaryGreen : primaryRed;
    Color statusColor = status == "Completed" ? primaryGreen : Colors.white38;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.03)),
      ),
      child: Column(
        children: [
          /// Row 1: Buy/Sell Badge & Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: typeColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      isBuy ? "BUY" : "SELL",
                      style: GoogleFonts.poppins(
                        color: typeColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "USDT",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              Text(
                status,
                style: GoogleFonts.poppins(
                  color: statusColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          /// Row 2: Amount & Peer Info
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Amount",
                    style: GoogleFonts.poppins(color: textGrey, fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "500.00 USDT",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "Price",
                    style: GoogleFonts.poppins(color: textGrey, fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "91.20 INR",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 14),
            child: Divider(color: Colors.white10, height: 1),
          ),

          /// Row 3: Peer Name & Date
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.blueGrey,
                    child: Text(
                      "A",
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Alex_Trader",
                    style: GoogleFonts.poppins(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              Text(
                "2026-02-18 14:20",
                style: GoogleFonts.poppins(color: textGrey, fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
