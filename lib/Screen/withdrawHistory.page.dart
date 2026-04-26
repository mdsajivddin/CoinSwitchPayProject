// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class WithdrawHistoryPage extends StatelessWidget {
//   const WithdrawHistoryPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF09111C),
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF09111C),
//         elevation: 0,
//         title: Text(
//           "Withdraw Records",
//           style: GoogleFonts.poppins(
//             color: Colors.white,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: ListView.builder(
//         padding: const EdgeInsets.all(16),
//         itemCount: 6, // static UI items
//         itemBuilder: (context, index) {
//           return _historyCard();
//         },
//       ),
//     );
//   }

//   Widget _historyCard() {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 14),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: const Color(0xFF0F172A),
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(color: const Color(0xFF1B8375).withOpacity(0.4)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           /// Date + Status
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 "12 Jan 2026, 10:45 AM",
//                 style: GoogleFonts.poppins(
//                   color: const Color(0xFFAEA3AD),
//                   fontSize: 13,
//                 ),
//               ),
//               Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 10,
//                   vertical: 4,
//                 ),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFF06CE8F).withOpacity(0.15),
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: Text(
//                   "Success",
//                   style: GoogleFonts.poppins(
//                     color: const Color(0xFF06CE8F),
//                     fontSize: 12,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ),
//             ],
//           ),

//           const SizedBox(height: 14),

//           /// TXID
//           Text(
//             "Transaction ID",
//             style: GoogleFonts.poppins(
//               color: const Color(0xFF6B7280),
//               fontSize: 12,
//             ),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             "0x9e8d1b6c7a8f99ab23e...",
//             style: GoogleFonts.poppins(
//               color: Colors.white,
//               fontSize: 14,
//               fontWeight: FontWeight.w500,
//             ),
//           ),

//           const SizedBox(height: 14),

//           /// Amount
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 "Amount",
//                 style: GoogleFonts.poppins(
//                   color: const Color(0xFF6B7280),
//                   fontSize: 13,
//                 ),
//               ),
//               Text(
//                 "- 120.50 USDT",
//                 style: GoogleFonts.poppins(
//                   color: Colors.white,
//                   fontSize: 15,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WithdrawHistoryPage extends StatelessWidget {
  const WithdrawHistoryPage({super.key});

  // Color Palette
  static const Color bgColor = Color(0xFF09111C);
  static const Color cardColor = Color(0xFF111A2E);
  static const Color accentRed = Color(0xFFFF5252);
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
          "Withdraw Records",
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
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        physics: const BouncingScrollPhysics(),
        itemCount: 6,
        itemBuilder: (context, index) {
          // Dummy data logic
          String status =
              index == 2
                  ? "Pending"
                  : index == 4
                  ? "Rejected"
                  : "Success";
          return _withdrawCard(status);
        },
      ),
    );
  }

  Widget _withdrawCard(String status) {
    Color statusColor = _getStatusColor(status);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Left status line
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: Container(width: 5, color: statusColor),
            ),

            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [
                  /// Top Row: Icon + Date + Status
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          status == "Success"
                              ? Icons.outbound_rounded
                              : Icons.pending_actions_rounded,
                          color: statusColor,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "12 Jan 2026",
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              "10:45 AM",
                              style: GoogleFonts.poppins(
                                color: textGrey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      _statusChip(status, statusColor),
                    ],
                  ),

                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Divider(
                      color: Colors.white10,
                      height: 1,
                      thickness: 1,
                    ),
                  ),

                  /// Bottom Row: TXID & Amount
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "TRANSACTION ID",
                            style: GoogleFonts.poppins(
                              color: textGrey,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                "0x9e8d1...a8f9",
                                style: GoogleFonts.poppins(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Icon(
                                Icons.copy_rounded,
                                color: textGrey.withOpacity(0.5),
                                size: 14,
                              ),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "AMOUNT",
                            style: GoogleFonts.poppins(
                              color: textGrey,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "- 120.50 USDT",
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusChip(String status, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Text(
        status,
        style: GoogleFonts.poppins(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case "Success":
        return const Color(0xFF06CE8F);
      case "Pending":
        return Colors.orangeAccent;
      case "Rejected":
        return accentRed;
      default:
        return textGrey;
    }
  }
}
