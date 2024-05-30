import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mailer/mailer.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _firestore = FirebaseFirestore.instance;

var userData; 

class ChatScreen extends StatefulWidget {
  static String routeName = "/chat";
  final _auth = FirebaseAuth.instance;
  ChatScreen({super.key});
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController _messageController = TextEditingController();
  List<ChatMessage> _messages = [];
  String? messgeText;
  var account = GetStorage();

  @override
  void initState() {
    super.initState();
    userData = account.read('keyUser');
    // _messages.add(
    //     ChatMessage(message: "Hello! How can We help you?", isUser: false));
  }

  void _sendMessage(String message) {
    setState(() {
      _messages.add(ChatMessage(message: message, isUser: true));
      // Simulating a response from ChatGPT
      _messages.add(ChatMessage(
          message: "We will solve your problem within a short time",
          isUser: false));
    });
    _messageController.clear();
  }

  void messageStreams() async {
    await for (var snapshot in _firestore.collection('messages').snapshots()) {
      for (var msg in snapshot.docs) {
        print(msg.data());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Messaging', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green[900],
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          const MessageStreamBuilder(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    onChanged: (value) {
                      messgeText = value;
                    },
                    decoration: InputDecoration(
                      hintText: 'write your message here ... ',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    // if (_messageController.text.isNotEmpty) {
                    //   _sendMessage(_messageController.text);
                    // }
                    _messageController.clear();
                    _firestore.collection('messages').add({
                      'text': messgeText,
                      'sender': userData["name"],
                      'time': FieldValue.serverTimestamp()
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessage {
  final String message;
  final bool isUser;

  ChatMessage({required this.message, required this.isUser});
}

class MessageStreamBuilder extends StatelessWidget {
  const MessageStreamBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('messages').orderBy('time').snapshots(),
        builder: (context, snapshot) {
          List<MessageLine> messageWidgets = [];

          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.blue,
              ),
            );
          }
          final mas = snapshot.data!.docs.reversed;
          for (var message in mas) {
            final MessageText = message.get('text');

            final MessageSender = message.get('sender');

            final currentUser = userData["name"];

            if (currentUser == MessageSender) {}

            final messageWidget = MessageLine(
              sender: MessageSender,
              text: MessageText,
              isMe: currentUser == MessageSender,
            );
            messageWidgets.add(messageWidget);
          }
          return Expanded(
            child: ListView(
              reverse: true,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              children: messageWidgets,
            ),
          );
        });
  }
}

class MessageLine extends StatelessWidget {
  const MessageLine({this.sender, this.text, required this.isMe, super.key});
  final String? sender;
  final String? text;
  final bool isMe;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            "$sender",
            style: TextStyle(fontSize: 12, color: Colors.yellow[900]),
          ),
          Material(
              elevation: 5,
              borderRadius: isMe
                  ? BorderRadius.only(
                      topLeft: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30))
                  : BorderRadius.only(
                      topRight: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30)),
              color: isMe ? Colors.blue[800] : Colors.white,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Text('$text',
                    style: TextStyle(
                        fontSize: 20,
                        color: isMe ? Colors.white : Colors.black45)),
              )),
        ],
      ),
    );
  }
}
