import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/auction.dart';
import 'package:shop_app/ticket1.dart';
import 'package:shop_app/ticket2.dart';
import 'package:shop_app/ticket3.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: EventScreen(),
    );
  }
}

class EventScreen extends StatefulWidget {
  static String routeName = "/event";

  const EventScreen({Key? key}) : super(key: key);

  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  late Future<List<Map<String, dynamic>>> _futureEvents;
  late TextEditingController _searchController;
  List<Map<String, dynamic>> _events = [];

  @override
  void initState() {
    super.initState();
    _futureEvents = fetchEvents();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        iconTheme: IconThemeData(color: Colors.grey[900]),
        title: Text(
          'Events',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
         decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 238, 227, 240), Color.fromARGB(255, 187, 168, 187),
            ], // Adjust colors as needed
          ),
        ),
         child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
           SizedBox(height: 20),
          Container(
            height: 65,
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.white),
            child: Center(
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {});
                },
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  hintText: 'Search Event',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 30),
         
          SizedBox(height: 12.5),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _futureEvents,
              builder: (BuildContext context,
                  AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  _events = snapshot.data ?? [];
                  List<Map<String, dynamic>> filteredEvents =
                      _searchController.text.isNotEmpty
                          ? _events.where((event) =>
                              event['title']
                                  .toString()
                                  .toLowerCase()
                                  .startsWith(
                                      _searchController.text.toLowerCase()))
                              .toList()
                          : _events;
                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          for (var i = 0; i < filteredEvents.length; i++)
                            GestureDetector(
                              onTap: () {
                                if (i == 0) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            Ticket1Screen(userData: {})),
                                  );
                                } else if (i == 1) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            Ticket2Screen(userData: {})),
                                  );
                                } else if (i == 2) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            Ticket3Screen(userData: {})),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            AuctionScreen()),
                                  );
                                }
                              },
                              child: _createRow(
                                date: filteredEvents[i]['date'],
                                month: filteredEvents[i]['month'],
                                time: filteredEvents[i]['time'],
                                image: filteredEvents[i]['image'],
                                title: filteredEvents[i]['title'],
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    ),
    );
  }
}

Widget _createRow({
  required String? date,
  required String? month,
  required String? time,
  required String? image,
  required String? title,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Row(
      children: [
        Container(
          padding: EdgeInsets.only(top: 20),
          height: 200,
          width: 50,
          child: Column(
            children: [
              Text(
                date ?? '',
                style: TextStyle(
                    color: const Color.fromARGB(255, 94, 96, 94),
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                month ?? '',
                style: TextStyle(
                    color: const Color.fromARGB(255, 94, 96, 94),
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              )
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(left: 10),
                height: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover, image: AssetImage(image ?? '')),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.center,
                      colors: [Colors.black.withOpacity(1), Colors.transparent],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          title ?? '',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 7.5,
                        ),
                        Row(
                          children: [


                            Icon(
                              Icons.access_time,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              time ?? '',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    ),
  );
}

Future<List<Map<String, dynamic>>> fetchEvents() async {
  final response =
      await http.get(Uri.parse('http://192.168.1.6:3000/user/getEvent'));
  if (response.statusCode == 200) {
    return List<Map<String, dynamic>>.from(
        jsonDecode(response.body)['events']);
  } else {
    throw Exception('Failed to load events');
  }
}