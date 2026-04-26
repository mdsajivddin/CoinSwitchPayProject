// To parse this JSON data, do
//
//     final saveSellRequestBodyModel = saveSellRequestBodyModelFromJson(jsonString);

import 'dart:convert';

SaveSellRequestBodyModel saveSellRequestBodyModelFromJson(String str) => SaveSellRequestBodyModel.fromJson(json.decode(str));

String saveSellRequestBodyModelToJson(SaveSellRequestBodyModel data) => json.encode(data.toJson());

class SaveSellRequestBodyModel {
    String? orderId;
    List<PaymentMethod>? paymentMethods;

    SaveSellRequestBodyModel({
        this.orderId,
        this.paymentMethods,
    });

    factory SaveSellRequestBodyModel.fromJson(Map<String, dynamic> json) => SaveSellRequestBodyModel(
        orderId: json["orderId"],
        paymentMethods: json["paymentMethods"] == null ? [] : List<PaymentMethod>.from(json["paymentMethods"]!.map((x) => PaymentMethod.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "orderId": orderId,
        "paymentMethods": paymentMethods == null ? [] : List<dynamic>.from(paymentMethods!.map((x) => x.toJson())),
    };
}

class PaymentMethod {
    String? methodType;
    String? label;
    Details? details;

    PaymentMethod({
        this.methodType,
        this.label,
        this.details,
    });

    factory PaymentMethod.fromJson(Map<String, dynamic> json) => PaymentMethod(
        methodType: json["methodType"],
        label: json["label"],
        details: json["details"] == null ? null : Details.fromJson(json["details"]),
    );

    Map<String, dynamic> toJson() => {
        "methodType": methodType,
        "label": label,
        "details": details?.toJson(),
    };
}

class Details {
    String? upiId;
    String? holderName;

    Details({
        this.upiId,
        this.holderName,
    });

    factory Details.fromJson(Map<String, dynamic> json) => Details(
        upiId: json["upiId"],
        holderName: json["holderName"],
    );

    Map<String, dynamic> toJson() => {
        "upiId": upiId,
        "holderName": holderName,
    };
}
