import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payment_app/Screen/login.page.dart';
import 'package:payment_app/config/auth/router/rightsliderFageRoute.dart';
import 'package:payment_app/config/network/api.network.dart';
import 'package:payment_app/config/utils/pretty.dio.dart';
import 'package:payment_app/config/utils/showMessage.dart';
import 'package:payment_app/data/model/forgotPassBodyModel.dart';
import 'package:payment_app/data/model/forgotPassResModel.dart';

final apiProvider = Provider<ApiNetwork>((ref) {
  final dio = createDio();
  return ApiNetwork(dio);
});

class ForgotPassController
    extends StateNotifier<AsyncValue<ForgotPassResModel?>> {
  final Ref ref;
  ForgotPassController(this.ref) : super(const AsyncValue.data(null));

  Future<void> forgotPasswrod({
    required BuildContext context,
    required String token,
    required String otp,
    required String pass,
    required String confirmpass,
    String? image,
    String? hash,
  }) async {
    try {
      state = AsyncValue.loading();
      final body = ForgotPassBodyModel(
        token: token,
        otp: otp,
        newPassword: pass,
        confirmPassword: confirmpass,
      );
      final response = await ref.read(apiProvider).forgotPassword(body);
      if (response.code == 0 || response.error == false) {
        state = AsyncValue.data(response);
        ShowMessage.success(context, response.message ?? "");
        Navigator.pushAndRemoveUntil(
          context,
          RightSlideFadeRoute(page: LoginPage()),
          (route) => false,
        );
        state = AsyncValue.data(null);
      } else {
        state = AsyncValue.data(null);
        ShowMessage.error(context, response.message ?? "Error Failed");
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

final forgotPassProvider = StateNotifierProvider<
  ForgotPassController,
  AsyncValue<ForgotPassResModel?>
>((ref) => ForgotPassController(ref));
