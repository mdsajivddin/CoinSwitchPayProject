// To parse this JSON data, do
//
//     final withdawBodyModel = withdawBodyModelFromJson(jsonString);

import 'dart:convert';

WithdawBodyModel withdawBodyModelFromJson(String str) => WithdawBodyModel.fromJson(json.decode(str));

String withdawBodyModelToJson(WithdawBodyModel data) => json.encode(data.toJson());

class WithdawBodyModel {
    int? amount;
    String? pin;
    String? walletType;

    WithdawBodyModel({
        this.amount,
        this.pin,
        this.walletType,
    });

    factory WithdawBodyModel.fromJson(Map<String, dynamic> json) => WithdawBodyModel(
        amount: json["amount"],
        pin: json["pin"],
        walletType: json["walletType"],
    );

    Map<String, dynamic> toJson() => {
        "amount": amount,
        "pin": pin,
        "walletType": walletType,
    };
}
