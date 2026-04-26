// To parse this JSON data, do
//
//     final getTicketByIdModel = getTicketByIdModelFromJson(jsonString);

import 'dart:convert';

GetTicketByIdModel getTicketByIdModelFromJson(String str) => GetTicketByIdModel.fromJson(json.decode(str));

String getTicketByIdModelToJson(GetTicketByIdModel data) => json.encode(data.toJson());

class GetTicketByIdModel {
    String? message;
    int? code;
    bool? error;
    Data? data;

    GetTicketByIdModel({
        this.message,
        this.code,
        this.error,
        this.data,
    });

    factory GetTicketByIdModel.fromJson(Map<String, dynamic> json) => GetTicketByIdModel(
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
    Ticket? ticket;
    List<Message>? messages;

    Data({
        this.ticket,
        this.messages,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        ticket: json["ticket"] == null ? null : Ticket.fromJson(json["ticket"]),
        messages: json["messages"] == null ? [] : List<Message>.from(json["messages"]!.map((x) => Message.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "ticket": ticket?.toJson(),
        "messages": messages == null ? [] : List<dynamic>.from(messages!.map((x) => x.toJson())),
    };
}

class Message {
    String? id;
    String? ticketId;
    String? senderType;
    String? senderId;
    String? message;
    bool? read;
    bool? isDisable;
    bool? isDeleted;
    List<Attachment>? attachments;
    int? date;
    int? month;
    int? year;
    int? createdAt;
    int? updatedAt;
    int? v;

    Message({
        this.id,
        this.ticketId,
        this.senderType,
        this.senderId,
        this.message,
        this.read,
        this.isDisable,
        this.isDeleted,
        this.attachments,
        this.date,
        this.month,
        this.year,
        this.createdAt,
        this.updatedAt,
        this.v,
    });

    factory Message.fromJson(Map<String, dynamic> json) => Message(
        id: json["_id"],
        ticketId: json["ticketId"],
        senderType: json["senderType"],
        senderId: json["senderId"],
        message: json["message"],
        read: json["read"],
        isDisable: json["isDisable"],
        isDeleted: json["isDeleted"],
        attachments: json["attachments"] == null ? [] : List<Attachment>.from(json["attachments"]!.map((x) => Attachment.fromJson(x))),
        date: json["date"],
        month: json["month"],
        year: json["year"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "ticketId": ticketId,
        "senderType": senderType,
        "senderId": senderId,
        "message": message,
        "read": read,
        "isDisable": isDisable,
        "isDeleted": isDeleted,
        "attachments": attachments == null ? [] : List<dynamic>.from(attachments!.map((x) => x.toJson())),
        "date": date,
        "month": month,
        "year": year,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "__v": v,
    };
}

class Attachment {
    String? url;
    String? type;
    String? id;

    Attachment({
        this.url,
        this.type,
        this.id,
    });

    factory Attachment.fromJson(Map<String, dynamic> json) => Attachment(
        url: json["url"],
        type: json["type"],
        id: json["_id"],
    );

    Map<String, dynamic> toJson() => {
        "url": url,
        "type": type,
        "_id": id,
    };
}

class Ticket {
    String? id;
    String? userId;
    List<String>? reasonPath;
    bool? issueResolved;
    String? status;
    String? priority;
    bool? isDisable;
    bool? isDeleted;
    int? date;
    int? month;
    int? year;
    int? createdAt;
    int? updatedAt;
    int? v;

    Ticket({
        this.id,
        this.userId,
        this.reasonPath,
        this.issueResolved,
        this.status,
        this.priority,
        this.isDisable,
        this.isDeleted,
        this.date,
        this.month,
        this.year,
        this.createdAt,
        this.updatedAt,
        this.v,
    });

    factory Ticket.fromJson(Map<String, dynamic> json) => Ticket(
        id: json["_id"],
        userId: json["userId"],
        reasonPath: json["reasonPath"] == null ? [] : List<String>.from(json["reasonPath"]!.map((x) => x)),
        issueResolved: json["issueResolved"],
        status: json["status"],
        priority: json["priority"],
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
        "userId": userId,
        "reasonPath": reasonPath == null ? [] : List<dynamic>.from(reasonPath!.map((x) => x)),
        "issueResolved": issueResolved,
        "status": status,
        "priority": priority,
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
