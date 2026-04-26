import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payment_app/config/network/api.network.dart';
import 'package:payment_app/config/utils/pretty.dio.dart';
import 'package:payment_app/config/utils/showMessage.dart';
import 'package:payment_app/data/controller/getKycController.dart';
import 'package:payment_app/data/controller/profileController.dart';
import 'package:payment_app/data/model/createOrUpdateKycBodyModel.dart';
import 'package:retrofit/dio.dart';

class KycState {
  final bool isLoading;
  final dynamic data;
  final String? error;

  const KycState({this.isLoading = false, this.data, this.error});

  KycState copyWith({bool? isLoading, dynamic data, String? error}) {
    return KycState(
      isLoading: isLoading ?? this.isLoading,
      data: data ?? this.data,
      error: error,
    );
  }
}

final apiProvider = Provider<ApiNetwork>((ref) {
  final dio = createDio();
  return ApiNetwork(dio);
});

class KycNotifier extends StateNotifier<KycState> {
  final ApiNetwork api;
  final Ref ref;
  KycNotifier(this.api, this.ref) : super(const KycState());

  Future<void> submitKyc({
    required File frontImage,
    required File backImage,
    required String name,
    required String amount,
    required String hash,
    required File screenshot,
    required BuildContext context,
  }) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      /// 1️⃣ Upload Front Image
      final frontRes = await api.uploadImage(frontImage);

      if (frontRes.code != 0 || frontRes.error == true) {
        state = state.copyWith(isLoading: false);
        ShowMessage.error(
          context,
          frontRes.message ?? "Front image upload failed",
        );
        return;
      }

      final String frontUrl = frontRes.data?.imageUrl ?? "";

      /// 2️⃣ Upload Back Image
      final backRes = await api.uploadImage(backImage);

      if (backRes.code != 0 || backRes.error == true) {
        state = state.copyWith(isLoading: false);
        ShowMessage.error(
          context,
          backRes.message ?? "Back image upload failed",
        );
        return;
      }

      final String backUrl = backRes.data?.imageUrl ?? "";
      final String screenshotUrl = backRes.data?.imageUrl ?? "";

      /// 3️⃣ Create / Update KYC
      final body = CreateOrUpdateKycBodyModel(
        front: frontUrl,
        back: backUrl,
        name: name,
        amount: amount,
        hash: hash,
        screenshotImage: screenshotUrl,
      );

      final kycRes = await api.createOrUpdateKyc(body);

      if (kycRes.code != 0 || kycRes.error == true) {
        state = state.copyWith(isLoading: false);
        ShowMessage.error(context, kycRes.message ?? "Kyc Failed");
        return;
      }
      state = state.copyWith(isLoading: false, data: kycRes.data);
      ShowMessage.success(
        context,
        kycRes.message ?? "KYC Submitted Successfully",
      );
      ref.invalidate(profileController);
      ref.invalidate(getKycController);
      Navigator.pop(context);
      state = state.copyWith(isLoading: false, error: null);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      log(e.toString());
      ShowMessage.error(context, "Something went wrong");
    }
  }
}

final kycProvider = StateNotifierProvider<KycNotifier, KycState>((ref) {
  final api = ref.read(apiProvider);
  return KycNotifier(api, ref);
});
