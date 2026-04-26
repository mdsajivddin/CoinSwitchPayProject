// To parse this JSON data, do
//
//     final releaseAmountRejectOrApproveBody = releaseAmountRejectOrApproveBodyFromJson(jsonString);

import 'dart:convert';

ReleaseAmountRejectOrApproveBody releaseAmountRejectOrApproveBodyFromJson(String str) => ReleaseAmountRejectOrApproveBody.fromJson(json.decode(str));

String releaseAmountRejectOrApproveBodyToJson(ReleaseAmountRejectOrApproveBody data) => json.encode(data.toJson());

class ReleaseAmountRejectOrApproveBody {
    String? orderId;
    String? rejectReason;
    String? status;

    ReleaseAmountRejectOrApproveBody({
        this.orderId,
        this.rejectReason,
        this.status,
    });

    factory ReleaseAmountRejectOrApproveBody.fromJson(Map<String, dynamic> json) => ReleaseAmountRejectOrApproveBody(
        orderId: json["orderId"],
        rejectReason: json["rejectReason"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "orderId": orderId,
        "rejectReason": rejectReason,
        "status": status,
    };
}
