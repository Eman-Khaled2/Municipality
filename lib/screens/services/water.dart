import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/screens/services/CustomButton.dart';
import 'package:shop_app/screens/services/waterMaint.dart';
import 'package:shop_app/screens/services/waterObToInv.dart';
import 'package:shop_app/screens/services/waterRequest.dart';
import 'package:shop_app/screens/services/waterStop.dart';
import 'package:shop_app/screens/services/waterTransfer.dart';

class WaterScreen extends StatefulWidget {
  static String routeName = "/water";

  const WaterScreen({Key? key}) : super(key: key);

  @override
  _WaterScreenState createState() => _WaterScreenState();
}

class _WaterScreenState extends State<WaterScreen> {
  List<String> waterServices = [];

  @override
  void initState() {
    super.initState();
    fetchWaterServices();
  }

  Future<void> fetchWaterServices() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.1.6:3000/service/getWaterServices'));
      if (response.statusCode == 200) {
        final dynamic responseData = json.decode(response.body);
        print('Response Data: $responseData');
        if (responseData != null && responseData['waterServices'] != null) {
          final List<dynamic> data = responseData['waterServices'];
          setState(() {
            waterServices = data.map((service) => service['serviceName'] as String).toList();
          });
        } else {
          throw Exception('Response body does not contain water services');
        }
      } else {
        throw Exception('Failed to load water services. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void onPressedAction(String service) {
    switch (service) {
      case 'Water request':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const RequestWScreen(userData: {}),
          ),
        );
        break;
      case 'Water transfer':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const TransferWScreen(userData: {}),
          ),
        );
        break;
      case 'Water stop':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const StopWScreen(userData: {}),
          ),
        );
        break;
      case 'Water invoice':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const InvoiceWScreen(userData: {}),
          ),
        );
        break;
      case 'Water maintenance':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const MaintWScreen(userData: {}),
          ),
        );
        break;
      default:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const UserInputPage(
              userData: {},
              pageTitle: '',
            ),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Water Services', style: TextStyle(color: Colors.white)),
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0), // Add padding horizontally
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Adjusted height of the image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20.0), // Set border radius
                    child: SizedBox(
                      height: 30, // Change this value as per your requirement
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Display water services dynamically
                  for (int i = 0; i < waterServices.length; i++)
                    Padding(
                      padding: i == 0
                          ? const EdgeInsets.only(bottom: 6.0)
                          : const EdgeInsets.symmetric(vertical: 4.0),
                      child: ElevatedButton(
                        onPressed: () => onPressedAction(waterServices[i]),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: const Color.fromARGB(221, 108, 107, 107),
                          backgroundColor: const Color.fromARGB(255, 255, 255, 255), // Purple text color
                          minimumSize: const Size(double.infinity, 40), // Smaller button size
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16), // Adjusted padding
                        ),
                        child: Text(
                          waterServices[i],
                          style: const TextStyle(
                            fontSize: 16, // Increased font size
                            fontFamily: 'Roboto', // Modern font family
                            // fontWeight: FontWeight.w900, // Updated font weight to 500 for a modern look
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
