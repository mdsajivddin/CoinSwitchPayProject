// To parse this JSON data, do
//
//     final createWithBodyModel = createWithBodyModelFromJson(jsonString);

import 'dart:convert';

CreateWithBodyModel createWithBodyModelFromJson(String str) => CreateWithBodyModel.fromJson(json.decode(str));

String createWithBodyModelToJson(CreateWithBodyModel data) => json.encode(data.toJson());

class CreateWithBodyModel {
    int? amount;
    String? pin;
    String? walletType;

    CreateWithBodyModel({
        this.amount,
        this.pin,
        this.walletType,
    });

    factory CreateWithBodyModel.fromJson(Map<String, dynamic> json) => CreateWithBodyModel(
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
