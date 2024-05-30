import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TaxAdPage extends StatefulWidget {
  static String routeName = "/Tax";

  const TaxAdPage({Key? key}) : super(key: key);

  @override
  _TaxAdPageState createState() => _TaxAdPageState();
}

class _TaxAdPageState extends State<TaxAdPage> {
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
      final response = await http.get(Uri.parse('http://192.168.1.6:3000/user/getTaxAd'));
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        List<dynamic> types = jsonResponse['types'];
        Map<String, dynamic> totals = jsonResponse['totals'];

        setState(() {
          taxes = types
              .map((type) => {
                    'type': type,
                    'totalAmount': totals[type],
                  })
              .toList();
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
        title: Text('Tax Payment', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green[900],
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: isLoading ? CircularProgressIndicator() : buildTaxPageBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTaxDialog();
        },
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        child: Icon(Icons.add),
      ),
    );
  }

  Widget buildTaxPageBody() {
    return Center(
      child: Container(
        padding: EdgeInsets.all(20.0),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [ Color.fromARGB(255, 238, 227, 240),Color.fromARGB(255, 187, 168, 187)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: buildTaxDetails(),
          ),
        ),
      ),
    );
  }

  List<Widget> buildTaxDetails() {
    List<Widget> widgets = [
      if (taxes.isNotEmpty) ...[
        SizedBox(height: 10),
        for (int i = 0; i < taxes.length; i++) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(taxes[i]['type'], style: TextStyle(color: Colors.black)),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      _showEditTaxDialog(i);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      _deleteTax(i);
                    },
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
              'Total Amount Due: \$${taxes[i]['totalAmount'].toStringAsFixed(2)}',
              style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
          SizedBox(height: 20),
        ],
      ],
    ];
    return widgets;
  }

  void _showAddTaxDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String newTaxType = '';
        double newTotalAmount = 0.00;

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text("Add Tax Type"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    decoration: InputDecoration(labelText: "Tax Type"),
                    onChanged: (value) {
                      setState(() {
                        newTaxType = value;
                      });
                    },
                  ),
                  TextFormField(
                    decoration:
                        InputDecoration(labelText: "Total Amount Paid"),
                    onChanged: (value) {
                      setState(() {
                        newTotalAmount = double.tryParse(value) ?? 0.00;
                      });
                    },
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Add tax to the list
                    if (newTaxType.isNotEmpty && newTotalAmount > 0) {
                      _addTax(newTaxType, newTotalAmount);
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text("Add"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _addTax(String newTaxType, double newTotalAmount) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.6:3000/user/addTax'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'type': newTaxType,
          'totalAmount': newTotalAmount,
        }),
      );

      if (response.statusCode == 201) {
        print('Tax added successfully');
        setState(() {
          taxes.add({'type': newTaxType, 'totalAmount': newTotalAmount});
        });
      } else {
        print('Failed to add tax. Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Failed to add tax: $e');
    }
  }

  void _showEditTaxDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String editedTaxType = taxes[index]['type'];
        double editedTotalAmount = taxes[index]['totalAmount'].toDouble();

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text("Edit Tax Type"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    initialValue: editedTaxType,
                    decoration: InputDecoration(labelText: "Tax Type"),
                    onChanged: (value) {
                      setState(() {
                        editedTaxType = value;
                      });
                    },
                  ),
                  TextFormField(
                    initialValue: editedTotalAmount.toString(),
                    decoration:
                        InputDecoration(labelText: "Total Amount Paid"),
                    onChanged: (value) {
                      setState(() {
                        editedTotalAmount = double.tryParse(value) ?? 0.00;
                      });
                    },
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Cancel"),
                ),
                ElevatedButton(

                  onPressed: () {
                    // Update tax in the list
                    if (editedTaxType.isNotEmpty && editedTotalAmount > 0) {
                      _updateTax(index, editedTaxType, editedTotalAmount);
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text("Save"),
                ),
          
              ],
            );
          },
        );
      },
    );
  }

  void _updateTax(
      int index, String editedTaxType, double editedTotalAmount) async {
    try {
      final response = await http.put(
        Uri.parse('http://192.168.1.6:3000/user/updateTax'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'oldType': taxes[index]['type'],
          'newType': editedTaxType,
          'totalAmount': editedTotalAmount,
        }),
      );

      if (response.statusCode == 200) {
        print('Tax updated successfully');
        setState(() {
          taxes[index]['type'] = editedTaxType;
          taxes[index]['totalAmount'] = editedTotalAmount;
        });
      } else {
        print('Failed to update tax. Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Failed to update tax: $e');
    }
  }

  void _deleteTax(int index) async {
    try {
      final taxName = taxes[index]
          ['type']; // Assuming each tax has a 'type' field in the database

      final response = await http.delete(
        Uri.parse('http://192.168.1.6:3000/user/deleteTax'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'type': taxName}),
      );

      if (response.statusCode == 200) {
        print('Tax deleted successfully');
        setState(() {
          taxes.removeAt(index);
        });
      } else {
        print('Failed to delete tax. Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Failed to delete tax: $e');
    }
  }
}
