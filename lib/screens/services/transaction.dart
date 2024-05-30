import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shop_app/translation/locale_keys.g.dart';
import 'package:http/http.dart' as http;

class TransScreen extends StatefulWidget {
  @override
  static String routeName = "/trans";

  const TransScreen({Key? key, required this.userData}) : super(key: key);

  final Map<String, dynamic> userData;

  @override
  State<TransScreen> createState() => _TransScreenState();
}

class _TransScreenState extends State<TransScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _invoiceInfoController = TextEditingController();
  TextEditingController _detailsController = TextEditingController();
  String? _selectedMaintenanceType = 'Clearance';

  var acount = GetStorage();
  late var userData;
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
          'serviceName': 'Transaction', // Provide the service name
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
          'Transactions',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFD3D3D3), // Light Gray
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
                  LocaleKeys.Name.tr(),
                  style: TextStyle(fontSize: 16.0),
                ),
                Text(
                  '${userData["name"]}',
                  style: TextStyle(fontSize: 16.0),
                ),
                Divider(color: Colors.grey[300], thickness: 1),
                Text(
                  LocaleKeys.Address.tr(),
                  style: TextStyle(fontSize: 16.0),
                ),
                Text(
                  '${userData["address"]}',
                  style: TextStyle(fontSize: 16.0),
                ),
                Divider(color: Colors.grey[300], thickness: 1),
                Text(
                  LocaleKeys.Phone_Number.tr(),
                  style: TextStyle(fontSize: 16.0),
                ),
                Text(
                  '${userData["phone_number"]}',
                  style: TextStyle(fontSize: 16.0),
                ),
                Divider(color: Colors.grey[300], thickness: 1),
                Text(
                  'Type of transaction',
                  style: TextStyle(fontSize: 16.0),
                ),
                ComboBox<String>(
                  items: [
                    'Residence certificate',
                    'Proof of work',
                    'Clearance',
                    'Issuing an invoice',
                  ].map<ComboBoxItem<String>>((String value) {
                    return ComboBoxItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  value: _selectedMaintenanceType,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedMaintenanceType = value;
                    });
                  },
                ),
                SizedBox(height: 20.0),
                Divider(color: Colors.grey[300], thickness: 1), // Added divider
                Text(
                  'Additional Details',
                  style: TextStyle(fontSize: 16.0),
                ),
                TextField(
                  controller: _detailsController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter more details here',
                    alignLabelWithHint: true, // Align label text at the top
                  ),
                ),
                SizedBox(height: 20.0),
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
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Color.fromARGB(221, 72, 21, 72),
                      backgroundColor: Color.fromARGB(255, 255, 255, 255), // Purple text color
                    ),
                    onPressed: () {
                      if (_selectedMaintenanceType == null) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text(LocaleKeys.Please_Enter_All_Information.tr()),
                            content: Text(LocaleKeys.Please_fill_in_all_required_fields.tr()),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: Text(LocaleKeys.OK.tr()),
                              ),
                            ],
                          ),
                        );
                      } else {
                        String name = userData['name'];
                        String address = userData['address'];
                        String phoneNumber = userData['phone_number'];
                        String details = _detailsController.text;

                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Transaction Information'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Name: $name'),
                                Divider(color: Colors.grey[300], thickness: 1),
                                Text('Address: $address'),
                                Divider(color: Colors.grey[300], thickness: 1),
                                Text('Phone Number: $phoneNumber'),
                                Divider(color: Colors.grey[300], thickness: 1),
                                Text('Type of transaction: $_selectedMaintenanceType'),
                                Divider(color: Colors.grey[300], thickness: 1),
                                Text('Additional Details: $details'),
                                Divider(color: Colors.grey[300], thickness: 1),
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
                      }
                    },
                    child: Text('Request Transaction'),
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

class ComboBox<T> extends StatefulWidget {
  final List<ComboBoxItem<T>> items;
  final T? value;
  final ValueChanged<T?>? onChanged;

  const ComboBox({
    required this.items,
    this.value,
    this.onChanged,
  });

  @override
  _ComboBoxState<T> createState() => _ComboBoxState<T>();
}

class _ComboBoxState<T> extends State<ComboBox<T>> {
  late T? _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 90.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        border: Border.all(color: Colors.grey),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: _selectedValue,
          items: widget.items.map((item) {
            return DropdownMenuItem<T>(
              value: item.value,
              child: item.child,
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedValue = value;
            });
            if (widget.onChanged != null) {
              widget.onChanged!(value);
            }
          },
        ),
      ),
    );
  }
}

class ComboBoxItem<T> {
  final T value;
  final Widget child;

  ComboBoxItem({required this.value, required this.child});
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
            builder: (_) => TransScreen(userData: userDataMap),
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
