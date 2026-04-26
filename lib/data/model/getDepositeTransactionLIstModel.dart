// // To parse this JSON data, do
// //
// //     final getdepositeTransactionListModel = getdepositeTransactionListModelFromJson(jsonString);

// import 'dart:convert';

// GetdepositeTransactionListModel getdepositeTransactionListModelFromJson(String str) => GetdepositeTransactionListModel.fromJson(json.decode(str));

// String getdepositeTransactionListModelToJson(GetdepositeTransactionListModel data) => json.encode(data.toJson());

// class GetdepositeTransactionListModel {
//     String? message;
//     int? code;
//     bool? error;
//     Data? data;

//     GetdepositeTransactionListModel({
//         this.message,
//         this.code,
//         this.error,
//         this.data,
//     });

//     factory GetdepositeTransactionListModel.fromJson(Map<String, dynamic> json) => GetdepositeTransactionListModel(
//         message: json["message"],
//         code: json["code"],
//         error: json["error"],
//         data: json["data"] == null ? null : Data.fromJson(json["data"]),
//     );

//     Map<String, dynamic> toJson() => {
//         "message": message,
//         "code": code,
//         "error": error,
//         "data": data?.toJson(),
//     };
// }

// class Data {
//     int? total;
//     int? page;
//     int? pages;
//     List<Datum>? data;

//     Data({
//         this.total,
//         this.page,
//         this.pages,
//         this.data,
//     });

//     factory Data.fromJson(Map<String, dynamic> json) => Data(
//         total: json["total"],
//         page: json["page"],
//         pages: json["pages"],
//         data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
//     );

//     Map<String, dynamic> toJson() => {
//         "total": total,
//         "page": page,
//         "pages": pages,
//         "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
//     };
// }

// class Datum {
//     String? id;
//     UserId? userId;
//     String? walletAddress;
//     WalletType? walletType;
//     TxType? txType;
//     int? amount;
//     Network? network;
//     Status? status;
//     int? expiresAt;
//     bool? isDisable;
//     bool? isDeleted;
//     int? date;
//     int? month;
//     int? year;
//     int? createdAt;
//     int? updatedAt;
//     int? v;
//     String? rejectReason;
//     String? hash;
//     String? image;

//     Datum({
//         this.id,
//         this.userId,
//         this.walletAddress,
//         this.walletType,
//         this.txType,
//         this.amount,
//         this.network,
//         this.status,
//         this.expiresAt,
//         this.isDisable,
//         this.isDeleted,
//         this.date,
//         this.month,
//         this.year,
//         this.createdAt,
//         this.updatedAt,
//         this.v,
//         this.rejectReason,
//         this.hash,
//         this.image,
//     });

//     factory Datum.fromJson(Map<String, dynamic> json) => Datum(
//         id: json["_id"],
//         userId: userIdValues.map[json["userId"]]!,
//         walletAddress: json["walletAddress"],
//         walletType: walletTypeValues.map[json["walletType"]]!,
//         txType: txTypeValues.map[json["txType"]]!,
//         amount: json["amount"],
//         network: networkValues.map[json["network"]]!,
//         status: statusValues.map[json["status"]]!,
//         expiresAt: json["expiresAt"],
//         isDisable: json["isDisable"],
//         isDeleted: json["isDeleted"],
//         date: json["date"],
//         month: json["month"],
//         year: json["year"],
//         createdAt: json["createdAt"],
//         updatedAt: json["updatedAt"],
//         v: json["__v"],
//         rejectReason: json["rejectReason"],
//         hash: json["hash"],
//         image: json["image"],
//     );

//     Map<String, dynamic> toJson() => {
//         "_id": id,
//         "userId": userIdValues.reverse[userId],
//         "walletAddress": walletAddress,
//         "walletType": walletTypeValues.reverse[walletType],
//         "txType": txTypeValues.reverse[txType],
//         "amount": amount,
//         "network": networkValues.reverse[network],
//         "status": statusValues.reverse[status],
//         "expiresAt": expiresAt,
//         "isDisable": isDisable,
//         "isDeleted": isDeleted,
//         "date": date,
//         "month": month,
//         "year": year,
//         "createdAt": createdAt,
//         "updatedAt": updatedAt,
//         "__v": v,
//         "rejectReason": rejectReason,
//         "hash": hash,
//         "image": image,
//     };
// }

// enum Network {
//     BEP20,
//     ERC20,
//     TRC20
// }

// final networkValues = EnumValues({
//     "BEP20": Network.BEP20,
//     "ERC20": Network.ERC20,
//     "TRC20": Network.TRC20
// });

// enum Status {
//     EXPIRED,
//     PROCESS
// }

// final statusValues = EnumValues({
//     "expired": Status.EXPIRED,
//     "process": Status.PROCESS
// });

// enum TxType {
//     DEPOSIT
// }

// final txTypeValues = EnumValues({
//     "deposit": TxType.DEPOSIT
// });

// enum UserId {
//     THE_69_A004_EC5363225_E4046_EB70
// }

// final userIdValues = EnumValues({
//     "69a004ec5363225e4046eb70": UserId.THE_69_A004_EC5363225_E4046_EB70
// });

// enum WalletType {
//     USDT
// }

// final walletTypeValues = EnumValues({
//     "USDT": WalletType.USDT
// });

// class EnumValues<T> {
//     Map<String, T> map;
//     late Map<T, String> reverseMap;

//     EnumValues(this.map);

//     Map<T, String> get reverse {
//             reverseMap = map.map((k, v) => MapEntry(v, k));
//             return reverseMap;
//     }
// }



import 'dart:convert';

GetDepositTransactionListModel getDepositTransactionListModelFromJson(String str) => 
    GetDepositTransactionListModel.fromJson(json.decode(str));

String getDepositTransactionListModelToJson(GetDepositTransactionListModel data) => 
    json.encode(data.toJson());

class GetDepositTransactionListModel {
  String? message;
  int? code;
  bool? error;
  Data? data;

  GetDepositTransactionListModel({
    this.message,
    this.code,
    this.error,
    this.data,
  });

  factory GetDepositTransactionListModel.fromJson(Map<String, dynamic> json) => 
    GetDepositTransactionListModel(
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
    data: json["data"] == null 
        ? [] 
        : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
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
  String? walletAddress;
  String? walletType; // "USDT" or "INR"
  String? txType;
  num? amount;        // num use kiya hai taaki int/double dono chalein
  String? network;    // USDT specific
  String? status;
  int? expiresAt;
  bool? isDisable;
  bool? isDeleted;
  int? date;
  int? month;
  int? year;
  int? createdAt;
  int? updatedAt;
  int? v;
  String? rejectReason;
  String? hash;       // INR specific
  String? image;      // INR specific

  Datum({
    this.id,
    this.userId,                                      
    this.walletAddress,
    this.walletType,
    this.txType,
    this.amount,
    this.network,
    this.status,
    this.expiresAt,
    this.isDisable,
    this.isDeleted,
    this.date,
    this.month,
    this.year,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.rejectReason,
    this.hash,
    this.image,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["_id"],
    userId: json["userId"]?.toString(), // Safely convert to string
    walletAddress: json["walletAddress"],
    walletType: json["walletType"],
    txType: json["txType"],
    amount: json["amount"],
    network: json["network"],
    status: json["status"],
    expiresAt: json["expiresAt"],
    isDisable: json["isDisable"],
    isDeleted: json["isDeleted"],
    date: json["date"],
    month: json["month"],
    year: json["year"],
    createdAt: json["createdAt"],
    updatedAt: json["updatedAt"],
    v: json["__v"],
    rejectReason: json["rejectReason"],
    hash: json["hash"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "userId": userId,
    "walletAddress": walletAddress,
    "walletType": walletType,
    "txType": txType,
    "amount": amount,
    "network": network,
    "status": status,
    "expiresAt": expiresAt,
    "isDisable": isDisable,
    "isDeleted": isDeleted,
    "date": date,
    "month": month,
    "year": year,
    "createdAt": createdAt,
    "updatedAt": updatedAt,
    "__v": v,
    "rejectReason": rejectReason,
    "hash": hash,
    "image": image,
  };
}