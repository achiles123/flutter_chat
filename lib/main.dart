import 'package:chat/Models/Chat.dart';
import 'package:chat/Transport/SignalrNotification.dart';
import 'package:flutter/material.dart';
import 'package:chat/Transport/ChatNotify.dart';
import 'package:intl/intl.dart';

String userId = "5d1cca30c995cd0aaec797e6";
String userName = "Rey";
String roomId = "none";

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _txtMessage;
  List<Chat> _listChat;
  ChatNotify _chat;
  SignalrNotification _signal;

  @override
  void initState() {
    super.initState();
    _txtMessage = new TextEditingController();
    _listChat = new List<Chat>();
    _signal = new SignalrNotification();
    _signal.init();
    _signal.onMessage = (List<Object> msg){
      setState(() {
       _listChat.add((msg[0] as Chat));
      });
    };
    _chat = new ChatNotify();
    _chat.setup();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body:Builder(
        builder: (context){
          DateFormat formatDate = new DateFormat("mm:ss");
          return Container(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Container(
                    child: ListView.builder(
                      itemBuilder: (context,index){
                        if(_listChat.length == 0)
                          return Container(
                            height: 10,
                          );
                        if(_listChat[index].userId != userId){
                          return Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Text(formatDate.format(DateTime.now())),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Text(_listChat[index].message),
                                  ],
                                )
                              ],
                            ),
                          );
                        }else{
                          return Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Text(formatDate.format(DateTime.now())),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Text(_listChat[index].message),
                                  ],
                                )
                              ],
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(3),
                  child: Row(
                    children: <Widget>[
                      Flexible(
                        child: TextField(
                          controller: _txtMessage,
                          decoration: InputDecoration(
                            hintText: "Hãy nhập tin nhắn",
                            hintStyle: TextStyle(color: Colors.grey)
                          ),
                        ),
                      ),
                      Container(
                        child: RaisedButton(
                          onPressed: (){
                            _signal.sendMessage(roomId, _txtMessage.text);
                          },
                          child:Icon(Icons.send)
                        ),
                      )
                    ],
                  ),
                ),
              ],
            )
          );
        },
      ) 
      
      
    );
  }
}
