import 'dart:convert';

GetBuyInrDepositeModel getBuyInrDepositeModelFromJson(String str) => GetBuyInrDepositeModel.fromJson(json.decode(str));

String getBuyInrDepositeModelToJson(GetBuyInrDepositeModel data) => json.encode(data.toJson());

class GetBuyInrDepositeModel {
    String? message;
    int? code;
    bool? error;
    Data? data;

    GetBuyInrDepositeModel({
        this.message,
        this.code,
        this.error,
        this.data,
    });

    factory GetBuyInrDepositeModel.fromJson(Map<String, dynamic> json) => GetBuyInrDepositeModel(
        message: json["message"],
        code: json["code"],
        error: json["error"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "code": code,
        "error": error,
        "data": data?.toJson(),
    };
}

class Data {
    bool? status;
    LastData? lastData;

    Data({
        this.status,
        this.lastData,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        status: json["status"],
        lastData: json["lastData"] == null ? null : LastData.fromJson(json["lastData"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "lastData": lastData?.toJson(),
    };
}

class LastData {
    String? id;
    String? userId;
    String? name;
    double? amount;     // Changed to double?
    double? percentage; // Changed to double?
    String? upiId;
    String? status;
    bool? isDisable;
    bool? isDeleted;
    int? expiresAt;
    int? date;
    int? month;
    int? year;
    int? createdAt;
    int? updatedAt;

    LastData({
        this.id,
        this.userId,
        this.name,
        this.amount,
        this.percentage,
        this.upiId,
        this.status,
        this.isDisable,
        this.isDeleted,
        this.expiresAt,
        this.date,
        this.month,
        this.year,
        this.createdAt,
        this.updatedAt,
    });

    factory LastData.fromJson(Map<String, dynamic> json) => LastData(
        id: json["_id"],
        userId: json["userId"],
        name: json["name"],
        // Amount fix:
        amount: json["amount"] == null 
            ? null 
            : (json["amount"] as num).toDouble(),
        // Percentage fix:
        percentage: json["percentage"] == null 
            ? null 
            : (json["percentage"] as num).toDouble(),
        upiId: json["upiId"],
        status: json["status"],
        isDisable: json["isDisable"],
        isDeleted: json["isDeleted"],
        expiresAt: json["expiresAt"],
        date: json["date"],
        month: json["month"],
        year: json["year"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "userId": userId,
        "name": name,
        "amount": amount,
        "percentage": percentage,
        "upiId": upiId,
        "status": status,
        "isDisable": isDisable,
        "isDeleted": isDeleted,
        "expiresAt": expiresAt,
        "date": date,
        "month": month,
        "year": year,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
    };
}