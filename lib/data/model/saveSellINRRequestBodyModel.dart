// To parse this JSON data, do
//
//     final saveSellInrRequestBodyModel = saveSellInrRequestBodyModelFromJson(jsonString);

import 'dart:convert';

SaveSellInrRequestBodyModel saveSellInrRequestBodyModelFromJson(String str) => SaveSellInrRequestBodyModel.fromJson(json.decode(str));

String saveSellInrRequestBodyModelToJson(SaveSellInrRequestBodyModel data) => json.encode(data.toJson());

class SaveSellInrRequestBodyModel {
    String? orderId;
    List<PaymentMethod>? paymentMethods;

    SaveSellInrRequestBodyModel({
        this.orderId,
        this.paymentMethods,
    });

    factory SaveSellInrRequestBodyModel.fromJson(Map<String, dynamic> json) => SaveSellInrRequestBodyModel(
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
    bool? isPrimary;

    PaymentMethod({
        this.methodType,
        this.label,
        this.details,
        this.isPrimary,
    });

    factory PaymentMethod.fromJson(Map<String, dynamic> json) => PaymentMethod(
        methodType: json["methodType"],
        label: json["label"],
        details: json["details"] == null ? null : Details.fromJson(json["details"]),
        isPrimary: json["isPrimary"],
    );

    Map<String, dynamic> toJson() => {
        "methodType": methodType,
        "label": label,
        "details": details?.toJson(),
        "isPrimary": isPrimary,
    };
}

class Details {
    String? bankName;
    String? accountNumber;
    String? ifscCode;
    String? branchName;
    String? accountHolderName;

    Details({
        this.bankName,
        this.accountNumber,
        this.ifscCode,
        this.branchName,
        this.accountHolderName,
    });

    factory Details.fromJson(Map<String, dynamic> json) => Details(
        bankName: json["bankName"],
        accountNumber: json["accountNumber"],
        ifscCode: json["ifscCode"],
        branchName: json["branchName"],
        accountHolderName: json["accountHolderName"],
    );

    Map<String, dynamic> toJson() => {
        "bankName": bankName,
        "accountNumber": accountNumber,
        "ifscCode": ifscCode,
        "branchName": branchName,
        "accountHolderName": accountHolderName,
    };
}
