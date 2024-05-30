import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ManageUsersPage extends StatefulWidget {
  @override
  _ManageUsersPageState createState() => _ManageUsersPageState();
}

class _ManageUsersPageState extends State<ManageUsersPage> {
  List<dynamic> _users = [];

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    final response = await http.get(Uri.parse('http://192.168.1.6:3000/user/getAllUsers'));
    if (response.statusCode == 200) {
      setState(() {
        _users = json.decode(response.body);
      });
    } else {
      // Handle the error
      throw Exception('Failed to load users');
    }
  }

  Future<void> _deleteUser(String name) async {
    final response = await http.delete(
      Uri.parse('http://192.168.1.6:3000/user/deleteUser'),
      body: jsonEncode({'name': name}), // Send name in the request body
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      setState(() {
        _users.removeWhere((user) => user['name'] == name);
      });
    } else {
      // Handle the error
      throw Exception('Failed to delete user');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Manage Users',
          style: TextStyle(color: Colors.white), // Title color
        ),
        backgroundColor: Colors.green, // App bar color
        iconTheme: IconThemeData(color: Colors.white), // Back arrow color
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 238, 227, 240),
              Color.fromARGB(255, 187, 168, 187)
            ],
          ),
        ),
        child: _users.isEmpty
            ? Center(child: CircularProgressIndicator())
            : ListView.separated(
                itemCount: _users.length,
                separatorBuilder: (BuildContext context, int index) => SizedBox(height: 16), // Add space between users
                itemBuilder: (context, index) {
                  final user = _users[index];
                  return ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Name: ${user['name']}'),
                        Text('Phone Number: ${user['phone_number']}'),
                        Text('Address: ${user['address']}'),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Email: ${user['email']}'),
                        Text('Password: ${user['password']}'),
                        Text('Types: ${user['types']}'),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Color.fromARGB(255, 87, 85, 85)),
                      onPressed: () => _deleteUserConfirmation(user['name']),
                    ),
                  );
                },
              ),
      ),
    );
  }

  Future<void> _deleteUserConfirmation(String name) async {
    final bool deleteConfirmed = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete User'),
          content: Text('Are you sure you want to delete this user?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Delete'),
            ),
          ],
        );
      },
    );

    if (deleteConfirmed != null && deleteConfirmed) {
      try {
        await _deleteUser(name);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('User deleted successfully'),
          duration: Duration(seconds: 2),
        ));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to delete user: $e'),
          duration: Duration(seconds: 2),
        ));
      }
    }
  }
}
