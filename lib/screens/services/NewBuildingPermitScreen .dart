import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class NewBuildingPermitScreen extends StatefulWidget {
  static String routeName = "/new_building_permit";

  const NewBuildingPermitScreen({Key? key, required this.userData})
      : super(key: key);

  final Map<String, dynamic> userData;

  @override
  State<NewBuildingPermitScreen> createState() =>
      _NewBuildingPermitState();
}

class _NewBuildingPermitState extends State<NewBuildingPermitScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _buildingTypeController = TextEditingController();
  TextEditingController _buildingLocationController = TextEditingController();

  var acount = GetStorage();
  var userData;
  late Future<int> _subscriptionFeeFuture;

  @override
  void initState() {
    super.initState();
    _subscriptionFeeFuture = fetchSubscriptionFee();
    userData = acount.read('keyUser');
    print(userData);

    // Check if userData is not null before initializing controllers
    if (widget.userData != null) {
      _nameController =
          TextEditingController(text: widget.userData['name'] ?? '');
      _buildingTypeController =
          TextEditingController(text: widget.userData['type'] ?? '');
      _buildingLocationController =
          TextEditingController(text: widget.userData['location'] ?? '');
    } else {
      // Set default values if userData is null
      _nameController = TextEditingController();
      _buildingTypeController = TextEditingController();
      _buildingLocationController = TextEditingController();
    }
  }

  Future<int> fetchSubscriptionFee() async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.6:3000/service/get'),
        body: jsonEncode({
          'serviceName': 'Building permit', // Provide the service name
        }),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final subscriptionFee = data['subscriptionFee'] as int;
        return subscriptionFee;
      } else {
        print('Failed to load subscription fee: ${response.statusCode}');
        return 0;
      }
    } catch (e) {
      print('Error fetching subscription fee: $e');
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'New Building Permit',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
        iconTheme: IconThemeData(color: Colors.white),
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
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Name',
                  style: TextStyle(fontSize: 16.0),
                ),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    enabled: false, // Disable editing
                    hintText: '${userData["name"]}',
                    hintStyle: TextStyle(color: Colors.black), // Set hint text color to black
                  ),
                ),
                SizedBox(height: 20.0),
                Text(
                  'Building Type',
                  style: TextStyle(fontSize: 16.0),
                ),
                TextField(
                  controller: _buildingTypeController,
                  decoration: InputDecoration(
                    hintText: '',
                  ),
                ),
                SizedBox(height: 20.0),
                Text(
                  'Building Location',
                  style: TextStyle(fontSize: 16.0),
                ),
                TextField(
                  controller: _buildingLocationController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: '',
                  ),
                ),
                SizedBox(height: 20.0),
                FutureBuilder<int>(
                  future: _subscriptionFeeFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      final subscriptionFee = snapshot.data ?? 0;
                      return Text(
                          'Subscription Fee: ${subscriptionFee.toString()}');
                    }
                  },
                ),
                SizedBox(height: 380), // Added spacing for better visual separation
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_nameController.text.isEmpty ||
                          _buildingTypeController.text.isEmpty ||
                          _buildingLocationController.text.isEmpty) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Please Enter All Information'),
                            content: Text('Please fill in all required fields.'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: Text('OK'),
                              ),
                            ],
                          ),
                        );
                      } else {
                        String name = _nameController.text;
                        String type = _buildingTypeController.text;
                        String location = _buildingLocationController.text;

                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Stop Subscription Information'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Name: $name'),
                                Text('Building Type: $type'),
                                Text('Building Location: $location'),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: Text('OK'),
                              ),
                            ],
                          ),
                        );

                        _nameController.clear();
                        _buildingTypeController.clear();
                        _buildingLocationController.clear();
                      }
                    },
                    child: Text('Submit'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Color.fromARGB(221, 72, 21, 72),
                      backgroundColor: Color.fromARGB(255, 255, 255, 255), // Purple text color
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSubscriptionFee(int subscriptionFee) {
    return Text(
      'Subscription Fee: ${subscriptionFee.toString()}',
      style: TextStyle(fontSize: 16.0),
    );
  }
}
