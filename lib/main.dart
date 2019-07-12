import 'package:chat/Constants.dart';
import 'package:chat/Models/Chat.dart';
import 'package:chat/Transport/SignalrNotification.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chat/Transport/ChatNotify.dart';
import 'package:intl/intl.dart';

import 'Popups/EmojiPopup.dart';

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
  EmojiPopup _emojiPopup;
  GlobalKey _messageKey;
  Offset _messageOffset;

  @override
  void initState() {
    super.initState();
    _txtMessage = new TextEditingController();
    _listChat = new List<Chat>();
    _signal = new SignalrNotification();
    _emojiPopup = new EmojiPopup(context);
    _emojiPopup.selectedEmo = (emoKey){
      _txtMessage.text += emoKey;
    };
    _messageKey = new GlobalKey();
    _signal.init();
    _signal.onMessage = (dynamic msg){
      setState(() {
       _listChat.add(msg);
      });
    };
    _chat = new ChatNotify();
    _chat.setup();
    WidgetsBinding.instance.addPostFrameCallback((_){
      _messageOffset = (_messageKey.currentContext.findRenderObject() as RenderBox).localToGlobal(Offset.zero);
    });
  }

  void submit(){
    if(_txtMessage.text.isEmpty)
      return;
    _signal.sendMessage(roomId, _txtMessage.text);
    _txtMessage.clear();
  }

  List<Widget> formatMessage(String msg){
    List<Widget> result = new List<Widget>();
    Map<int,Map<String,String>> parts = new Map<int,Map<String,String>>();
    for(MapEntry<String,String> emo in Constants.emojiList.entries){
      int lastIndex = msg.lastIndexOf('\(like\)');
      int indexEmo = 0;
      if(lastIndex != -1){
        while(indexEmo <= lastIndex){
          indexEmo = msg.indexOf('\(like\)',indexEmo);
          if(indexEmo != -1){
            parts.addAll({indexEmo:{emo.key:emo.value}});
          }
          indexEmo += emo.key.length;
        }
      
      }
    }
    List<int> partsSorted = parts.keys.toList()..sort();
    int beginCusor = 0;
    int endCusor = msg.length;
    for(int key in partsSorted){
      if(key - beginCusor != 0)
        result.add(Text(msg.substring(beginCusor,key-1)));
      result.add(Image.asset(parts[key].values.first,width: 16,height: 16,));
      beginCusor = key+parts[key].keys.first.length;
    }
    if(endCusor > beginCusor)
      result.add(Text(msg.substring(beginCusor)));
    if(beginCusor == 0)
      result.add(Text(msg));
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body:Builder(
        builder: (context){
          DateFormat formatDate = new DateFormat("HH:mm a");
          return Container(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Container(
                    child: ListView.builder(
                      itemCount:  _listChat.length,
                      itemBuilder: (context,index){
                        if(_listChat.length == 0)
                          return Container();
                        bool isSameTime = (index - 1 >= 0 && formatDate.format(_listChat[index-1].dateCreate)  == formatDate.format(_listChat[index].dateCreate) && _listChat[index-1].userId == _listChat[index].userId)?true:false;
                        if(_listChat[index].userId != userId){ // Thiers
                          return Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Builder(
                                  builder: (context){
                                    if(!isSameTime){
                                      return Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            alignment: Alignment.topLeft,
                                            margin: EdgeInsets.only(bottom: 0,top: 5,left: 5,right: 5),
                                            padding: EdgeInsets.all(3),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(5)),
                                              //color: Color(0xffeff5f5)
                                            ),
                                            child: Text(
                                              _listChat[index].userName +", "+formatDate.format(_listChat[index].dateCreate),
                                              textAlign: TextAlign.right,style: TextStyle(fontSize: 12,color: Colors.grey),
                                              ),
                                          )

                                        ],
                                      );
                                    }else{
                                      return Container();
                                    }
                                  },
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      alignment: Alignment.topLeft,
                                      margin: EdgeInsets.only(bottom: isSameTime || index - 1 < 0?1:5,top: isSameTime || index - 1 < 0?1:5,left: 5,right: 5),
                                      padding: EdgeInsets.only(bottom: 7,top: 7,left: 5,right: 5),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(5)),
                                        color: Color(0xffeff5f5)
                                      ),
                                      //child: Text(_listChat[index].message,textAlign: TextAlign.right),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: formatMessage(_listChat[index].message),
                                      )
                                    )
                                    
                                  ],
                                )
                              ],
                            ),
                          );
                        }else{ // My
                          return Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Builder(
                                  builder: (context){
                                    if(!isSameTime){
                                      return Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: <Widget>[
                                          Container(
                                            alignment: Alignment.topRight,
                                            margin: EdgeInsets.only(bottom: 0,top: 5,left: 5,right: 5),
                                            padding: EdgeInsets.all(3),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(5)),
                                              //color: Color(0xffcce6ff)
                                            ),
                                            child: Text(
                                              formatDate.format(_listChat[index].dateCreate),
                                              textAlign: TextAlign.right,style: TextStyle(fontSize: 12,color: Colors.grey),
                                              ),
                                          )

                                        ],
                                      );
                                    }else{
                                      return Container();
                                    }
                                  },
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Container(
                                      alignment: Alignment.topRight,
                                      margin: EdgeInsets.only(bottom: isSameTime || index - 1 < 0?1:5,top: isSameTime || index - 1 < 0?1:5,left: 5,right: 5),
                                      padding: EdgeInsets.only(bottom: 7,top: 7,left: 5,right: 5),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(5)),
                                        color: Color(0xffcce6ff)
                                      ),
                                      //child: Text(_listChat[index].message,textAlign: TextAlign.right),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: formatMessage(_listChat[index].message),
                                      )
                                    )
                                    
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
                  key: _messageKey,
                  padding: EdgeInsets.all(3),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Flexible(
                            child: TextField(
                              controller: _txtMessage,
                              decoration: InputDecoration(
                                hintText: "Hãy nhập tin nhắn",
                                hintStyle: TextStyle(color: Colors.grey)
                              ),
                              onSubmitted: (text){
                                submit();
                              },
                            ),
                          ),
                          ButtonTheme(
                            minWidth: 10,
                            buttonColor: Colors.white,
                            child: RaisedButton(
                              onPressed: (){
                                submit();
                              },
                              child:Icon(Icons.send,color: Colors.blue,)
                            ),
                          )
                        ],
                      ), // Chat text
                      Row(
                        children: <Widget>[
                          InkWell(
                            onTap: (){
                              double x = _messageOffset.dx;
                              double y = MediaQuery.of(context).size.height -  _messageOffset.dy;
                              _emojiPopup.show(context: context,x: x,y: y);
                            },
                            child: Container(
                              padding: EdgeInsets.only(top:5,bottom: 5,right: 7,left: 7),
                              child: Image.asset("assets/emo/smile_display.png",fit: BoxFit.fill,height: 25,width: 25,),
                            ),
                          ),
                          
                        ],
                      )
                    ],
                  )
                  
                  
                  
                ),
              ],
            )
          );
        },
      ) 
      
      
    );
  }
}
