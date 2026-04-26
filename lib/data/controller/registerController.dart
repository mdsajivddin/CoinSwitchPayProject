import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payment_app/Screen/otp.page.dart';
import 'package:payment_app/config/auth/router/rightsliderFageRoute.dart';
import 'package:payment_app/config/network/api.network.dart';
import 'package:payment_app/config/utils/pretty.dio.dart';
import 'package:payment_app/config/utils/showMessage.dart';
import 'package:payment_app/data/model/registerBodyModel.dart';
import 'package:payment_app/data/model/registerResModel.dart';

final apiProvider = Provider<ApiNetwork>((ref) {
  final dio = createDio();
  return ApiNetwork(dio);
});

final userControllerProvider =
    StateNotifierProvider<RegisterController, AsyncValue<RegisterResModel?>>(
      (ref) => RegisterController(ref),
    );

class RegisterController extends StateNotifier<AsyncValue<RegisterResModel?>> {
  final Ref ref;

  RegisterController(this.ref) : super(const AsyncValue.data(null));

  Future<void> userRegister({
    required String name,
    required String email,
    required String mobile,
    required String passw,
    required String confirmPassword,
    required String refByCode,
    required String transactionPin,
    required BuildContext context,
  }) async {
    try {
      state = const AsyncValue.loading();
      final body = RegisterBodyModel(
        name: name,
        email: email,
        password: passw,
        confirmPassword: confirmPassword,
        mobile: mobile,
        transactionPin: transactionPin
        ,refByCode: refByCode,
      );
      final response = await ref.read(apiProvider).register(body);

      if (response.code == 0 || response.error == false) {
        state = AsyncValue.data(response);
        Navigator.pushAndRemoveUntil(
          context,
          RightSlideFadeRoute(
            page: OtpPage(
              token: response.data!.token!,
              email: email,
              name: name,
              pass: passw,

            ),
          ),
          (route) => false,
        );
      } else {
        state = AsyncValue.data(null);
        ShowMessage.error(context, response.message ?? "Register Failed");
      }
    } catch (e, st) {
      state = AsyncValue.data(
        null,
      ); // Error hone par bhi state reset karein taaki button wapas aa jaye
      log(e.toString());
      ShowMessage.error(context, "An unexpected error occurred");
    }
  }

  void reset() {
    state = const AsyncValue.data(null);
  }
}
