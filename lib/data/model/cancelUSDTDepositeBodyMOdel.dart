// To parse this JSON data, do
//
//     final cancelUsdtDepositBodyModel = cancelUsdtDepositBodyModelFromJson(jsonString);

import 'dart:convert';

CancelUsdtDepositBodyModel cancelUsdtDepositBodyModelFromJson(String str) => CancelUsdtDepositBodyModel.fromJson(json.decode(str));

String cancelUsdtDepositBodyModelToJson(CancelUsdtDepositBodyModel data) => json.encode(data.toJson());

class CancelUsdtDepositBodyModel {
    String? depositId;

    CancelUsdtDepositBodyModel({
        this.depositId,
    });

    factory CancelUsdtDepositBodyModel.fromJson(Map<String, dynamic> json) => CancelUsdtDepositBodyModel(
        depositId: json["depositId"],
    );

    Map<String, dynamic> toJson() => {
        "depositId": depositId,
    };
}
