import 'dart:convert';

GetPendingSellOrdersModel getPendingSellOrdersModelFromJson(String str) => GetPendingSellOrdersModel.fromJson(json.decode(str));

String getPendingSellOrdersModelToJson(GetPendingSellOrdersModel data) => json.encode(data.toJson());

class GetPendingSellOrdersModel {
    String? message;
    int? code;
    bool? error;
    Data? data;

    GetPendingSellOrdersModel({
        this.message,
        this.code,
        this.error,
        this.data,
    });

    factory GetPendingSellOrdersModel.fromJson(Map<String, dynamic> json) => GetPendingSellOrdersModel(
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
    List<ListElement>? list;
    Pagination? pagination;

    Data({
        this.list,
        this.pagination,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        list: json["list"] == null ? [] : List<ListElement>.from(json["list"]!.map((x) => ListElement.fromJson(x))),
        pagination: json["pagination"] == null ? null : Pagination.fromJson(json["pagination"]),
    );

    Map<String, dynamic> toJson() => {
        "list": list == null ? [] : List<dynamic>.from(list!.map((x) => x.toJson())),
        "pagination": pagination?.toJson(),
    };
}

class ListElement {
    String? id;
    Creator? creator; // Updated from String? to Creator?
    dynamic counterParty;
    String? sellerAddress;
    String? walletType;
    int? amount;
    int? price;
    String? status;
    Dispute? dispute;
    bool? isDisable;
    bool? isDeleted;
    int? date;
    int? month;
    int? year;
    int? createdAt;
    int? updatedAt;
    int? v;

    ListElement({
        this.id,
        this.creator,
        this.counterParty,
        this.sellerAddress,
        this.walletType,
        this.amount,
        this.price,
        this.status,
        this.dispute,
        this.isDisable,
        this.isDeleted,
        this.date,
        this.month,
        this.year,
        this.createdAt,
        this.updatedAt,
        this.v,
    });

    factory ListElement.fromJson(Map<String, dynamic> json) => ListElement(
        id: json["_id"],
        // Yahan handle kiya gaya hai Map vs String error
        creator: json["creator"] == null 
            ? null 
            : (json["creator"] is Map<String, dynamic> 
                ? Creator.fromJson(json["creator"]) 
                : Creator(id: json["creator"].toString())), 
        counterParty: json["counterParty"],
        sellerAddress: json["sellerAddress"],
        walletType: json["walletType"],
        amount: json["amount"],
        price: json["price"],
        status: json["status"],
        dispute: json["dispute"] == null ? null : Dispute.fromJson(json["dispute"]),
        isDisable: json["isDisable"],
        isDeleted: json["isDeleted"],
        date: json["date"],
        month: json["month"],
        year: json["year"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "creator": creator?.toJson(),
        "counterParty": counterParty,
        "sellerAddress": sellerAddress,
        "walletType": walletType,
        "amount": amount,
        "price": price,
        "status": status,
        "dispute": dispute?.toJson(),
        "isDisable": isDisable,
        "isDeleted": isDeleted,
        "date": date,
        "month": month,
        "year": year,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "__v": v,
    };
}

class Creator {
    String? id;
    String? name;
    String? email;

    Creator({this.id, this.name, this.email});

    factory Creator.fromJson(Map<String, dynamic> json) => Creator(
        id: json["_id"],
        name: json["name"],
        email: json["email"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "email": email,
    };
}

class Dispute {
    bool? isDisputed;
    dynamic raisedBy;
    String? reason;
    bool? resolvedByAdmin;

    Dispute({
        this.isDisputed,
        this.raisedBy,
        this.reason,
        this.resolvedByAdmin,
    });

    factory Dispute.fromJson(Map<String, dynamic> json) => Dispute(
        isDisputed: json["isDisputed"],
        raisedBy: json["raisedBy"],
        reason: json["reason"],
        resolvedByAdmin: json["resolvedByAdmin"],
    );

    Map<String, dynamic> toJson() => {
        "isDisputed": isDisputed,
        "raisedBy": raisedBy,
        "reason": reason,
        "resolvedByAdmin": resolvedByAdmin,
    };
}

class Pagination {
    int? totalRecords;
    int? totalPages;
    int? currentPage;
    int? limit;

    Pagination({
        this.totalRecords,
        this.totalPages,
        this.currentPage,
        this.limit,
    });

    factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        totalRecords: json["totalRecords"],
        totalPages: json["totalPages"],
        currentPage: json["currentPage"],
        limit: json["limit"],
    );

    Map<String, dynamic> toJson() => {
        "totalRecords": totalRecords,
        "totalPages": totalPages,
        "currentPage": currentPage,
        "limit": limit,
    };
}