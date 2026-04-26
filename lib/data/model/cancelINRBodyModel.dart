// To parse this JSON data, do
//
//     final canceInrDepositeBodyModel = canceInrDepositeBodyModelFromJson(jsonString);

import 'dart:convert';

CanceInrDepositeBodyModel canceInrDepositeBodyModelFromJson(String str) => CanceInrDepositeBodyModel.fromJson(json.decode(str));

String canceInrDepositeBodyModelToJson(CanceInrDepositeBodyModel data) => json.encode(data.toJson());

class CanceInrDepositeBodyModel {
    String? orderId;

    CanceInrDepositeBodyModel({
        this.orderId,
    });

    factory CanceInrDepositeBodyModel.fromJson(Map<String, dynamic> json) => CanceInrDepositeBodyModel(
        orderId: json["orderId"],
    );

    Map<String, dynamic> toJson() => {
        "orderId": orderId,
    };
}
