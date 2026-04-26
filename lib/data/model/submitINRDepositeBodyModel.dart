// To parse this JSON data, do
//
//     final submitInrDepositeBodyModel = submitInrDepositeBodyModelFromJson(jsonString);

import 'dart:convert';

SubmitInrDepositeBodyModel submitInrDepositeBodyModelFromJson(String str) => SubmitInrDepositeBodyModel.fromJson(json.decode(str));

String submitInrDepositeBodyModelToJson(SubmitInrDepositeBodyModel data) => json.encode(data.toJson());

class SubmitInrDepositeBodyModel {
    String? orderId;
    String? hash;
    String? image;
    String? pin;
    String? rate;
    String? realAmount;
    String? upi;
    String? upiHolder;

    SubmitInrDepositeBodyModel({
        this.orderId,
        this.hash,
        this.image,
        this.pin,
        this.rate,
        this.realAmount,
        this.upi,
        this.upiHolder,
    });

    factory SubmitInrDepositeBodyModel.fromJson(Map<String, dynamic> json) => SubmitInrDepositeBodyModel(
        orderId: json["orderId"],
        hash: json["hash"],
        image: json["image"],
        pin: json["pin"],
        rate: json["rate"],
        realAmount: json["realAmount"],
        upi: json["upi"],
        upiHolder: json["upiHolder"],
    );

    Map<String, dynamic> toJson() => {
        "orderId": orderId,
        "hash": hash,
        "image": image,
        "pin": pin,
        "rate": rate,
        "realAmount": realAmount,
        "upi": upi,
        "upiHolder": upiHolder,
    };
}
