// To parse this JSON data, do
//
//     final messageModel = messageModelFromJson(jsonString);

import 'dart:convert';

import 'package:chat_hasura/src/models/user_model.dart';

MessageModel messageModelFromJson(String str) => MessageModel.fromJson(json.decode(str));

String messageModelToJson(MessageModel data) => json.encode(data.toJson());

class MessageModel {
    String content;
    int id;
    UserModel user;

    MessageModel({
        this.content,
        this.id,
        this.user,
    });

    factory MessageModel.fromJson(Map<String, dynamic> json) => new MessageModel(
        content: json["content"],
        id: json["id"],
        user: UserModel.fromJson(json["user"]),
    );

    Map<String, dynamic> toJson() => {
        "content": content,
        "id": id,
        "user": user.toJson(),
    };


    static List<MessageModel> fromJsonList(List list){
      if(list == null) return null;
      return list
        .map((item) => MessageModel.fromJson(item))
        .toList();
    }
}