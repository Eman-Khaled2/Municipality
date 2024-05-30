import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class TicketAdScreen extends StatefulWidget {
  static String routeName = "/ticketad";

  const TicketAdScreen(
      {Key? key, required this.userData, required this.onSaveChanges})
      : super(key: key);

  final Map<String, dynamic> userData;
  final void Function(Map<String, dynamic> updatedData) onSaveChanges;

  @override
  State<TicketAdScreen> createState() => _TicketAdScreenState();
}

class _TicketAdScreenState extends State<TicketAdScreen> {
  final _formKey = GlobalKey<FormState>();
  final List<String> _numberOfTickets = [];
  final List<String> _seats = [];
  String _priceA = '';
  String _priceB = '';
  final String _selectedSeat = '';
  Map<String, int> seatPrices = {
    'A': 0,
    'B': 0,
  };

  var account = GetStorage();
  var userData;

  @override
  void initState() {
    super.initState();
    userData = account.read('keyUser');
    print(userData);
  }

  int calculatePrice() {
    String seatCategory = _selectedSeat.substring(0, 1);
    int pricePerTicket = seatPrices[seatCategory] ?? 0;
    return pricePerTicket * _numberOfTickets.length;
  }

  Future<void> _saveChanges() async {
    try {
      // Prepare ticket data
      Map<String, dynamic> ticketData = {
        'numberOfTickets': _numberOfTickets,
        'seats': _seats,
        'priceA': _priceA,
        'priceB': _priceB,
      };

      // Send ticket data to backend server
      final response = await http.post(
        Uri.parse('http://192.168.1.6:3000/user/addTicket'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(ticketData),
      );

      if (response.statusCode == 201) {
        // Ticket added successfully
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ticket added successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        // Failed to add ticket
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to add ticket'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // Error occurred
      print('Error saving ticket: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to add ticket. Please try again later.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _addNumberOfTickets() async {
    int? selectedValue;
    int maxNumberOfTickets = 10; // Maximum number of tickets allowed

    await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Number of Tickets'),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<int>(
                  value: selectedValue,
                  items: List.generate(
                    maxNumberOfTickets - _numberOfTickets.length,
                    (index) => DropdownMenuItem<int>(
                      value: index + 1,
                      child: Text('${index + 1}'),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      selectedValue = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a number';
                    }
                    return null;
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState != null &&
                            _formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          Navigator.pop(context, selectedValue);
                        }
                      },
                      child: const Text('Add'),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );

    if (selectedValue != null) {
      setState(() {
        for (int i = 0; i < selectedValue!; i++) {
          _numberOfTickets.add((_numberOfTickets.length + 1).toString());
        }
      });
    }
  }

  Future<void> _deleteNumberOfTickets() async {
    int? selectedNumber;
    await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Number of Tickets'),
        content: DropdownButtonFormField<int>(
          value: selectedNumber,
          items: _numberOfTickets.map((ticket) {
            return DropdownMenuItem<int>(
              value: int.parse(ticket),
              child: Text(ticket),
            );
          }).toList(),
          onChanged: (value) {
            selectedNumber = value;
          },
          validator: (value) {
            if (value == null) {
              return 'Please select a number';
            }
            return null;
          },
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (selectedNumber != null) {
                Navigator.pop(context, selectedNumber);
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (selectedNumber != null) {
      setState(() {
        _numberOfTickets.remove(selectedNumber.toString());
      });
    }
  }

  Future<void> _addSeat() async {
    String? selectedValue;
    await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Seat'),
        content: DropdownButtonFormField<String>(
          value: selectedValue,
          items: [
            for (int i = 1; i <= 10; i++)
              DropdownMenuItem<String>(
                value: 'A$i',
                child: Text('A$i'),
              ),
            for (int i = 1; i <= 10; i++)
              DropdownMenuItem<String>(
                value: 'B$i',
                child: Text('B$i'),
              ),
          ],
          onChanged: (value) {
            selectedValue = value;
          },
          validator: (value) {
            if (value == null) {
              return 'Please select a seat';
            }
            return null;
          },
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (selectedValue != null) {
                Navigator.pop(context, selectedValue);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );

    if (selectedValue != null) {
      setState(() {
        _seats.add(selectedValue!);
      });
    }
  }

  Future<void> _deleteSeat() async {
    String? selectedSeat;
    await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Seat'),
        content: DropdownButtonFormField<String>(
          value: selectedSeat,
          items: _seats.map((seat) {
            return DropdownMenuItem<String>(
              value: seat,
              child: Text(seat),
            );
          }).toList(),
          onChanged: (value) {
            selectedSeat = value;
          },
          validator: (value) {
            if (value == null) {
              return 'Please select a seat';
            }
            return null;
          },
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (selectedSeat != null) {
                Navigator.pop(context, selectedSeat);
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (selectedSeat != null) {
      setState(() {
        _seats.remove(selectedSeat!);
      });
    }
  }

  Future<void> _editPrice() async {
    String? priceA;
    String? priceB;
    await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Price'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              onChanged: (value) {
                priceA = value;
              },
              decoration: const InputDecoration(labelText: 'Price for Seats A'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the price for Seats A';
                }
                return null;
              },
            ),
            TextFormField(
              onChanged: (value) {
                priceB = value;
              },
              decoration: const InputDecoration(labelText: 'Price for Seats B'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the price for Seats B';
                }
                return null;
              },
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (priceA != null && priceB != null) {
                Navigator.pop(context, priceA);
                Navigator.pop(context, priceB);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (priceA != null && priceB != null) {
      setState(() {
        _priceA = priceA!;
        _priceB = priceB!;
        seatPrices['A'] = int.tryParse(_priceA) ?? 0;
        seatPrices['B'] = int.tryParse(_priceB) ?? 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Ticket',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0.0,
        backgroundColor: Colors.green[900],
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
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
           Color.fromARGB(255, 238, 227, 240),Color.fromARGB(255, 187, 168, 187)
            ],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            ListTile(
              title: const Text(
                'Number of Tickets',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: _addNumberOfTickets,
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: _deleteNumberOfTickets,
                  ),
                ],
              ),
              subtitle: _numberOfTickets.isNotEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:
                          _numberOfTickets.map((ticket) => Text(ticket)).toList(),
                    )
                  : null,
            ),
            ListTile(
              title: const Text(
                'Seats',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: _addSeat,
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: _deleteSeat,
                  ),
                ],
              ),
              subtitle: _seats.isNotEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _seats.map((seat) => Text(seat)).toList(),
                    )
                  : null,
            ),
            ListTile(
              title: const Text(
                'Price',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: _editPrice,
                  ),
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Price for Seats A: $_priceA'),
                  Text('Price for Seats B: $_priceB'),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: _saveChanges, // Call the save changes function
              child: const Text('Save Change'),
            ),
          ],
        ),
      ),
    );
  }
}
