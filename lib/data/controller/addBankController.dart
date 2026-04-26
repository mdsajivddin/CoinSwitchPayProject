import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payment_app/config/network/api.network.dart';
import 'package:payment_app/config/utils/pretty.dio.dart';
import 'package:payment_app/config/utils/showMessage.dart';
import 'package:payment_app/data/controller/getAllBankController.dart';
import 'package:payment_app/data/model/addBankBodyModel.dart';
import 'package:payment_app/data/model/addBankResModel.dart';

class AddBankController extends StateNotifier<AsyncValue<AddBankResModel?>> {
  final Ref ref;
  AddBankController(this.ref) : super(AsyncValue.data(null));

  Future<void> createBank({
    required BuildContext context,
    required String holdername,
    required String accountnumber,
    required String banktname,
    required String branchname,
    required String ifscode,
  }) async {
    try {
      state = AsyncValue.loading();
      final body = AddBankBodyModel(
        accountHolderName: holdername,
        accountNumber: accountnumber,
        bankName: banktname,
        branchName: branchname,
        ifscCode: ifscode,

      );
      final servcie = ApiNetwork(createDio());
      final response = await servcie.addBank(body);
      if (response.code == 0 && response.error == false) {
        state = AsyncValue.data(response);
        ShowMessage.success(context, response.message ?? "");
        ref.invalidate(getBankListProvider);
        Navigator.pop(context);
        state = AsyncValue.data(null);
      } else {
        final errorMessage =
            response.message?.trim() ?? "Failed to add UPI. Please try again.";

        state = AsyncValue.data(null);
        ShowMessage.error(context, errorMessage);
      }
    } catch (e, st) {
      state = AsyncValue.data(
        null,
      ); // Error hone par bhi state reset karein taaki button wapas aa jaye
      log(e.toString());
      log(st.toString());
      ShowMessage.error(context, "An unexpected error occurred");
    }
  }
}

final addBankProvider =
    StateNotifierProvider<AddBankController, AsyncValue<AddBankResModel?>>(
      (ref) => AddBankController(ref),
    );
