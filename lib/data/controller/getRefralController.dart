import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payment_app/config/network/api.network.dart';
import 'package:payment_app/config/utils/pretty.dio.dart';
import 'package:payment_app/data/model/getRefralChainListModel.dart';
import 'package:payment_app/data/model/sellUpiModel.dart';

class ReferralChainNotifier
    extends StateNotifier<AsyncValue<GetRefralchainlistModel>> {
  final ApiNetwork _service;

  ReferralChainNotifier(this._service) : super(const AsyncValue.loading()) {
    getReferralList();
  }

  Future<void> getReferralList() async {
    state = const AsyncValue.loading();
    try {
      final response = await _service.getRefralList();
      state = AsyncValue.data(response);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

// Final Provider
final referralChainProvider = StateNotifierProvider.autoDispose<
  ReferralChainNotifier,
  AsyncValue<GetRefralchainlistModel>
>((ref) {
  final service = ApiNetwork(createDio());
  return ReferralChainNotifier(service);
});
