import 'package:flutter_local_notifications/flutter_local_notifications.dart';


class ChatNotify{
    AndroidInitializationSettings _androidSetting;
    IOSInitializationSettings _iosSetting;
    InitializationSettings _initSetting;
    FlutterLocalNotificationsPlugin _localNotification;
    AndroidNotificationDetails _androidNotitfication;
    IOSNotificationDetails _iosNotification;
    NotificationDetails _notification;
    String _channelId = "1";
    String _channelName = "Channel 1";
    String _channelDescription = "Test";

     void setup(){
      _androidSetting = new AndroidInitializationSettings("@mipmap/ic_launcher");
      _iosSetting = IOSInitializationSettings();
      _initSetting = new InitializationSettings(_androidSetting,_iosSetting);
      _localNotification = new FlutterLocalNotificationsPlugin();
      _localNotification.initialize(_initSetting);
      _androidNotitfication = new AndroidNotificationDetails(_channelId,_channelName,_channelDescription);
      _iosNotification = new IOSNotificationDetails();
      _notification = new NotificationDetails(_androidNotitfication,_iosNotification);
      _localNotification.show(0, "Tin nhắn", "ok", _notification);
     }
}