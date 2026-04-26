import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payment_app/config/network/api.network.dart';
import 'package:payment_app/config/utils/pretty.dio.dart';
import 'package:payment_app/data/model/profileResModel.dart';

final profileController = FutureProvider<ProfileResModel>((ref) async {
  final service = ApiNetwork(createDio());
  return await service.fetchProfile();
});

class ProfileController extends StateNotifier<AsyncValue<ProfileResModel?>> {
  ProfileController() : super(AsyncValue.loading()) {
    getProfileData();
  }

  Future<void> getProfileData() async {
    try {
      state = AsyncValue.loading();
      final service = ApiNetwork(createDio());
      final response = await service.fetchProfile();
      state = AsyncValue.data(response);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final profileProvider =
    StateNotifierProvider.autoDispose<ProfileController, AsyncValue<ProfileResModel?>>((
      ref,
    ) {
      return ProfileController();
    });
