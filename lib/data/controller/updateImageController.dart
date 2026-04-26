// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:hive/hive.dart';
// import 'package:payment_app/config/network/api.network.dart';
// import 'package:payment_app/config/utils/pretty.dio.dart';
// import 'package:payment_app/config/utils/showMessage.dart';
// import 'package:payment_app/data/model/updateImageResModel.dart';

// // Pehle ApiNetwork ka provider bana lete hain taaki baar baar naya create na karna pade
// final apiProvider = Provider<ApiNetwork>((ref) {
//   return ApiNetwork(createDio());
// });

// class UpdateImageController
//     extends StateNotifier<AsyncValue<UpdateImageResModel?>> {
//   final ApiNetwork apiClient;

//   UpdateImageController(this.apiClient) : super(const AsyncValue.data(null));

//   /// 1. Pehle Image File upload hogi
//   /// 2. Phir mili hui URL/Data ko body me bhej kar update karenge
//   Future<void> uploadAndUpdateImage({
//     required BuildContext context,
//     required File imageFile,
//   }) async {
//     try {
//       state = const AsyncValue.loading();

//       // --- STEP 1: UPLOAD ---
//       // Maan lete hain ki ye File accept karta hai aur response me data deta hai
//       final uploadResponse = await apiClient.uploadImage(imageFile);

//       if (uploadResponse.code == 0 || uploadResponse.error == false) {
//         var box = Hive.box("userdata");
//         await box.put("imageUrl", uploadResponse.data!.imageUrl!);
//         // --- STEP 2: UPDATE ---
//         // Upload hone ke baad jo URL ya ID mili, usko Body me bhejenge
//         // Aapne kaha tha body me jayega, toh yahan uploadResponse.data pass hoga
//         final imageUrl =
//             uploadResponse.data!.imageUrl
//                 .toString(); // Ya jo bhi aapka field name ho

//         final updateResponse = await apiClient.updateImage(imageUrl);

//         if (updateResponse.code == 0 || updateResponse.error == false) {
//           var box = Hive.box("userdata");
//           await box.put("image", updateResponse.data!.image);
//           // ShowMessage.success(
//           //   context,
//           //   updateResponse.message ?? "Image Updated Successfully",
//           // );
//           state = AsyncValue.data(updateResponse);
//         } else {
//           _handleError(context, updateResponse.message ?? "Update Failed");
//         }
//       } else {
//         _handleError(context, uploadResponse.message ?? "Upload Failed");
//       }
//     } catch (e, stack) {
//       _handleError(context, "An unexpected error occurred");
//       state = AsyncValue.error(e, stack);
//     }
//   }

//   void _handleError(BuildContext context, String msg) {
//     ShowMessage.error(context, msg);
//     state = AsyncValue.error(msg, StackTrace.current);
//   }
// }

// /// --- PROVIDER ---
// final updateImageControllerProvider = StateNotifierProvider<
//   UpdateImageController,
//   AsyncValue<UpdateImageResModel?>
// >((ref) {
//   final apiClient = ref.read(apiProvider);
//   return UpdateImageController(apiClient);
// });

import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:payment_app/config/network/api.network.dart';
import 'package:payment_app/config/utils/pretty.dio.dart';
import 'package:payment_app/config/utils/showMessage.dart';
import 'package:payment_app/data/model/updateImageResModel.dart';
import 'package:payment_app/data/controller/profileController.dart'; // Import profile provider
import 'dart:convert';

final apiProvider = Provider<ApiNetwork>((ref) {
  return ApiNetwork(createDio());
});

class UpdateImageController
    extends StateNotifier<AsyncValue<UpdateImageResModel?>> {
  final Ref ref; // ref add kiya taaki dusre providers invalidate kar sakein
  final ApiNetwork apiClient;

  UpdateImageController(this.ref, this.apiClient)
    : super(const AsyncValue.data(null));

  Future<void> uploadAndUpdateImage({
    required BuildContext context,
    required File imageFile,
  }) async {
    try {
      state = const AsyncValue.loading();

      // --- STEP 1: UPLOAD FILE ---
      final uploadResponse = await apiClient.uploadImage(imageFile);

      if (uploadResponse.code == 0 || uploadResponse.error == false) {
        // Response se URL nikaalte waqt null check zaroor karein
        final newImageUrl = uploadResponse.data?.imageUrl?.toString();

        if (newImageUrl != null) {
          // --- STEP 2: UPDATE PROFILE IMAGE ON SERVER ---
          final updateResponse = await apiClient.updateImage(newImageUrl);

          if (updateResponse.code == 0 || updateResponse.error == false) {
            // ✅ Hive mein final image save karein
            var box = Hive.box("userdata");
            await box.put("image", updateResponse.data?.image);

            state = AsyncValue.data(updateResponse);

            // ✅ Sabse Important: Profile Controller ko refresh karein
            // Taaki Drawer aur har jagah photo turant change ho jaye
            ref.invalidate(profileController);

            ShowMessage.success(context, "Profile picture updated!");
          } else {
            _handleError(context, updateResponse.message ?? "Update failed");
          }
        }
      } else {
        _handleError(context, uploadResponse.message ?? "Upload failed");
      }
    } catch (e, stack) {
      log("Image Upload Error: $e");
      _handleError(context, "Connection error or invalid data");
      state = AsyncValue.error(e, stack);
    }
  }

  void _handleError(BuildContext context, String msg) {
    ShowMessage.error(context, msg);
    state = AsyncValue.error(msg, StackTrace.current);
  }
}

/// --- PROVIDER ---
final updateImageControllerProvider = StateNotifierProvider<
  UpdateImageController,
  AsyncValue<UpdateImageResModel?>
>((ref) {
  final apiClient = ref.read(apiProvider);
  return UpdateImageController(ref, apiClient);
});
