import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payment_app/config/network/api.network.dart';
import 'package:payment_app/config/utils/pretty.dio.dart';
import 'package:payment_app/data/model/getBuyInrDepositeModel.dart';

class GetBuyInrDepositeController
    extends StateNotifier<AsyncValue<GetBuyInrDepositeModel?>> {
  GetBuyInrDepositeController() : super(const AsyncLoading()) {
    getbuyInrDeposite();
  }

  Future<void> getbuyInrDeposite() async {
    try {
      state = const AsyncLoading();

      final service = ApiNetwork(createDio());
      final response = await service.getBuyInrDeposite();

      state = AsyncData(response);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

final getBuyInrDepoProvider = StateNotifierProvider<
  GetBuyInrDepositeController,
  AsyncValue<GetBuyInrDepositeModel?>
>((ref) => GetBuyInrDepositeController());
