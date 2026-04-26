import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payment_app/config/network/api.network.dart';
import 'package:payment_app/config/utils/pretty.dio.dart';
import 'package:payment_app/data/model/getBankResModel.dart';

class GetBankController extends StateNotifier<AsyncValue<GetBankResModel>> {
  GetBankController() : super(AsyncValue.loading()) {
    getBankList();
  }

  Future<void> getBankList() async {
    try {
      state = AsyncValue.loading();
      final service = ApiNetwork(createDio());
      final response = await service.getAllBankList();
      state = AsyncValue.data(response);
    } catch (e, st) {
      // Error: Error state set hogi
      state = AsyncValue.error(e, st);
    }
  }
}

final getBankListProvider = StateNotifierProvider.autoDispose<
  GetBankController,
  AsyncValue<GetBankResModel>
>((ref) {
  return GetBankController();
});
