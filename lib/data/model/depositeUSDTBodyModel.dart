// To parse this JSON data, do
//
//     final depositeUsdtBodyModel = depositeUsdtBodyModelFromJson(jsonString);

import 'dart:convert';

DepositeUsdtBodyModel depositeUsdtBodyModelFromJson(String str) => DepositeUsdtBodyModel.fromJson(json.decode(str));

String depositeUsdtBodyModelToJson(DepositeUsdtBodyModel data) => json.encode(data.toJson());

class DepositeUsdtBodyModel {
    String? network;
    String? pin;
    int? amount;

    DepositeUsdtBodyModel({
        this.network,
        this.pin,
        this.amount,
    });

    factory DepositeUsdtBodyModel.fromJson(Map<String, dynamic> json) => DepositeUsdtBodyModel(
        network: json["network"],
        pin: json["pin"],
        amount: json["amount"],
    );

    Map<String, dynamic> toJson() => {
        "network": network,
        "pin": pin,
        "amount": amount,
    };
}
