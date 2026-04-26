import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payment_app/config/network/api.network.dart';
import 'package:payment_app/config/utils/pretty.dio.dart';
import 'package:payment_app/config/utils/showMessage.dart';
import 'package:payment_app/data/model/cancelINRBodyModel.dart';
import 'package:payment_app/data/model/cancelINRResModel.dart';

class CancelINRDepositeController
    extends StateNotifier<AsyncValue<CancelInrDepositeResModel?>> {
  final Ref ref;

  CancelINRDepositeController(this.ref)
      : super(const AsyncValue.data(null));

  Future<bool> cancelINRDeposite({
    required BuildContext context,
    required String depositId,
  }) async {
    try {
      state = const AsyncLoading();

      final service = ApiNetwork(createDio());

      final body = CanceInrDepositeBodyModel(orderId: depositId);

      final response = await service.cancelINRDeposite(body);

      /// SUCCESS
      if (response.error == false && response.code == 0) {
        state = AsyncData(response);

        ShowMessage.success(context, response.message ?? "Deposit Cancelled");

        return true;
      }

      /// API ERROR
      state = AsyncData(response);

      ShowMessage.error(context, response.message ?? "Cancel failed");

      return false;
    } catch (e, st) {
      log("Cancel Deposit Error: $e");
      log("StackTrace: $st");

      state = AsyncError(e, st);

      if (e is DioException) {
        final errorMessage =
            e.response?.data?["message"] ?? "Network error occurred";
        ShowMessage.error(context, errorMessage);
      } else {
        ShowMessage.error(context, "Something went wrong");
      }

      return false;
    }
  }
}

final cancelINRDepositeProvider = StateNotifierProvider<
    CancelINRDepositeController,
    AsyncValue<CancelInrDepositeResModel?>>(
  (ref) => CancelINRDepositeController(ref),
);