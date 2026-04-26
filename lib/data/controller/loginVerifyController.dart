import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:payment_app/Screen/home.page.dart';
import 'package:payment_app/config/auth/router/rightsliderFageRoute.dart';
import 'package:payment_app/config/network/api.network.dart';
import 'package:payment_app/config/utils/pretty.dio.dart';
import 'package:payment_app/config/utils/showMessage.dart';
import 'package:payment_app/data/controller/profileController.dart';
import 'package:payment_app/data/model/loginBodyModel.dart';
import 'package:payment_app/data/model/loginResModel.dart';
import 'package:payment_app/data/model/loginVerifyBodyModel.dart';
import 'package:payment_app/data/model/loginVerifyResModel.dart';

final apiProvider = Provider<ApiNetwork>((ref) {
  final dio = createDio();
  return ApiNetwork(dio);
});

final loginVerifyProvider = StateNotifierProvider<
  LoginVerifyController,
  AsyncValue<LoginVerifyResModel?>
>((ref) => LoginVerifyController(ref));

class LoginVerifyController
    extends StateNotifier<AsyncValue<LoginVerifyResModel?>> {
  final Ref ref;

  LoginVerifyController(this.ref) : super(const AsyncValue.data(null));

  Future<void> loginVerify({
    required String token,
    required String otp,
    required BuildContext context,
  }) async {
    try {
      state = const AsyncValue.loading();
      final body = LoginVerifyBodyModel(token: token, otp: otp);
      final response = await ref.read(apiProvider).loginVerify(body);

      if (response.code == 0 || response.error == false) {
        var box = Hive.box("userdata");
        await box.clear();
        await box.put("email", response.data!.email);
        await box.put("name", response.data!.name);
        await box.put("id", response.data!.id);
        await box.put("token", response.data!.token);
        state = AsyncValue.data(response);
        ref.invalidate(profileController);
        Navigator.pushAndRemoveUntil(
          context,
          RightSlideFadeRoute(page: HomeBottomNav()),
          (route) => false,
        );
      } else {
        state = AsyncValue.data(null);
        ShowMessage.error(context, response.message ?? "Login Verify Failed");
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

///////////////////////////// Resend OTP  ///////////////////////

final resendProvider =
    StateNotifierProvider<ResendController, AsyncValue<LoginResModel?>>(
      (ref) => ResendController(ref),
    );

class ResendController extends StateNotifier<AsyncValue<LoginResModel?>> {
  final Ref ref;
  ResendController(this.ref) : super(const AsyncValue.data(null));

  Future<void> resend({
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
      } else {
        state = AsyncValue.data(null);
        ShowMessage.error(context, response.message ?? "Resend Failed");
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
