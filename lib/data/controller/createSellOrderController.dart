import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payment_app/config/network/api.network.dart';
import 'package:payment_app/config/utils/pretty.dio.dart';
import 'package:payment_app/config/utils/showMessage.dart';
import 'package:payment_app/data/model/createSellOrderBodyModel.dart';
import 'package:payment_app/data/model/createSellOrderResModel.dart';

class CreateSellOrderController
    extends StateNotifier<AsyncValue<CreateSellOrderResModel?>> {
  final Ref ref;

  CreateSellOrderController(this.ref) : super(const AsyncValue.data(null));

  Future<void> createSellOrders({
    required int ammount,
    required int price,
    required String sellerAddress,
    required String walletType,
    required BuildContext context,
  }) async {
    try {
      state = AsyncValue.loading();
      final body = CreateSellOrderBodyModel(
        amount: ammount,
        price: price,
        sellerAddress: sellerAddress,
        walletType: walletType,
      );
      final serive = ApiNetwork(createDio());
      final respone = await serive.createSellOrder(body);
      if (respone.code == 0 || respone.error == false) {
        // Navigator.pop(context);
        ShowMessage.success(context, respone.message ?? "Success");
        state = AsyncValue.data(respone);
      } else {
        state = AsyncValue.data(null);
        ShowMessage.error(context, respone.message ?? "Error");
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

final createSellOrderProvider = StateNotifierProvider<
  CreateSellOrderController,
  AsyncValue<CreateSellOrderResModel?>
>((ref) => CreateSellOrderController(ref));
