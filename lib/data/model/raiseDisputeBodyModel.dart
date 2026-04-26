// To parse this JSON data, do
//
//     final raiseDsiputeBodyModel = raiseDsiputeBodyModelFromJson(jsonString);

import 'dart:convert';

RaiseDsiputeBodyModel raiseDsiputeBodyModelFromJson(String str) => RaiseDsiputeBodyModel.fromJson(json.decode(str));

String raiseDsiputeBodyModelToJson(RaiseDsiputeBodyModel data) => json.encode(data.toJson());

class RaiseDsiputeBodyModel {
    String? orderId;
    String? reason;

    RaiseDsiputeBodyModel({
        this.orderId,
        this.reason,
    });

    factory RaiseDsiputeBodyModel.fromJson(Map<String, dynamic> json) => RaiseDsiputeBodyModel(
        orderId: json["orderId"],
        reason: json["reason"],
    );

    Map<String, dynamic> toJson() => {
        "orderId": orderId,
        "reason": reason,
    };
}
