import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/translation/locale_keys.g.dart';
import 'package:http/http.dart' as http;

class Fees1Screen extends StatefulWidget {
  static String routeName = "/fees1";

  const Fees1Screen({Key? key, required this.userData}) : super(key: key);

  final Map<String, dynamic> userData;

  @override
  State<Fees1Screen> createState() => _Fees1ScreenState();
}

class _Fees1ScreenState extends State<Fees1Screen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _propertyController = TextEditingController();
  TextEditingController _reasonController = TextEditingController();

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
      _nameController = TextEditingController(text: widget.userData['name'] ?? '');
      _propertyController = TextEditingController(text: widget.userData['address'] ?? '');
    } else {
      // Set default values if userData is null
      _nameController = TextEditingController();
      _propertyController = TextEditingController();
    }

    // Disable editing for name and address fields
    _nameController..text = userData['name'] ?? ''..selection = TextSelection.collapsed(offset: 0);
    _propertyController..text = userData['address'] ?? ''..selection = TextSelection.collapsed(offset: 0);
  }

  Future<int> fetchSubscriptionFee() async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.6:3000/service/get'),
        body: jsonEncode({
          'serviceName': 'Fees request objection to closure', // Provide the service name
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
        backgroundColor: Colors.green,
        title: Text(LocaleKeys.fees_sd.tr(), style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white), // Change the arrow color to white
        systemOverlayStyle: SystemUiOverlayStyle.light, // Change the AppBar's text color to white
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
            padding: EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center, // Center the button vertically
                children: <Widget>[
                  Text(
                    LocaleKeys.Requestor_Information.tr(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    'Name',
                    style: TextStyle(
                      color: Colors.black, // Set text color to black
                    ),
                  ),
                  SizedBox(height: 5.0),
                  TextFormField(
                    controller: _nameController,
                    enabled: false, // Disable editing
                    decoration: InputDecoration(hintText: '${userData["name"]}'),
                    style: TextStyle(color: Colors.black),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    'Address',
                    style: TextStyle(
                      color: Colors.black, // Set text color to black
                    ),
                  ),
                  SizedBox(height: 5.0),
                  TextFormField(
                    controller: _propertyController,
                    enabled: false, // Disable editing
                    decoration: InputDecoration(hintText: '${userData["address"]}' ),
                    style: TextStyle(color: Colors.black),
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                    controller: _reasonController,
                    decoration: InputDecoration(labelText: LocaleKeys.Reason_for_Amendment.tr()),
                    maxLines: 5,
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
                  SizedBox(height: 276),
                  Center( // Center the button horizontally
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Color.fromARGB(221, 72, 21, 72),
                        backgroundColor: Color.fromARGB(255, 255, 255, 255), // Purple text color
                        padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 140.0), // زيادة الهامش الداخلي للزر
                      ),
                      onPressed: () {
                        String name = _nameController.text;
                        String property = _propertyController.text;
                        String reason = _reasonController.text;

                        if (_formKey.currentState!.validate()) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Request Submitted'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Name: $name'),
                                    Text('Property: $property'),
                                    Text('Reason: $reason'),
                                  ],
                                ),
                                actions: <Widget>[
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text(LocaleKeys.OK.tr(), style: TextStyle(color: Colors.black)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          );

                          _reasonController.clear();
                        }
                      },
                      child: Text(LocaleKeys.Submit.tr()),
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

Widget _buildSubscriptionFee(int subscriptionFee) {
  return Text(
    'Subscription Fee: ${subscriptionFee.toString()}',
    style: TextStyle(fontSize: 16.0),
  );
}
