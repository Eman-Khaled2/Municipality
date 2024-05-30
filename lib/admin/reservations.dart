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
      home: const ReservationsPage(),
    );
  }
}

class ReservationsPage extends StatefulWidget {
  const ReservationsPage({Key? key}) : super(key: key);

  @override
  _ReservationsPageState createState() => _ReservationsPageState();
}

class _ReservationsPageState extends State<ReservationsPage> {
  List _reservations = [];

  @override
  void initState() {
    super.initState();
    _fetchReservations();
  }

  Future<void> _fetchReservations() async {
    final response =
        await http.get(Uri.parse('http://192.168.1.6:3000/user/getReservations'));
    if (response.statusCode == 200) {
      setState(() {
        _reservations = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load reservations');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text('Reservations',
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
          itemCount: _reservations.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(_reservations[index]['name']),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Number of Tickets: ${_reservations[index]['numberOfTickets']}'),
                  Text('Selected Seat: ${_reservations[index]['selectedSeat']}'),
                  Text('Price: ${_reservations[index]['price']}'),
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
