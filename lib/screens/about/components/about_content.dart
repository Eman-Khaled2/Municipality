import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/translation/locale_keys.g.dart';

import '../../../constants.dart';

class HelpContent extends StatefulWidget {
  const HelpContent({
    Key? key,
    this.text,
    this.image,
  }) : super(key: key);
  final String? text, image;

  @override
  State<HelpContent> createState() => _SplashContentState();
}

class _SplashContentState extends State<HelpContent> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const Spacer(),
          Text(
          LocaleKeys.About_us.tr(),
          style: TextStyle(
            fontSize: 32,
            color: kPrimaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          widget.text!,
          textAlign: TextAlign.center,
        ),
        const Spacer(flex: 2),
        Image.asset(
          widget.image!,
          height: 265,
          width: 235,
        ),
      ],
    );
  }
}
