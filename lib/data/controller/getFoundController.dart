import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payment_app/config/network/api.network.dart';
import 'package:payment_app/config/utils/pretty.dio.dart';
import 'package:payment_app/data/model/getFoundTransferModel.dart';

// final getFoundController = FutureProvider<GetFoundTransferModel>((ref) async {
//   final service = ApiNetwork(createDio());
//   return await service.getFoundTransfer();
// });

class GetFoundController
    extends StateNotifier<AsyncValue<GetFoundTransferModel?>> {
  GetFoundController() : super(const AsyncValue.loading()) {
    getFoundTransfer();
  }

  final _service = ApiNetwork(createDio());

  Future<void> getFoundTransfer() async {
    try {
      state = const AsyncValue.loading();

      final response = await _service.getFoundTransfer();

      state = AsyncValue.data(response);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final getFoundProvider = StateNotifierProvider<
  GetFoundController,
  AsyncValue<GetFoundTransferModel?>
>((ref) => GetFoundController());
