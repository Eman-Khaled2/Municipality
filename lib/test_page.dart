
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/translation/locale_keys.g.dart';


class TestPage extends StatelessWidget {
  const TestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.testPage.tr()),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text(LocaleKeys.back.tr()),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
