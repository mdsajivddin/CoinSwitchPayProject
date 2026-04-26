import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:payment_app/Screen/home.page.dart';
import 'package:payment_app/Screen/noInternet.page.dart';
import 'package:payment_app/Screen/splash.page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payment_app/config/utils/globalKey.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox("userdata");
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late StreamSubscription<List<ConnectivityResult>> _subscription;
  bool isOfflineShown = false;

  @override
  void initState() {
    super.initState();
    // 1. App khulne par pehle se check karein (Initial check)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkCurrentStatus();
    });

    // 2. Connectivity listener
    _subscription = Connectivity().onConnectivityChanged.listen((results) {
      _handleConnectivityChange(results);
    });
  }

  // Initial check ke liye function
  Future<void> _checkCurrentStatus() async {
    List<ConnectivityResult> result = await Connectivity().checkConnectivity();
    _handleConnectivityChange(result);
  }

  Future<void> _handleConnectivityChange(
    List<ConnectivityResult> results,
  ) async {
    final hasConnection = results.any(
      (result) => result != ConnectivityResult.none,
    );
    bool hasInternet = false;

    if (hasConnection) {
      hasInternet = await checkInternet();
    }

    if (!hasInternet) {
      if (!isOfflineShown) {
        isOfflineShown = true;
        // navigatorKey ka use karke push karein
        navigatorKey.currentState?.pushNamed("/NoInternetPage");
      }
    } else {
      if (isOfflineShown) {
        isOfflineShown = false;
        // Jab internet aa jaye to NoInternetPage ko hata dein
        if (navigatorKey.currentState?.canPop() ?? false) {
          navigatorKey.currentState?.popUntil((route) => route.isFirst);
        }
      }
    }
  }

  Future<bool> checkInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var box = Hive.box("userdata");
    var token = box.get("token");
    log("Bearer Token : - ${token ?? "No Token Found"}");
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      splitScreenMode: true,
      minTextAdapt: true,
      builder: (context, child) {
        return MaterialApp(
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          title: 'CoinSwitchPay',
          theme: ThemeData(
            // This is the theme of your application.
            //
            // TRY THIS: Try running your application with "flutter run". You'll see
            // the application has a purple toolbar. Then, without quitting the app,
            // try changing the seedColor in the colorScheme below to Colors.green
            // and then invoke "hot reload" (save your changes or press the "hot
            // reload" button in a Flutter-supported IDE, or press "r" if you used
            // the command line to start the app).
            //
            // Notice that the counter didn't reset back to zero; the application
            // state is not lost during the reload. To reset the state, use hot
            // restart instead.
            //
            // This works for code too, not just values: Most code changes can be
            // tested with just a hot reload.
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          ),
          // --- ROUTES ADDED HERE ---
          initialRoute: token == null ? '/splash' : '/home',
          routes: {
            '/splash': (context) => const SplashPage(),
            '/home': (context) => const HomeBottomNav(),
            '/NoInternetPage': (context) => NoInternetPage(),
          },

          // home: token == null ? SplashPage() : HomeBottomNav(),
        );
      },
    );
  }
}
