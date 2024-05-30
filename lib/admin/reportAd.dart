import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ReportAd {
  String type;

  ReportAd(this.type);
}
 
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ReportAdPage(),
    );
  }
}

class ReportAdPage extends StatefulWidget {
  const ReportAdPage({Key? key}) : super(key: key);
  static String routeName = "/ReportAdPage";

  @override
  State<ReportAdPage> createState() => _ReportAdPageState();
}

class _ReportAdPageState extends State<ReportAdPage> {
  ReportAd? _selectedReport;
  String? type;
  List<ReportAd> reports = [];

  @override
  void initState() {
    super.initState();
    fetchReports();
  }

  void fetchReports() async {
    final response =
        await http.get(Uri.parse('http://192.168.1.6:3000/user/getReports'));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      List<dynamic> reportList = data['reports'];

      setState(() {
        reports = reportList
            .map((report) =>
                ReportAd(report['type']))
            .toList();
      });
    } else {
      throw Exception('Failed to load reports');
    }
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Reports Page', style: TextStyle(color: Colors.white)),
      backgroundColor: Colors.green,
      iconTheme: const IconThemeData(color: Colors.white),
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
      child: ListView.builder(
        itemCount: reports.length,
        itemBuilder: (context, index) {
          final report = reports[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        report.type,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    _editReport(context, report);
                  },
                  icon: const Icon(Icons.edit),
                ),
                IconButton(
                  onPressed: () {
                    _deleteReport(report);
                  },
                  icon: const Icon(Icons.delete),
                ),
              ],
            ),
          );
        },
      ),
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: () {
        _showAddReportDialog(context);
      },
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      child: const Icon(Icons.add),
    ),
  );
}



  void _showAddReportDialog(BuildContext context) {
    String newType = '';
    String newDescription = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Report Type'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Type'),
                onChanged: (value) {
                  newType = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final response = await http.post(
                  Uri.parse('http://192.168.1.6:3000/user/addReport'),
                  headers: {"Content-Type": "application/json"},
                  body: jsonEncode({
                    "type": newType,
                  }),
                );

                if (response.statusCode == 201) {
                  setState(() {
                    reports.add(ReportAd(newType));
                  });
                  Navigator.of(context).pop();
                } else {
                  print('Error adding report: ${response.body}');
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _editReport(BuildContext context, ReportAd report) async {
    String type = report.type;
 

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Report'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Type'),
                controller: TextEditingController(text: type),
                onChanged: (value) {
                  type = value;
                },
              ),
    
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final response = await http.put(
                  Uri.parse('http://192.168.1.6:3000/user/editReport'),
                  headers: {"Content-Type": "application/json"},
                  body: jsonEncode({
                    "oldType": report.type,
                    "newType": type,
                  }),
                );

                if (response.statusCode == 200) {
                  setState(() {
                    report.type = type;
              
                  });
                  Navigator.of(context).pop();
                } else {
                  print('Error editing report: ${response.body}');
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _deleteReport(ReportAd report) async {
    try {
      final response = await http.delete(
        Uri.parse('http://192.168.1.6:3000/user/deleteReport'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "type": report.type,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          reports.removeWhere((element) => element.type == report.type);
        });
        print('Report deleted successfully');
      } else {
        print('Error deleting reports: ${response.body}');
      }
    } catch (error) {
      print('Error deleting donation: $error');
    }
  }
}



