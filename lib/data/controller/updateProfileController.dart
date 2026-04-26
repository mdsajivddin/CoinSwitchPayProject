import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:payment_app/config/network/api.network.dart';
import 'package:payment_app/config/utils/pretty.dio.dart';
import 'package:payment_app/config/utils/showMessage.dart';
import 'package:payment_app/data/controller/profileController.dart';
import 'package:payment_app/data/model/updateProfileBodyModel.dart';
import 'package:payment_app/data/model/updateProfileResModel.dart';

class UpdateProfileController
    extends StateNotifier<AsyncValue<UpdateProfileResModel?>> {
  final Ref ref;
  UpdateProfileController(this.ref) : super(const AsyncValue.data(null));

  Future<void> updateProfile({
    required String name,
    required BuildContext context,
  }) async {
    try {
      state = const AsyncValue.loading();

      final body = UpdateProfileBodyModel(name: name);
      final service = ApiNetwork(createDio());

      final response = await service.updateProfle(body);

      /// ✅ Proper success condition
      if (response.code == 0 && response.error == false) {
        var box = Hive.box("userdata");

        await box.put("name", response.data!.name);
        await box.put("image", response.data!.image);

        // 🔥 Force UI refresh
        ref.read(userBoxProvider.notifier).state = Hive.box("userdata");

        state = AsyncValue.data(response);

        ShowMessage.success(
          context,
          response.message ?? "Profile updated successfully",
        );
        ref.invalidate(profileController);
        ref.read(userBoxProvider.notifier).state = Hive.box("userdata");

        Navigator.pop(context);
      } else {
        state = AsyncValue.error(
          response.message ?? "Failed to update profile",
          StackTrace.current,
        );

        ShowMessage.error(
          context,
          response.message ?? "Failed to update profile",
        );
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);

      ShowMessage.error(context, "Network failed to update profile");
    }
  }
}

final updateProfileControllerProvider = StateNotifierProvider<
  UpdateProfileController,
  AsyncValue<UpdateProfileResModel?>
>((ref) {
  return UpdateProfileController(ref);
});

final userBoxProvider = StateProvider<Box>((ref) {
  return Hive.box("userdata");
});
