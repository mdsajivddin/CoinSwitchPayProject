import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payment_app/config/network/api.network.dart';
import 'package:payment_app/config/utils/pretty.dio.dart';
import 'package:payment_app/data/model/getBankResModel.dart';
import 'package:payment_app/data/model/sellUpiModel.dart';

class SellUpiStateNotifier extends StateNotifier<AsyncValue<SellUpiModel>> {
  final ApiNetwork _service;

  SellUpiStateNotifier(this._service) : super(const AsyncValue.loading()) {
    fetchSellUpi();
  }

  Future<void> fetchSellUpi() async {
    state = const AsyncValue.loading();
    try {
      final response = await _service.sellUpi();
      state = AsyncValue.data(response);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

// Final Provider
final sellUpiControllerProvider =
    StateNotifierProvider<SellUpiStateNotifier, AsyncValue<SellUpiModel>>((
      ref,
    ) {
      final service = ApiNetwork(createDio());
      return SellUpiStateNotifier(service);
    });

///////////////////////////////////////////////////////
///
class SellBankStateNotifier extends StateNotifier<AsyncValue<GetBankResModel>> {
  final ApiNetwork _service;

  SellBankStateNotifier(this._service) : super(const AsyncValue.loading()) {
    fetchSellBank();
  }

  Future<void> fetchSellBank() async {
    state = const AsyncValue.loading();
    try {
      final response = await _service.sellBankList();
      state = AsyncValue.data(response);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

// Final Provider
final sellBankControllerProvider =
    StateNotifierProvider<SellBankStateNotifier, AsyncValue<GetBankResModel>>((
      ref,
    ) {
      final service = ApiNetwork(createDio());
      return SellBankStateNotifier(service);
    });
