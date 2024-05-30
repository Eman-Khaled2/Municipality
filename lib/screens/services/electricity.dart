import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/screens/services/CustomButton.dart';
import 'package:shop_app/screens/services/PermitRequestPage%20.dart';
import 'package:shop_app/screens/services/elecMaint.dart';
import 'package:shop_app/screens/services/elecObToInv.dart';
import 'package:shop_app/screens/services/elecRequest.dart';
import 'package:shop_app/screens/services/elecStop.dart';

class Electricity extends StatefulWidget {
  static String routeName = "/elec";

  const Electricity({Key? key}) : super(key: key);

  @override
  _ElectricityScreenState createState() => _ElectricityScreenState();
}

class _ElectricityScreenState extends State<Electricity> {
  List<String> elecServices = [];

  @override
  void initState() {
    super.initState();
    fetchWaterServices();
  }

  Future<void> fetchWaterServices() async {
    try {
      final response = await http
          .get(Uri.parse('http://192.168.1.6:3000/service/getElecServices'));
      if (response.statusCode == 200) {
        final dynamic responseData = json.decode(response.body);
        print('Response Data: $responseData');
        if (responseData != null && responseData['elecServices'] != null) {
          final List<dynamic> data = responseData['elecServices'];
          setState(() {
            elecServices = data
                .map((service) => service['serviceName'] as String)
                .toList();
          });
        } else {
          throw Exception('Response body does not contain water services');
        }
      } else {
        throw Exception(
            'Failed to load electricity services. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Electricity Services',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 238, 227, 240),
              Color.fromARGB(255, 187, 168, 187),
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Adjusted height of the image
                SizedBox(
                  height: 90, // Change this value as per your requirement
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Display water services dynamically
                      for (int i = 0; i < elecServices.length; i++)
                        Padding(
                          padding: i == 0
                              ? const EdgeInsets.only(bottom: 6.0)
                              : const EdgeInsets.symmetric(vertical: 4.0),
                          child: ElevatedButton(
                            onPressed: () {
                              // Navigate to appropriate screen based on the selected service
                              switch (elecServices[i]) {
                                case 'Electricity request':
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const RequestEScreen(
                                              userData: {},
                                            )),
                                  );
                                  break;
                                case 'Electricity stop':
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const StopEScreen(
                                              userData: {},
                                            )),
                                  );
                                  break;
                                case 'Electricity invoice':
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const InvoiceEScreen(
                                              userData: {},
                                            )),
                                  );
                                  break;
                                case 'Electricity maintenance':
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const MaintEScreen(
                                              userData: {},
                                            )),
                                  );
                                  break;
                                case 'Electricity permit':
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const PermitRequestPage(
                                              userData: {},
                                            )),
                                  );
                                  break;
                                default:
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const UserInputPage(
                                              userData: {},
                                              pageTitle: '',
                                            )),
                                  );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor:
                                  const Color.fromARGB(221, 108, 107, 107),
                              backgroundColor: const Color.fromARGB(
                                  255, 255, 255, 255), // Purple text color
                              minimumSize: const Size(
                                  double.infinity, 60), // Larger button size
                              padding:
                                  const EdgeInsets.all(16), // Increased padding
                            ),
                            child: Text(
                              elecServices[i],
                              style: const TextStyle(
                                fontSize: 16, // Increased font size
                                fontFamily: 'Roboto', // Modern font family
                               // fontWeight: FontWeight
                              //      .w900, // Updated font weight to 500 for a modern look
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
        ),
      ),
    );
  }
}
