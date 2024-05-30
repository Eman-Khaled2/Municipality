import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AllChats extends StatefulWidget {
  const AllChats({Key? key}) : super(key: key);

  @override
  State<AllChats> createState() => _AllChatsState();
}

class _AllChatsState extends State<AllChats> {
  final TextEditingController _search = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var userMap;
  var userMap2;

  @override
  void initState() {
    super.initState();
  }

  void onSearch() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    setState(() {
      if (_search.text.isEmpty) {
        userMap = null;
      }
    });

    await firestore
        .collection('users')
        .where("name", isEqualTo: _search.text)
        .get()
        .then((value) {
      setState(() {
        if (value.docs.isNotEmpty) {
          userMap = value.docs.first.data();
        } else {
          userMap = null;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0077b5),
        centerTitle: true,
        title: const Text(
          "Chat",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: size.height / 20),
          Container(
            height: size.height / 14,
            width: size.width,
            alignment: Alignment.center,
            child: SizedBox(
              height: size.height / 14,
              width: size.width / 1.15,
              child: TextField(
                onChanged: (text) {
                  setState(() {
                    onSearch();
                  });
                },
                controller: _search,
                decoration: InputDecoration(
                  hintText: "Search",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: size.height / 50),
          SizedBox(height: size.height / 30),
          userMap != null
              ? Expanded(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .where('name', isEqualTo: _search.text)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData || snapshot.data == null) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      return ListView(
                        children: snapshot.data!.docs.map((document) {
                          if (document['email'] !=
                              FirebaseAuth.instance.currentUser?.email) {
                            String roomId = chatRoomId(
                                _auth.currentUser?.email ?? '',
                                userMap?['email'] ?? '');

                            return TextButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => ChatScreena(
                                      chatRoomId: roomId,
                                      userMap: document['name'],
                                    ),
                                  ),
                                );
                              },
                              child: listTileForUser(
                                email: document['email'],
                                name: document['name'],
                              ),
                            );
                          } else {
                            return const SizedBox(height: 1);
                          }
                        }).toList(),
                      );
                    },
                  ),
                )
              : Expanded(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return ListView(
                        children: snapshot.data!.docs.map((document) {
                          if (document['email'] !=
                              FirebaseAuth.instance.currentUser?.email) {
                            return TextButton(
                              onPressed: () {
                                String roomId = chatRoomId(
                                    _auth.currentUser!.email!,
                                    document['email']);

                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => ChatScreena(
                                      chatRoomId: roomId,
                                      userMap: document['name'],
                                    ),
                                  ),
                                );
                              },
                              child: listTileForUser(
                                email: document['email'],
                                name: document['name'],
                              ),
                            );
                          } else {
                            return const SizedBox(height: 1);
                          }
                        }).toList(),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }

  Widget listTileForUser({required String email, required String name}) {
    return Container(
      child: Column(
        children: [
          const Divider(
            color: Colors.grey,
            height: 20,
            thickness: 0.5,
            indent: 10,
            endIndent: 10,
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            children: [
              const SizedBox(
                width: 20,
              ),
              const SizedBox(
                width: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 5, 96, 145),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(bottom: 2.0)),
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('messages')
                        .doc(
                          "${FirebaseAuth.instance.currentUser?.email}$email",
                        )
                        .collection('chats')
                        .orderBy("time", descending: true)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return const Text(
                          ".....................",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        );
                      } else {
                        if (snapshot.data!.docs.isEmpty) {
                          return const Text(
                            "Click To Message",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color.fromARGB(255, 76, 74, 74),
                            ),
                          );
                        } else {
                          var t =
                              snapshot.data!.docs.first['message'].toString();
                          if (t.length > 12) {
                            t = "${t.substring(0, 12)}...";
                          }
                          return Text(
                            t,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color.fromARGB(255, 76, 74, 74),
                            ),
                            maxLines: 1,
                          );
                        }
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
        ],
      ),
    );
  }

  String chatRoomId(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2.toLowerCase().codeUnits[0]) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
    }
  }
}

class ChatScreena extends StatelessWidget {
  final String chatRoomId;
  final String userMap;

  const ChatScreena({Key? key, required this.chatRoomId, required this.userMap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Your Chat Screen UI here
    return Container();
  }
}
