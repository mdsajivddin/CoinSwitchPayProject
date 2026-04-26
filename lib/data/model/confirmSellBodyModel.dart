// // To parse this JSON data, do
// //
// //     final confirmSellBodyModel = confirmSellBodyModelFromJson(jsonString);

// import 'dart:convert';

// ConfirmSellBodyModel confirmSellBodyModelFromJson(String str) =>
//     ConfirmSellBodyModel.fromJson(json.decode(str));

// String confirmSellBodyModelToJson(ConfirmSellBodyModel data) =>
//     json.encode(data.toJson());

// class ConfirmSellBodyModel {
//   int? amount;
//   String? pin;
//   String? walletType;
//   String? assetSymbol;
//   PaymentMethods? paymentMethods;

//   ConfirmSellBodyModel({
//     this.amount,
//     this.pin,
//     this.walletType,
//     this.assetSymbol,
//     this.paymentMethods,
//   });

//   factory ConfirmSellBodyModel.fromJson(Map<String, dynamic> json) =>
//       ConfirmSellBodyModel(
//         amount: json["amount"],
//         pin: json["pin"],
//         walletType: json["walletType"],
//         assetSymbol: json["assetSymbol"],
//         paymentMethods:
//             json["paymentMethods"] == null
//                 ? null
//                 : PaymentMethods.fromJson(json["paymentMethods"]),
//       );

//   Map<String, dynamic> toJson() => {
//     "amount": amount,
//     "pin": pin,
//     "walletType": walletType,
//     "assetSymbol": assetSymbol,
//     "paymentMethods": paymentMethods?.toJson(),
//   };
// }

// class PaymentMethods {
//   String? methodType;
//   String? label;
//   Details? details;
//   bool? isPrimary;

//   PaymentMethods({this.methodType, this.label, this.details, this.isPrimary});

//   factory PaymentMethods.fromJson(Map<String, dynamic> json) => PaymentMethods(
//     methodType: json["methodType"],
//     label: json["label"],
//     details: json["details"] == null ? null : Details.fromJson(json["details"]),
//     isPrimary: json["isPrimary"],
//   );

//   Map<String, dynamic> toJson() => {
//     "methodType": methodType,
//     "label": label,
//     "details": details?.toJson(),
//     "isPrimary": isPrimary,
//   };
// }

// class Details {
//   String? upiId;
//   String? accountNumber;
//   String? ifsc;
//   String? accountHolderName;

//   Details({this.upiId, this.accountNumber, this.ifsc, this.accountHolderName});

//   factory Details.fromJson(Map<String, dynamic> json) => Details(
//     upiId: json["upiId"] ?? "",
//     accountNumber: json["accountNumber"] ?? "",
//     ifsc: json["ifsc"] ?? "",
//     accountHolderName: json["accountHolderName"] ?? "",
//   );

//   Map<String, dynamic> toJson() => {
//     "upiId": upiId ?? "",
//     "accountNumber": accountNumber ?? "",
//     "ifsc": ifsc ?? "",
//     "accountHolderName": accountHolderName ?? "",
//   };
// }

// To parse this JSON data, do
//
//     final confirmSellUpiBodyModel = confirmSellUpiBodyModelFromJson(jsonString);




// import 'dart:convert';

// ConfirmSellUpiBodyModel confirmSellUpiBodyModelFromJson(String str) =>
//     ConfirmSellUpiBodyModel.fromJson(json.decode(str));

// String confirmSellUpiBodyModelToJson(ConfirmSellUpiBodyModel data) =>
//     json.encode(data.toJson());

// class ConfirmSellUpiBodyModel {
//   int? amount;
//   String? pin;
//   String? walletType;
//   String? assetSymbol;
//   String? methodType;
//   String? label;
//   Details? details;
//   bool? isPrimary;

//   ConfirmSellUpiBodyModel({
//     this.amount,
//     this.pin,
//     this.walletType,
//     this.assetSymbol,
//     this.methodType,
//     this.label,
//     this.details,
//     this.isPrimary,
//   });

//   factory ConfirmSellUpiBodyModel.fromJson(Map<String, dynamic> json) =>
//       ConfirmSellUpiBodyModel(
//         amount: json["amount"],
//         pin: json["pin"],
//         walletType: json["walletType"],
//         assetSymbol: json["assetSymbol"],
//         methodType: json["methodType"],
//         label: json["label"],
//         details:
//             json["details"] == null ? null : Details.fromJson(json["details"]),
//         isPrimary: json["isPrimary"],
//       );

//   Map<String, dynamic> toJson() => {
//     "amount": amount,
//     "pin": pin,
//     "walletType": walletType,
//     "assetSymbol": assetSymbol,
//     "methodType": methodType,
//     "label": label,
//     "details": details?.toJson(),
//     "isPrimary": isPrimary,
//   };
// }

// class Details {
//   String? upiId;

//   Details({this.upiId});

//   factory Details.fromJson(Map<String, dynamic> json) =>
//       Details(upiId: json["upiId"]);

//   Map<String, dynamic> toJson() => {"upiId": upiId};
// }


class ConfirmSellBodyModel {
  int? amount;
  String? pin;
  String? walletType;
  String? assetSymbol;
  PaymentMethods? paymentMethods;

  ConfirmSellBodyModel({
    this.amount,
    this.pin,
    this.walletType,
    this.assetSymbol,
    this.paymentMethods,
  });

  Map<String, dynamic> toJson() => {
        "amount": amount,
        "pin": pin,
        "walletType": walletType,
        "assetSymbol": assetSymbol,
        "paymentMethods": paymentMethods?.toJson(),
      };
}

class PaymentMethods {
  String? methodType;
  String? label;
  bool? isPrimary;
  Details? details;

  PaymentMethods({
    this.methodType,
    this.label,
    this.isPrimary,
    this.details,
  });

  Map<String, dynamic> toJson() => {
        "methodType": methodType,
        "label": label,
        "isPrimary": isPrimary,
        "details": details?.toJson(),
      };
}

class Details {
  String? upiId;

  // bank fields
  String? accountNumber;
  String? ifsc;
  String? accountHolderName;

  Details({
    this.upiId,
    this.accountNumber,
    this.ifsc,
    this.accountHolderName,
  });

  Map<String, dynamic> toJson() => {
        if (upiId != null) "upiId": upiId,
        if (accountNumber != null) "accountNumber": accountNumber,
        if (ifsc != null) "ifsc": ifsc,
        if (accountHolderName != null)
          "accountHolderName": accountHolderName,
      };
}