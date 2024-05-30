import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Complaints App',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: ComplaintsPage(),
    );
  }
}

class ComplaintsPage extends StatefulWidget {
  @override
  _ComplaintsPageState createState() => _ComplaintsPageState();
}

class _ComplaintsPageState extends State<ComplaintsPage> {
  List<dynamic> complaints = [];
  Set<int> clickedComplaintIds = {};

  @override
  void initState() {
    super.initState();
    fetchComplaints();
    loadClickedComplaints();
  }

  Future<void> fetchComplaints() async {
    final response = await http.get(Uri.parse('http://192.168.1.6:3000/user/getComplaints'));
    if (response.statusCode == 200) {
      setState(() {
        complaints = json.decode(response.body)['complaints'];
      });
    } else {
      throw Exception('Failed to load complaints');
    }
  }

  Future<void> loadClickedComplaints() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      clickedComplaintIds = (prefs.getStringList('clickedComplaints') ?? [])
          .map((id) => int.parse(id))
          .toSet();
    });
  }

  Future<void> saveClickedComplaint(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    clickedComplaintIds.add(id);
    prefs.setStringList('clickedComplaints', clickedComplaintIds.map((id) => id.toString()).toList());
  }

  void handleComplaintClick(int index) {
    setState(() {
      saveClickedComplaint(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Complaints',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: Color.fromARGB(255, 240, 230, 255), // Set background color to light purple
      body: complaints.isEmpty
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: complaints.length,
              itemBuilder: (BuildContext context, int index) {
                bool isClicked = clickedComplaintIds.contains(index);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0), // Add space between cards
                  child: Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Time: ${complaints[index]['createdAt'].toString().split("T")[1].split(".")[0]}',
                                style: TextStyle(
                                  color: isClicked ? Colors.green : const Color.fromARGB(255, 236, 16, 0),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ListTile(
                          title: Text(
                            complaints[index]['complaintType'],
                            style: TextStyle(
                              color: isClicked ? Colors.green : Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                complaints[index]['description'],
                                style: TextStyle(
                                  color: isClicked ? Colors.green : Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                complaints[index]['userName'],
                                style: TextStyle(
                                  color: isClicked ? Colors.green : Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                complaints[index]['location']['coordinates'].toString(),
                                style: TextStyle(
                                  color: isClicked ? Colors.green : Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                complaints[index]['updatedAt'],
                                style: TextStyle(
                                  color: isClicked ? Colors.green : Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          onTap: () {
                            handleComplaintClick(index);
                          },
                        ),
                        SizedBox(height: 8),
                        Image.asset(
                          'assets/images/${complaints[index]['image']}',
                          height: 150,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
