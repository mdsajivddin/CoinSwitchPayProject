import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payment_app/config/network/api.network.dart';
import 'package:payment_app/config/utils/pretty.dio.dart';
import 'package:payment_app/config/utils/showMessage.dart';
import 'package:payment_app/data/controller/getUpiController.dart';
import 'package:payment_app/data/model/updateUpiStatus.dart';

final apiProvider = Provider<ApiNetwork>((ref) {
  final dio = createDio();
  return ApiNetwork(dio);
});
final updateUpiStatusProvider = StateNotifierProvider<
  UpdateUpiStatusController,
  AsyncValue<UpdateUpiStatusResModel?>
>((ref) => UpdateUpiStatusController(ref));

class UpdateUpiStatusController
    extends StateNotifier<AsyncValue<UpdateUpiStatusResModel?>> {
  final Ref ref;
  UpdateUpiStatusController(this.ref) : super(const AsyncValue.data(null));

  Future<void> updateUpiStatus({
    required BuildContext context,
    required String upiId,
    required bool isDisable,
  }) async {
    try {
      state = const AsyncValue.loading();
      final body = UpdateUpiStatusBodyModel(upiId: upiId, isDisable: isDisable);

      final service = ApiNetwork(createDio());

      final response = await service.updateUpiStatus(body);

      if (response.code == 0 || response.error == false) {
        state = const AsyncValue.data(null);
        ref.invalidate(getUpiController);
        ShowMessage.success(
          context,
          isDisable ? "UPI Disabled Successfully" : "UPI Enabled Successfully",
        );
        Navigator.pop(context);
      } else {
        state = const AsyncValue.data(null);
        ShowMessage.success(context, response.message ?? "Error");
      }
    } catch (e, st) {
      state = const AsyncValue.data(null);
      debugPrint(e.toString());
      debugPrint(st.toString());

      ShowMessage.error(context, "Something went wrong");
    }
  }
}
