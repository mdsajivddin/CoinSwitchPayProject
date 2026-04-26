import 'package:payment_app/config/network/api.network.dart';
import 'package:payment_app/config/utils/pretty.dio.dart';
import 'package:riverpod/riverpod.dart';



class BannerBottomController extends StateNotifier<AsyncValue<dynamic>> {
  BannerBottomController() : super(const AsyncValue.loading()) {
    getBannersBottom();
  }

  final _service = ApiNetwork(createDio());

  Future<void> getBannersBottom() async {
    try {
      state = const AsyncValue.loading();

      final response = await _service.getBannersBottom();

      state = AsyncValue.data(response);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final bannerBottomProvider =
    StateNotifierProvider<BannerBottomController, AsyncValue<dynamic>>(
      (ref) => BannerBottomController(),
    );

class BannerTopController extends StateNotifier<AsyncValue<dynamic>> {
  BannerTopController() : super(const AsyncValue.loading()) {
    getBannersTop();
  }

  final _service = ApiNetwork(createDio());

  Future<void> getBannersTop() async {
    try {
      state = const AsyncValue.loading();

      final response = await _service.getBannersTop();

      state = AsyncValue.data(response);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final bannerTopProvider =
    StateNotifierProvider<BannerTopController, AsyncValue<dynamic>>(
      (ref) => BannerTopController(),
    );
