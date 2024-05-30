import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/screens/services/CustomButton.dart';

class NewServiceScreen extends StatefulWidget {
  static String routeName = "/newService";

  const NewServiceScreen({Key? key}) : super(key: key);

  @override
  _NewServiceScreenState createState() => _NewServiceScreenState();
}

class _NewServiceScreenState extends State<NewServiceScreen> {
  List<String> newServices = [];

  @override
  void initState() {
    super.initState();
    fetchNewServices();
  }

  Future<void> fetchNewServices() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.1.6:3000/service/getNewServices'));
      if (response.statusCode == 200) {
        final dynamic responseData = json.decode(response.body);
        print('Response Data: $responseData');
        if (responseData != null && responseData['newServices'] != null) {
          final List<dynamic> data = responseData['newServices'];
          setState(() {
            newServices = data.map((service) => service['serviceName'] as String).toList();
          });
        } else {
          throw Exception('Response body does not contain services');
        }
      } else {
        throw Exception('Failed to load services. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Services', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green[900],
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.zero,
                    ),
                  ),  
                  SizedBox(height: 15),
                  // Display water services dynamically
                  for (int i = 0; i < newServices.length; i++)
                    Padding(
                      padding: i == 0 ? EdgeInsets.only(bottom: 6.0) : EdgeInsets.symmetric(vertical: 4.0),
                      child: ElevatedButton(
                        onPressed: () { 
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => UserInputPage(userData: {}, pageTitle: '',)),
                              );
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Color.fromARGB(221, 72, 21, 72),
                          backgroundColor: Color.fromARGB(255, 255, 255, 255), // Purple text color
                          minimumSize: Size(double.infinity, 60), // Larger button size
                          padding: EdgeInsets.all(16), // Increased padding
                        ),
                        child: Text(
                          newServices[i],
                          style: TextStyle( 
                            fontSize: 18, // Increased font size
                            fontFamily: 'Roboto', // Modern font family
                            fontWeight: FontWeight.w500, // Updated font weight to 500 for a modern look
                  
                          ),
                        ), 
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
