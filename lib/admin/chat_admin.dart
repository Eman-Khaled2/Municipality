import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final _firestore = FirebaseFirestore.instance;
late User signedInUser;
final _auth = FirebaseAuth.instance;
// late User signedInUser;

class ChatScreena extends StatelessWidget {
  final String userMap;
  final String chatRoomId;
  //static const String screenRoute = 'chat_screen';
  ChatScreena({super.key, required this.chatRoomId, required this.userMap});

  final TextEditingController _message = TextEditingController();
  final messageTextController = TextEditingController();
 
  String? messageText;

  void getCurrentUser() {
    try {
      final userr = _auth.currentUser;
      if (userr != null) {
        signedInUser = userr;
        print(signedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  void onSendMessage() async {
    try {
      if (_message.text.isNotEmpty) {
        print("this isss nowwwwwwwwwwwwwwwwwwwwww");
        print(chatRoomId);
        Map<String, dynamic> messages = {
          "message": _message.text,
          "sender": _auth.currentUser!.email,
          "time": FieldValue.serverTimestamp(),
        };

        _message.clear();
        await _firestore
            .collection('messages')
            .doc(chatRoomId)
            .collection('chats')
            .add(messages);
      } else {
        print("Enter Some Text");
      }
    } catch (e) {
      print(e);
      print("heeeeere issssssssssssssssss errrrrrrrrrrrrrrror");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0077b5),
        title: Text(
          userMap,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            //    messageStreams();
            // _auth.signOut();
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MessageStreamBuilder(
              chatRoomId: chatRoomId,
            ),
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Color(0xFF0077b5),
                    width: 2,
                  ),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.camera_alt),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _message,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 20,
                        ),
                        hintText: 'Message',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: onSendMessage,
                    child: const Text(
                      'send',
                      style: TextStyle(
                        color: Color(0xFF0077b5),
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageShape extends StatelessWidget {
  const MessageShape({
    super.key,
    required this.boolean,
    required this.time,
    required this.date,
    this.text,
    this.sender,
    required this.isMe,
  });
  final bool boolean;
  final String time;
  final String date;
  final String? sender;
  final String? text;
  final bool isMe;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (boolean)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(15),
                        ),
                        color: Color(0xffeae4d8)),
                    padding: const EdgeInsets.only(
                        left: 10, right: 10, top: 10, bottom: 10),
                    child: Text(date.toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.black,
                        )),
                  ),
                ),
              ],
            ),
          Material(
            elevation: 5,
            borderRadius: isMe
                ? const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  )
                : const BorderRadius.only(
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
            color: isMe
                ? const Color(0xFF0077b5)
                : const Color.fromARGB(136, 48, 47, 47),
            child: Column(children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Column(
                  crossAxisAlignment:
                      isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$text',
                      style: const TextStyle(fontSize: 15, color: Colors.white),
                    ),
                    isMe
                        ? Text(time,
                            style: const TextStyle(
                                fontSize: 12,
                                color: Color.fromARGB(255, 197, 195, 195)))
                        : Text(time,
                            style: const TextStyle(
                                fontSize: 12,
                                color: Color.fromARGB(255, 197, 195, 195)))
                  ],
                ),
              )
            ]),
          ),
        ],
      ),
    );
    //;
  }
}

class MessageStreamBuilder extends StatelessWidget {
  final String chatRoomId;

  const MessageStreamBuilder({super.key, required this.chatRoomId});

  @override
  Widget build(BuildContext context) {
    String currentDate = " ";
    bool boolean = false;
    return StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('messages')
            .doc(chatRoomId)
            .collection('chats')
            .orderBy("time", descending: false)
            .snapshots(),
        builder: (context, snapshot) {
          List<MessageShape> messagesWidgets = [];
          if (!snapshot.hasData) {
            return const Center(
              child:
                  CircularProgressIndicator(backgroundColor: Color(0xFF0077b5)),
            );
          }
          final messages = snapshot.data!.docs.reversed;
          for (var message in messages) {
            RegExp regexDate = RegExp('[0-9]{4}-[0-9]{2}-[0-9]{2}');
            var dateAndTime = message.get('time') == null
                ? Text(DateTime.now().toString())
                : message.get('time').toDate();
            var date = regexDate.firstMatch(dateAndTime.toString())!.group(0);

            RegExp regexTime =
                RegExp('[0-9]{1}[0-9]{1}:[0-9]{1}[0-9]{1}:[0-9]{1}[0-9]{1}');

            var time = regexTime.firstMatch(dateAndTime.toString())!.group(0);
            if (date != currentDate) {
              currentDate = date!;
              print(message.get('message'));
              boolean = true;
            } else {
              print(message.get('message'));

              boolean = false;
            }
            print(boolean);

            final messageText = message.get('message');
            final messageSender = message.get('sendby');
            final currentUser = _auth.currentUser!.email;
            final messageWidget = MessageShape(
                boolean: boolean,
                time: time!,
                date: currentDate,
                sender: messageSender,
                text: messageText,
                isMe: currentUser == messageSender);
            messagesWidgets.add(messageWidget);

            //mongo
          }
          return Expanded(
            child: ListView(
              reverse: true,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              children: messagesWidgets,
            ),
          );
        });
  }
}
