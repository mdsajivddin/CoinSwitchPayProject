import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:payment_app/Screen/login.page.dart';

class OnbordingPage extends StatefulWidget {
  const OnbordingPage({super.key});

  @override
  State<OnbordingPage> createState() => _OnbordingPageState();
}

class _OnbordingPageState extends State<OnbordingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> pages = [
    {
      "title": "Welcome to CoinSwitchPay",
      "desc": "I will take you around to see what\'s so exciting about",
      // "image": "assets/onboard_1.webp",
      "image": "assets/iconlogo.jpeg",
    },
    {
      "title": "Create Account",
      "desc":
          "Sign up easily using your email and password and start trading within minutes.",
      "image": "assets/onboard_2.webp",
    },
    {
      "title": "Deposit USDT",
      "desc":
          "Deposit USDT securely into your DhanPayX wallet and start trading instantly.",
      "image": "assets/onboard_3.webp",
    },
    {
      "title": "Withdraw INR",
      "desc":
          "Convert USDT to INR and withdraw directly to your bank account safely.",
      "image": "assets/onboard_4.webp",
    },
    {
      "title": "Track & Manage",
      "desc":
          "Monitor transactions, manage funds, and track your trading activity anytime.",
      "image": "assets/onboard_5.webp",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF09111C),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/onboard_background.webp"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: pages.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return OnboardingPage(
                      title: pages[index]["title"]!,
                      description: pages[index]["desc"]!,
                      image: pages[index]["image"]!,
                    );
                  },
                ),
              ),

              /// Indicators + Buttons
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    /// Skip
                    TextButton(
                      onPressed: () {
                        _pageController.jumpToPage(pages.length - 1);
                      },
                      child: Text(
                        "Skip",
                        style: GoogleFonts.poppins(
                          color: const Color(0xFFAEA3AD),
                          fontSize: 14,
                        ),
                      ),
                    ),

                    /// Dots
                    Row(
                      children: List.generate(
                        pages.length,
                        (index) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: _currentPage == index ? 12 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color:
                                _currentPage == index
                                    ? const Color(0xFF06CE8F)
                                    : const Color(0xFF1B8375),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),

                    /// Next / Get Started
                    TextButton(
                      onPressed: () {
                        if (_currentPage < pages.length - 1) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          Navigator.pushReplacement(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => LoginPage(),
                            ),
                          ); // go to Login
                        }
                      },
                      child: Text(
                        _currentPage == pages.length - 1
                            ? "Get Started"
                            : "Next",
                        style: GoogleFonts.poppins(
                          color: const Color(0xFF06CE8F),
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String title;
  final String description;
  final String image;

  const OnboardingPage({
    super.key,
    required this.title,
    required this.description,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            image,
            height: 280,
            errorBuilder:
                (_, __, ___) =>
                    const Icon(Icons.image, size: 100, color: Colors.grey),
          ),

          const SizedBox(height: 30),

          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 16),

          Text(
            description,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: const Color(0xFFAEA3AD),
            ),
          ),
        ],
      ),
    );
  }
}
