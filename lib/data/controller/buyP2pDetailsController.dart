// import 'dart:developer';

// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:payment_app/config/network/api.network.dart';
// import 'package:payment_app/config/utils/pretty.dio.dart';
// import 'package:payment_app/data/model/getOrCreateTransactionP2pDetailsModel.dart';

// class BuyP2pDetailsController
//     extends StateNotifier<AsyncValue<GetOrCreateP2PTransactionDetailsModel?>> {
//   BuyP2pDetailsController() : super(AsyncValue.data(null));

//   Future<void> buyP2pDetail(String id) async {
//     try {
//       state = AsyncValue.loading();
//       final srvice = ApiNetwork(createDio());
//       final response = await srvice.getOrCreateP2pTransationDetails(id);
//       state = AsyncValue.data(response);
//     } catch (e, st) {
//       log("Error fetching P2P details: $e");
//       state = AsyncValue.error(e, st);
//     }
//   }
// }

// final buyP2pDetailsProvider = StateNotifierProvider<
//   BuyP2pDetailsController,
//   AsyncValue<GetOrCreateP2PTransactionDetailsModel?>
// >((ref) {
//   return BuyP2pDetailsController();
// });

import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payment_app/config/network/api.network.dart';
import 'package:payment_app/config/utils/pretty.dio.dart';
import 'package:payment_app/data/model/getOrCreateTransactionP2pDetailsModel.dart';

class P2pTransactionDetailsController
    extends StateNotifier<AsyncValue<GetOrCreateP2PTransactionDetailsModel?>> {
  P2pTransactionDetailsController() : super(const AsyncValue.data(null));

  Future<void> getP2pDetail({
    required String id,
    required String type, // BUY or SELL
  }) async {
    try {
      state = const AsyncValue.loading();

      final service = ApiNetwork(createDio());

      final response = await service.getOrCreateP2pTransationDetails(id, type);

      state = AsyncValue.data(response);
    } catch (e, st) {
      log("Error fetching P2P details: $e");
      state = AsyncValue.error(e, st);
    }
  }
}

final p2pTransactionDetailsProvider = StateNotifierProvider<
  P2pTransactionDetailsController,
  AsyncValue<GetOrCreateP2PTransactionDetailsModel?>
>((ref) {
  return P2pTransactionDetailsController();
});
