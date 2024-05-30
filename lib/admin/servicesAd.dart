import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class ServicesAdPage extends StatefulWidget {
  @override
  _ServicesAdPageState createState() => _ServicesAdPageState();

}

class _ServicesAdPageState extends State<ServicesAdPage> {
  List<String> services = [];
  List<String> waterServices = [];
  List<String> elecServices = [];
  List<String> streetServices = [];
  List<String> feesServices = [];
  List<String> advServices = [];
  List<String> sanServices = [];
  List<String> adServices = [];
   List<String> buiServices = [];
   List<String> newServices = [];
  bool elecServicesFetched = false;
   bool streetServicesFetched = false;

  @override
  void initState() {
    super.initState();
    fetchServices();
  }

  Future<void> fetchServices() async {
    final response = await http.get(Uri.parse('http://192.168.1.6:3000/user/getServices'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        services = List<String>.from(data['services'].map((service) => service['type']));
      });
    } else {
      throw Exception('Failed to load services');
    }
  }

  Future<void> fetchWaterServices() async {
    final response = await http.get(Uri.parse('http://192.168.1.6:3000/service/getWaterServices'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> waterServicesData = data['waterServices'];
      setState(() {
        waterServices = waterServicesData.map<String>((service) =>
          '${service['serviceName']} - ${service['subscriptionFee']}').toList();
      });
    } else {
      throw Exception('Failed to load water services');
    }
  }

   Future<void> fetchElecServices() async {
    if (!elecServicesFetched) { // Check if electricity services have already been fetched
      final response = await http.get(Uri.parse('http://192.168.1.6:3000/service/getElecServices'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> elecServicesData = data['elecServices'];
        setState(() {
          elecServices = elecServicesData.map<String>((service) =>
              '${service['serviceName']} - ${service['subscriptionFee']}').toList();
        });
        elecServicesFetched = true; // Set flag to true after fetching electricity services
      } else {
        throw Exception('Failed to load electricity services');
      }
    }
  }

    Future<void> fetchStreetServices() async {
    if (!streetServicesFetched) { 
      final response = await http.get(Uri.parse('http://192.168.1.6:3000/service/getStreetServices'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> streetServicesData = data['streetServices'];
        setState(() {
          streetServices = streetServicesData.map<String>((service) =>
              '${service['serviceName']} - ${service['subscriptionFee']}').toList();
        });
        streetServicesFetched = true; 
      } else {
        throw Exception('Failed to load street services');
      }
    }
  }

   Future<void> fetchFeesServices() async {
    final response = await http.get(Uri.parse('http://192.168.1.6:3000/service/getFeesServices'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> feesServicesData = data['feesServices'];
      setState(() {
        feesServices = feesServicesData.map<String>((service) =>
          '${service['serviceName']} - ${service['subscriptionFee']}').toList();
      });
    } else {
      throw Exception('Failed to load fees services');
    }
  }

   Future<void> fetchAdvServices() async {
    final response = await http.get(Uri.parse('http://192.168.1.6:3000/service/getAdvServices'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> advServicesData = data['advServices'];
      setState(() {
        advServices = advServicesData.map<String>((service) =>
          '${service['serviceName']} - ${service['subscriptionFee']}').toList();
      });
    } else {
      throw Exception('Failed to load adv services');
    }
  }

   Future<void> fetchSanServices() async {
    final response = await http.get(Uri.parse('http://192.168.1.6:3000/service/getSanServices'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> sanServicesData = data['sanServices'];
      setState(() {
        sanServices = sanServicesData.map<String>((service) =>
          '${service['serviceName']} - ${service['subscriptionFee']}').toList();
      });
    } else {
      throw Exception('Failed to load san services');
    }
  }

    Future<void> fetchAdServices() async {
    final response = await http.get(Uri.parse('http://192.168.1.6:3000/service/getAdServices'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> adServicesData = data['adServices'];
      setState(() {
        adServices = adServicesData.map<String>((service) =>
          '${service['serviceName']} - ${service['subscriptionFee']}').toList();
      });
    } else {
      throw Exception('Failed to load ad services');
    }
  }

      Future<void> fetchBuiServices() async {
    final response = await http.get(Uri.parse('http://192.168.1.6:3000/service/getBuiServices'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> buiServicesData = data['buiServices'];
      setState(() {
        buiServices = buiServicesData.map<String>((service) =>
          '${service['serviceName']} - ${service['subscriptionFee']}').toList();
      });
    } else {
      throw Exception('Failed to load building services');
    }
  }



        Future<void> fetchNewServices() async {
    final response = await http.get(Uri.parse('http://192.168.1.6:3000/service/getNewServices'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> newServicesData = data['newServices'];
      setState(() {
        newServices = newServicesData.map<String>((service) =>
          '${service['serviceName']} - ${service['subscriptionFee']}').toList();
      });
    } else {
      throw Exception('Failed to load services');
    }
  }

  void _addService(BuildContext context) async {
    TextEditingController _textFieldController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add New Service'),
          content: TextField(
            controller: _textFieldController,
            decoration: InputDecoration(hintText: "Enter service name"),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('SAVE'),
              onPressed: () async {
                String newService = _textFieldController.text;
                if (newService.isNotEmpty) {
                  final response = await http.post(
                    Uri.parse('http://192.168.1.6:3000/user/addService'),
                    headers: {"Content-Type": "application/json"},
                    body: jsonEncode({"type": newService}),
                  );

                  if (response.statusCode == 201) {
                    setState(() {
                      services.add(newService);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Service added successfully'),
                      ),
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Error'),
                          content: Text('Failed to add service. Please try again later.'),
                          actions: <Widget>[
                            TextButton(
                              child: Text('OK'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _editService(BuildContext context, int index) async {
  TextEditingController _textFieldController = TextEditingController(text: services[index]);

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Edit Service'),
        content: TextField(
          controller: _textFieldController,
          decoration: InputDecoration(hintText: "Enter service name"),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('CANCEL'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('SAVE'),
            onPressed: () async {
              String editedService = _textFieldController.text;
              if (editedService.isNotEmpty) {
                final response = await http.put(
                  Uri.parse('http://192.168.1.6:3000/user/editService'),
                  headers: {"Content-Type": "application/json"},
                  body: jsonEncode({"oldType": services[index], "newType": editedService}),
                );

                if (response.statusCode == 200) {
                  setState(() {
                    services[index] = editedService;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Service edited successfully'),
                    ),
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Error'),
                        content: Text('Failed to edit service. Please try again later.'),
                        actions: <Widget>[
                          TextButton(
                            child: Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              }
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

void _deleteService(BuildContext context, int index) async {
  String serviceToDelete = services[index];
  final response = await http.delete(
    Uri.parse('http://192.168.1.6:3000/user/deleteService'),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({"type": serviceToDelete}),
  );

  if (response.statusCode == 200) {
    setState(() {
      services.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Service deleted successfully'),
      ),
    );
  } else {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text('Failed to delete service. Please try again later.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

void _editWaterService(BuildContext context, String service) {
  // Split the service string to extract service name and subscription fee
  List<String> parts = service.split(' - ');
  String serviceName = parts[0];
  double subscriptionFee = double.tryParse(parts[1]) ?? 0.0;

  TextEditingController _serviceController = TextEditingController(text: serviceName);
  TextEditingController _feeController = TextEditingController(text: subscriptionFee.toString());

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Edit Water Service'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _serviceController,
              decoration: InputDecoration(labelText: 'Service Name'),
            ),
            TextField(
              controller: _feeController,
              decoration: InputDecoration(labelText: 'Subscription Fee'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: Text('CANCEL'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('SAVE'),
            onPressed: () async {
              String editedServiceName = _serviceController.text;
              double editedSubscriptionFee = double.tryParse(_feeController.text) ?? 0.0;
              if (editedServiceName.isNotEmpty && editedSubscriptionFee > 0) {
                final response = await http.put(
                  Uri.parse('http://192.168.1.6:3000/service/editWaterService'),
                  headers: {"Content-Type": "application/json"},
                  body: jsonEncode({
                    "serviceName": serviceName, // Send the original service name
                    "newServiceName": editedServiceName, // Send the edited service name
                    "subscriptionFee": editedSubscriptionFee
                  }),
                );

                if (response.statusCode == 200) {
                  setState(() {
                    // Update the water service details in the list
                    int index = waterServices.indexWhere((service) => service.contains(serviceName));
                    if (index != -1) {
                      waterServices[index] = '$editedServiceName - $editedSubscriptionFee';
                    }
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Water service edited successfully'),
                    ),
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Error'),
                        content: Text('Failed to edit water service. Please try again later.'),
                        actions: <Widget>[
                          TextButton(
                            child: Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              } else {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Error'),
                      content: Text('Invalid service name or fee. Please try again.'),
                      actions: <Widget>[
                        TextButton(
                          child: Text('OK'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              }
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}



void _deleteWaterService(BuildContext context, String service) async {
  // Split the service string to extract service name
  List<String> parts = service.split(' - ');
  String serviceName = parts[0]; // Extract the service name

  final response = await http.delete(
    Uri.parse('http://192.168.1.6:3000/service/deleteWaterService'),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({"serviceName": serviceName}), // Pass the service name only
  );

  if (response.statusCode == 200) {
    setState(() {
      waterServices.remove(service); // Remove the entire service string from the list
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Water service deleted successfully'),
      ),
    );
  } else {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text('Failed to delete water service. Please try again later.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}



void _addWaterService(BuildContext context) async {
  TextEditingController _serviceController = TextEditingController();
  TextEditingController _feeController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Add Water Service'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _serviceController,
              decoration: InputDecoration(labelText: 'Service Name'),
            ),
            TextField(
              controller: _feeController,
              decoration: InputDecoration(labelText: 'Subscription Fee'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: Text('CANCEL'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('SAVE'),
            onPressed: () async {
              String newService = _serviceController.text;
              double fee = double.tryParse(_feeController.text) ?? 0.0;
              if (newService.isNotEmpty && fee > 0) {
                final response = await http.post(
                  Uri.parse('http://192.168.1.6:3000/service/addWaterService'),
                  headers: {"Content-Type": "application/json"},
                  body: jsonEncode({"serviceName": newService, "subscriptionFee": fee}),
                );

                if (response.statusCode == 201) {
                  setState(() {
                    // Add the new water service to the water services list
                    waterServices.add('$newService - $fee');
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Water service added successfully'),
                    ),
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Error'),
                        content: Text('Failed to add water service. Please try again later.'),
                        actions: <Widget>[
                          TextButton(
                            child: Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              } else {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Error'),
                      content: Text('Invalid service name or fee. Please try again.'),
                      actions: <Widget>[
                        TextButton(
                          child: Text('OK'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              }
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}



void _editElecService(BuildContext context, String service) {
  // Split the service string to extract service name and subscription fee
  List<String> parts = service.split(' - ');
  String serviceName = parts[0];
  double subscriptionFee = double.tryParse(parts[1]) ?? 0.0;

  TextEditingController _serviceController = TextEditingController(text: serviceName);
  TextEditingController _feeController = TextEditingController(text: subscriptionFee.toString());

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Edit Electricity Service'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _serviceController,
              decoration: InputDecoration(labelText: 'Service Name'),
            ),
            TextField(
              controller: _feeController,
              decoration: InputDecoration(labelText: 'Subscription Fee'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: Text('CANCEL'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('SAVE'),
            onPressed: () async {
              String editedServiceName = _serviceController.text;
              double editedSubscriptionFee = double.tryParse(_feeController.text) ?? 0.0;
              if (editedServiceName.isNotEmpty && editedSubscriptionFee > 0) {
                final response = await http.put(
                  Uri.parse('http://192.168.1.6:3000/service/editElecService'),
                  headers: {"Content-Type": "application/json"},
                  body: jsonEncode({
                    "serviceName": serviceName, // Send the original service name
                    "newServiceName": editedServiceName, // Send the edited service name
                    "subscriptionFee": editedSubscriptionFee
                  }),
                );

                if (response.statusCode == 200) {
                  setState(() {
                    // Update the water service details in the list
                    int index = elecServices.indexWhere((service) => service.contains(serviceName));
                    if (index != -1) {
                      elecServices[index] = '$editedServiceName - $editedSubscriptionFee';
                    }
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Elec service edited successfully'),
                    ),
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Error'),
                        content: Text('Failed to edit electricity service. Please try again later.'),
                        actions: <Widget>[
                          TextButton(
                            child: Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              } else {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Error'),
                      content: Text('Invalid service name or fee. Please try again.'),
                      actions: <Widget>[
                        TextButton(
                          child: Text('OK'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              }
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}



void _deleteElecService(BuildContext context, String service) async {
  // Split the service string to extract service name
  List<String> parts = service.split(' - ');
  String serviceName = parts[0]; // Extract the service name

  final response = await http.delete(
    Uri.parse('http://192.168.1.6:3000/service/deleteElecService'),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({"serviceName": serviceName}), // Pass the service name only
  );

  if (response.statusCode == 200) {
    setState(() {
      elecServices.remove(service); // Remove the entire service string from the list
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Elec service deleted successfully'),
      ),
    );
  } else {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text('Failed to delete electricity service. Please try again later.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

void _addElecService(BuildContext context) async {
    TextEditingController _serviceController = TextEditingController();
    TextEditingController _feeController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Electricity Service'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _serviceController,
                decoration: InputDecoration(labelText: 'Service Name'),
              ),
              TextField(
                controller: _feeController,
                decoration: InputDecoration(labelText: 'Subscription Fee'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('SAVE'),
              onPressed: () async {
                String newService = _serviceController.text;
                double fee = double.tryParse(_feeController.text) ?? 0.0;
                if (newService.isNotEmpty && fee > 0) {
                  // Add the new service to the local list
                  setState(() {
                    elecServices.add('$newService - $fee');
                  });

                  // Send a request to add the new service to the database
                  final response = await http.post(
                    Uri.parse('http://192.168.1.6:3000/service/addElecService'),
                    headers: {"Content-Type": "application/json"},
                    body: jsonEncode({"serviceName": newService, "subscriptionFee": fee}),
                  );

                  if (response.statusCode == 201) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Electricity service added successfully'),
                      ),
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Error'),
                          content: Text('Failed to add electricity service. Please try again later.'),
                          actions: <Widget>[
                            TextButton(
                              child: Text('OK'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                } else {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Error'),
                        content: Text('Invalid service name or fee. Please try again.'),
                        actions: <Widget>[
                          TextButton(
                            child: Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

void _addStreetService(BuildContext context) async {
  TextEditingController _serviceController = TextEditingController();
  TextEditingController _feeController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Add Street Service'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _serviceController,
              decoration: InputDecoration(labelText: 'Service Name'),
            ),
            TextField(
              controller: _feeController,
              decoration: InputDecoration(labelText: 'Subscription Fee'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: Text('CANCEL'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('SAVE'),
            onPressed: () async {
              String newService = _serviceController.text;
              double fee = double.tryParse(_feeController.text) ?? 0.0;
              if (newService.isNotEmpty && fee > 0) {
                // Add the new service to the local list
                setState(() {
                  streetServices.add('$newService - $fee');
                });

                // Send a request to add the new service to the database
                final response = await http.post(
                  Uri.parse('http://192.168.1.6:3000/service/addStreetService'),
                  headers: {"Content-Type": "application/json"},
                  body: jsonEncode({"serviceName": newService, "subscriptionFee": fee}),
                );

                if (response.statusCode == 201) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Street service added successfully'),
                    ),
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Error'),
                        content: Text('Failed to add street service. Please try again later.'),
                        actions: <Widget>[
                          TextButton(
                            child: Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              } else {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Error'),
                      content: Text('Invalid service name or fee. Please try again.'),
                      actions: <Widget>[
                        TextButton(
                          child: Text('OK'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              }
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

void _editStreetService(BuildContext context, String service) {
  // Split the service string to extract service name and subscription fee
  List<String> parts = service.split(' - ');
  String serviceName = parts[0];
  double subscriptionFee = double.tryParse(parts[1]) ?? 0.0;

  TextEditingController _serviceController = TextEditingController(text: serviceName);
  TextEditingController _feeController = TextEditingController(text: subscriptionFee.toString());

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Edit Street Service'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _serviceController,
              decoration: InputDecoration(labelText: 'Service Name'),
            ),
            TextField(
              controller: _feeController,
              decoration: InputDecoration(labelText: 'Subscription Fee'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: Text('CANCEL'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('SAVE'),
            onPressed: () async {
              String editedServiceName = _serviceController.text;
              double editedSubscriptionFee = double.tryParse(_feeController.text) ?? 0.0;
              if (editedServiceName.isNotEmpty && editedSubscriptionFee > 0) {
                final response = await http.put(
                  Uri.parse('http://192.168.1.6:3000/service/editStreetService'),
                  headers: {"Content-Type": "application/json"},
                  body: jsonEncode({
                    "serviceName": serviceName, // Send the original service name
                    "newServiceName": editedServiceName, // Send the edited service name
                    "subscriptionFee": editedSubscriptionFee
                  }),
                );

                if (response.statusCode == 200) {
                  setState(() {
                    // Update the water service details in the list
                    int index = streetServices.indexWhere((service) => service.contains(serviceName));
                    if (index != -1) {
                      streetServices[index] = '$editedServiceName - $editedSubscriptionFee';
                    }
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Street service edited successfully'),
                    ),
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Error'),
                        content: Text('Failed to edit street service. Please try again later.'),
                        actions: <Widget>[
                          TextButton(
                            child: Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              } else {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Error'),
                      content: Text('Invalid service name or fee. Please try again.'),
                      actions: <Widget>[
                        TextButton(
                          child: Text('OK'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              }
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}



void _deleteStreetService(BuildContext context, String service) async {
  // Split the service string to extract service name
  List<String> parts = service.split(' - ');
  String serviceName = parts[0]; // Extract the service name

  final response = await http.delete(
    Uri.parse('http://192.168.1.6:3000/service/deleteStreetService'),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({"serviceName": serviceName}), // Pass the service name only
  );

  if (response.statusCode == 200) {
    setState(() {
      streetServices.remove(service); // Remove the entire service string from the list
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Street service deleted successfully'),
      ),
    );
  } else {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text('Failed to delete street service. Please try again later.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

void _addFeesService(BuildContext context) async {
  TextEditingController _serviceController = TextEditingController();
  TextEditingController _feeController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Add Fees Service'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _serviceController,
              decoration: InputDecoration(labelText: 'Service Name'),
            ),
            TextField(
              controller: _feeController,
              decoration: InputDecoration(labelText: 'Subscription Fee'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: Text('CANCEL'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('SAVE'),
            onPressed: () async {
              String newService = _serviceController.text;
              double fee = double.tryParse(_feeController.text) ?? 0.0;
              if (newService.isNotEmpty && fee > 0) {
                // Add the new service to the local list
                setState(() {
                  feesServices.add('$newService - $fee');
                });

                // Send a request to add the new service to the database
                final response = await http.post(
                  Uri.parse('http://192.168.1.6:3000/service/addFeesService'),
                  headers: {"Content-Type": "application/json"},
                  body: jsonEncode({"serviceName": newService, "subscriptionFee": fee}),
                );

                if (response.statusCode == 201) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Fees service added successfully'),
                    ),
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Error'),
                        content: Text('Failed to add fees service. Please try again later.'),
                        actions: <Widget>[
                          TextButton(
                            child: Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              } else {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Error'),
                      content: Text('Invalid service name or fee. Please try again.'),
                      actions: <Widget>[
                        TextButton(
                          child: Text('OK'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              }
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

void _editFeesService(BuildContext context, String service) {
  // Split the service string to extract service name and subscription fee
  List<String> parts = service.split(' - ');
  String serviceName = parts[0];
  double subscriptionFee = double.tryParse(parts[1]) ?? 0.0;

  TextEditingController _serviceController = TextEditingController(text: serviceName);
  TextEditingController _feeController = TextEditingController(text: subscriptionFee.toString());

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Edit Fees Service'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _serviceController,
              decoration: InputDecoration(labelText: 'Service Name'),
            ),
            TextField(
              controller: _feeController,
              decoration: InputDecoration(labelText: 'Subscription Fee'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: Text('CANCEL'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('SAVE'),
            onPressed: () async {
              String editedServiceName = _serviceController.text;
              double editedSubscriptionFee = double.tryParse(_feeController.text) ?? 0.0;
              if (editedServiceName.isNotEmpty && editedSubscriptionFee > 0) {
                final response = await http.put(
                  Uri.parse('http://192.168.1.6:3000/service/editFeesService'),
                  headers: {"Content-Type": "application/json"},
                  body: jsonEncode({
                    "serviceName": serviceName, // Send the original service name
                    "newServiceName": editedServiceName, // Send the edited service name
                    "subscriptionFee": editedSubscriptionFee
                  }),
                );

                if (response.statusCode == 200) {
                  setState(() {
                    // Update the water service details in the list
                    int index = feesServices.indexWhere((service) => service.contains(serviceName));
                    if (index != -1) {
                      feesServices[index] = '$editedServiceName - $editedSubscriptionFee';
                    }
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Fees service edited successfully'),
                    ),
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Error'),
                        content: Text('Failed to edit fees service. Please try again later.'),
                        actions: <Widget>[
                          TextButton(
                            child: Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              } else {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Error'),
                      content: Text('Invalid service name or fee. Please try again.'),
                      actions: <Widget>[
                        TextButton(
                          child: Text('OK'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              }
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}



void _deleteFeesService(BuildContext context, String service) async {
  // Split the service string to extract service name
  List<String> parts = service.split(' - ');
  String serviceName = parts[0]; // Extract the service name

  final response = await http.delete(
    Uri.parse('http://192.168.1.6:3000/service/deleteFeesService'),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({"serviceName": serviceName}), // Pass the service name only
  );

  if (response.statusCode == 200) {
    setState(() {
      feesServices.remove(service); // Remove the entire service string from the list
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Fees service deleted successfully'),
      ),
    );
  } else {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text('Failed to delete street service. Please try again later.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
  
  void _addAdvService(BuildContext context) async {
  TextEditingController _serviceController = TextEditingController();
  TextEditingController _feeController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Add Adv Service'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _serviceController,
              decoration: InputDecoration(labelText: 'Service Name'),
            ),
            TextField(
              controller: _feeController,
              decoration: InputDecoration(labelText: 'Subscription Fee'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: Text('CANCEL'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('SAVE'),
            onPressed: () async {
              String newService = _serviceController.text;
              double fee = double.tryParse(_feeController.text) ?? 0.0;
              if (newService.isNotEmpty && fee > 0) {
                // Add the new service to the local list
                setState(() {
                  advServices.add('$newService - $fee');
                });

                // Send a request to add the new service to the database
                final response = await http.post(
                  Uri.parse('http://192.168.1.6:3000/service/addAdvService'),
                  headers: {"Content-Type": "application/json"},
                  body: jsonEncode({"serviceName": newService, "subscriptionFee": fee}),
                );

                if (response.statusCode == 201) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Adv service added successfully'),
                    ),
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Error'),
                        content: Text('Failed to add adv service. Please try again later.'),
                        actions: <Widget>[
                          TextButton(
                            child: Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              } else {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Error'),
                      content: Text('Invalid service name or fee. Please try again.'),
                      actions: <Widget>[
                        TextButton(
                          child: Text('OK'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              }
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

void _editAdvService(BuildContext context, String service) {
  // Split the service string to extract service name and subscription fee
  List<String> parts = service.split(' - ');
  String serviceName = parts[0];
  double subscriptionFee = double.tryParse(parts[1]) ?? 0.0;

  TextEditingController _serviceController = TextEditingController(text: serviceName);
  TextEditingController _feeController = TextEditingController(text: subscriptionFee.toString());

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Edit Adv Service'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _serviceController,
              decoration: InputDecoration(labelText: 'Service Name'),
            ),
            TextField(
              controller: _feeController,
              decoration: InputDecoration(labelText: 'Subscription Fee'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: Text('CANCEL'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('SAVE'),
            onPressed: () async {
              String editedServiceName = _serviceController.text;
              double editedSubscriptionFee = double.tryParse(_feeController.text) ?? 0.0;
              if (editedServiceName.isNotEmpty && editedSubscriptionFee > 0) {
                final response = await http.put(
                  Uri.parse('http://192.168.1.6:3000/service/editAdvService'),
                  headers: {"Content-Type": "application/json"},
                  body: jsonEncode({
                    "serviceName": serviceName, // Send the original service name
                    "newServiceName": editedServiceName, // Send the edited service name
                    "subscriptionFee": editedSubscriptionFee
                  }),
                );

                if (response.statusCode == 200) {
                  setState(() {
                    // Update the water service details in the list
                    int index = advServices.indexWhere((service) => service.contains(serviceName));
                    if (index != -1) {
                      advServices[index] = '$editedServiceName - $editedSubscriptionFee';
                    }
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Adv service edited successfully'),
                    ),
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Error'),
                        content: Text('Failed to edit adv service. Please try again later.'),
                        actions: <Widget>[
                          TextButton(
                            child: Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              } else {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Error'),
                      content: Text('Invalid service name or fee. Please try again.'),
                      actions: <Widget>[
                        TextButton(
                          child: Text('OK'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              }
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}



void _deleteAdvService(BuildContext context, String service) async {
  // Split the service string to extract service name
  List<String> parts = service.split(' - ');
  String serviceName = parts[0]; // Extract the service name

  final response = await http.delete(
    Uri.parse('http://192.168.1.6:3000/service/deleteAdvService'),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({"serviceName": serviceName}), // Pass the service name only
  );

  if (response.statusCode == 200) {
    setState(() {
      advServices.remove(service); // Remove the entire service string from the list
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Adv service deleted successfully'),
      ),
    );
  } else {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text('Failed to delete adv service. Please try again later.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}



  void _addSanService(BuildContext context) async {
  TextEditingController _serviceController = TextEditingController();
  TextEditingController _feeController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Add San Service'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _serviceController,
              decoration: InputDecoration(labelText: 'Service Name'),
            ),
            TextField(
              controller: _feeController,
              decoration: InputDecoration(labelText: 'Subscription Fee'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: Text('CANCEL'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('SAVE'),
            onPressed: () async {
              String newService = _serviceController.text;
              double fee = double.tryParse(_feeController.text) ?? 0.0;
              if (newService.isNotEmpty && fee > 0) {
                // Add the new service to the local list
                setState(() {
                  sanServices.add('$newService - $fee');
                });

                // Send a request to add the new service to the database
                final response = await http.post(
                  Uri.parse('http://192.168.1.6:3000/service/addSanService'),
                  headers: {"Content-Type": "application/json"},
                  body: jsonEncode({"serviceName": newService, "subscriptionFee": fee}),
                );

                if (response.statusCode == 201) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('San service added successfully'),
                    ),
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Error'),
                        content: Text('Failed to add san service. Please try again later.'),
                        actions: <Widget>[
                          TextButton(
                            child: Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              } else {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Error'),
                      content: Text('Invalid service name or fee. Please try again.'),
                      actions: <Widget>[
                        TextButton(
                          child: Text('OK'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              }
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

void _editSanService(BuildContext context, String service) {
  // Split the service string to extract service name and subscription fee
  List<String> parts = service.split(' - ');
  String serviceName = parts[0];
  double subscriptionFee = double.tryParse(parts[1]) ?? 0.0;

  TextEditingController _serviceController = TextEditingController(text: serviceName);
  TextEditingController _feeController = TextEditingController(text: subscriptionFee.toString());

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Edit San Service'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _serviceController,
              decoration: InputDecoration(labelText: 'Service Name'),
            ),
            TextField(
              controller: _feeController,
              decoration: InputDecoration(labelText: 'Subscription Fee'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: Text('CANCEL'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('SAVE'),
            onPressed: () async {
              String editedServiceName = _serviceController.text;
              double editedSubscriptionFee = double.tryParse(_feeController.text) ?? 0.0;
              if (editedServiceName.isNotEmpty && editedSubscriptionFee > 0) {
                final response = await http.put(
                  Uri.parse('http://192.168.1.6:3000/service/editSanService'),
                  headers: {"Content-Type": "application/json"},
                  body: jsonEncode({
                    "serviceName": serviceName, // Send the original service name
                    "newServiceName": editedServiceName, // Send the edited service name
                    "subscriptionFee": editedSubscriptionFee
                  }),
                );

                if (response.statusCode == 200) {
                  setState(() {
                    // Update the water service details in the list
                    int index = sanServices.indexWhere((service) => service.contains(serviceName));
                    if (index != -1) {
                     sanServices[index] = '$editedServiceName - $editedSubscriptionFee';
                    }
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('San service edited successfully'),
                    ),
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Error'),
                        content: Text('Failed to edit san service. Please try again later.'),
                        actions: <Widget>[
                          TextButton(
                            child: Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              } else {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Error'),
                      content: Text('Invalid service name or fee. Please try again.'),
                      actions: <Widget>[
                        TextButton(
                          child: Text('OK'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              }
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}



void _deleteSanService(BuildContext context, String service) async {
  List<String> parts = service.split(' - ');
  String serviceName = parts[0]; // Extract the service name

  final response = await http.delete(
    Uri.parse('http://192.168.1.6:3000/service/deleteSanService'),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({"serviceName": serviceName}), // Pass the service name only
  );

  if (response.statusCode == 200) {
    setState(() {
      sanServices.remove(service); // Remove the entire service string from the list
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('San service deleted successfully'),
      ),
    );
  } else {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text('Failed to delete san service. Please try again later.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}


  void _addAdService(BuildContext context) async {
  TextEditingController _serviceController = TextEditingController();
  TextEditingController _feeController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Add ad Service'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _serviceController,
              decoration: InputDecoration(labelText: 'Service Name'),
            ),
            TextField(
              controller: _feeController,
              decoration: InputDecoration(labelText: 'Subscription Fee'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: Text('CANCEL'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('SAVE'),
            onPressed: () async {
              String newService = _serviceController.text;
              double fee = double.tryParse(_feeController.text) ?? 0.0;
              if (newService.isNotEmpty && fee > 0) {
                // Add the new service to the local list
                setState(() {
                  adServices.add('$newService - $fee');
                });

                // Send a request to add the new service to the database
                final response = await http.post(
                  Uri.parse('http://192.168.1.6:3000/service/addAdService'),
                  headers: {"Content-Type": "application/json"},
                  body: jsonEncode({"serviceName": newService, "subscriptionFee": fee}),
                );

                if (response.statusCode == 201) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Ad service added successfully'),
                    ),
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Error'),
                        content: Text('Failed to add ad service. Please try again later.'),
                        actions: <Widget>[
                          TextButton(
                            child: Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              } else {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Error'),
                      content: Text('Invalid service name or fee. Please try again.'),
                      actions: <Widget>[
                        TextButton(
                          child: Text('OK'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              }
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

void _editAdService(BuildContext context, String service) {
  // Split the service string to extract service name and subscription fee
  List<String> parts = service.split(' - ');
  String serviceName = parts[0];
  double subscriptionFee = double.tryParse(parts[1]) ?? 0.0;

  TextEditingController _serviceController = TextEditingController(text: serviceName);
  TextEditingController _feeController = TextEditingController(text: subscriptionFee.toString());

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Edit Ad Service'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _serviceController,
              decoration: InputDecoration(labelText: 'Service Name'),
            ),
            TextField(
              controller: _feeController,
              decoration: InputDecoration(labelText: 'Subscription Fee'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: Text('CANCEL'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('SAVE'),
            onPressed: () async {
              String editedServiceName = _serviceController.text;
              double editedSubscriptionFee = double.tryParse(_feeController.text) ?? 0.0;
              if (editedServiceName.isNotEmpty && editedSubscriptionFee > 0) {
                final response = await http.put(
                  Uri.parse('http://192.168.1.6:3000/service/editAdService'),
                  headers: {"Content-Type": "application/json"},
                  body: jsonEncode({
                    "serviceName": serviceName, // Send the original service name
                    "newServiceName": editedServiceName, // Send the edited service name
                    "subscriptionFee": editedSubscriptionFee
                  }),
                );

                if (response.statusCode == 200) {
                  setState(() {
                    // Update the water service details in the list
                    int index = adServices.indexWhere((service) => service.contains(serviceName));
                    if (index != -1) {
                      adServices[index] = '$editedServiceName - $editedSubscriptionFee';
                    }
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Ad service edited successfully'),
                    ),
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Error'),
                        content: Text('Failed to edit ad service. Please try again later.'),
                        actions: <Widget>[
                          TextButton(
                            child: Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              } else {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Error'),
                      content: Text('Invalid service name or fee. Please try again.'),
                      actions: <Widget>[
                        TextButton(
                          child: Text('OK'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              }
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}



void _deleteAdService(BuildContext context, String service) async {
  List<String> parts = service.split(' - ');
  String serviceName = parts[0]; // Extract the service name

  final response = await http.delete(
    Uri.parse('http://192.168.1.6:3000/service/deleteAdService'),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({"serviceName": serviceName}), // Pass the service name only
  );

  if (response.statusCode == 200) {
    setState(() {
      adServices.remove(service); // Remove the entire service string from the list
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Ad service deleted successfully'),
      ),
    );
  } else {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text('Failed to delete ad service. Please try again later.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

  void _addBuiService(BuildContext context) async {
  TextEditingController _serviceController = TextEditingController();
  TextEditingController _feeController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Add building Service'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _serviceController,
              decoration: InputDecoration(labelText: 'Service Name'),
            ),
            TextField(
              controller: _feeController,
              decoration: InputDecoration(labelText: 'Subscription Fee'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: Text('CANCEL'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('SAVE'),
            onPressed: () async {
              String newService = _serviceController.text;
              double fee = double.tryParse(_feeController.text) ?? 0.0;
              if (newService.isNotEmpty && fee > 0) {
                // Add the new service to the local list
                setState(() {
                  buiServices.add('$newService - $fee');
                });

                // Send a request to add the new service to the database
                final response = await http.post(
                  Uri.parse('http://192.168.1.6:3000/service/addBuiService'),
                  headers: {"Content-Type": "application/json"},
                  body: jsonEncode({"serviceName": newService, "subscriptionFee": fee}),
                );

                if (response.statusCode == 201) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Building service added successfully'),
                    ),
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Error'),
                        content: Text('Failed to add building service. Please try again later.'),
                        actions: <Widget>[
                          TextButton(
                            child: Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              } else {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Error'),
                      content: Text('Invalid service name or fee. Please try again.'),
                      actions: <Widget>[
                        TextButton(
                          child: Text('OK'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              }
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

void _editBuiService(BuildContext context, String service) {
  // Split the service string to extract service name and subscription fee
  List<String> parts = service.split(' - ');
  String serviceName = parts[0];
  double subscriptionFee = double.tryParse(parts[1]) ?? 0.0;

  TextEditingController _serviceController = TextEditingController(text: serviceName);
  TextEditingController _feeController = TextEditingController(text: subscriptionFee.toString());

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Edit Building Service'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _serviceController,
              decoration: InputDecoration(labelText: 'Service Name'),
            ),
            TextField(
              controller: _feeController,
              decoration: InputDecoration(labelText: 'Subscription Fee'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: Text('CANCEL'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('SAVE'),
            onPressed: () async {
              String editedServiceName = _serviceController.text;
              double editedSubscriptionFee = double.tryParse(_feeController.text) ?? 0.0;
              if (editedServiceName.isNotEmpty && editedSubscriptionFee > 0) {
                final response = await http.put(
                  Uri.parse('http://192.168.1.6:3000/service/editBuiService'),
                  headers: {"Content-Type": "application/json"},
                  body: jsonEncode({
                    "serviceName": serviceName, // Send the original service name
                    "newServiceName": editedServiceName, // Send the edited service name
                    "subscriptionFee": editedSubscriptionFee
                  }),
                );

                if (response.statusCode == 200) {
                  setState(() {
                    // Update the water service details in the list
                    int index = buiServices.indexWhere((service) => service.contains(serviceName));
                    if (index != -1) {
                      buiServices[index] = '$editedServiceName - $editedSubscriptionFee';
                    }
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Building service edited successfully'),
                    ),
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Error'),
                        content: Text('Failed to edit building service. Please try again later.'),
                        actions: <Widget>[
                          TextButton(
                            child: Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              } else {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Error'),
                      content: Text('Invalid service name or fee. Please try again.'),
                      actions: <Widget>[
                        TextButton(
                          child: Text('OK'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              }
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}



void _deleteBuiService(BuildContext context, String service) async {
  List<String> parts = service.split(' - ');
  String serviceName = parts[0]; // Extract the service name

  final response = await http.delete(
    Uri.parse('http://192.168.1.6:3000/service/deleteBuiService'),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({"serviceName": serviceName}), // Pass the service name only
  );

  if (response.statusCode == 200) {
    setState(() {
      buiServices.remove(service); // Remove the entire service string from the list
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Building service deleted successfully'),
      ),
    );
  } else {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text('Failed to delete building service. Please try again later.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

 void _addNewService(BuildContext context) async {
  TextEditingController _serviceController = TextEditingController();
  TextEditingController _feeController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Add Service'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _serviceController,
              decoration: InputDecoration(labelText: 'Service Name'),
            ),
            TextField(
              controller: _feeController,
              decoration: InputDecoration(labelText: 'Subscription Fee'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: Text('CANCEL'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('SAVE'),
            onPressed: () async {
              String newService = _serviceController.text;
              double fee = double.tryParse(_feeController.text) ?? 0.0;
              if (newService.isNotEmpty && fee > 0) {
                // Add the new service to the local list
                setState(() {
                  newServices.add('$newService - $fee');
                });

                // Send a request to add the new service to the database
                final response = await http.post(
                  Uri.parse('http://192.168.1.6:3000/service/addNewService'),
                  headers: {"Content-Type": "application/json"},
                  body: jsonEncode({"serviceName": newService, "subscriptionFee": fee}),
                );

                if (response.statusCode == 201) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Service added successfully'),
                    ),
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Error'),
                        content: Text('Failed to add service. Please try again later.'),
                        actions: <Widget>[
                          TextButton(
                            child: Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              } else {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Error'),
                      content: Text('Invalid service name or fee. Please try again.'),
                      actions: <Widget>[
                        TextButton(
                          child: Text('OK'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              }
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

void _deleteNewService(BuildContext context, String service) async {
  List<String> parts = service.split(' - ');
  String serviceName = parts[0]; // Extract the service name

  final response = await http.delete(
    Uri.parse('http://192.168.1.6:3000/service/deleteNewService'),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({"serviceName": serviceName}), // Pass the service name only
  );

  if (response.statusCode == 200) {
    setState(() {
      newServices.remove(service); // Remove the entire service string from the list
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Service deleted successfully'),
      ),
    );
  } else {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text('Failed to delete service. Please try again later.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

void _editNewService(BuildContext context, String service) {
  // Split the service string to extract service name and subscription fee
  List<String> parts = service.split(' - ');
  String serviceName = parts[0];
  double subscriptionFee = double.tryParse(parts[1]) ?? 0.0;

  TextEditingController _serviceController = TextEditingController(text: serviceName);
  TextEditingController _feeController = TextEditingController(text: subscriptionFee.toString());

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Edit Service'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _serviceController,
              decoration: InputDecoration(labelText: 'Service Name'),
            ),
            TextField(
              controller: _feeController,
              decoration: InputDecoration(labelText: 'Subscription Fee'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: Text('CANCEL'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('SAVE'),
            onPressed: () async {
              String editedServiceName = _serviceController.text;
              double editedSubscriptionFee = double.tryParse(_feeController.text) ?? 0.0;
              if (editedServiceName.isNotEmpty && editedSubscriptionFee > 0) {
                final response = await http.put(
                  Uri.parse('http://192.168.1.6:3000/service/editNewService'),
                  headers: {"Content-Type": "application/json"},
                  body: jsonEncode({
                    "serviceName": serviceName, // Send the original service name
                    "newServiceName": editedServiceName, // Send the edited service name
                    "subscriptionFee": editedSubscriptionFee
                  }),
                );

                if (response.statusCode == 200) {
                  setState(() {
                    
                    int index = newServices.indexWhere((service) => service.contains(serviceName));
                    if (index != -1) {
                      newServices[index] = '$editedServiceName - $editedSubscriptionFee';
                    }
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Service edited successfully'),
                    ),
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Error'),
                        content: Text('Failed to edit service. Please try again later.'),
                        actions: <Widget>[
                          TextButton(
                            child: Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              } else {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Error'),
                      content: Text('Invalid service name or fee. Please try again.'),
                      actions: <Widget>[
                        TextButton(
                          child: Text('OK'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              }
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Services',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
           decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
             Color.fromARGB(255, 238, 227, 240), Color.fromARGB(255, 187, 168, 187)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView.builder(
        itemCount: services.length,
        itemBuilder: (context, index) {
          return ExpansionTile(
            title: Row(
              children: [
                Expanded(
                  child: Text(services[index]),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    if (services[index] == 'Water Services') {
                      _addWaterService(context);
                    } else if (services[index] == 'Electricity Services') {
                      _addElecService(context);
                    } else if (services[index] == 'Street and road Services') {
                      _addStreetService(context);
                    }
                    else if (services[index] == 'Fees Services') {
                      _addFeesService(context);
                    }
                    else if (services[index] == 'Advertising Services') {
                      _addAdvService(context);
                    }
                    else if (services[index] == 'Sanitation Services') {
                      _addSanService(context);
                    }
                     else if (services[index] == 'Administrative Services') {
                      _addAdService(context);
                    }
                     else if (services[index] == 'Building Services') {
                      _addBuiService(context);
                    }
                    else {
                      _addNewService(context);
                    }
                  },
                ),
              ],
            ),
            onExpansionChanged: (expanded) {
              if (expanded) {
                if (services[index] == 'Building Services') {
                  setState(() {
                    buiServices = [];
                  });
                  fetchBuiServices();
                }
                else if (services[index] == 'Administrative Services') {
                  setState(() {
                    adServices = [];
                  });
                  fetchAdServices();
                }
                else if (services[index] == 'Sanitation Services') {
                  setState(() {
                    sanServices = [];
                  });
                  fetchSanServices();
                }
                 else if (services[index] == 'Advertising Services') {
                  setState(() {
                    advServices = [];
                  });
                  fetchAdvServices();
                }
                 else if (services[index] == 'Fees Services') {
                  setState(() {
                    feesServices = [];
                  });
                  fetchFeesServices();
                }
                else if (services[index] == 'Street and road Services') {
                  setState(() {
                    streetServices = [];
                  });
                  fetchStreetServices();
                } else if (services[index] == 'Electricity Services') {
                  setState(() {
                    elecServices = [];
                  });
                  fetchElecServices();
                } else if (services[index] == 'Water Services') {
                  setState(() {
                    waterServices = [];
                  });
                  fetchWaterServices();
                }
                else {
                  setState(() {
                    newServices = [];
                  });
                  fetchNewServices();
                }
              }
            },
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => _editService(context, index),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _deleteService(context, index),
                ),
              ],
            ),
            children: services[index] == 'Water Services'
                ? waterServices.map((service) {
                    return ListTile(
                      title: Row(
                        children: [
                          Expanded(
                            child: Text(
                              service,
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () => _editWaterService(context, service),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => _deleteWaterService(context, service),
                          ),
                        ],
                      ),
                    );
                  }).toList()
                   : services[index] == 'Building Services'
                    ? buiServices.map((service) {
                        return ListTile(
                          title: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  service,
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () => _editBuiService(context, service),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () => _deleteBuiService(context, service),
                              ),
                            ],
                          ),
                        );
                      }).toList()
                   : services[index] == 'Administrative Services'
                    ? adServices.map((service) {
                        return ListTile(
                          title: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  service,
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () => _editAdService(context, service),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () => _deleteAdService(context, service),
                              ),
                            ],
                          ),
                        );
                      }).toList()
                   : services[index] == 'Sanitation Services'
                    ? sanServices.map((service) {
                        return ListTile(
                          title: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  service,
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () => _editSanService(context, service),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () => _deleteSanService(context, service),
                              ),
                            ],
                          ),
                        );
                      }).toList()
                   : services[index] == 'Advertising Services'
                    ? advServices.map((service) {
                        return ListTile(
                          title: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  service,
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () => _editAdvService(context, service),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () => _deleteAdvService(context, service),
                              ),
                            ],
                          ),
                        );
                      }).toList()
                   : services[index] == 'Fees Services'
                    ? feesServices.map((service) {
                        return ListTile(
                          title: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  service,
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () => _editFeesService(context, service),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () => _deleteFeesService(context, service),
                              ),
                            ],
                          ),
                        );
                      }).toList()
                : services[index] == 'Street and road Services'
                    ? streetServices.map((service) {
                        return ListTile(
                          title: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  service,
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () => _editStreetService(context, service),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () => _deleteStreetService(context, service),
                              ),
                            ],
                          ),
                        );
                      }).toList()
                      : services[index] == 'Electricity Services'
                    ? elecServices.map((service) {
                        return ListTile(
                          title: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  service,
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () => _editElecService(context, service),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () => _deleteElecService(context, service),
                              ),
                            ],
                          ),
                        );
                      }).toList()
                      :  newServices.map((service) {
                        return ListTile(
                          title: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  service,
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () => _editNewService(context, service),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () => _deleteNewService(context, service),
                              ),
                            ],
                          ),
                        );
                      }).toList()
          );
        },
      ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addService(context);
        },
        tooltip: 'Add Service',
        child: Icon(Icons.add),
        backgroundColor: const Color.fromARGB(255, 249, 255, 249),
      ),
    );
  }
}