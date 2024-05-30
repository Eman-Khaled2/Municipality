import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/Login.dart';
import 'package:shop_app/translation/locale_keys.g.dart';

class ResetPassPage extends StatefulWidget {
  final String baseUrl;
  final String email;

  const ResetPassPage({Key? key, required this.baseUrl, required this.email})
      : super(key: key);
  @override
  _ResetPassPageState createState() => _ResetPassPageState();
}

class _ResetPassPageState extends State<ResetPassPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _scaleAnimation;

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.0),
      end: const Offset(0.0, 0.1),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    String email = widget.email;
    String password = _passwordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();

    try {
      if (password != confirmPassword) {
        // Passwords don't match, show an error message
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Color.fromARGB(255, 0, 0, 0).withOpacity(0.3),
              title: Row(
                children: [
                  const Icon(
                    Icons.error,
                    color: Colors.red,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    LocaleKeys.Password_Mismatch.tr(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
              content: Text(
                LocaleKeys.The_entered_passwords_do_not_match.tr(),
                style: const TextStyle(color: Colors.white),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK',
                      style: TextStyle(color: Color(0xFFFFE797), fontSize: 20)),
                ),
              ],
            );
          },
        );
        return; // Exit the function as passwords don't match
      }

      var url = Uri.parse('http://192.168.1.6:3000/user/reset');
      var response = await http.put(
        url,
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Password reset successful, navigate to a success page or handle accordingly
        Navigator.push(
          context,
          // MaterialPageRoute(builder: (context) => LoginPage()),
          MaterialPageRoute(
              builder: (context) => LoginDemo(baseUrl: widget.baseUrl)),
        );
        print('Password reset successful!');
      } else {
        // Password reset failed, show an error dialog
        print('Password reset failed with status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.black.withOpacity(0.3),
              title: Row(
                children: [
                  const Icon(
                    Icons.error,
                    color: Colors.red,
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    // Wrap the Text widget with Flexible
                    child: Text(
                      LocaleKeys.Password_Mismatch.tr(),
                      style: const TextStyle(color: Colors.white),
                      overflow: TextOverflow
                          .ellipsis, // Use ellipsis to handle overflow
                    ),
                  ),
                ],
              ),
              content: Text(
                LocaleKeys.The_entered_passwords_do_not_match.tr(),
                style: const TextStyle(color: Colors.white),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK',
                      style: TextStyle(color: Color(0xFFFFE797), fontSize: 20)),
                ),
              ],
            );
          },
        );
      }
    } catch (error) {
      // An error occurred, show an error dialog
      print('Error: $error');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.black.withOpacity(0.3),
            title: Row(
              children: [
                const Icon(
                  Icons.error,
                  color: Colors.red,
                ),
                const SizedBox(width: 10),
                Text(
                  LocaleKeys.Error.tr(),
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
            content: Text(
              LocaleKeys.An_error_occurred_Please_try_again_later.tr(),
              style: const TextStyle(color: Colors.white),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(LocaleKeys.OK.tr(),
                    style: const TextStyle(
                        color: Color(0xFFFFE797), fontSize: 20)),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          LocaleKeys.Reset_Password.tr(),
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFD3D3D3), // Light Gray
              Color.fromARGB(255, 187, 168, 187),
                ],
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                  10.0, 2.0, 10.0, 10.0), // Adjusted padding
              child: SingleChildScrollView(
                child: Card(
                  // color: Color(0xFF818962), // Set card color here
                  shadowColor: Color.fromARGB(255, 187, 168, 187),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 20.0,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            labelText: LocaleKeys.New_Password.tr(),
                            prefixIcon: const Icon(Icons.lock), // Add lock icon
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        TextFormField(
                          controller: _confirmPasswordController,
                          obscureText: _obscureConfirmPassword,
                          decoration: InputDecoration(
                            labelText: LocaleKeys.Confirm_Password.tr(),
                            prefixIcon: const Icon(Icons.lock), // Add lock icon
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _obscureConfirmPassword =
                                      !_obscureConfirmPassword;
                                });
                              },
                              icon: Icon(
                                _obscureConfirmPassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed:
                              _resetPassword, // Call reset password function
                          style: ElevatedButton.styleFrom(
                            //primary: Colors.green[500],
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                          child: Text(
                            LocaleKeys.Reset_Password.tr(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    LoginDemo(baseUrl: widget.baseUrl),
                              ),
                            );
                          },
                          child: Text(
                            LocaleKeys.Back_to_Login.tr(),
                            style: const TextStyle(color: Colors.green),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
