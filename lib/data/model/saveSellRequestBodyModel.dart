import 'dart:convert';

SaveSellRequestBodyModel saveSellRequestBodyModelFromJson(String str) =>
    SaveSellRequestBodyModel.fromJson(json.decode(str));

String saveSellRequestBodyModelToJson(SaveSellRequestBodyModel data) =>
    json.encode(data.toJson());

class SaveSellRequestBodyModel {
  String? orderId;
  List<PaymentMethod>? paymentMethods;

  SaveSellRequestBodyModel({
    this.orderId,
    this.paymentMethods,
  });

  factory SaveSellRequestBodyModel.fromJson(Map<String, dynamic> json) =>
      SaveSellRequestBodyModel(
        orderId: json["orderId"],
        paymentMethods: json["paymentMethods"] == null
            ? []
            : List<PaymentMethod>.from(
                json["paymentMethods"]
                    .map((x) => PaymentMethod.fromJson(x))),
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (orderId != null) data["orderId"] = orderId;

    if (paymentMethods != null) {
      data["paymentMethods"] =
          paymentMethods!.map((e) => e.toJson()).toList();
    }

    return data;
  }
}

class PaymentMethod {
  String? methodType; // UPI / BANK_TRANSFER
  String? label;
  bool? isPrimary;
  Details? details;

  PaymentMethod({
    this.methodType,
    this.label,
    this.isPrimary,
    this.details,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) =>
      PaymentMethod(
        methodType: json["methodType"],
        label: json["label"],
        isPrimary: json["isPrimary"],
        details: json["details"] == null
            ? null
            : Details.fromJson(json["details"]),
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (methodType != null) data["methodType"] = methodType;
    if (label != null) data["label"] = label;
    if (isPrimary != null) data["isPrimary"] = isPrimary;
    if (details != null) data["details"] = details!.toJson();

    return data;
  }
}

class Details {
  /// UPI fields
  String? upiId;
  String? holderName;

  /// Bank fields
  String? bankName;
  String? accountNumber;
  String? ifscCode;
  String? branchName;
  String? accountHolderName;

  Details({
    this.upiId,
    this.holderName,
    this.bankName,
    this.accountNumber,
    this.ifscCode,
    this.branchName,
    this.accountHolderName,
  });

  factory Details.fromJson(Map<String, dynamic> json) => Details(
        upiId: json["upiId"],
        holderName: json["holderName"],
        bankName: json["bankName"],
        accountNumber: json["accountNumber"],
        ifscCode: json["ifscCode"],
        branchName: json["branchName"],
        accountHolderName: json["accountHolderName"],
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (upiId != null) data["upiId"] = upiId;
    if (holderName != null) data["holderName"] = holderName;

    if (bankName != null) data["bankName"] = bankName;
    if (accountNumber != null) data["accountNumber"] = accountNumber;
    if (ifscCode != null) data["ifscCode"] = ifscCode;
    if (branchName != null) data["branchName"] = branchName;
    if (accountHolderName != null)
      data["accountHolderName"] = accountHolderName;

    return data;
  }
}