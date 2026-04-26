import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payment_app/Screen/orderDetails.page.dart';
import 'package:payment_app/config/auth/router/rightsliderFageRoute.dart';
import 'package:payment_app/config/network/api.network.dart';
import 'package:payment_app/config/utils/pretty.dio.dart';
import 'package:payment_app/config/utils/showMessage.dart';
import 'package:payment_app/data/controller/getBuyInrDepositeController.dart';
import 'package:payment_app/data/model/processBuyINRDepositeBody.dart';
import 'package:payment_app/data/model/processBuyINRDepositeRes.dart';

/// ✅ Step 1: State class to handle per-item loading
class ProcessBuyState {
  final String? loadingOrderId; // currently loading order id
  final ProcessBuyInrDepositResModel? response; // last response

  ProcessBuyState({this.loadingOrderId, this.response});

  ProcessBuyState copyWith({
    String? loadingOrderId,
    ProcessBuyInrDepositResModel? response,
  }) {
    return ProcessBuyState(
      loadingOrderId: loadingOrderId ?? this.loadingOrderId,
      response: response ?? this.response,
    );
  }
}

/// ✅ Step 2: Controller
class ProcessByuINRDepositeController extends StateNotifier<ProcessBuyState> {
  final Ref ref;

  ProcessByuINRDepositeController(this.ref) : super(ProcessBuyState());

  /// ✅ Main function to process Buy INR Deposit
  Future<void> processBuyINRDeposite({
    required BuildContext context,
    required String orderId,
  }) async {
    try {
      /// Show loading only for clicked order
      state = state.copyWith(loadingOrderId: orderId);

      final service = ApiNetwork(createDio());

      /// Prepare API body
      final body = ProcessBuyInrDepositBodyModel(orderId: orderId);

      /// Call API
      final response = await service.processBuyINRDeposite(body);

      /// Check success response
      if (response.error == false && response.code == 0) {
        state = state.copyWith(response: response);

        /// Navigate to Order Details
        Navigator.push(
          context,
          RightSlideFadeRoute(
            page: OrderDetailsPage(
              amount: response.data!.amount.toString(),
              percentage: response.data!.percentage.toString(),
              id: response.data!.id.toString(),
              upiId: response.data!.upiId.toString(),
              name: response.data!.name.toString(),
              // remainingSeconds: response.data!.expiresAt ?? 0,
              remainingSeconds:
                  ((response.data!.expiresAt ?? 0) -
                          DateTime.now().millisecondsSinceEpoch)
                      .abs() ~/
                  1000,
            ),
          ),
        ).then((value) {
          /// ✅ Reset loading
          state = state.copyWith(loadingOrderId: null);

          /// Refresh API
          ref.read(getBuyInrDepoProvider.notifier).getbuyInrDeposite();
        });
        ShowMessage.success(
          context,
          response.message ?? "Deposit submitted successfully",
        );
      } else {
        /// API returned error
        state = state.copyWith(loadingOrderId: null);

        ShowMessage.error(context, response.message ?? "Submission failed");
      }
    } catch (e, st) {
      state = state.copyWith(loadingOrderId: null);

      log("Error: $e");
      log("Stacktrace: $st");

      if (e is DioException) {
        final errorMessage =
            e.response?.data?["message"] ?? "Network error occurred";
        ShowMessage.error(context, errorMessage);
      } else {
        ShowMessage.error(context, "An unexpected error occurred");
      }
    }
  }
}

/// ✅ Step 3: Provider
final processBuyINRDepositeProvider =
    StateNotifierProvider<ProcessByuINRDepositeController, ProcessBuyState>(
      (ref) => ProcessByuINRDepositeController(ref),
    );
