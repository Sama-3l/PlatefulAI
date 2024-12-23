// ignore_for_file: must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:platefulai/constants/colors.dart';

class AddPageTextfield extends StatelessWidget {
  AddPageTextfield({
    super.key,
    required this.controller,
    required this.maxLines,
    required this.placeholder,
    required this.style,
    this.maxLength,
    this.inputType,
    this.padding = const EdgeInsets.all(8),
  });

  final TextEditingController controller;
  int maxLines;
  int? maxLength;
  String placeholder;
  TextStyle style;
  EdgeInsets padding;
  TextInputType? inputType;

  @override
  Widget build(BuildContext context) {
    return CupertinoTextField(
      controller: controller,
      minLines: 1,
      maxLines: maxLines,
      maxLength: maxLength,
      keyboardType: inputType,
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(8.0),
      ),
      placeholder: placeholder,
      style: style,
      placeholderStyle: style.copyWith(
        color: style.color!.withOpacity(0.3),
      ),
    );
  }
}
