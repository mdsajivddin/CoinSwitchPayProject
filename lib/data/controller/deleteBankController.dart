import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payment_app/config/network/api.network.dart';
import 'package:payment_app/config/utils/pretty.dio.dart';
import 'package:payment_app/config/utils/showMessage.dart';
import 'package:payment_app/data/controller/getAllBankController.dart';
import 'package:payment_app/data/model/deleteBankBodyModel.dart';
import 'package:payment_app/data/model/deleteBankResModel.dart';

final apiProvider = Provider<ApiNetwork>((ref) {
  final dio = createDio();
  return ApiNetwork(dio);
});

// StateNotifier ko AsyncValue ke saath update kiya taaki UI loading pakad sake
class DeleteBankController extends StateNotifier<AsyncValue<DeleteBankResModel?>> {
  final Ref ref;

  DeleteBankController(this.ref) : super(const AsyncValue.data(null));

  Future<void> deleteBank({
    required BuildContext context,
    required String bankId,
  }) async {
    try {
      // STEP 1: State ko loading set karo (Isse UI mein circular show hoga)
      state = const AsyncValue.loading();

      final body = DeleteBankBodyModel(bankId: bankId);
      final response = await ref.read(apiProvider).deleteBank(body);

      if (response.code == 0 || response.error == false) {
        // Success state set karo
        state = AsyncValue.data(response);

        // Check if context is still valid before using it
        if (context.mounted) {
          ShowMessage.success(context, response.message ?? "Bank removed successfully");
          ref.invalidate(getBankListProvider);
          Navigator.pop(context); // Screen se bahar jaane ke liye
        }
      } else {
        state = AsyncValue.data(null);
        if (context.mounted) {
          ShowMessage.error(context, response.message ?? "Failed to delete");
        }
      }
    } catch (e, st) {
      log(e.toString());
      log(st.toString());
      state = AsyncValue.error(e, st);
      
      if (context.mounted) {
        ShowMessage.error(context, "An unexpected error occurred");
      }
    }
  }
}

final deleteBankProvider =
    StateNotifierProvider<DeleteBankController, AsyncValue<DeleteBankResModel?>>(
  (ref) => DeleteBankController(ref),
);