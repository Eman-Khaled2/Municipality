import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shop_app/translation/locale_keys.g.dart';
import 'package:http/http.dart' as http;

class RequestWScreen extends StatefulWidget {
  @override
  static String routeName = "/requestw";

  const RequestWScreen({Key? key, required this.userData}) : super(key: key);

  final Map<String, dynamic> userData;

  @override
  State<RequestWScreen> createState() => _RequestWScreenState();
}

class _RequestWScreenState extends State<RequestWScreen> {
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
          'serviceName': 'Water request', // Provide the service name
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
          LocaleKeys.Subscription_Request.tr(),
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
                _buildLabel(LocaleKeys.Name.tr(), '${userData["name"]}'),
                _buildDivider(), // Add a divider
                _buildLabel(LocaleKeys.Address.tr(), '${userData["address"]}'),
                _buildDivider(), // Add a divider
                _buildLabel(LocaleKeys.Phone_Number.tr(), '${userData["phone_number"]}'),
                _buildDivider(), // Add a divider
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
                SizedBox(height: 390),
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
                          title: Text('Subscription Information'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Name: ${userData["name"]}'),
                              Text('Address: ${userData["address"]}'),
                              Text('Phone Number: ${userData["phone_number"]}'),
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

  Widget _buildLabel(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16.0),
        ),
        SizedBox(height: 5),
        Text(
          value,
          style: TextStyle(fontSize: 16.0),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildDivider() {
    return Divider(color: Colors.grey[300]); // Add a divider
  }

  Widget _buildSubscriptionFee(int subscriptionFee) {
    return Text(
      'Subscription Fee: ${subscriptionFee.toString()}',
      style: TextStyle(fontSize: 16.0),
    );
  }
}
