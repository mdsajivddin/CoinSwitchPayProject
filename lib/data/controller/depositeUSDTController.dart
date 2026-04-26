import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payment_app/Screen/depositeUSDDetails.page.dart';
import 'package:payment_app/config/auth/router/rightsliderFageRoute.dart';
import 'package:payment_app/config/network/api.network.dart';
import 'package:payment_app/config/utils/pretty.dio.dart';
import 'package:payment_app/config/utils/showMessage.dart';
import 'package:payment_app/data/model/depositeUSDTBodyModel.dart';
import 'package:payment_app/data/model/depositeUSDTResModel.dart';

final apiProvider = Provider<ApiNetwork>((ref) {
  final dio = createDio();
  return ApiNetwork(dio);
});

class USDTDepositeController
    extends StateNotifier<AsyncValue<DepositeUsdtResModel?>> {
  final Ref ref;
  USDTDepositeController(this.ref) : super(const AsyncValue.data(null));

  Future<void> createUSDTDeposite({
    required BuildContext context,
    required int ammount,
    required String network,
    required String pin,
  }) async {
    try {
      state = AsyncValue.loading();
      final body = DepositeUsdtBodyModel(
        amount: ammount,
        network: network,
        pin: pin,
      );
      final response = await ref.read(apiProvider).createUSDTDeposite(body);
      if (response.code == 0 || response.error == false) {
        state = AsyncValue.data(response);
        Navigator.push(
          context,
          RightSlideFadeRoute(
            page: DepositUsdtDetailsPage(
              walletAddress: response.data!.walletAddress.toString(),
              network: response.data!.network.toString(),
              depositeId: response.data!.depositId.toString(),
              amount: response.data!.amount.toString(),
              expireAt: response.data!.expiresAt!.millisecondsSinceEpoch,
            ),
          ),
        );

        ShowMessage.success(context, response.message ?? "");
      } else {
        state = AsyncValue.data(null);
        ShowMessage.error(context, response.message ?? "Register Failed");
      }
    } catch (e, st) {
      state = AsyncValue.data(
        null,
      ); // Error hone par bhi state reset karein taaki button wapas aa jaye
      log(e.toString());
      log(st.toString());
      if (e is DioException) {
        final errorMessage =
            e.response?.data?["message"] ?? "Something went wrong";
        final erro = e.error ?? "";
        ShowMessage.error(context, errorMessage);
      } else {
        ShowMessage.error(context, "An unexpected error occurred");
      }
    }
  }
}

final usdtDepositeProvider = StateNotifierProvider<
  USDTDepositeController,
  AsyncValue<DepositeUsdtResModel?>
>((ref) => USDTDepositeController(ref));
