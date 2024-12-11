import 'package:flutter/cupertino.dart';
import 'package:platefulai/constants/colors.dart';
import 'package:platefulai/constants/extensions.dart';

class TextFieldWidget extends StatelessWidget {
  const TextFieldWidget({
    super.key,
    required this.controller,
    required this.placeholder,
    required this.icon,
    this.maxLength,
    this.maxLines = 1,
  });

  final TextEditingController controller;
  final int maxLines;
  final int? maxLength;
  final String placeholder;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return CupertinoTextField(
      controller: controller,
      minLines: 1,
      maxLength: maxLength,
      maxLines: maxLines,
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 8), // Add left padding to avoid overlap with icon
      placeholder: placeholder,
      style: context.inputText,
      placeholderStyle: context.inputText.copyWith(
        color: context.inputText.color!.withOpacity(0.3),
      ),
      prefix: Padding(
        padding: EdgeInsets.only(left: 8),
        child: icon,
      ),
    );
  }
}
