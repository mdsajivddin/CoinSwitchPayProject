import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payment_app/config/network/api.network.dart';
import 'package:payment_app/config/utils/pretty.dio.dart';
import 'package:payment_app/data/model/sendOTPForgotPinRes.dart';

class ForgotPinSendOTPController
    extends StateNotifier<AsyncValue<SendOtPforgotInRes>> {
  final Ref ref;

  ForgotPinSendOTPController(this.ref) : super(const AsyncValue.loading());

  Future<void> sendForgotPinOtp() async {
    try {
      state = const AsyncValue.loading();

      final service = ApiNetwork(createDio());
      final response = await service.forgotPinSendOTP();

      if (response.code == 0 && response.error == false) {
        state = AsyncValue.data(response);
      } else {
        state = AsyncValue.error(
          response.message ?? "Failed to send OTP",
          StackTrace.current,
        );
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final forgotPinSendOTPProvider = StateNotifierProvider<
  ForgotPinSendOTPController,
  AsyncValue<SendOtPforgotInRes>
>((ref) {
  return ForgotPinSendOTPController(ref);
});
