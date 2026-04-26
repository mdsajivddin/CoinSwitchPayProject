// To parse this JSON data, do
//
//     final updateBankStatusBodyModel = updateBankStatusBodyModelFromJson(jsonString);

import 'dart:convert';

UpdateBankStatusBodyModel updateBankStatusBodyModelFromJson(String str) => UpdateBankStatusBodyModel.fromJson(json.decode(str));

String updateBankStatusBodyModelToJson(UpdateBankStatusBodyModel data) => json.encode(data.toJson());

class UpdateBankStatusBodyModel {
    String? bankId;
    bool? isDisable;

    UpdateBankStatusBodyModel({
        this.bankId,
        this.isDisable,
    });

    factory UpdateBankStatusBodyModel.fromJson(Map<String, dynamic> json) => UpdateBankStatusBodyModel(
        bankId: json["bankId"],
        isDisable: json["isDisable"],
    );

    Map<String, dynamic> toJson() => {
        "bankId": bankId,
        "isDisable": isDisable,
    };
}
