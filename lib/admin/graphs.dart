import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';
import 'dart:convert';

class GraphsPage extends StatefulWidget {
  @override
  _GraphsPageState createState() => _GraphsPageState();
}

class _GraphsPageState extends State<GraphsPage> {
  Map<String, double> taxData = {};
  List<String> taxTypes = [];

  Future<void> fetchTaxData() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.1.6:3000/user/getTaxGraph'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          taxTypes = List<String>.from(data['types']);
          taxData = Map<String, double>.fromEntries(
            (data['paid'] as Map<String, dynamic>).entries.map((entry) =>
              MapEntry(entry.key, (entry.value as num).toDouble())
            )
          );
        });
      } else {
        throw Exception('Failed to load tax data: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching tax data: $error');
      // Handle error accordingly, like showing an error message to the user
    }
  }

  @override
  void initState() {
    super.initState();
    fetchTaxData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tax Graphs',
          style: TextStyle(
            color: Colors.white, // Set title text color
          ),
        ),
        backgroundColor: Colors.green, // Set app bar background color
        iconTheme: IconThemeData(color: Colors.white), // Set icon color
      ),
      backgroundColor: Color.fromARGB(255, 240, 230, 255), // Set background color to light purple
      body: Center(
        child: taxData.isEmpty
            ? CircularProgressIndicator()
            : BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: taxData.values.reduce((a, b) => a > b ? a : b) * 1.2,
                  groupsSpace: 20,
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: FlTitlesData(
                    leftTitles: SideTitles(
                      showTitles: false, // Hide left titles
                    ),
                    bottomTitles: SideTitles(
                      showTitles: true,
                      getTextStyles: (value, context) {
                        return TextStyle(
                          color: Color.fromARGB(255, 131, 84, 133), // Set number color
                          fontSize: 14,
                          fontFamily: 'Roboto', // Set font family
                          fontWeight: FontWeight.bold, // Set font weight to bold
                        );
                      },
                      margin: 10,
                      rotateAngle: 0, // Set rotation angle to 0 degrees
                      getTitles: (double value) {
                        final index = value.toInt();
                        if (index < 0 || index >= taxData.keys.length) {
                          return '';
                        }
                        return taxTypes[index]; // Use taxTypes instead of taxData.keys
                      },
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: taxData.entries.map((entry) {
                    return BarChartGroupData(
                      x: taxTypes.indexOf(entry.key), // Use taxTypes instead of taxData.keys
                      barRods: [
                        BarChartRodData(
                          y: entry.value,
                          colors: [Color.fromARGB(255, 204, 167, 213)],
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
      ),
    );
  }
}
