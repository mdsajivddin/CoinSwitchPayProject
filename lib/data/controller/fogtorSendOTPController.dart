import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payment_app/Screen/forgotPassowedOTP.page.dart';
import 'package:payment_app/config/auth/router/rightsliderFageRoute.dart';
import 'package:payment_app/config/network/api.network.dart';
import 'package:payment_app/config/utils/pretty.dio.dart';
import 'package:payment_app/config/utils/showMessage.dart';
import 'package:payment_app/data/model/forgotSendOTPResModel.dart';

final apiProvider = Provider<ApiNetwork>((ref) {
  final dio = createDio();
  return ApiNetwork(dio);
});

class ForgotSendOTPController
    extends StateNotifier<AsyncValue<ForgotSendOtpResModel?>> {
  final Ref ref;
  ForgotSendOTPController(this.ref) : super(const AsyncValue.data(null));

  Future<void> forgotSentOTP({
    required BuildContext context,
    required String email,
  }) async {
    try {
      state = AsyncValue.loading();
      final body = ForgotSendOtpBodyModel(loginType: email);
      final response = await ref.read(apiProvider).forgotSendOTP(body);
      if (response.code == 0 || response.error == false) {
        state = AsyncValue.data(response);
        ShowMessage.success(context, response.message ?? "");
        Navigator.push(
          context,
          RightSlideFadeRoute(
            page: ForgotPasswordOtpPage(token: response.data!.token!),
          ),
        );
        state = AsyncValue.data(null);
      } else {
        state = AsyncValue.data(null);
        ShowMessage.error(context, response.message ?? "Send OTP Failed");
      }
    } catch (e, st) {
      state = AsyncValue.data(
        null,
      ); // Error hone par bhi state reset karein taaki button wapas aa jaye
      log(e.toString());
      log(st.toString());
      ShowMessage.error(context, "An unexpected error occurred");
    }
  }
}

final forgotSendOTPCont = StateNotifierProvider<
  ForgotSendOTPController,
  AsyncValue<ForgotSendOtpResModel?>
>((ref) => ForgotSendOTPController(ref));
