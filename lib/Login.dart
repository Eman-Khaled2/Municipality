import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/Users_Pages.dart';
import 'package:shop_app/admin/admin.dart';
import 'package:shop_app/otpSignUp.dart';
import 'package:shop_app/screens/forgot_password/otp.dart';
import 'package:shop_app/translation/locale_keys.g.dart';

class LoginDemo extends StatefulWidget {
  final String baseUrl; // Declare a final String for baseUrl

  const LoginDemo({Key? key, required this.baseUrl}) : super(key: key);
  @override
  _LoginDemoState createState() => _LoginDemoState();
}

class _LoginDemoState extends State<LoginDemo> {
  final _formKey = GlobalKey<FormState>(); // GlobalKey for form
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final account = GetStorage();

  bool _isObscure = true;

  void _togglePasswordVisibility() {
    setState(() {
      _isObscure = !_isObscure;
    });
  }

  Future<bool> _authenticateUser() async {
    const apiUrl = 'http://192.168.1.6:3000/user/login';
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": _emailController.text,
          "password": _passwordController.text
        }),
      );
      if (response.statusCode == 200) {
        print("response.body: ${response.body}");
        var da = json.decode(response.body);
        // Check user type here (assuming 'type' is a key in your JSON response)
        String userType = da["types"];

        // Redirect based on user type
        if (userType == "admin") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AdminScreen(
                userData: {},
              ), // Navigate to AdminScreen
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  const SettingsPage(), // Navigate to SettingsPage for regular users
            ),
          );
        }

        Map<String, dynamic> user = {
          "name": da["name"],
          "email": da["email"],
          "password": da["password"],
          "address": da["address"],
          "phone_number": da["phone_number"],
          "id": da["_id"]
        };

        print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>");
        print(json.encode(user));

        account.write("keyUser", user);

        return true; // authentication successful
      } else {
        return false; // authentication failed
      }
    } catch (error) {
      print('Error occurred: $error');
      return false; // authentication failed due to error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          LocaleKeys.Login_Page.tr(),
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          Tooltip(
            message: LocaleKeys.change_language.tr(),
            child: IconButton(
              onPressed: () {
                LocalizationChecker.changeLanguage(context);
              },
              icon: const Icon(Icons.language),
            ),
          )
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/c.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Form(
            key: _formKey, // Assigning GlobalKey to Form
            autovalidateMode:
                AutovalidateMode.onUserInteraction, // Enable auto-validation
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(20.0),
                  color: Colors.white.withOpacity(0.7),
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: _emailController,
                        onChanged: (value) {},
                        validator: (value) {
                          // Validation for email field
                          if (value == null || value.isEmpty) {
                            return LocaleKeys.Enter_valid_email_as_Muheebgmail
                                .tr();
                          }
                          // You can add more validation rules for email here if needed
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: LocaleKeys.Email.tr(),
                          hintText:
                              LocaleKeys.Enter_valid_email_as_Muheebgmail.tr(),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        controller: _passwordController,
                        onChanged: (value) {},
                        validator: (value) {
                          // Validation for password field
                          if (value == null || value.isEmpty) {
                            return LocaleKeys.Enter_secure_password.tr();
                          }
                          // You can add more validation rules for password here if needed
                          return null;
                        },
                        obscureText: _isObscure,
                        decoration: InputDecoration(
                          labelText: LocaleKeys.Password.tr(),
                          hintText: LocaleKeys.Enter_secure_password.tr(),
                          suffixIcon: IconButton(
                            onPressed: _togglePasswordVisibility,
                            icon: Icon(_isObscure
                                ? Icons.visibility
                                : Icons.visibility_off),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      TextButton(
                        onPressed: () {
                          // Navigate to ForgotPasswordScreen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ForgetPasswordPage(
                                baseUrl: '',
                              ),
                            ),
                          );
                        },
                        child: Text(
                          LocaleKeys.Forgot_Password.tr(),
                          style:
                              TextStyle(color: Colors.green[900], fontSize: 15),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          // Check if form is valid
                          if (_formKey.currentState!.validate()) {
                            // Authenticate user
                            final isLoggedIn = await _authenticateUser();
                            if (!isLoggedIn) {
                              // If login fails, show error message
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Failed to login. Please check your credentials.',
                                  ),
                                ),
                              );
                            }
                          }
                        },
                        child: Text(
                          LocaleKeys.Login.tr(),
                          style: const TextStyle(
                              color: Colors.green, fontSize: 25),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      TextButton(
                        onPressed: () {
                          // Navigate to SignUpScreen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SignUpScreenR(
                                baseUrl: '',
                                email: '',
                              ),
                            ),
                          );
                        },
                        child: Text(
                          LocaleKeys.sign_up.tr(),
                          style:
                              TextStyle(color: Colors.green[900], fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LocalizationChecker {
  static changeLanguage(BuildContext context) {
    Locale? currentLocal = EasyLocalization.of(context)!.currentLocale;
    if (currentLocal == const Locale('en')) {
      EasyLocalization.of(context)!.setLocale(const Locale('ar'));
    } else {
      EasyLocalization.of(context)!.setLocale(const Locale('en'));
    }
  }
}
