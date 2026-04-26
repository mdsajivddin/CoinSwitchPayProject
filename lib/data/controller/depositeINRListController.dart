import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payment_app/config/network/api.network.dart';
import 'package:payment_app/config/utils/pretty.dio.dart';
import 'package:payment_app/data/model/depositeINRListModel.dart';

class DepositeINRListController
    extends StateNotifier<AsyncValue<DepositeInrListModel>> {
  DepositeINRListController() : super(const AsyncValue.loading()) {
    fetchINRDepositeList(); // Screen khulte hi data load hoga
  }

  Future<void> fetchINRDepositeList() async {
    try {
      // Refresh hone par loading state dikhayega
      state = const AsyncValue.loading();

      final service = ApiNetwork(createDio());
      final response = await service.depositeINRList();

      // Success: Data state mein save ho jayega
      state = AsyncValue.data(response);
    } catch (e, st) {
      // Error: Error state set hogi
      state = AsyncValue.error(e, st);
    }
  }
}

// 2. Provider Definition
final depositeINRListProvider = StateNotifierProvider<
  DepositeINRListController,
  AsyncValue<DepositeInrListModel>
>((ref) {
  return DepositeINRListController();
});
