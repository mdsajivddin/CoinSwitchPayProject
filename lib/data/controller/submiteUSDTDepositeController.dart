import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payment_app/Screen/home.page.dart';
import 'package:payment_app/config/auth/router/rightsliderFageRoute.dart';
import 'package:payment_app/config/network/api.network.dart';
import 'package:payment_app/config/utils/pretty.dio.dart';
import 'package:payment_app/config/utils/showMessage.dart';
import 'package:payment_app/data/model/submitUSDTDEpositeResModel.dart';
import 'package:payment_app/data/model/submiteUSDTDepositeBodyModel.dart';

class SubmitUSDTDepositeController
    extends StateNotifier<AsyncValue<SubmitUsdtDepositeResModel?>> {
  final Ref ref;
  SubmitUSDTDepositeController(this.ref) : super(const AsyncValue.data(null));

  Future<void> submitUSDTDeposite({
    required BuildContext context,
    required String hash,
    required String depositId,
    required File screenshot,
      required String pin,
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
      final body = SubmitUsdtDepositeBodyModel(
        depositId: depositId,
        hash: hash,
        image: image,
        pin: pin
      );

      final response = await service.submiteUSDTDeposite(body);

      // SAHI LOGIC: Agar error false hai aur code 0 hai (Success)
      if (response.error == false && response.code == 0) {
        state = AsyncValue.data(response);

        // Success hone par Home par bhejein
        Navigator.pushAndRemoveUntil(
          context,
          RightSlideFadeRoute(page: const HomeBottomNav()),
          (route) => false,
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

      if (e is DioException) {
        final errorMessage =
            e.response?.data?["message"] ?? "Network error occurred";
        ShowMessage.error(context, errorMessage);
      } else {
        ShowMessage.error(context, "An unexpected error occurred");
      }
    }
  }
}

final submiteUSDTDepositeProvider = StateNotifierProvider<
  SubmitUSDTDepositeController,
  AsyncValue<SubmitUsdtDepositeResModel?>
>((ref) => SubmitUSDTDepositeController(ref));
