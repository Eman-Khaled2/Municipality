import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:shop_app/screens/forgot_password/reser.dart';
import 'package:shop_app/translation/locale_keys.g.dart';

class ForgetPasswordPage extends StatefulWidget {
  final String baseUrl;

  const ForgetPasswordPage({Key? key, required this.baseUrl}) : super(key: key);

  @override
  _ForgetPasswordPageState createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _verificationController = TextEditingController();

  bool _verificationVisible = false;

  String _verificationCode = ''; // Variable to store the verification code
  String _correctVerificationCode =
      ''; // Variable to store the correct verification code

  final List<TextEditingController> _verificationCodeControllers =
      List.generate(6, (index) => TextEditingController());

  @override
  void dispose() {
    // Dispose verification code controllers
    for (var controller in _verificationCodeControllers) {
      controller.dispose();
    }
    _emailController.dispose();
    _verificationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'OTP Password',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'OTP Verification',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 132, 129, 129),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  constraints: BoxConstraints(maxWidth: 400), // Set maximum width for the container
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 238, 230, 230), // Set the background color to white
                    borderRadius: BorderRadius.circular(10), // Add border radius
                  ),
                  padding: EdgeInsets.all(20), // Add padding
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Email input field
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                           
                              TextFormField(
                                controller: _emailController,
                                validator: _validateEmail,
                                decoration: InputDecoration(
                                  labelText: LocaleKeys.Enter_valid_email_as_Muheebgmail.tr(),
                                  labelStyle: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                                  filled: true,
                                  fillColor: Color.fromARGB(255, 37, 36, 36).withOpacity(0.1),
                                ),
                                style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                // Check if email is entered
                                // Generate a random 6-digit verification code
                                _verificationCode = _generateRandomCode(6);
                                _correctVerificationCode = _verificationCode; // Store the correct verification code
                                print('Verification Code: $_verificationCode');

                                // Send email with verification code
                                sendEmail(_emailController.text, _verificationCode);

                                // Show success dialog for sending code to email
                                _showAlertDialog(
                                    LocaleKeys.success.tr(),
                                    LocaleKeys.Verification_code_sent_to_your_email.tr());
                                setState(() {
                                  _verificationVisible = true;
                                });
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                            child: Text(
                              LocaleKeys.Send.tr(),
                              style: const TextStyle(color: Colors.black),
                            ),
                          ),
                          const SizedBox(height: 30),
                          // Verification code input field
                          Visibility(
                            visible: _verificationVisible,
                            child: Column(
                              children: [
                                const SizedBox(height: 20),
                                // Verification code boxes
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(
                                    6,
                                    (index) => Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.3),
                                        border: Border.all(color: Colors.white),
                                        borderRadius: BorderRadius.circular(8.0),
                                      ),
                                      alignment: Alignment.center,
                                      child: TextFormField(
                                        controller: _verificationCodeControllers[index],
                                        onChanged: (value) {
                                          if (value.length <= 1) {
                                            if (value.isNotEmpty) {
                                              if (index < 5) {
                                                FocusScope.of(context).nextFocus(); // Move focus to the next TextFormField
                                              }
                                            }
                                          }
                                        },
                                        textAlign: TextAlign.center,
                                        keyboardType: TextInputType.number,
                                        maxLength: 1,
                                        style: const TextStyle(color: Colors.white),
                                        decoration: const InputDecoration(
                                          counterText: '',
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                // Back button
                                ElevatedButton(
                                  onPressed: () {
                                    // Check if entered code matches the correct verification code
                                    String code = '';
                                    for (var controller in _verificationCodeControllers) {
                                      code += controller.text;
                                    }
                                    if (code == _correctVerificationCode) {
                                      // Show dialog for correct verification code
                                      _showAlertDialog(LocaleKeys.success.tr(),
                                          LocaleKeys.Verification_code_is_correct.tr());
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ResetPassPage(
                                              baseUrl: widget.baseUrl,
                                              email: _emailController.text), // Pass email here
                                        ),
                                      );
                                    } else {
                                      // Show dialog for incorrect verification code
                                      _showAlertDialog(
                                          LocaleKeys.Error.tr(),
                                          LocaleKeys.Verification_code_is_incorrect.tr());
                                    }
                                    // Clear verification code TextFormField
                                    for (var controller in _verificationCodeControllers) {
                                      controller.clear();
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                  ),
                                  child: Text(
                                    LocaleKeys.Verify.tr(),
                                    style: const TextStyle(color: Colors.black),
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Method to generate a random code with the specified length
  String _generateRandomCode(int length) {
    const chars = '0123456789';
    Random random = Random();
    return String.fromCharCodes(
      Iterable.generate(length, (_) => chars.codeUnitAt(random.nextInt(chars.length))),
    );
  }

  // Method to validate email
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return LocaleKeys.Enter_valid_email_as_Muheebgmail.tr();
    } else if (!RegExp(r'^[\w-.]+@([\w-]+.)+[\w-]{2,4}$').hasMatch(value)) {
      return LocaleKeys.Enter_valid_email_as_Muheebgmail.tr();
    }
    return null;
  }

  // Method to send email
  void sendEmail(String email, String code) async {
    String username = 's12010108@stu.najah.edu'; // Your email username
    String password = 'zhd@941187'; // Your email password

    final smtpServer = gmail(username, password);

    final message = Message()
      ..from = Address(username, 'Tix Tap team')
      ..recipients.add(email)
      ..subject = 'Verification Code for your account in Tix Tap'
      ..text = 'The code is $code: please write it to reset your password';

    try {
      final sendReport = await send(message, smtpServer);
      print('Email sent to $email: ${sendReport.toString()}');
    } catch (e) {
      print('Error sending email to $email: $e');
    }
  }

  // Method to show alert dialog
  void _showAlertDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            Icon(
              title == 'Success' ? Icons.check_circle : Icons.error,
              color: title == 'Success' ? Colors.green : Colors.red,
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(LocaleKeys.OK.tr()),
            ),
          ],
        );
      },
    );
  }
}
