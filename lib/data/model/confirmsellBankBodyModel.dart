// To parse this JSON data, do
//
//     final confirmSellBankBodyModel = confirmSellBankBodyModelFromJson(jsonString);

import 'dart:convert';

ConfirmSellBankBodyModel confirmSellBankBodyModelFromJson(String str) => ConfirmSellBankBodyModel.fromJson(json.decode(str));

String confirmSellBankBodyModelToJson(ConfirmSellBankBodyModel data) => json.encode(data.toJson());

class ConfirmSellBankBodyModel {
   int? amount;
  String? pin;
  String? walletType;
  String? assetSymbol;
    String? methodType;
    String? label;
    Details? details;
    bool? isPrimary;

    ConfirmSellBankBodyModel({
       this.amount,
    this.pin,
    this.walletType,
    this.assetSymbol,
        this.methodType,
        this.label,
        this.details,
        this.isPrimary,
    });

    factory ConfirmSellBankBodyModel.fromJson(Map<String, dynamic> json) => ConfirmSellBankBodyModel(
        amount: json["amount"],
        pin: json["pin"],
        walletType: json["walletType"],
        assetSymbol: json["assetSymbol"],
        methodType: json["methodType"],
        label: json["label"],
        details: json["details"] == null ? null : Details.fromJson(json["details"]),
        isPrimary: json["isPrimary"],
    );

    Map<String, dynamic> toJson() => {
       "amount": amount,
    "pin": pin,
    "walletType": walletType,
    "assetSymbol": assetSymbol,
        "methodType": methodType,
        "label": label,
        "details": details?.toJson(),
        "isPrimary": isPrimary,
    };
}

class Details {
    String? accountNumber;
    String? ifsc;
    String? accountHolderName;

    Details({
        this.accountNumber,
        this.ifsc,
        this.accountHolderName,
    });

    factory Details.fromJson(Map<String, dynamic> json) => Details(
        accountNumber: json["accountNumber"],
        ifsc: json["ifsc"],
        accountHolderName: json["accountHolderName"],
    );

    Map<String, dynamic> toJson() => {
        "accountNumber": accountNumber,
        "ifsc": ifsc,
        "accountHolderName": accountHolderName,
    };
}
