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
import 'package:payment_app/data/model/submitINRDepositeBodyModel.dart';
import 'package:payment_app/data/model/submitINRDepositeResModel.dart';

class SubmitINRDepositeController
    extends StateNotifier<AsyncValue<SubmitInrDepositeResModel?>> {
  final Ref ref;
  SubmitINRDepositeController(this.ref) : super(const AsyncValue.data(null));

  Future<void> submitINRDeposite({
    required BuildContext context,
   required String UTR,
    required String depositId,
    required File screenshot,
    required String pin,
    required String rate,
    required String realAmount,
    required String upi,
    required String upiHolder,
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
      final body = SubmitInrDepositeBodyModel(
        orderId: depositId,
        hash: UTR,
        image: image,
        pin: pin,
        rate: rate,
        realAmount: realAmount,
        upi: upi,
        upiHolder: upiHolder,
      );

      final response = await service.submiteINRDeposite(body);

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

final submiteINRDepositeProvider = StateNotifierProvider<
  SubmitINRDepositeController,
  AsyncValue<SubmitInrDepositeResModel?>
>((ref) => SubmitINRDepositeController(ref));
