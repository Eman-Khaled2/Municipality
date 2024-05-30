import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shop_app/Login.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/translation/locale_keys.g.dart';

class SignUpScreen extends StatefulWidget {
  static String routeName = "/signup";
  final String baseUrl;
  final String email;

  const SignUpScreen({Key? key, required this.baseUrl, required this.email}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _picController = TextEditingController();
  final TextEditingController _phonNomperController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _addresController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmpassController = TextEditingController();

  String selectedPrefix = "+970";

  String _message = '';
  final String apiUrl = 'http://192.168.1.6:3000/user/add';

  Future<void> signUp() async {
    if (_formKey.currentState!.validate()) {
      final Map<String, dynamic> data = {
        "picture": _picController.text.toString(),
        "phone_number": _phonNomperController.text.toString(),
        "name": _usernameController.text.toString(),
        "address": _addresController.text.toString(),
        "email": widget.email, // Using the email from previous page
        "password": _passwordController.text.toString(),
        "type_user":"user"
      };
      try {
        final response = await http.post(Uri.parse(apiUrl), body: json.encode(data), headers: {'Content-Type': 'application/json'});
        print(response.statusCode);

        if (response.statusCode == 200) {
          final responseData = json.decode(response.body);
          if (responseData['message'] == 'add user') {
            setState(() {
              _message = 'add user';
            });
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return CupertinoAlertDialog(
                  title: Text(LocaleKeys.success.tr()),
                  content: Text(LocaleKeys.Go_back_to_sign_in_to_see_your_account.tr()),
                  actions: [
                    CupertinoDialogAction(
                      child: Text(LocaleKeys.OK.tr()),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginDemo(baseUrl: '',)),
                        );
                      },
                    ),
                  ],
                );
              },
            );
          }}   if (response.statusCode == 400) {    final responseData = json.decode(response.body);

        if (responseData['message'] == 'email already exist') {
          setState(() {
            _message = 'email already exist';
          });
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return CupertinoAlertDialog(
                title: Text(LocaleKeys.Error.tr()),
                content: Text(LocaleKeys.Email_already_exists.tr()),
                actions: [
                  CupertinoDialogAction(
                    child: Text(LocaleKeys.OK.tr()),
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
      } catch (error) {
        print('Error occurred: $error');
        setState(() {
          _message = 'Error occurred: $error';
        });
      }
    }
  }

  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return  LocaleKeys.Please_enter_your_phone_number.tr();
    }
    return null;
  }

  String? _validateProfessionalName(String? value) {
    if (value == null || value.isEmpty) {
      return LocaleKeys.Please_enter_your_name.tr();
    }
    return null;
  }

  String? _validateAddress(String? value) {
    if (value == null || value.isEmpty) {
      return LocaleKeys.Please_enter_your_address.tr();
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return LocaleKeys.Please_enter_your_email_address.tr();
    } else if (!value.contains('@')) {
      return LocaleKeys.Please_enter_a_valid_email_address.tr();
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return LocaleKeys.Please_enter_a_password.tr();
    } else if (value.length < 6) {
      return LocaleKeys.Password_must_be_at_least_6_characters_long.tr();
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return LocaleKeys.Please_confirm_your_password.tr();
    } else if (value != _passwordController.text) {
      return LocaleKeys.Passwords_do_not_match.tr();
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/c.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              color: Colors.transparent,
            ),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                     Text(
                       LocaleKeys.sign_up.tr(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Card(
                      margin: const EdgeInsets.symmetric(horizontal: 30),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                             
                              const SizedBox(height: 20),
                            TextFormField(
  initialValue: widget.email, // Using the email from previous page
  enabled: false, // Disable editing
  decoration: InputDecoration(
    labelText: LocaleKeys.Email.tr(),
    hintText: widget.email, // Updated hint text with the email from previous page
    border: OutlineInputBorder(),
    prefixIcon: Icon(Icons.email), // Added prefix icon
  ),
  keyboardType: TextInputType.emailAddress,
  validator: _validateEmail,
),

                              const SizedBox(height: 20),
                              TextFormField(
                                controller: _phonNomperController,
                                decoration: InputDecoration(
                                  labelText:LocaleKeys.Phone_Number.tr(),
                                  hintText: LocaleKeys.Enter_your_phone_number.tr(), // Added hint text
                                  border: OutlineInputBorder(),
                                  prefixIcon: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 11.0),
                                        child: Image.asset(
                                          'assets/images/signup.jpg',
                                          height: 14,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      DropdownButton<String>(
                                        value: selectedPrefix,
                                        onChanged: (String? newValue) {
                                          if (newValue != null) {
                                            setState(() {
                                              selectedPrefix = newValue;
                                            });
                                          }
                                        },
                                        items: <String>["+970", "+972"]
                                            .map<DropdownMenuItem<String>>(
                                          (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          },
                                        ).toList(),
                                      ),
                                    ],
                                  ),
                                ),
                                keyboardType: TextInputType.phone,
                                validator: _validatePhoneNumber,
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                controller: _usernameController,
                                decoration: InputDecoration(
                                  labelText:LocaleKeys.Name.tr(),
                                  hintText: LocaleKeys.Enter_your_name.tr(), // Added hint text
                                  border: OutlineInputBorder(),
                                ),
                                validator: _validateProfessionalName,
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                controller: _addresController,
                                decoration:  InputDecoration(
                                  labelText:LocaleKeys.Address.tr(),
                                  hintText: LocaleKeys.Enter_your_address.tr(), // Added hint text
                                  border: OutlineInputBorder(),
                                ),
                                validator: _validateAddress,
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                controller: _passwordController,
                                decoration: InputDecoration(
                                  labelText: LocaleKeys.Password.tr(),
                                  hintText: LocaleKeys.Password.tr(), // Added hint text
                                  border: OutlineInputBorder(),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                                    icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                                  ),
                                ),
                                obscureText: _obscurePassword,
                                validator: _validatePassword,
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                controller: _confirmpassController,
                                decoration: InputDecoration(
                                  labelText: LocaleKeys.Confirm_Password.tr(),
                                  hintText: LocaleKeys.Confirm_Password.tr(), // Added hint text
                                  border: OutlineInputBorder(),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _obscureConfirmPassword = !_obscureConfirmPassword;
                                      });
                                    },
                                    icon: Icon(_obscureConfirmPassword ? Icons.visibility : Icons.visibility_off),
                                  ),
                                ),
                                obscureText: _obscureConfirmPassword,
                                validator: _validateConfirmPassword,
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color.fromARGB(255, 39, 218, 66),
                                  minimumSize: const Size(double.infinity, 50),
                                ),
                                onPressed: signUp,
                                child: Text(
                                   LocaleKeys.sign_up.tr(),
                                  style: TextStyle(
                                    color: Colors.green[900],
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const LoginDemo(baseUrl: '',)),
                                  );
                                },
                                child:  Text(LocaleKeys.Already_have_an_account_Log_In.tr()),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
