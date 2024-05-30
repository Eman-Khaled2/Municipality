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
      title: 'Taxes',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.green, // Set app bar color to green
          iconTheme: IconThemeData(color: Colors.white), // Set icon color to white
        ),
        textTheme: const TextTheme(
          headline6: TextStyle(color: Colors.white), // Set title color to white
        ),
      ),
      home: const TaxesPage(),
    );
  }
}

class TaxesPage extends StatefulWidget {
  const TaxesPage({Key? key}) : super(key: key);

  @override
  _TaxesPageState createState() => _TaxesPageState();
}

class _TaxesPageState extends State<TaxesPage> {
  List _taxes = [];

  @override
  void initState() {
    super.initState();
    _fetchTaxes();
  }

  Future<void> _fetchTaxes() async {
    final response =
        await http.get(Uri.parse('http://192.168.1.6:3000/user/getAllTaxes'));
    if (response.statusCode == 200) {
      setState(() {
        _taxes = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load taxes');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text('Taxes',
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
          itemCount: _taxes.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(_taxes[index]['type']),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${_taxes[index]['totalAmount']}'),
                  Text('${_taxes[index]['paidAmount']}'),
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
