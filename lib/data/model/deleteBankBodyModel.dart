// To parse this JSON data, do
//
//     final deleteBankBodyModel = deleteBankBodyModelFromJson(jsonString);

import 'dart:convert';

DeleteBankBodyModel deleteBankBodyModelFromJson(String str) => DeleteBankBodyModel.fromJson(json.decode(str));

String deleteBankBodyModelToJson(DeleteBankBodyModel data) => json.encode(data.toJson());

class DeleteBankBodyModel {
    String? bankId;

    DeleteBankBodyModel({
        this.bankId,
    });

    factory DeleteBankBodyModel.fromJson(Map<String, dynamic> json) => DeleteBankBodyModel(
        bankId: json["bankId"],
    );

    Map<String, dynamic> toJson() => {
        "bankId": bankId,
    };
}
