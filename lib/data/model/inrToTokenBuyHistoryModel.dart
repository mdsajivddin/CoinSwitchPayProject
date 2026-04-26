// // To parse this JSON data, do
// //
// //     final intToTokenBuyHistoryModel = intToTokenBuyHistoryModelFromJson(jsonString);

// import 'dart:convert';

// IntToTokenBuyHistoryModel intToTokenBuyHistoryModelFromJson(String str) =>
//     IntToTokenBuyHistoryModel.fromJson(json.decode(str));

// String intToTokenBuyHistoryModelToJson(IntToTokenBuyHistoryModel data) =>
//     json.encode(data.toJson());

// class IntToTokenBuyHistoryModel {
//   String? message;
//   int? code;
//   bool? error;
//   Data? data;

//   IntToTokenBuyHistoryModel({this.message, this.code, this.error, this.data});

//   factory IntToTokenBuyHistoryModel.fromJson(Map<String, dynamic> json) =>
//       IntToTokenBuyHistoryModel(
//         message: json["message"],
//         code: json["code"],
//         error: json["error"],
//         data: json["data"] == null ? null : Data.fromJson(json["data"]),
//       );

//   Map<String, dynamic> toJson() => {
//     "message": message,
//     "code": code,
//     "error": error,
//     "data": data?.toJson(),
//   };
// }

// class Data {
//   int? total;
//   int? page;
//   int? pages;
//   List<Datum>? data;

//   Data({this.total, this.page, this.pages, this.data});

//   factory Data.fromJson(Map<String, dynamic> json) => Data(
//     total: json["total"],
//     page: json["page"],
//     pages: json["pages"],
//     data:
//         json["data"] == null
//             ? []
//             : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
//   );

//   Map<String, dynamic> toJson() => {
//     "total": total,
//     "page": page,
//     "pages": pages,
//     "data":
//         data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
//   };
// }

// class Datum {
//   String? id;
//   String? userId;
//   String? walletType;
//   String? txType;
//   double? amount;
//   String? status;
//   String? hash;
//   String? image;
//   bool? isDisable;
//   bool? isDeleted;
//   int? expiresAt;
//   int? date;
//   int? month;
//   int? year;
//   int? createdAt;
//   int? updatedAt;
//   int? v;
//   String? rejectReason;

//   Datum({
//     this.id,
//     this.userId,
//     this.walletType,
//     this.txType,
//     this.amount,
//     this.status,
//     this.hash,
//     this.image,
//     this.isDisable,
//     this.isDeleted,
//     this.expiresAt,
//     this.date,
//     this.month,
//     this.year,
//     this.createdAt,
//     this.updatedAt,
//     this.v,
//     this.rejectReason,
//   });

//   factory Datum.fromJson(Map<String, dynamic> json) => Datum(
//     id: json["_id"],
//     userId: json["userId"],
//     walletType: json["walletType"],
//     txType: json["txType"],
//     amount: (json["amount"] as num?)?.toDouble(),
//     status: json["status"],
//     hash: json["hash"],
//     image: json["image"],
//     isDisable: json["isDisable"],
//     isDeleted: json["isDeleted"],
//     expiresAt: json["expiresAt"],
//     date: json["date"],
//     month: json["month"],
//     year: json["year"],
//     createdAt: json["createdAt"],
//     updatedAt: json["updatedAt"],
//     v: json["__v"],
//     rejectReason: json["rejectReason"],
//   );

//   Map<String, dynamic> toJson() => {
//     "_id": id,
//     "userId": userId,
//     "walletType": walletType,
//     "txType": txType,
//     "amount": amount,
//     "status": status,
//     "hash": hash,
//     "image": image,
//     "isDisable": isDisable,
//     "isDeleted": isDeleted,
//     "expiresAt": expiresAt,
//     "date": date,
//     "month": month,
//     "year": year,
//     "createdAt": createdAt,
//     "updatedAt": updatedAt,
//     "__v": v,
//     "rejectReason": rejectReason,
//   };
// }


// To parse this JSON data, do
//
//     final intToTokenBuyHistoryModel = intToTokenBuyHistoryModelFromJson(jsonString);

import 'dart:convert';

IntToTokenBuyHistoryModel intToTokenBuyHistoryModelFromJson(String str) => IntToTokenBuyHistoryModel.fromJson(json.decode(str));

String intToTokenBuyHistoryModelToJson(IntToTokenBuyHistoryModel data) => json.encode(data.toJson());

class IntToTokenBuyHistoryModel {
    String? message;
    int? code;
    bool? error;
    Data? data;

    IntToTokenBuyHistoryModel({
        this.message,
        this.code,
        this.error,
        this.data,
    });

    factory IntToTokenBuyHistoryModel.fromJson(Map<String, dynamic> json) => IntToTokenBuyHistoryModel(
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
    int? total;
    int? page;
    int? pages;
    List<Datum>? data;

    Data({
        this.total,
        this.page,
        this.pages,
        this.data,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        total: json["total"],
        page: json["page"],
        pages: json["pages"],
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "total": total,
        "page": page,
        "pages": pages,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class Datum {
    String? id;
    String? userId;
    String? walletType;
    String? txType;
    double? amount;
    String? status;
    String? hash;
    String? image;
    double? rate;
    int? realAmount;
    String? upi;
    dynamic expiresAt;
    bool? isDisable;
    bool? isDeleted;
    int? date;
    int? month;
    int? year;
    int? createdAt;
    int? updatedAt;
    String? orderId;
    int? v;
    String? rejectReason;

    Datum({
        this.id,
        this.userId,
        this.walletType,
        this.txType,
        this.amount,
        this.status,
        this.hash,
        this.image,
        this.rate,
        this.realAmount,
        this.upi,
        this.expiresAt,
        this.isDisable,
        this.isDeleted,
        this.date,
        this.month,
        this.year,
        this.createdAt,
        this.updatedAt,
        this.orderId,
        this.v,
        this.rejectReason,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["_id"],
        userId: json["userId"],
        walletType: json["walletType"],
        txType: json["txType"],
        amount: json["amount"]?.toDouble(),
        status: json["status"],
        hash: json["hash"],
        image: json["image"],
        rate: json["rate"]?.toDouble(),
        realAmount: json["realAmount"],
        upi: json["upi"],
        expiresAt: json["expiresAt"],
        isDisable: json["isDisable"],
        isDeleted: json["isDeleted"],
        date: json["date"],
        month: json["month"],
        year: json["year"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
        orderId: json["orderId"],
        v: json["__v"],
        rejectReason: json["rejectReason"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "userId": userId,
        "walletType": walletType,
        "txType": txType,
        "amount": amount,
        "status": status,
        "hash": hash,
        "image": image,
        "rate": rate,
        "realAmount": realAmount,
        "upi": upi,
        "expiresAt": expiresAt,
        "isDisable": isDisable,
        "isDeleted": isDeleted,
        "date": date,
        "month": month,
        "year": year,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "orderId": orderId,
        "__v": v,
        "rejectReason": rejectReason,
    };
}
