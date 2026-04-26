import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payment_app/config/network/api.network.dart';
import 'package:payment_app/config/utils/pretty.dio.dart';
import 'package:payment_app/config/utils/showMessage.dart';
import 'package:payment_app/data/model/withdrawBodyModel.dart';
import 'package:payment_app/data/model/withdrawResModel.dart';

final apiProvider = Provider<ApiNetwork>((ref) {
  final dio = createDio();
  return ApiNetwork(dio);
});

class WithdrawTokenController
    extends StateNotifier<AsyncValue<WithdawResModel?>> {
  WithdrawTokenController() : super(AsyncValue.data(null));

  Future<void> withdawalForToken({
    required BuildContext context,
    required int ammount,
    required String pin,
    required String walletType,
  }) async {
    try {
      state = AsyncValue.loading();
      final body = WithdawBodyModel(
        amount: ammount,
        pin: pin,
        walletType: walletType,
      );
      final serivce = ApiNetwork(createDio());
      final response = await serivce.withdrawForToken(body);
      if (response.data == 0 || response.error == false) {
        state = AsyncValue.data(response);
        ShowMessage.success(
          context,
          response.message ?? "Withdrawal Requiest Send",
        );
        Navigator.pop(context);
      } else {
        state = AsyncValue.data(null);
        final message =
            response.message == "Access denied"
                ? "Incorrect PIN"
                : response.message ?? "Incorrect";
        ShowMessage.error(context, message);
      }
    } catch (e, st) {
      state = AsyncValue.data(null);
      log(e.toString());
      log(st.toString());
      ShowMessage.error(context, "An unexpected error occurred");
    }
  }
}

final withdrawalTokenProvider = StateNotifierProvider<
  WithdrawTokenController,
  AsyncValue<WithdawResModel?>
>((ref) => WithdrawTokenController());
