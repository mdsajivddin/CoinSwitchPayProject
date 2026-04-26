import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:payment_app/Screen/p2pBuySellHistoryDetails.dart';
import 'package:payment_app/Screen/p2pSellHistoryDetails.page.dart';
import 'package:payment_app/config/auth/router/rightsliderFageRoute.dart';
import 'package:payment_app/data/controller/getp2pTrasationSellController.dart';

// Provider to manage tab state (0: Buy, 1: Sell)
final p2pTabProvider = StateProvider<int>((ref) => 0);

class P2pBuySellTransationHistoryPage extends ConsumerWidget {
  const P2pBuySellTransationHistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTab = ref.watch(p2pTabProvider);

    final transactionAsync =
        selectedTab == 0
            ? ref.watch(p2pBuyHistoryProvider)
            : ref.watch(p2pSellProvider);

    return PopScope(
      canPop: false, // Default back behavior band kar diya
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        // Jab user back karega, hum use home/drawer page par bhej denge
        Navigator.pushReplacementNamed(context, '/home');
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF09111C),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(
                  context,
                ); // Agar piche koi page hai to waha jayega
              } else {
                // Agar piche kuch nahi hai (replacement ki wajah se), to Home par bhej do
                Navigator.pushReplacementNamed(
                  context,
                  '/home',
                ); // Aapne home route ka jo bhi naam rakha ho
              }
            },
            icon: Icon(Icons.arrow_back, color: Colors.white, size: 24.sp),
          ),
          title: Text(
            "P2P History",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 18.sp,
              color: Colors.white,
            ),
          ),
        ),
        body: Column(
          children: [
            _buildToggleSwitch(ref, selectedTab),
            Expanded(
              child: transactionAsync.when(
                data: (data) => _buildTransactionList(ref, data, selectedTab),
                error:
                    (error, stack) => Center(
                      child: Text(
                        "Error: $error",
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                loading:
                    () => const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🛠 UNIVERSAL TRANSACTION LIST
  Widget _buildTransactionList(
    WidgetRef ref,
    dynamic response,
    int selectedTab,
  ) {
    final transactions = response.data?.data ?? [];

    if (transactions.isEmpty) {
      return _buildEmptyState(
        selectedTab == 0 ? "No Buy Orders Found" : "No Sell Orders Found",
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(
          selectedTab == 0 ? p2pBuyHistoryProvider : p2pSellProvider,
        );
      },
      child: ListView.separated(
        padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 20.h),
        itemCount: transactions.length,
        separatorBuilder: (context, index) => SizedBox(height: 12.h),
        itemBuilder: (context, index) {
          final item = transactions[index];
          return InkWell(
            onTap: () {
              selectedTab == 0
                  ? Navigator.push(
                    context,
                    RightSlideFadeRoute(
                      page: P2pBuySellHistoryDetails(id: item.id),
                    ),
                  )
                  : Navigator.push(
                    context,
                    RightSlideFadeRoute(
                      page: P2pSellHistoryDetailsPage(sellData: item),
                    ),
                  );
            },
            child: TransactionCard(
              isBuy: selectedTab == 0,
              title: item.name ?? "Market",
              subtitle: item.counterParty?.name ?? "Unknown User",
              rate: "₹${item.rate ?? 0}/unit",
              amount:
                  "${selectedTab == 0 ? '+' : '-'}${item.amount ?? 0} ${item.walletType ?? 'USDT'}",
              date: _formatTimestamp(item.createdAt),
              status: item.status?.toUpperCase() ?? "PENDING",
            ),
          );
        },
      ),
    );
  }

  String _formatTimestamp(dynamic timestamp) {
    if (timestamp == null) return "N/A";
    try {
      final dt = DateTime.fromMillisecondsSinceEpoch(
        timestamp is String ? int.parse(timestamp) : timestamp,
      );
      return DateFormat('dd MMM yyyy, hh:mm a').format(dt);
    } catch (e) {
      return "Invalid Date";
    }
  }

  /// 🛠 RESPONSIVE TOGGLE SWITCH
  Widget _buildToggleSwitch(WidgetRef ref, int selectedTab) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        color: const Color(0xFF141E2D),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          _toggleButton(
            title: "BUY ORDERS",
            icon: Icons.south_west,
            isActive: selectedTab == 0,
            onTap: () {
              ref.read(p2pTabProvider.notifier).state = 0;
              ref.invalidate(p2pBuyHistoryProvider);
            },
            activeColor: const Color(0xFF00E676),
          ),
          SizedBox(width: 5.w),
          _toggleButton(
            title: "SELL ORDERS",
            icon: Icons.north_east,
            isActive: selectedTab == 1,
            onTap: () {
              ref.read(p2pTabProvider.notifier).state = 1;
              ref.invalidate(p2pSellProvider);
            },
            activeColor: const Color(0xFFF05351),
          ),
        ],
      ),
    );
  }

  Widget _toggleButton({
    required String title,
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
    required Color activeColor,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            color: isActive ? activeColor : Colors.transparent,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 14.sp),
              SizedBox(width: 8.w),
              Text(
                title,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(String msg) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history_rounded, color: Colors.white10, size: 60.sp),
          SizedBox(height: 10.h),
          Text(
            msg,
            style: GoogleFonts.poppins(color: Colors.white38, fontSize: 13.sp),
          ),
        ],
      ),
    );
  }
}

class TransactionCard extends StatelessWidget {
  final bool isBuy;
  final String title;
  final String subtitle;
  final String rate;
  final String amount;
  final String date;
  final String status;

  const TransactionCard({
    super.key,
    required this.isBuy,
    required this.title,
    required this.subtitle,
    required this.rate,
    required this.amount,
    required this.date,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final themeColor =
        isBuy ? const Color(0xFF00E676) : const Color(0xFFF05351);
    final iconBg = isBuy ? const Color(0xFF161B22) : const Color(0xFF23141A);

    Color statusColor;
    String statusText;

    switch (status.toLowerCase()) {
      case "pending":
        statusColor = const Color(0xFFF59E0B);
        statusText = "Pending";
        break;

      case "process":
      case "processing":
        statusColor = const Color(0xFF3B82F6);
        statusText = "Processing";
        break;

      case "approve":
        statusColor = const Color(0xFF00FF9D);
        statusText = "Complete"; // 👈 yahi change chahiye tha
        break;

      case "reject":
        statusColor = const Color(0xFFEF4444);
        statusText = "Rejected";
        break;

      case "cancel":
        statusColor = const Color(0xFF9CA3AF);
        statusText = "Cancelled";
        break;

      case "expired":
        statusColor = const Color(0xFFEF4444);
        statusText = "Expired";
        break;

      default:
        statusColor = Colors.white54;
        statusText = status;
    }

    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1117),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          // Dynamic Icon based on Buy/Sell
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: themeColor.withOpacity(0.2)),
            ),
            child: Icon(
              isBuy ? Icons.call_received : Icons.north_east,
              color: themeColor,
              size: 20.sp,
            ),
          ),
          SizedBox(width: 12.w),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "$subtitle • $rate",
                  style: GoogleFonts.poppins(
                    color: Colors.white60,
                    fontSize: 12.sp,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  date,
                  style: GoogleFonts.poppins(
                    color: Colors.white38,
                    fontSize: 10.sp,
                  ),
                ),
              ],
            ),
          ),

          // Amount & Status
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: GoogleFonts.poppins(
                  color: themeColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: statusColor.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.access_time, color: statusColor, size: 10.sp),
                    SizedBox(width: 4.w),
                    Text(
                      statusText,
                      style: GoogleFonts.poppins(
                        color: statusColor,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
