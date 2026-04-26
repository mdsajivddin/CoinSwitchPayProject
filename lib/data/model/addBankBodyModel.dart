// To parse this JSON data, do
//
//     final addBankBodyModel = addBankBodyModelFromJson(jsonString);

import 'dart:convert';

AddBankBodyModel addBankBodyModelFromJson(String str) => AddBankBodyModel.fromJson(json.decode(str));

String addBankBodyModelToJson(AddBankBodyModel data) => json.encode(data.toJson());

class AddBankBodyModel {
    String? accountHolderName;
    String? bankName;
    String? accountNumber;
    String? ifscCode;
    String? branchName;

    AddBankBodyModel({
        this.accountHolderName,
        this.bankName,
        this.accountNumber,
        this.ifscCode,
        this.branchName,
    });

    factory AddBankBodyModel.fromJson(Map<String, dynamic> json) => AddBankBodyModel(
        accountHolderName: json["accountHolderName"],
        bankName: json["bankName"],
        accountNumber: json["accountNumber"],
        ifscCode: json["ifscCode"],
        branchName: json["branchName"],
    );

    Map<String, dynamic> toJson() => {
        "accountHolderName": accountHolderName,
        "bankName": bankName,
        "accountNumber": accountNumber,
        "ifscCode": ifscCode,
        "branchName": branchName,
    };
}
