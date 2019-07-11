import 'dart:convert';

import 'package:intl/intl.dart';

class Chat{
  String roomId;
  String userName;
  String userId;
  String message;
  int messageType;
  DateTime dateCreate;

  Chat({this.roomId,this.userName,this.userId,this.message,this.messageType,this.dateCreate});

  toJson() {
    DateFormat format = new DateFormat("yyyy-MM-dd HH:mm:ss");
    return {
      'roomId': roomId,
      'userName': userName,
      'userId': userId,
      'message': message,
      'messageType': messageType,
      'dateCreate': format.format(dateCreate) ,
    };
  }

  factory Chat.parseJson(Map<String,dynamic> json){
    return Chat(
      roomId: json["roomId"],
      userId: json["userId"],
      userName: json["userName"],
      message: json["message"],
      messageType: json["messageType"],
      dateCreate: DateTime.tryParse(json["dateCreate"]) ,
    );
  }
}