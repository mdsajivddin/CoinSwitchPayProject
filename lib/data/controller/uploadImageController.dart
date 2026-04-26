import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:payment_app/config/network/api.network.dart';
import 'package:payment_app/config/utils/pretty.dio.dart';
import 'package:payment_app/config/utils/showMessage.dart';
import 'package:retrofit/dio.dart';

/// ---------------- STATE ----------------
class UploadImageState {
  final bool isLoading;
  final dynamic data;
  final String? error;

  const UploadImageState({this.isLoading = false, this.data, this.error});

  UploadImageState copyWith({bool? isLoading, dynamic data, String? error}) {
    return UploadImageState(
      isLoading: isLoading ?? this.isLoading,
      data: data ?? this.data,
      error: error,
    );
  }
}

/// ---------------- API PROVIDER ----------------
final apiProvider = Provider<ApiNetwork>((ref) {
  final dio = createDio();
  return ApiNetwork(dio);
});

/// ---------------- NOTIFIER ----------------
class UploadImageNotifier extends StateNotifier<UploadImageState> {
  final ApiNetwork apiClient;

  UploadImageNotifier(this.apiClient) : super(const UploadImageState());

  Future<void> uploadImage(BuildContext context, File file) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      // final HttpResponse response = await apiClient.uploadImage(file);

      final response = await apiClient.uploadImage(file);
      if (response.code == 0 || response.error == false) {
        var box = Hive.box("userdata");
        await box.put("imageUrl", response.data!.imageUrl!);
        state = state.copyWith(isLoading: false, data: response.data);
      } else {
        state = state.copyWith(isLoading: false, error: response.message);
        ShowMessage.error(context, response.message ?? "Error");
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

/// ---------------- STATE NOTIFIER PROVIDER ----------------
final uploadImageProvider =
    StateNotifierProvider<UploadImageNotifier, UploadImageState>((ref) {
      final apiClient = ref.read(apiProvider);
      return UploadImageNotifier(apiClient);
    });
