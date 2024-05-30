import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:shop_app/signup.dart';
import 'package:shop_app/translation/locale_keys.g.dart';

class SignUpScreenR extends StatefulWidget {
  final String baseUrl;

  const SignUpScreenR({Key? key, required this.baseUrl, required String email}) : super(key: key);

  @override
  _SignUpScreenRState createState() => _SignUpScreenRState();
}

class _SignUpScreenRState extends State<SignUpScreenR> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _verificationController = TextEditingController();

  bool _verificationVisible = false;

  String _verificationCode = ''; // Variable to store the verification code
  String _correctVerificationCode = ''; // Variable to store the correct verification code

  List<TextEditingController> _verificationCodeControllers =
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
    final _formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'OTP Signup',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
        iconTheme: IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
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
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'OTP Verification', // Add the text "OTP" here
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 132, 129, 129),
                    ),
                  ),
                  SizedBox(height: 30),
                  Container(
                    width: 400, // Adjust the width as needed
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 238, 230, 230),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: LocaleKeys.Enter_valid_email_as_Muheebgmail.tr(),
                            labelStyle: TextStyle(color: Colors.black),
                            filled: true,
                            fillColor: Colors.grey[200],
                          ),
                          style: TextStyle(color: Colors.black),
                          keyboardType: TextInputType.emailAddress,
                          validator: _validateEmail,
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              // Check if email is entered
                              // Generate a random 6-digit verification code
                              _verificationCode = _generateRandomCode(6);
                              _correctVerificationCode =
                                  _verificationCode; // Store the correct verification code
                              print('Verification Code: $_verificationCode');

                              // Send email with verification code
                              sendEmail(_emailController.text, _verificationCode);

                              // Show success dialog for sending code to email
                              _showAlertDialog(
                                  LocaleKeys.success.tr(), LocaleKeys.Verification_code_sent_to_your_email.tr());
                              setState(() {
                                _verificationVisible = true;
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                          ),
                          child: Text(
                            LocaleKeys.Send.tr(),
                            style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Verification code input field
                  Visibility(
                    visible: _verificationVisible,
                    child: Column(
                      children: [
                        SizedBox(height: 20),
                        // Verification code boxes
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            6,
                            (index) => Container(
                              margin: EdgeInsets.symmetric(horizontal: 5.0),
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
                                        FocusScope.of(context)
                                            .nextFocus(); // Move focus to the next TextFormField
                                      }
                                    }
                                  }
                                },
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                maxLength: 1,
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  counterText: '',
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
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
                              _showAlertDialog(LocaleKeys.success.tr(), LocaleKeys.Verification_code_is_correct.tr());
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SignUpScreen(baseUrl: widget.baseUrl, email: _emailController.text), // Pass email here
                                ),
                              );
                            } else {
                              // Show dialog for incorrect verification code
                              _showAlertDialog(LocaleKeys.Error.tr(),LocaleKeys.Verification_code_is_incorrect.tr());
                            }
                            // Clear verification code TextFormField
                            for (var controller in _verificationCodeControllers) {
                              controller.clear();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                          ),
                          child: Text(
                            LocaleKeys.Verify.tr(),
                            style: TextStyle(color: Colors.white),
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
      ),
    );
  }

  // Method to generate a random code with the specified length
  String _generateRandomCode(int length) {
    const chars = '0123456789';
    Random random = Random();
    return String.fromCharCodes(Iterable.generate(
        length, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
  }

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

  // Method to validate email
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return LocaleKeys.Enter_valid_email_as_Muheebgmail.tr();
    } else if (!value.contains('@')) {
      return LocaleKeys.Enter_valid_email_as_Muheebgmail.tr();
    }
    return null;
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
