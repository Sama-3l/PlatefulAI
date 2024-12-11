import 'package:flutter/cupertino.dart';
import 'package:platefulai/alogrithms/methods.dart';
import 'package:platefulai/constants/colors.dart';
import 'package:platefulai/constants/extensions.dart';
import 'package:platefulai/constants/sizes.dart';
import 'package:platefulai/data/models/user.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({super.key, required this.currUser});

  final UserModel currUser;
  final Methods func = Methods();

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        backgroundColor: AppColors.backgroundWhite,
        child: SafeArea(
            child: Stack(children: [
          Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Column(children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Chats",
                    style: context.title,
                  ),
                ),
                kGap8,
                Expanded(
                    child: Center(
                  child: Text(
                    "Collaborating function coming soon",
                    style: context.heading,
                  ),
                ))
              ]))
        ])));
  }
}
