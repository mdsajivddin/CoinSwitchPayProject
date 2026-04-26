import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:payment_app/Screen/home.page.dart';
import 'package:payment_app/Screen/otp.page.dart';
import 'package:payment_app/config/auth/router/rightsliderFageRoute.dart';
import 'package:payment_app/config/network/api.network.dart';
import 'package:payment_app/config/utils/pretty.dio.dart';
import 'package:payment_app/config/utils/showMessage.dart';
import 'package:payment_app/data/controller/profileController.dart';
import 'package:payment_app/data/model/registerBodyModel.dart';
import 'package:payment_app/data/model/registerResModel.dart';
import 'package:payment_app/data/model/registerVerifyBodyModel.dart';
import 'package:payment_app/data/model/registerVerifyResModel.dart';

final apiProvider = Provider<ApiNetwork>((ref) {
  final dio = createDio();
  return ApiNetwork(dio);
});

final registerVerifyProvider = StateNotifierProvider<
  RegisterVerifyController,
  AsyncValue<RegisterVerifyResModel?>
>((ref) => RegisterVerifyController(ref));

class RegisterVerifyController
    extends StateNotifier<AsyncValue<RegisterVerifyResModel?>> {
  final Ref ref;

  RegisterVerifyController(this.ref) : super(const AsyncValue.data(null));

  Future<void> registerVerify({
    required String token,

    required String otp,
    required BuildContext context,
  }) async {
    try {
      state = const AsyncValue.loading();
      final body = RegisterVerifyBodyModel(token: token, otp: otp);
      final response = await ref.read(apiProvider).registerVerify(body);

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
        // Message dikhane ke baad state ko reset karein taaki spinner ruk jaye
        state = AsyncValue.data(null);
        ShowMessage.error(
          context,
          response.message ?? "Register Verify Failed",
        );
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

//////////////////////////////  Resend Register ///////////////

final resendRegisterVerfiProvider = StateNotifierProvider<
  ResendRegisterController,
  AsyncValue<RegisterResModel?>
>((ref) => ResendRegisterController(ref));

class ResendRegisterController
    extends StateNotifier<AsyncValue<RegisterResModel?>> {
  final Ref ref;

  ResendRegisterController(this.ref) : super(const AsyncValue.data(null));

  Future<void> resendRegister({
    required String name,
    required String email,
    required String passw,
    required BuildContext context,
  }) async {
    try {
      state = const AsyncValue.loading();
      final body = RegisterBodyModel(name: name, email: email, password: passw);
      final response = await ref.read(apiProvider).register(body);

      if (response.code == 0 || response.error == false) {
        state = AsyncValue.data(response);
      } else {
        state = AsyncValue.data(null);
        ShowMessage.error(context, response.message ?? "Resend  Failed");
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
