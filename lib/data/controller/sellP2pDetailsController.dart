import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payment_app/config/network/api.network.dart';
import 'package:payment_app/config/utils/pretty.dio.dart';
import 'package:payment_app/data/model/sellP2pDetailsModel.dart';

class SellP2pDetailsController
    extends StateNotifier<AsyncValue<SellP2PDetailsModel?>> {
  SellP2pDetailsController() : super(AsyncValue.data(null));

  Future<void> sellP2pDetail(String id) async {
    try {
      state = AsyncValue.loading();
      final srvice = ApiNetwork(createDio());
      final response = await srvice.sellP2pDetails(id);
      state = AsyncValue.data(response);
    } catch (e, st) {
      log("Error fetching P2P details: $e");
      state = AsyncValue.error(e, st);
    }
  }
}

final sellP2pDetailsProvider = StateNotifierProvider<
  SellP2pDetailsController,
  AsyncValue<SellP2PDetailsModel?>
>((ref) {
  return SellP2pDetailsController();
});
