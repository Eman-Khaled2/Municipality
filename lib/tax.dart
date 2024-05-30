import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shop_app/translation/locale_keys.g.dart';

class TaxPage extends StatefulWidget {
  @override
  _TaxPageState createState() => _TaxPageState();
}

class _TaxPageState extends State<TaxPage> {
  List<Map<String, dynamic>> taxes = [];
  String? selectedTaxType;
  double paymentAmount = 0.00;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTaxes();
  }

  Future<void> fetchTaxes() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.1.6:3000/user/getTax'));
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        List<dynamic> types = jsonResponse['types'];
        Map<String, dynamic> totals = jsonResponse['totals'];
        Map<String, dynamic> paid = jsonResponse['paid'];

        setState(() {
          taxes = types.map((type) => {
            'type': type,
            'totalAmount': totals[type],
            'paidAmount': paid[type]
          }).toList();
          isLoading = false;
          selectedTaxType = taxes.isNotEmpty ? taxes.first['type'] : null;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Failed to load taxes: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.Tax_Payment.tr(), style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: isLoading ? Center(child: CircularProgressIndicator()) : buildTaxPageBody(),
    );
  }

  Widget buildTaxPageBody() {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFD3D3D3), // Light Gray
                Color.fromARGB(255, 187, 168, 187), // Custom Color
              ],
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Card(
                shadowColor: Color.fromARGB(255, 183, 143, 196),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 20.0,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: buildTaxDetails(),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> buildTaxDetails() {
    List<Widget> widgets = [
      if (taxes.isNotEmpty) ...[
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            LocaleKeys.Select_Tax_Type.tr(),
            style: TextStyle(color: Color.fromARGB(255, 36, 36, 36), fontSize: 16),
          ),
        ),
        SizedBox(height: 10),
        DropdownButtonFormField<String>(
          value: selectedTaxType,
          items: taxes.map<DropdownMenuItem<String>>((tax) {
            return DropdownMenuItem<String>(
              value: tax['type'],
              child: Text(tax['type'], style: TextStyle(color: Color.fromARGB(255, 81, 80, 80))),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              selectedTaxType = newValue;
            });
          },
          decoration: InputDecoration(
            fillColor: Color.fromARGB(255, 227, 217, 227),
            filled: true,
            border: InputBorder.none,
          ),
        ),
        SizedBox(height: 10),
        Text('Total Amount Due: \$${taxes.firstWhere((tax) => tax['type'] == selectedTaxType, orElse: () => {'totalAmount': 0})['totalAmount'].toStringAsFixed(2)}',
            style: TextStyle(color: Color.fromARGB(255, 61, 61, 61))),
        SizedBox(height: 10),
        Text('Amount Paid: \$${taxes.firstWhere((tax) => tax['type'] == selectedTaxType, orElse: () => {'paidAmount': 0})['paidAmount'].toStringAsFixed(2)}',
            style: TextStyle(color: Color.fromARGB(255, 61, 61, 61))),
        SizedBox(height: 20),
      ],
      Align(
        alignment: Alignment.centerLeft,
        child: Text(
          LocaleKeys.Enter_Payment_Amount.tr(),
          style: TextStyle(color: Color.fromARGB(255, 36, 36, 36), fontSize: 16),
        ),
      ),
      SizedBox(height: 10),
      TextFormField(
        onChanged: (value) {
          setState(() {
            paymentAmount = double.tryParse(value) ?? 0.00;
          });
        },
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          fillColor: Color.fromARGB(255, 227, 217, 227),
          filled: true,
          border: InputBorder.none,
        ),
      ),
      SizedBox(height: 20),
      ElevatedButton(
        onPressed: () => makePayment(),
        child: Text(
          LocaleKeys.Pay_Amount.tr(),
          style: TextStyle(color: Color.fromARGB(255, 182, 130, 192)),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          padding: EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
      ),
    ];
    return widgets;
  }

  void makePayment() async {
    if (selectedTaxType == null || taxes.isEmpty || paymentAmount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a tax type and enter a valid amount before making a payment.')),
      );
      return;
    }

    try {
      final payload = jsonEncode({
        'type': selectedTaxType,
        'amount': paymentAmount
      });

      final response = await http.post(
        Uri.parse('http://192.168.1.6:3000/user/postTax'),
        headers: {'Content-Type': 'application/json'},
        body: payload,
      );

      if (response.statusCode == 200) {
        fetchTaxes(); // Reload tax data after payment
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(LocaleKeys.success.tr())),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Payment failed: ${response.body}')),
        );
      }
    } catch (e) {
      print("HTTP request failed: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment exception: $e')),
      );
    }
  }
}
