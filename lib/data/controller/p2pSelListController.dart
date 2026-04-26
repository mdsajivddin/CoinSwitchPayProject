import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payment_app/config/network/api.network.dart';
import 'package:payment_app/config/utils/pretty.dio.dart';
import 'package:payment_app/data/model/buyP2pListResModel.dart';

class SellP2pListController
    extends StateNotifier<AsyncValue<BuyP2PListResModel?>> {
  SellP2pListController() : super(const AsyncValue.loading()) {
    fetchP2PSellList(); // Screen load hote hi data mangwane ke liye
  }

  Future<void> fetchP2PSellList() async {
    try {
      // Refreshing state (taaki UI ko pata chale ki update ho raha hai)
      state = const AsyncValue.loading();

      final service = ApiNetwork(createDio());
      final response = await service.sellP2pList();

      // Data successfully mil gaya
      state = AsyncValue.data(response);
    } catch (e, st) {
      // Agar error aaye toh error state set karein
      state = AsyncValue.error(e, st);
    }
  }
}

// Provider definition
final sellP2pListProvider = StateNotifierProvider<
  SellP2pListController,
  AsyncValue<BuyP2PListResModel?>
>((ref) {
  return SellP2pListController();
});
