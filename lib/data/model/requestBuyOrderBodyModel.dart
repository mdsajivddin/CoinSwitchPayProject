// To parse this JSON data, do
//
//     final requestBuyOrderBodyModel = requestBuyOrderBodyModelFromJson(jsonString);

import 'dart:convert';

RequestBuyOrderBodyModel requestBuyOrderBodyModelFromJson(String str) => RequestBuyOrderBodyModel.fromJson(json.decode(str));

String requestBuyOrderBodyModelToJson(RequestBuyOrderBodyModel data) => json.encode(data.toJson());

class RequestBuyOrderBodyModel {
    String? orderId;
    String? hash;
    String? image;

    RequestBuyOrderBodyModel({
        this.orderId,
        this.hash,
        this.image,
    });

    factory RequestBuyOrderBodyModel.fromJson(Map<String, dynamic> json) => RequestBuyOrderBodyModel(
        orderId: json["orderId"],
        hash: json["hash"],
        image: json["image"],
    );

    Map<String, dynamic> toJson() => {
        "orderId": orderId,
        "hash": hash,
        "image": image,
    };
}
