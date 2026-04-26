import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payment_app/config/network/api.network.dart';
import 'package:payment_app/config/utils/pretty.dio.dart';
import 'package:payment_app/data/model/usdtDepositeHistoryModel.dart';

class UsdtDepositHistoryController
    extends StateNotifier<AsyncValue<UsdtDepositeHisotryModel?>> {
  UsdtDepositHistoryController() : super(const AsyncValue.loading()) {
    getUsdtDepositHistory(); // auto call on init
  }

  final _service = ApiNetwork(createDio());

  Future<void> getUsdtDepositHistory() async {
    try {
      state = const AsyncValue.loading();

      final response = await _service.usdtDepositeHostory();

      state = AsyncValue.data(response);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final usdtDepositHistoryProvider = StateNotifierProvider.autoDispose<
  UsdtDepositHistoryController,
  AsyncValue<UsdtDepositeHisotryModel?>
>((ref) => UsdtDepositHistoryController());
