import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:payment_app/Screen/p2pOrderDetails.page.dart';
import 'package:payment_app/Screen/p2pSellOrder.page.dart';
import 'package:payment_app/config/auth/router/rightsliderFageRoute.dart';
import 'package:payment_app/config/network/p2pSocketService.dart';
import 'package:payment_app/data/controller/getP2pExitBuyController.dart';
import 'package:socket_io_client/socket_io_client.dart';

class P2pPage extends ConsumerStatefulWidget {
  const P2pPage({super.key});

  @override
  ConsumerState<P2pPage> createState() => _P2pPageState();
}

class _P2pPageState extends ConsumerState<P2pPage> {
  final socketService = P2pSocketService();
  int selectedTab = 0; // 0 for BUY (User buys from Admin's SELL), 1 for SELL
  bool isLoading = true;
  String sortOrder = "asc";

  List<dynamic> buyList = [];
  List<dynamic> sellList = [];

  // Logic: User BUY tab = Admin SELL data | User SELL tab = Admin BUY data
  // String get socketRequestType => selectedTab == 0 ? "BUY" : "SELL";
  String get socketRequestType => selectedTab == 0 ? "SELL" : "BUY";
  String get exitRequestType => selectedTab == 0 ? "BUY" : "SELL";

  @override
  void initState() {
    super.initState();

    socketService.connect();
    fetchListings();
    listenRealtimeUpdate();

    Future.microtask(() {
      ref.read(getP2pExitBuyProvider.notifier).getP2pExiteBuy(exitRequestType);
    });

    socketService.socket.onConnect((_) {
      if (!mounted) return;
      fetchListings();
    });
  }

  List _sortData(List list) {
    List sorted = List.from(list);

    sorted.sort((a, b) {
      final aAmount = double.tryParse(a["amount"].toString()) ?? 0;
      final bAmount = double.tryParse(b["amount"].toString()) ?? 0;

      return sortOrder == "asc"
          ? aAmount.compareTo(bAmount)
          : bAmount.compareTo(aAmount);
    });

    return sorted;
  }

  void fetchListings() async {
    if (!mounted) return;

    try {
      final response = await socketService.getP2PBuyOrSellList(
        txType: socketRequestType,
        sortOrder: sortOrder,
        page: 1,
        limit: 10,
      );

      final list = response["data"]["list"] ?? [];

      setState(() {
        if (selectedTab == 0) {
          buyList = _sortData(list);
        } else {
          sellList = _sortData(list);
        }

        isLoading = false;
      });
    } catch (e) {
      log("Fetch Error $e");

      setState(() {
        isLoading = false;
      });
    }
  }

  void listenRealtimeUpdate() {
    socketService.listenP2pUpdate((payload) {
      if (!mounted) return;
      String jsonResponse = JsonEncoder.withIndent('  ').convert(payload);
      log("🔥 REALTIME UPDATE RECEIVED");
      print("🔥 REALTIME EVENT RECEIVED\n$jsonResponse");

      fetchListings();
    });
  }

  void changeTab(int index) {
    if (selectedTab == index) return;
    setState(() {
      selectedTab = index;
      isLoading = true;
    });

    fetchListings();
    ref.read(getP2pExitBuyProvider.notifier).getP2pExiteBuy(
      // socketRequestType,
      exitRequestType
      );
  }

  @override
  void dispose() {
    socketService.socket.off("P2PBuyOrSellListUpdated");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentList = selectedTab == 0 ? buyList : sellList;
    final getP2pExitBuyState = ref.watch(getP2pExitBuyProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF09111C),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),

              /// HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "P2P Market",
                    style: GoogleFonts.poppins(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20.h),

              /// TAB
              Row(children: [_tabButton("Buy", 0), _tabButton("Sell", 1)]),

              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        sortOrder = sortOrder == "asc" ? "desc" : "asc";
                        isLoading = true;
                      });

                      fetchListings();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                        color: Colors.white.withOpacity(0.08),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            sortOrder == "asc"
                                ? Icons.arrow_upward
                                : Icons.arrow_downward,
                            size: 16,
                            color: const Color(0xFF06CE8F),
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            sortOrder == "asc" ? "Low → High" : "High → Low",
                            style: GoogleFonts.poppins(
                              fontSize: 12.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  getP2pExitBuyState.when(
                    data: (data) {
                      final status = data.data!.status == false;

                      /// ❌ Status false → Hide Full Widget
                      if (status) {
                        return const SizedBox();
                      }
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Align(
                            alignment: Alignment.centerRight,
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  RightSlideFadeRoute(
                                    page:
                                        selectedTab == 0
                                            ? P2POrderDetailPage(
                                              id:
                                                  data.data!.lastData!.id
                                                      .toString(),
                                            )
                                            : P2PSellOrderPage(
                                              id:
                                                  data.data!.lastData!.id
                                                      .toString(),
                                            ),
                                  ),
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 14.w,
                                  vertical: 6.h,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.r),
                                  color: const Color(0xFF06CE8F),
                                ),
                                child: Text(
                                  "Processing",
                                  style: GoogleFonts.poppins(
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                    error: (error, stackTrace) {
                      log(stackTrace.toString());
                      return Center(
                        child: Text(
                          error.toString(),
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    },
                    loading:
                        () => SizedBox(
                          width: 20.w,
                          height: 20.h,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 1.5,
                            ),
                          ),
                        ),
                  ),
                ],
              ),

              SizedBox(height: 20.h),

              /// LIST
              Expanded(
                child:
                    isLoading
                        ? const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF06CE8F),
                          ),
                        )
                        : currentList.isEmpty
                        ? const Center(
                          child: Text(
                            "No Orders Found",
                            style: TextStyle(color: Colors.white54),
                          ),
                        )
                        : ListView.builder(
                          itemCount: currentList.length,
                          itemBuilder: (context, index) {
                            final item = currentList[index];

                            final methods =
                                (item['paymentMethods'] as List?)
                                    ?.map((m) => m['methodType'] ?? "")
                                    .toList() ??
                                [];

                            return TraderCard(
                              name: item['name'] ?? "",
                              rate: item['rate'].toString(),
                              amount: item['amount'].toString(),
                              type: item['walletType'] ?? "",
                              paymentMethods: List<String>.from(methods),
                              avatarColor: const Color(0xFF06CE8F),
                              btnText: selectedTab == 0 ? "Buy" : "Sell",
                              callback: () {
                                Navigator.push(
                                  context,
                                  RightSlideFadeRoute(
                                    page:
                                        selectedTab == 0
                                            ? P2POrderDetailPage(
                                              id: item["_id"],
                                            )
                                            : P2PSellOrderPage(id: item["_id"]),
                                  ),
                                );
                              },
                            );
                          },
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tabButton(String title, int index) {
    final isSelected = selectedTab == index;
    Color bgColor;

    if (isSelected) {
      bgColor = index == 0 ? const Color(0xFF06CE8F) : const Color(0xFFF05351);
    } else {
      bgColor = Colors.white.withOpacity(0.05);
    }

    return Expanded(
      child: GestureDetector(
        onTap: () => changeTab(index),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          decoration: BoxDecoration(
            color: bgColor,
            // isSelected
            //     ? const Color(0xFF06CE8F)
            //     : Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(title, style: const TextStyle(color: Colors.white)),
          ),
        ),
      ),
    );
  }
}

// TraderCard implementation remains the same...

class TraderCard extends StatelessWidget {
  final String name;
  final String rate;
  final String amount;
  final List<String> paymentMethods;
  final Color avatarColor;
  final String btnText;
  final String type;
  final VoidCallback callback;

  const TraderCard({
    super.key,
    required this.name,
    required this.rate,
    required this.amount,
    required this.paymentMethods,
    required this.avatarColor,
    required this.btnText,
    required this.type,
    required this.callback,
  });

  @override
  Widget build(BuildContext context) {
    final bool isBuy = btnText.toLowerCase() == "buy";

    final List<Color> gradientColors =
        isBuy
            ? [const Color(0xFF06CE8F), const Color(0xFF05B47A)] // Buy
            : [const Color(0xFFF05351), const Color(0xFFD94343)]; // Sell

    final Color shadowColor =
        isBuy ? const Color(0xFF06CE8F) : const Color(0xFFF05351);

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.07),
            Colors.white.withOpacity(0.02),
          ],
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(radius: 5.r, backgroundColor: avatarColor),
                    SizedBox(width: 10.w),
                    Flexible(
                      child: Text(
                        name,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 15.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(width: 6.w),
                    const Icon(
                      Icons.verified,
                      color: Color(0xFF06CE8F),
                      size: 14,
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Text(
                      "Rate: ",
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF9CA3AF),
                        fontSize: 13.sp,
                      ),
                    ),
                    Text(
                      "₹$rate",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ),
                Text(
                  "Available: $amount $type",
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF6B7280),
                    fontSize: 12.sp,
                  ),
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Wrap(
                      spacing: 8.w,
                      runSpacing: 4.h,
                      children:
                          paymentMethods.map((method) {
                            final isFirst = paymentMethods.indexOf(method) == 0;
                            return _paymentTag(
                              method,
                              isFirst
                                  ? const Color(0xFF06CE8F)
                                  : Colors.white70,
                            );
                          }).toList(),
                    ),
                    SizedBox(width: 8.w),
                  ],
                ),
              ],
            ),
          ),

          // --- Action Button ---
          Container(
            constraints: BoxConstraints(minWidth: 80.w, maxWidth: 100.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.r),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF06CE8F), Color(0xFF05B47A)],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF06CE8F).withOpacity(0.3),
                  blurRadius: 10.r,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(15.r),
              child: InkWell(
                borderRadius: BorderRadius.circular(15.r),
                onTap: callback,
                splashColor: Colors.white.withOpacity(0.2),
                highlightColor: Colors.white.withOpacity(0.1),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.r),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: gradientColors,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: shadowColor.withOpacity(0.3),
                        blurRadius: 10.r,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  constraints: BoxConstraints(minHeight: 40.h),
                  child: Text(
                    btnText,
                    style: GoogleFonts.poppins(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _paymentTag(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          color: color,
          fontSize: 10.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
