import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payment_app/config/network/api.network.dart';
import 'package:payment_app/config/utils/pretty.dio.dart';
import 'package:payment_app/config/utils/showMessage.dart';
import 'package:payment_app/data/controller/getUpiController.dart';
import 'package:payment_app/data/model/upiDelete.dart';

class DeleteUpiState {
  final String? deletingId;
  final UpiDeleteResModel? response;

  DeleteUpiState({this.deletingId, this.response});

  DeleteUpiState copyWith({String? deletingId, UpiDeleteResModel? response}) {
    return DeleteUpiState(
      deletingId: deletingId,
      response: response ?? this.response,
    );
  }
}

final apiProvider = Provider<ApiNetwork>((ref) {
  final dio = createDio();
  return ApiNetwork(dio);
});

class DeleteUpiController extends StateNotifier<DeleteUpiState> {
  final Ref ref;

  DeleteUpiController(this.ref) : super(DeleteUpiState());

  Future<void> deleteUpi({
    required BuildContext context,
    required String id,
  }) async {
    try {
      /// 👉 sirf current id ko loading set karo
      state = state.copyWith(deletingId: id);

      final body = UpiDeleteBodyModel(id: id);
      final response = await ref.read(apiProvider).deleteUpi(body);

      if (response.code == 0 || response.error == false) {
        ShowMessage.success(context, response.message ?? "");
        ref.invalidate(getUpiController);
      } else {
        ShowMessage.error(context, response.message ?? "Error Failed");
      }

      /// 👉 loading remove
      state = DeleteUpiState();
    } catch (e, st) {
      log(e.toString());
      log(st.toString());

      state = DeleteUpiState();
      ShowMessage.error(context, "An unexpected error occurred");
    }
  }
}

final deleteUpiProvider =
    StateNotifierProvider<DeleteUpiController, DeleteUpiState>(
      (ref) => DeleteUpiController(ref),
    );
