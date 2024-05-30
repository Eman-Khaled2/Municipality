import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/screens/services/administrative.dart';
import 'package:shop_app/screens/services/advertising.dart';
import 'package:shop_app/screens/services/building.dart';
import 'package:shop_app/screens/services/electricity.dart';
import 'package:shop_app/screens/services/fees.dart';
import 'package:shop_app/screens/services/newService.dart';
import 'package:shop_app/screens/services/road.dart';
import 'package:shop_app/screens/services/sanitation.dart';
import 'package:shop_app/screens/services/transaction.dart';
import 'package:shop_app/screens/services/water.dart';
import 'package:shop_app/translation/locale_keys.g.dart';

class ServiceScreen extends StatefulWidget {
  const ServiceScreen({super.key});

  @override
  _ServiceScreenState createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  List<String> services = [];
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchServices();
  }

  Future<void> fetchServices() async {
    final response = await http.get(Uri.parse('http://192.168.1.6:3000/user/getServices'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        services = List<String>.from(data['services'].map((service) => service['type']));
      });
    } else {
      throw Exception('Failed to load services');
    }
  }

  void _previousService() {
    setState(() {
      if (_currentIndex > 0) {
        _currentIndex--;
      }
    });
  }

  void _nextService() {
    setState(() {
      if (_currentIndex < services.length - 1) {
        _currentIndex++;
      }
    });
  }

  void _navigateToWaterScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const WaterScreen()),
    );
  }

  void _navigateToBuildingScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const BuildingScreen()),
    );
  }

  void _navigateToSanitationScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SanitationScreen()),
    );
  }

  void _navigateToAdministrativeScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Administrative()),
    );
  }

  void _navigateToFeesScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const FeesScreen()),
    );
  }

  void _navigateToAdvertisingScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Advertising()),
    );
  }

  void _navigateToStreetScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RoadScreen()),
    );
  }

  void _navigateToElectricityScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Electricity()),
    );
  }

  void _navigateToTransactionScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TransScreen(userData: {},)),
    );
  }

  void _navigateToXScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NewServiceScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          LocaleKeys.Services.tr(),
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFD3D3D3), // Light Gray
              Color.fromARGB(255, 187, 168, 187),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: services.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0), // Add vertical padding
                      child: ListView.builder(
                        itemCount: services.length,
                        itemBuilder: (context, index) {
                          return AnimatedOpacity(
                            duration: const Duration(milliseconds: 300),
                            opacity: index == _currentIndex ? 1.0 : 0.5,
                            child: ServiceButton(
                              label: services[index],
                              onPressed: () {
                                if (services[index] == 'Water Services') {
                                  _navigateToWaterScreen();
                                } else if (services[index] == 'Building Services') {
                                  _navigateToBuildingScreen();
                                } else if (services[index] == 'Sanitation Services') {
                                  _navigateToSanitationScreen();
                                } else if (services[index] == 'Administrative Services') {
                                  _navigateToAdministrativeScreen();
                                } else if (services[index] == 'Fees Services') {
                                  _navigateToFeesScreen();
                                } else if (services[index] == 'Advertising Services') {
                                  _navigateToAdvertisingScreen();
                                } else if (services[index] == 'Street and road Services') {
                                  _navigateToStreetScreen();
                                } else if (services[index] == 'Electricity Services') {
                                  _navigateToElectricityScreen();
                                } else if (services[index] == 'Transaction Services') {
                                  _navigateToTransactionScreen();
                                } else {
                                  _navigateToXScreen();
                                }
                              },
                            ),
                          );
                        },
                      ),
                    ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Color.fromARGB(221, 255, 255, 255)),
                  onPressed: _previousService,
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward, color: Color.fromARGB(221, 255, 255, 255)),
                  onPressed: _nextService,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ServiceButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const ServiceButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 60,
      margin: const EdgeInsets.all(8),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          foregroundColor: const Color.fromARGB(221, 22, 4, 54),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 16,
           // fontWeight: FontWeight.w900,
            color: Color.fromARGB(221, 108, 107, 108),
          ),
        ),
      ),
    );
  }
}
