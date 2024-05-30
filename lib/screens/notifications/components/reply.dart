import '../../../constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class ReplyNotifcation extends StatelessWidget {
  const ReplyNotifcation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(
          height: 80,
          width: 80,
          child: Stack(children: [
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: CircleAvatar(
                radius: 25,
                backgroundImage: AssetImage("assets/images/Avatar3.png"),
              ),
            ),
            Positioned(
              bottom: 10,
              child: CircleAvatar(
                radius: 25,
                backgroundImage: AssetImage("assets/images/Avatar4.png"),
              ),
            ),
          ]),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              RichText(
                maxLines: 2,
                text: TextSpan(
                    //   text: "",
                    style: Theme.of(context)
                        .textTheme
                        .headline3!
                        .copyWith(color: mainText),
                    children: [
                      TextSpan(
                        text: "Admin replied to you.\n",
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(color: mainText),
                      ),
                      //const TextSpan(text: "")
                    ]),
              ),
              const SizedBox(
                height: 10,
              ),
              Transform.translate(
                offset:
                    Offset(0, -15), // Adjust the value based on your preference
                child: Text(
                  "send me location  .  h1",
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1!
                      .copyWith(color: SecondaryText),
                ),
              )
            ],
          ),
        ),
        Image.asset(
          "assets/images/reply.png",
          height: 64,
          width: 64,
        ),
      ],
    );
  }
}
