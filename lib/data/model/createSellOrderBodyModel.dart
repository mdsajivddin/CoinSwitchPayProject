// To parse this JSON data, do
//
//     final createSellOrderBodyModel = createSellOrderBodyModelFromJson(jsonString);

import 'dart:convert';

CreateSellOrderBodyModel createSellOrderBodyModelFromJson(String str) => CreateSellOrderBodyModel.fromJson(json.decode(str));

String createSellOrderBodyModelToJson(CreateSellOrderBodyModel data) => json.encode(data.toJson());

class CreateSellOrderBodyModel {
    int? amount;
    int? price;
    String? sellerAddress;
    String? walletType;

    CreateSellOrderBodyModel({
        this.amount,
        this.price,
        this.sellerAddress,
        this.walletType,
    });

    factory CreateSellOrderBodyModel.fromJson(Map<String, dynamic> json) => CreateSellOrderBodyModel(
        amount: json["amount"],
        price: json["price"],
        sellerAddress: json["sellerAddress"],
        walletType: json["walletType"],
    );

    Map<String, dynamic> toJson() => {
        "amount": amount,
        "price": price,
        "sellerAddress": sellerAddress,
        "walletType": walletType,
    };
}
