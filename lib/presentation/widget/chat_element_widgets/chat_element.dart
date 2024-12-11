import 'package:flutter/material.dart';
import 'package:platefulai/constants/colors.dart';
import 'package:platefulai/constants/extensions.dart';
import 'package:platefulai/constants/sizes.dart';

class ChatElement extends StatelessWidget {
  const ChatElement({
    super.key,
    required this.user,
    required this.text,
    required this.ai,
  });

  final String user;
  final String text;
  final bool ai;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: ai ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          Text(
            user,
            style: context.subTitle.copyWith(
              color: AppColors.surfaceWhite,
            ),
          ),
          kGap4,
          Text(
            text,
            softWrap: true,
            textAlign: ai ? TextAlign.left : TextAlign.right,
            style: context.body.copyWith(
              color: AppColors.surfaceWhite.withOpacity(0.85),
            ),
          )
        ],
      ),
    );
  }
}
