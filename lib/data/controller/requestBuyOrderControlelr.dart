import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payment_app/config/network/api.network.dart';
import 'package:payment_app/config/utils/pretty.dio.dart';
import 'package:payment_app/config/utils/showMessage.dart';
import 'package:payment_app/data/model/requestBuyOrderBodyModel.dart';
import 'package:payment_app/data/model/requestBuyOrderResModel.dart';

class RequestBuyOrderController
    extends StateNotifier<AsyncValue<RequestBuyOrderResModel?>> {
  RequestBuyOrderController() : super(const AsyncValue.data(null));

  Future<void> submitPayment({
    required String orderId,
    required String hash,
    required File imagePath, // Local file path
    required BuildContext context,
  }) async {
    try {
      state = const AsyncLoading();
      final service = ApiNetwork(createDio());

      /// 1️⃣ Image Upload karein (Multipart)
      final imageUploadRes = await service.uploadImage(imagePath);

      if (imageUploadRes.error == true || imageUploadRes.code != 0) {
        state = AsyncValue.error(
          imageUploadRes.message ?? "Image upload failed",
          StackTrace.current,
        );
        ShowMessage.error(
          context,
          imageUploadRes.message ?? "Image upload failed",
        );
        return;
      }

      final String uploadedImageUrl = imageUploadRes.data?.imageUrl ?? "";

      /// 2️⃣ Buy Order Request Body taiyar karein
      final body = RequestBuyOrderBodyModel(
        orderId: orderId,
        hash: hash,
        image: uploadedImageUrl,
      );

      /// 3️⃣ API Hit karein Order submit karne ke liye
      final response = await service.requestBuyOrder(body);

      if (response.error == true || response.code != 0) {
        state = AsyncValue.data(response);
        ShowMessage.error(
          context,
          response.message ?? "Failed to submit request",
        );
      } else {
        state = AsyncValue.data(response);
        ShowMessage.success(context, "Payment Proof Submitted Successfully!");

        // Success hone par wapas jayein
        Navigator.pop(context);
      }
    } catch (e) {
      state = AsyncValue.error(e.toString(), StackTrace.current);
      log("Error in RequestBuyOrder: ${e.toString()}");
      ShowMessage.error(context, "Something went wrong: ${e.toString()}");
    }
  }
}

// Provider definition
final requestBuyOrderProvider = StateNotifierProvider<
  RequestBuyOrderController,
  AsyncValue<RequestBuyOrderResModel?>
>((ref) {
  return RequestBuyOrderController();
});
