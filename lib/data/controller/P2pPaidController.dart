import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payment_app/Screen/p2pBuySellTransationHistory.page.dart';
import 'package:payment_app/Screen/paymentRecive.page.dart';
import 'package:payment_app/config/auth/router/rightsliderFageRoute.dart';
import 'package:payment_app/config/network/api.network.dart';
import 'package:payment_app/config/utils/pretty.dio.dart';
import 'package:payment_app/config/utils/showMessage.dart';
import 'package:payment_app/data/controller/buyP2pListController.dart';
import 'package:payment_app/data/controller/getp2pTrasationSellController.dart';
import 'package:payment_app/data/model/p2pPaidBodyModel.dart';
import 'package:payment_app/data/model/p2pPaidResModel.dart';

class P2pPaidController extends StateNotifier<AsyncValue<P2PPaidResModel?>> {
  final Ref ref;
  P2pPaidController(this.ref) : super(const AsyncValue.data(null));

  Future<void> p2pPaid({
    required BuildContext context,
    required String hash,
    required String depositId,
    required File screenshot,
    required String pin,
    required String methodId,
  }) async {
    try {
      state = const AsyncValue.loading();
      final service = ApiNetwork(createDio());

      // 1. Pehle image upload karein
      final imageResponse = await service.uploadImage(screenshot);

      // SAHI LOGIC: Agar error true hai YA code 0 nahi hai, tabhi error dikhayein.
      // Lekin aapke case mein code: 0 hi SUCCESS hai.
      if (imageResponse.error == true) {
        state = const AsyncValue.data(null);
        ShowMessage.error(
          context,
          imageResponse.message ?? "Image upload failed",
        );
        return;
      }

      // Agar yahan tak aaya hai, matlab image upload ho chuki hai
      final String image = imageResponse.data?.imageUrl ?? "";

      // 2. Deposit data submit karein
      final body = P2PPaidBodyModel(
        orderId: depositId,
        hash: hash,
        image: image,
        pin: pin,
        methodId: methodId,
      );

      final response = await service.p2pPaid(body);

      // SAHI LOGIC: Agar error false hai aur code 0 hai (Success)
      if (response.error == false && response.code == 0) {
        state = AsyncValue.data(response);

        ref.read(p2pTabProvider.notifier).state = 0;
        ref.invalidate(p2pBuyHistoryProvider);
        ref.read(buyP2pListProvider.notifier).fetchP2PBuyList();
        Navigator.pushAndRemoveUntil(
          context,
          RightSlideFadeRoute(page: const P2pBuySellTransationHistoryPage()),
          ModalRoute.withName(
            '/home',
          ), // Home page ko stack mein rehne dega, baaki sab hata dega
        );

        ShowMessage.success(
          context,
          response.message ?? "Deposit submitted successfully",
        );
      } else {
        // Agar API error response deti hai (e.g. error: true)
        state = const AsyncValue.data(null);
        ShowMessage.error(context, response.message ?? "Submission failed");
      }
    } catch (e, st) {
      state = const AsyncValue.data(null);
      log("Error: $e");
      log("Stacktrace: $st");
    }
  }
}

final p2pPaidProvider =
    StateNotifierProvider<P2pPaidController, AsyncValue<P2PPaidResModel?>>(
      (ref) => P2pPaidController(ref),
    );
