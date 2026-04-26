// import 'package:flutter/material.dart';

// class RightSlideFadeRoute extends PageRouteBuilder {
//   final Widget page;

//   RightSlideFadeRoute({required this.page})
//     : super(
//         transitionDuration: const Duration(milliseconds: 300),
//         reverseTransitionDuration: const Duration(milliseconds: 300),
//         pageBuilder: (context, animation, secondaryAnimation) => page,
//         transitionsBuilder: (context, animation, secondaryAnimation, child) {
//           final slideAnimation = Tween<Offset>(
//             begin: const Offset(1.0, 0.0), // Right se entry
//             end: Offset.zero,
//           ).chain(CurveTween(curve: Curves.easeOutCubic));

//           return SlideTransition(
//             position: animation.drive(slideAnimation),
//             child: FadeTransition(opacity: animation, child: child),
//           );
//         },
//       );
// }

import 'package:flutter/material.dart';

class RightSlideFadeRoute extends PageRouteBuilder {
  final Widget page;

  RightSlideFadeRoute({required this.page})
    : super(
        transitionDuration: const Duration(milliseconds: 480), // थोड़ा slow
        reverseTransitionDuration: const Duration(milliseconds: 420),
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // Slide from right → left
          final slideTween = Tween<Offset>(
            begin: const Offset(0.95, 0.0), // 95% right se start (natural feel)
            end: Offset.zero,
          );

          final curvedSlide = slideTween.chain(
            CurveTween(
              curve: Curves.easeInOutCubicEmphasized,
            ), // बहुत smooth ending
          );

          // Fade ko thoda late shuru karte hain → premium feel
          final fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).chain(
            CurveTween(curve: const Interval(0.15, 1.0, curve: Curves.easeOut)),
          );

          return SlideTransition(
            position: animation.drive(curvedSlide),
            child: FadeTransition(
              opacity: animation.drive(fadeAnimation),
              child: child,
            ),
          );
        },
      );
}
