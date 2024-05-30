import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reservations',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.green, // Set app bar color to green
          iconTheme: IconThemeData(color: Colors.white), // Set icon color to white
        ),
        textTheme: const TextTheme(
          headline6: TextStyle(color: Colors.white), // Set title color to white
        ),
      ),
      home: const DonationsPage(),
    );
  }
}

class DonationsPage extends StatefulWidget {
  const DonationsPage({Key? key}) : super(key: key);

  @override
  _DonationsPageState createState() => _DonationsPageState();
}

class _DonationsPageState extends State<DonationsPage> {
  List _donations = [];

  @override
  void initState() {
    super.initState();
    _fetchDonations();
  }

  Future<void> _fetchDonations() async {
    final response =
        await http.get(Uri.parse('http://192.168.1.6:3000/user/getAllDonations'));
    if (response.statusCode == 200) {
      setState(() {
        _donations = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load donations');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text('Donations',
               style: TextStyle(color: Colors.white), // Title color
        ),
        backgroundColor: Colors.green, // Set app bar color to green
          iconTheme: IconThemeData(color: Colors.white), // Back arrow color
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 238, 227, 240),Color.fromARGB(255, 187, 168, 187)], // Set gradient colors
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView.builder(
          itemCount: _donations.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(_donations[index]['userName']),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Type: ${_donations[index]['type']}'),
                  Text('Address: ${_donations[index]['address']}'),
                  Text('Preferred date: ${_donations[index]['preferredDate']}'),
                  Text('Donation amount: ${_donations[index]['donationAmount']}'),
                ],
              ),
              // Add more fields as needed
            );
          },
        ),
      ),
    );
  }
}
