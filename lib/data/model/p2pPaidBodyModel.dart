// To parse this JSON data, do
//
//     final p2PPaidBodyModel = p2PPaidBodyModelFromJson(jsonString);

import 'dart:convert';

P2PPaidBodyModel p2PPaidBodyModelFromJson(String str) => P2PPaidBodyModel.fromJson(json.decode(str));

String p2PPaidBodyModelToJson(P2PPaidBodyModel data) => json.encode(data.toJson());

class P2PPaidBodyModel {
    String? hash;
    String? image;
    String? orderId;
    String? pin;
    String? methodId;

    P2PPaidBodyModel({
        this.hash,
        this.image,
        this.orderId,
        this.pin,
        this.methodId,
    });

    factory P2PPaidBodyModel.fromJson(Map<String, dynamic> json) => P2PPaidBodyModel(
        hash: json["hash"],
        image: json["image"],
        orderId: json["orderId"],
        pin: json["pin"],
        methodId: json["methodId"],
    );

    Map<String, dynamic> toJson() => {
        "hash": hash,
        "image": image,
        "orderId": orderId,
        "pin": pin,
        "methodId": methodId,
    };
}
