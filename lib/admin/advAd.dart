import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AdvertisementsAdPage(),
    );
  }
}

class AdvertisementsAdPage extends StatefulWidget {
  static String routeName = "/AdvertisementsAdPage";

  const AdvertisementsAdPage({Key? key});

  @override
  _AdvertisementsAdPageState createState() => _AdvertisementsAdPageState();
}

class _AdvertisementsAdPageState extends State<AdvertisementsAdPage> {
  List<dynamic> _advertisements = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Advertisements',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.green,
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
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [ Color.fromARGB(255, 238, 227, 240),Color.fromARGB(255, 187, 168, 187)],
          ),
        ),
        child: ListView.builder(
          itemCount: _advertisements.length,
          itemBuilder: (BuildContext context, int index) {
            return AdvertisementWidget(
              advertisement: _advertisements[index],
              onDelete: () {
                _deleteAdvertisement(index);
              },
              onEdit: () {
                _editAdvertisement(index);
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddAdvertisementDialog();
        },
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        child: const Icon(Icons.add, color: Color.fromARGB(255, 0, 0, 0)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchAdvertisements();
  }

  void _fetchAdvertisements() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.1.6:3000/user/getAdv'));
      if (response.statusCode == 200) {
        setState(() {
          _advertisements = json.decode(response.body)['advertisements'];
        });
      } else {
        throw Exception('Failed to load advertisements');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _deleteAdvertisement(int index) async {
    try {
      final title = _advertisements[index]['title'];
      final response = await http.delete(
        Uri.parse('http://192.168.1.6:3000/user/deleteAd'),
        headers: <String, String>{'Content-Type': 'application/json'},
        body: jsonEncode(<String, dynamic>{'title': title}),
      );
      if (response.statusCode == 200) {
        setState(() {
          _advertisements.removeAt(index);
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Advertisement deleted successfully'),
        ));
      } else {
        throw Exception('Failed to delete advertisement');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _showAddAdvertisementDialog() async {
    TextEditingController titleController = TextEditingController();
    TextEditingController imageController = TextEditingController();
    TextEditingController detailsController = TextEditingController();
    TextEditingController priceController = TextEditingController();
    TextEditingController facebookLinkController = TextEditingController();

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Advertisement'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                TextFormField(
                  controller: imageController,
                  decoration: const InputDecoration(labelText: 'Image URL'),
                ),
                TextFormField(
                  controller: detailsController,
                  decoration: const InputDecoration(labelText: 'Details'),
                ),
                TextFormField(
                  controller: priceController,
                  decoration: const InputDecoration(labelText: 'Price'),
                ),
                TextFormField(
                  controller: facebookLinkController,
                  decoration: const InputDecoration(labelText: 'Facebook Link'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                _addAdvertisement(
                  imageController.text,
                  titleController.text,
                  detailsController.text,
                  priceController.text,
                  facebookLinkController.text,
                );
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _addAdvertisement(String image, String title, String details, String price, String facebookLink) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.6:3000/user/addAd'),
        headers: <String, String>{'Content-Type': 'application/json'},
        body: jsonEncode(<String, String>{
          'image': image,
          'title': title,
          'details': details,
          'price': price,
          'link': facebookLink,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          _advertisements.add(json.decode(response.body));
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Advertisement added successfully'),
        ));
      } else {
        throw Exception('Failed to add advertisement');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _editAdvertisement(int index) async {
    TextEditingController imageController = TextEditingController(text: _advertisements[index]['image']);
    TextEditingController titleController = TextEditingController(text: _advertisements[index]['title']);
    TextEditingController detailsController = TextEditingController(text: _advertisements[index]['details']);
    TextEditingController priceController = TextEditingController(text: _advertisements[index]['price']);
    TextEditingController facebookLinkController = TextEditingController(text: _advertisements[index]['link']);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Advertisement'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  controller: imageController,
                  decoration: const InputDecoration(labelText: 'Image URL'),
                ),
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                TextFormField(
                  controller: detailsController,
                  decoration: const InputDecoration(labelText: 'Details'),
                ),
                TextFormField(
                  controller: priceController,
                  decoration: const InputDecoration(labelText: 'Price'),
                ),
                TextFormField(
                  controller: facebookLinkController,
                  decoration: const InputDecoration(labelText: 'Facebook Link'),
                ),
              ],
            ),
          ),
          actions: <Widget>
          [
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                _saveAdvertisement(
                    index,
                    imageController.text,
                    titleController.text,
                    detailsController.text,
                    priceController.text,
                    facebookLinkController.text);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _saveAdvertisement(int index, String image, String title, String details, String price, String facebookLink) async {
    try {
      final response = await http.put(
        Uri.parse('http://192.168.1.6:3000/user/updateAd'),
        headers: <String, String>{'Content-Type': 'application/json'},
        body: jsonEncode(<String, dynamic>{
          'id': _advertisements[index]['id'],
          'image': image,
          'title': title,
          'details': details,
          'price': price,
          'link': facebookLink,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          _advertisements[index] = json.decode(response.body)['advertisement'];
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Advertisement updated successfully'),
        ));
      } else {
        throw Exception('Failed to update advertisement');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}

class AdvertisementWidget extends StatefulWidget {
  final dynamic advertisement;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const AdvertisementWidget(
      {Key? key,
      required this.advertisement,
      required this.onDelete,
      required this.onEdit});

  @override
  _AdvertisementWidgetState createState() => _AdvertisementWidgetState();
}

class _AdvertisementWidgetState extends State<AdvertisementWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ListTile(
          title: Text(
            widget.advertisement['title'] ?? '',
            style: const TextStyle(
              fontSize: 20,
            ),
          ),
          trailing: IconButton(
            icon: Icon(_isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down),
            onPressed: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
          ),
        ),
        if (_isExpanded)
          Card(
            elevation: 4.0,
            margin: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.asset(
                    widget.advertisement['image'] ?? '',
                    fit: BoxFit.cover,
                    height: 200.0,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.advertisement['details'] ?? '',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.advertisement['price'] ?? '',
                    style: const TextStyle(fontSize: 16),
                  ),
                  TextButton(
                    onPressed: () {
                      _openFacebookPage(widget.advertisement['link'] ?? '');
                    },
                    child: const Text(
                      'Visit Facebook Page',
                      style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 129, 107, 144)),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: widget.onEdit,
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: widget.onDelete,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  void _openFacebookPage(String facebookLink) async {
    try {
      if (await canLaunch(facebookLink)) {
        await launch(facebookLink);
      } else {
        throw 'Could not launch $facebookLink';
      }
    } catch (e) {
      print('Error opening Facebook page: $e');
      await launch(facebookLink, forceSafariVC: false);
    }
  }
}
