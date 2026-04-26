import 'package:flutter/material.dart';

class StockPriceWidget extends StatelessWidget {
  final double currentPrice;
  final double percentageChange;

  const StockPriceWidget({
    super.key,
    required this.currentPrice,
    required this.percentageChange,
  });

  // 🎨 SAME TYPE COLORS (Direct)
  static const Color approved = Color(0xFF2ECC71); // Green
  static const Color errorColorDark = Color(0xFFE74C3C); // Red

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // ===== PRICE =====
        Text(
          "\$${currentPrice.toStringAsFixed(2)}",
          style: Theme.of(context).textTheme.titleMedium,
        ),

        const SizedBox(height: 4),

        // ===== PERCENTAGE CHANGE =====
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: percentageChange >= 0
                ? approved
                : errorColorDark,
          ),
          child: Text(
            "${percentageChange >= 0 ? '+' : ''}${percentageChange.toStringAsFixed(2)}%",
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
