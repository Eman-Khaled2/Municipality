import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shop_app/translation/locale_keys.g.dart';
import 'package:http/http.dart' as http;

class InvoiceWScreen extends StatefulWidget {
  @override
  static String routeName = "/invoicew";

  const InvoiceWScreen({Key? key, required this.userData}) : super(key: key);

  final Map<String, dynamic> userData;

  @override
  State<InvoiceWScreen> createState() => _InvoiceWScreenState();
}

class _InvoiceWScreenState extends State<InvoiceWScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _invoiceInfoController = TextEditingController();

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
          'serviceName': 'Water invoice', // Provide the service name
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
          LocaleKeys.Objection_to_Invoice.tr(),
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
                _buildLabel(LocaleKeys.Name.tr(), '${userData["name"]}'),
                _buildDivider(),
                _buildLabel(LocaleKeys.Address.tr(), '${userData["address"]}'),
                _buildDivider(),
                _buildLabel(LocaleKeys.Phone_Number.tr(), '${userData["phone_number"]}'),
                _buildDivider(),
                _buildLabel(LocaleKeys.additional_invoice_info.tr(), ''),
                TextField(
                  controller: _invoiceInfoController,
                  decoration: InputDecoration(
                    hintText: LocaleKeys.enter_additional_invoice_info.tr(),
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
                SizedBox(height: 250),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Color.fromARGB(221, 72, 21, 72),
                      backgroundColor: Color.fromARGB(255, 255, 255, 255),
                    ),
                    onPressed: () {
                      if (_invoiceInfoController.text.isEmpty) {
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
                        String invoiceInfo = _invoiceInfoController.text;

                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Invoice Objection Information'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Name: $name'),
                                Text('Address: $address'),
                                Text('Phone Number: $phoneNumber'),
                                Text('Additional Invoice Information: $invoiceInfo'),
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

                        _invoiceInfoController.clear();
                      }
                    },
                    child: Text(LocaleKeys.object_to_invoice.tr()),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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

  Widget _buildSubscriptionFee(int subscriptionFee) {
    return Text(
      'Subscription Fee: ${subscriptionFee.toString()}',
      style: TextStyle(fontSize: 16.0),
    );
  }

  Widget _buildDivider() {
    return Divider(color: Colors.grey[300]);
  }
}
