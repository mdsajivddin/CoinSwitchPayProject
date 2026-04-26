import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payment_app/config/network/api.network.dart';
import 'package:payment_app/config/utils/pretty.dio.dart';
import 'package:payment_app/data/model/getP2pTransatinSellModel.dart';
import 'package:payment_app/data/model/getP2pTransationBuyModel.dart';

final p2pBuyHistoryProvider =
    FutureProvider.autoDispose<GetP2PTrasationBuyModel>((ref) async {
      final service = ApiNetwork(createDio());
      return await service.getP2PBuyTransactions(); // Sahi function call karein
    });

// SELL Provider -> calls Sell API
final p2pSellProvider = FutureProvider.autoDispose<GetP2PTrasationSellModel>((
  ref,
) async {
  final service = ApiNetwork(createDio());
  return await service.getP2PSellTransactions(); // Sahi function call karein
});
