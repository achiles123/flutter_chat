import 'package:chat/Models/Chat.dart';
import 'package:chat/main.dart';
import 'package:signalr_client/signalr_client.dart';

class SignalrNotification{
  static String _serverUrl = "http://192.168.1.132:6969/notification";
  HubConnection _hubConnection ;
  Function onMessage;
  Function onNotification;

  Future init() async {
    if (_hubConnection == null) {
      _hubConnection = HubConnectionBuilder().withUrl(_serverUrl).build();
      if (_hubConnection.state != HubConnectionState.Connected) {
        await _hubConnection.start();
      }
      _hubConnection.onclose((error) {
        print(error);
        _hubConnection.start();
      });
      _hubConnection.on("onNotification", _handleNotification);
      _hubConnection.on("onMessage", _handleIncommingChatMessage);

    }

    if (_hubConnection.state != HubConnectionState.Connected) {
      await _hubConnection.start();
    }
  }

  void _handleIncommingChatMessage(List<Object> args){
    List<dynamic> data = args[0];
    onMessage(data);
  }

  void _handleNotification(List<Object> args){
    List<dynamic> data = args[0];
    onNotification(data);
  }

  void sendMessage(String roomId,String message){
    _hubConnection.invoke("SendMessage",args: [
      new Chat(
        roomId:roomId,
        userId:userId,
        userName:userName,
        message:message,
        messageType:1,
        dateCreate:DateTime.now()
      )
    ]);
  }
}