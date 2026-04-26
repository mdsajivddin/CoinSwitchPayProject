import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ShowMessage {
  ShowMessage._();

  static void show(
    BuildContext context, {
    required String message,
    required Color backgroundColor,
    IconData? icon,
    Duration duration = const Duration(seconds: 3),
  }) {
    // Top overlay create karne ke liye
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder:
          (context) => Positioned(
            top: MediaQuery.of(context).padding.top + 10, // Status bar ke niche
            left: 20,
            right: 20,
            child: Material(
              color: Colors.transparent,
              child: Dismissible(
                key: UniqueKey(),
                onDismissed: (_) => overlayEntry.remove(),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      if (icon != null) ...[
                        Icon(icon, color: Colors.white, size: 20),
                        const SizedBox(width: 12),
                      ],
                      Expanded(
                        child: Text(
                          message,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
    );

    // Overlay insert karein
    overlay.insert(overlayEntry);

    // Duration ke baad auto remove karein
    Future.delayed(duration, () {
      if (overlayEntry.mounted) {
        overlayEntry.remove();
      }
    });
  }

  static void success(BuildContext context, String message) {
    show(
      context,
      message: message,
      backgroundColor: const Color(0xFF06CE8F),
      icon: Icons.check_circle_outline,
    );
  }

  static void error(BuildContext context, String message) {
    show(
      context,
      message: message,
      backgroundColor: const Color(0xFFE53935), // Professional Red
      icon: Icons.error_outline,
    );
  }
}
