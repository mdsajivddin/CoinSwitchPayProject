import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payment_app/Screen/home.page.dart';
import 'package:payment_app/config/auth/router/rightsliderFageRoute.dart';
import 'package:payment_app/config/network/api.network.dart';
import 'package:payment_app/config/utils/pretty.dio.dart';
import 'package:payment_app/config/utils/showMessage.dart';
import 'package:payment_app/data/model/cancelUSDTDepositeBodyMOdel.dart';
import 'package:payment_app/data/model/cancelUSDTDepositeResModel.dart';

class CancelUSDTDepositeController
    extends StateNotifier<AsyncValue<CancelUsdtDepositResModel?>> {
  final Ref ref;
  CancelUSDTDepositeController(this.ref) : super(const AsyncValue.data(null));

  Future<void> cancelUSDTDeposite({
    required BuildContext context,

    required String depositId,
  }) async {
    try {
      state = const AsyncValue.loading();
      final service = ApiNetwork(createDio());

      final body = CancelUsdtDepositBodyModel(depositId: depositId);

      final response = await service.cancelUSDTDeposite(body);

      // SAHI LOGIC: Agar error false hai aur code 0 hai (Success)
      if (response.error == false && response.code == 0) {
        state = AsyncValue.data(response);

        // Success hone par Home par bhejein
        Navigator.pushAndRemoveUntil(
          context,
          RightSlideFadeRoute(page: const HomeBottomNav()),
          (route) => false,
        );

        ShowMessage.success(context, response.message ?? "Cancel");
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

final cancelUSDTDepositeProvider = StateNotifierProvider<
  CancelUSDTDepositeController,
  AsyncValue<CancelUsdtDepositResModel?>
>((ref) => CancelUSDTDepositeController(ref));
