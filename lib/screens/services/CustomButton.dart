import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/translation/locale_keys.g.dart';

class UserInputPage extends StatefulWidget {
  static String routeName = "/user_input";

  const UserInputPage({Key? key, required this.userData, required String pageTitle}) : super(key: key);

  final Map<String, dynamic> userData;

  State<UserInputPage> createState() => _UserInputPage();
}

class _UserInputPage extends State<UserInputPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  var account = GetStorage();
  var userData;
  late Future<int> _subscriptionFeeFuture;

  @override
  void initState() {
    super.initState();
    _subscriptionFeeFuture = fetchSubscriptionFee();
    userData = account.read('keyUser');
    print(userData);

    // Check if userData is not null before initializing controllers
    if (widget.userData != null) {
      _nameController = TextEditingController(text: widget.userData['name'] ?? '');
      _phoneController = TextEditingController(text: widget.userData['phone_number'] ?? '');
      _addressController = TextEditingController(text: widget.userData['address'] ?? '');
    } else {
      // Set default values if userData is null
      _nameController = TextEditingController();
      _addressController = TextEditingController();
      _phoneController = TextEditingController();
    }
  }

  Future<int> fetchSubscriptionFee() async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.6:3000/service/get'),
        body: jsonEncode({
          'serviceName': 'Street build', // Provide the service name
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
        title: Text('Request', style: TextStyle(color: Colors.white)),
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
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Enter your information'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
                  ),
                  child: Text(
                    '${LocaleKeys.Address.tr()}\n${userData["address"] ?? ""}',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
                  ),
                  child: Text(
                    '${LocaleKeys.Phone_Number.tr()}\n${userData["phone_number"] ?? ""}',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                SizedBox(height: 20),
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
                SizedBox(height: 430), // Added spacing for better visual separation
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Color.fromARGB(221, 72, 21, 72),
                    backgroundColor: Color.fromARGB(255, 255, 255, 255), // Purple text color
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Action to submit the request
                      // You can access the entered values using _nameController.text
                    }
                  },
                  child: Text(
                    LocaleKeys.Submit_Request.tr(),
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

Widget _buildSubscriptionFee(int subscriptionFee) {
  return Text(
    'Subscription Fee: ${subscriptionFee.toString()}',
    style: TextStyle(fontSize: 16.0),
  );
}
