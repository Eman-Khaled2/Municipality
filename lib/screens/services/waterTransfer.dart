import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shop_app/translation/locale_keys.g.dart';
import 'package:http/http.dart' as http;

class TransferWScreen extends StatefulWidget {
  @override
  static String routeName = "/transferw";

  const TransferWScreen({Key? key, required this.userData}) : super(key: key);

  final Map<String, dynamic> userData;

  @override
  State<TransferWScreen> createState() => _TransferWScreenState();
}

class _TransferWScreenState extends State<TransferWScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _gallonsController = TextEditingController();

  var acount = GetStorage();
  var userData;
  late Future<int> _subscriptionFeeFuture;

  @override
  void initState() {
    super.initState();
    _subscriptionFeeFuture = fetchSubscriptionFee();
    userData = acount.read('keyUser');
    print(userData);
  }

  Future<int> fetchSubscriptionFee() async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.6:3000/service/get'),
        body: jsonEncode({
          'serviceName': 'Water transfer', // Provide the service name
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
    String subscriptionFee = LocaleKeys.Pric.tr();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          LocaleKeys.Subscription_Transfer.tr(),
          style: TextStyle(color: Colors.white), // Set text color to white
        ),
        backgroundColor: Colors.green, // Set AppBar color to green
        iconTheme: IconThemeData(color: Colors.white), // Set arrow color to white
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
                _buildLabel('Transfer From:', '${userData["address"]}',
                    enabled: false, textColor: Colors.black),
                SizedBox(height: 10), // Add space between fields
                _buildLabel('Transfer To:', '', hint: 'Enter the desired address'),
                SizedBox(height: 10), // Add space between fields
                _buildLabel(LocaleKeys.Phone_Number.tr(), '${userData["phone_number"]}',
                    enabled: false, textColor: Colors.black),
                SizedBox(height: 20), // Add space between fields
                FutureBuilder<int>(
                  future: _subscriptionFeeFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      final subscriptionFee = snapshot.data ?? 0;
                      return _buildSubscriptionFee(subscriptionFee);
                    }
                  },
                ),
                SizedBox(height: 365), // Add space at the bottom
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Color.fromARGB(221, 72, 21, 72),
                      backgroundColor: Color.fromARGB(255, 255, 255, 255), // Purple text color
                    ),
                    onPressed: () {
                      // Handle submission of subscription request
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Subscription Transfer'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Transfer From: ', style: TextStyle(color: Colors.black)),
                              Text('${userData["address"]}', style: TextStyle(color: Colors.black)),
                              Text('Transfer To: '),
                              Text('Phone Number: ', style: TextStyle(color: Colors.black)),
                              Text('${userData["phone_number"]}', style: TextStyle(color: Colors.black)),
                              FutureBuilder<int>(
                                future: _subscriptionFeeFuture,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return CircularProgressIndicator();
                                  } else if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  } else {
                                    final subscriptionFee = snapshot.data ?? 0;
                                    return Text('Subscription Fee: ${subscriptionFee.toString()}');
                                  }
                                },
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text(LocaleKeys.OK.tr()),
                            ),
                          ],
                        ),
                      );

                      // Resetting text fields after submission
                      _gallonsController.clear();
                    },
                    child: Text(LocaleKeys.Submit_Request.tr()),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _gallonsController.dispose();
    super.dispose();
  }

  Widget _buildLabel(String label, String value,
      {bool enabled = true, String hint = '', Color textColor = Colors.black}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16.0),
        ),
        SizedBox(height: 5),
        TextFormField(
          enabled: enabled,
          decoration: InputDecoration(
            hintText: hint,
          ),
          initialValue: value,
          style: TextStyle(fontSize: 16.0, color: textColor),
        ),
        if (label == 'Transfer To:') Divider(color: Colors.grey[300]), // Add a divider only for "Transfer To" field
      ],
    );
  }

  Widget _buildSubscriptionFee(int subscriptionFee) {
    return Text(
      'Subscription Fee: ${subscriptionFee.toString()}',
      style: TextStyle(fontSize: 16.0),
    );
  }
}

Future<void> fetchUserDataService(
    String email, String password, BuildContext context) async {
  try {
    final response = await http.post(
      Uri.parse('http://192.168.1.6:3000/user/get'),
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      final userData = json.decode(response.body);
      print(userData);
      if (userData['name'] != null &&
          userData['address'] != null &&
          userData['phone_number'] != null) {
        final Map<String, dynamic> userDataMap = {
          'name': userData['name'],
          'address': userData['address'],
          'phone_number': userData['phone_number'],
        };

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TransferWScreen(userData: userDataMap),
          ),
        );
      } else {
        print('Invalid user data received');
      }
    } else {
      print('Failed to load user data: ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetching user data: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Failed to fetch user data. Please try again later.'),
        backgroundColor: Colors.red,
      ),
    );
  }
}
