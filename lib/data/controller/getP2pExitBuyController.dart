import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payment_app/config/network/api.network.dart';
import 'package:payment_app/config/utils/pretty.dio.dart';
import 'package:payment_app/data/model/getP2pExitBuyModel.dart';

class GetP2pExitBuyController
    extends StateNotifier<AsyncValue<GetP2PExitBuyModel>> {
  GetP2pExitBuyController() : super(const AsyncValue.loading());

  Future<void> getP2pExiteBuy(String type) async {
    try {
      state = const AsyncValue.loading();

      final service = ApiNetwork(createDio());
      final response = await service.getP2pExit(type);

      state = AsyncValue.data(response);
    } catch (e, st) {
      log(e.toString());
      state = AsyncValue.error(e, st);
    }
  }
}

final getP2pExitBuyProvider = StateNotifierProvider<
  GetP2pExitBuyController,
  AsyncValue<GetP2PExitBuyModel>
>((ref) => GetP2pExitBuyController());
