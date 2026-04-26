import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payment_app/config/network/api.network.dart';
import 'package:payment_app/config/utils/pretty.dio.dart';
import 'package:payment_app/config/utils/showMessage.dart';
import 'package:payment_app/data/controller/getUpiController.dart';
import 'package:payment_app/data/model/createUpiModel.dart';

final apiProvider = Provider<ApiNetwork>((ref) {
  final dio = createDio();
  return ApiNetwork(dio);
});

class CreateUpiController
    extends StateNotifier<AsyncValue<CreateUpiResModel?>> {
  final Ref ref;
  CreateUpiController(this.ref) : super(const AsyncValue.data(null));

  Future<void> createUpi({
    required BuildContext context,
    required String upi,
    required String name,
  }) async {
    try {
      state = AsyncValue.loading();
      final body = CreateUpiBodyModel(upi: upi, name: name);
      final response = await ref.read(apiProvider).createUpi(body);
      if (response.code == 0 || response.error == false) {
        state = AsyncValue.data(response);
        ShowMessage.success(context, response.message ?? "");
        ref.invalidate(getUpiController);
        Navigator.pop(context);
        state = AsyncValue.data(null);
      } else {
        final errorMessage =
            response.message?.trim() ?? "Failed to add UPI. Please try again.";

        state = AsyncValue.data(null);
        ShowMessage.error(context, errorMessage);
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

final createUpiProvider =
    StateNotifierProvider<CreateUpiController, AsyncValue<CreateUpiResModel?>>(
      (ref) => CreateUpiController(ref),
    );
