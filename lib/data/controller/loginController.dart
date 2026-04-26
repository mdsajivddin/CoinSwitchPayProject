import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payment_app/Screen/loginVerifyOtp.dart';
import 'package:payment_app/Screen/otp.page.dart';
import 'package:payment_app/config/auth/router/rightsliderFageRoute.dart';
import 'package:payment_app/config/network/api.network.dart';
import 'package:payment_app/config/utils/pretty.dio.dart';
import 'package:payment_app/config/utils/showMessage.dart';
import 'package:payment_app/data/model/loginBodyModel.dart';
import 'package:payment_app/data/model/loginResModel.dart';

final apiProvider = Provider<ApiNetwork>((ref) {
  final dio = createDio();
  return ApiNetwork(dio);
});

final loginProvider =
    StateNotifierProvider<LoginController, AsyncValue<LoginResModel?>>(
      (ref) => LoginController(ref),
    );

class LoginController extends StateNotifier<AsyncValue<LoginResModel?>> {
  final Ref ref;
  LoginController(this.ref) : super(const AsyncValue.data(null));

  Future<void> login({
    required String email,
    required String pass,

    required BuildContext context,
  }) async {
    try {
      state = const AsyncValue.loading();
      final body = LoginBodyModel(loginType: email, password: pass);
      final response = await ref.read(apiProvider).login(body);

      if (response.code == 0 || response.error == false) {
        state = AsyncValue.data(response);
        Navigator.push(
          context,
          RightSlideFadeRoute(
            page: LoginVerifyOtp(
              token: response.data!.token!,
              email: email,
              pass: pass,
            ),
          ),
        );
      } else {
        // Message dikhane ke baad state ko reset karein taaki spinner ruk jaye
        state = AsyncValue.data(null);
        ShowMessage.error(context, response.message ?? "Login Failed");
      }
    } catch (e, st) {
      state = AsyncValue.data(
        null,
      ); // Error hone par bhi state reset karein taaki button wapas aa jaye
      log(e.toString());
      ShowMessage.error(context, "An unexpected error occurred");
    }
  }
}
