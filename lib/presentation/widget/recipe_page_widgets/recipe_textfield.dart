import 'package:flutter/cupertino.dart';
import 'package:platefulai/constants/colors.dart';

class RecipeTextfield extends StatelessWidget {
  const RecipeTextfield({
    super.key,
    required this.controller,
    required this.maxLines,
    this.maxLength,
    required this.placeholder,
    this.icon,
    this.iconPadding = const EdgeInsets.only(left: 8),
    this.readOnly = false,
    required this.style,
  });

  final TextEditingController controller;
  final int maxLines;
  final int? maxLength;
  final String placeholder;
  final Widget? icon;
  final EdgeInsets iconPadding;
  final bool readOnly;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return CupertinoTextField(
      readOnly: readOnly,
      controller: controller,
      minLines: 1,
      maxLength: maxLength,
      maxLines: maxLines,
      padding: EdgeInsets.zero,
      decoration: const BoxDecoration(
        color: AppColors.transparent,
      ),
      placeholder: placeholder,
      style: style,
      placeholderStyle: style.copyWith(
        color: style.color!.withOpacity(0.3),
      ),
      prefix: icon != null
          ? Padding(
              padding: iconPadding,
              child: icon,
            )
          : null,
    );
  }
}
