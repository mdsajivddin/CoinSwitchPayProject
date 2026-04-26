import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payment_app/config/network/api.network.dart';
import 'package:payment_app/config/utils/pretty.dio.dart';
import 'package:payment_app/data/model/getWallerCommissionModel.dart';
import 'package:payment_app/data/model/getWalletModel.dart';

class GetWalletController extends StateNotifier<AsyncValue<GetWalletModel?>> {
  GetWalletController() : super(AsyncValue.loading()) {
    getWallet();
  }

  Future<void> getWallet() async {
    try {
      state = AsyncValue.loading();
      final service = ApiNetwork(createDio());
      final response = await service.getWallet();
      state = AsyncValue.data(response);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final getWalletProvider =
    StateNotifierProvider<GetWalletController, AsyncValue<GetWalletModel?>>((
      ref,
    ) {
      return GetWalletController();
    });

final commissionController = FutureProvider.autoDispose<GetWalletCommissionModel>((
  ref,
) async {
  final service = ApiNetwork(createDio());
  return await service.getWalletCommission();
});
