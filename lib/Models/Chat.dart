class Chat{
  String roomId;
  String userName;
  String userId;
  String message;
  int messageType;
  DateTime dateCreate;

  Chat({this.roomId,this.userName,this.userId,this.message,this.messageType,this.dateCreate});

  toJson() {
    return {
      'roomId': roomId,
      'userName': userName,
      'userId': userId,
      'message': message,
      'messageType': messageType,
      'dateCreate': dateCreate.millisecondsSinceEpoch,
    };
  }
}