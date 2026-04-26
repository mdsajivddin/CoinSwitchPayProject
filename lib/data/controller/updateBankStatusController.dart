import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payment_app/config/network/api.network.dart';
import 'package:payment_app/config/utils/pretty.dio.dart';
import 'package:payment_app/config/utils/showMessage.dart';
import 'package:payment_app/data/controller/getAllBankController.dart';
import 'package:payment_app/data/model/updateBankStatusBodyModel.dart';
import 'package:payment_app/data/model/updateBankStatusResModel.dart';

final apiProvider = Provider<ApiNetwork>((ref) {
  final dio = createDio();
  return ApiNetwork(dio);
});

class UpdateBankStatusController
    extends StateNotifier<AsyncValue<UpdateBankStatuResModel?>> {
  final Ref ref;
  UpdateBankStatusController(this.ref) : super(const AsyncValue.data(null));

  Future<void> updateBankStatus({
    required BuildContext context,
    required String bankId,
    required bool isDisable,
  }) async {
    try {
      state = const AsyncValue.loading();
      final body = UpdateBankStatusBodyModel(
        bankId: bankId,
        isDisable: isDisable,
      );

      final service = ApiNetwork(createDio());

      final response = await service.updateBankStatus(body);

      if (response.code == 0 || response.error == false) {
        state = const AsyncValue.data(null);
        ref.invalidate(getBankListProvider);
        ShowMessage.success(context, response.message ?? "Successfully");
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

final updateBankStatusProvider = StateNotifierProvider<
  UpdateBankStatusController,
  AsyncValue<UpdateBankStatuResModel?>
>((ref) => UpdateBankStatusController(ref));
