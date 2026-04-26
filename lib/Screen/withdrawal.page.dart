import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class WithdrawalPage extends StatelessWidget {
  const WithdrawalPage({super.key});

  // Dummy static data
  final String totalBalance = "1250.50";
  final String frozenBalance = "250.00";
  final String availableBalance = "1000.50";
  final String inrValue = "1,04,500";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF09111C),
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xFF09111C),
        elevation: 0,
        title: Text(
          "Withdraw",
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// WALLET CARD
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF06CE8F), Color(0xFF0B6B50)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// HEADER
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Wallet",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 6.w,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "USDT",
                          style: GoogleFonts.poppins(color: Colors.white),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20.h),

                  /// TOTAL BALANCE
                  Text(
                    "Total Balance",
                    style: GoogleFonts.poppins(color: Colors.white70),
                  ),
                  SizedBox(height: 6.h),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: totalBalance,
                          style: GoogleFonts.poppins(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        TextSpan(
                          text: " USDT",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    "≈ ₹$inrValue",
                    style: GoogleFonts.poppins(color: Colors.white70),
                  ),

                  SizedBox(height: 20.h),

                  /// AVAILABLE / FROZEN
                  Container(
                    padding: EdgeInsets.all(14.w),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white.withOpacity(0.25)),
                    ),
                    child: Row(
                      children: [
                        _balanceTile(
                          title: "Available",
                          value: "$availableBalance USDT",
                        ),
                        Container(
                          width: 1,
                          height: 40,
                          color: Colors.white.withOpacity(0.3),
                        ),
                        _balanceTile(
                          title: "Frozen",
                          value: "$frozenBalance USDT",
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 24.h),

            /// WITHDRAW AMOUNT
            Text(
              "I want to withdraw",
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8.h),
            _inputField(
              hint: "Eg: 100",
              suffix: "USDT",
              keyboardType: TextInputType.number,
            ),

            SizedBox(height: 16.h),

            /// WALLET ADDRESS
            Text(
              "Wallet Address",
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8.h),
            _inputField(
              hint: "Eg: TFi943kqRd4gXo1AeWtFpFG6oT2zBh15yS",
              keyboardType: TextInputType.text,
            ),

            SizedBox(height: 24.h),

            /// BREAKUP CARD
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: const Color(0xFF111827),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white12),
              ),
              child: Column(
                children: [
                  _breakupRow("Network Fee", "2 USDT"),
                  _breakupRow("Commission", "1.5%"),
                  _breakupRow("Minimum Withdraw", "10 USDT"),
                ],
              ),
            ),

            SizedBox(height: 40.h),

            /// WITHDRAW BUTTON
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF06CE8F),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Withdraw (UI only)")),
                  );
                },
                child: Text(
                  "Withdraw",
                  style: GoogleFonts.poppins(
                    color: Color(0xFF09111C),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= HELPERS =================

  Widget _balanceTile({required String title, required String value}) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: GoogleFonts.poppins(color: Colors.white70)),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _inputField({
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    String? suffix,
  }) {
    return TextField(
      keyboardType: keyboardType,
      style: GoogleFonts.poppins(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.poppins(color: Colors.grey),
        suffixText: suffix,
        suffixStyle: GoogleFonts.poppins(color: Colors.white),
        filled: true,
        fillColor: const Color(0xFF111827),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _breakupRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: GoogleFonts.poppins(color: Colors.grey)),
          Text(value, style: GoogleFonts.poppins(color: Colors.white)),
        ],
      ),
    );
  }
}
