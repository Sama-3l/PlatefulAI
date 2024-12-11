import 'package:flutter/cupertino.dart';
import 'package:platefulai/constants/colors.dart';
import 'package:platefulai/constants/extensions.dart';
import 'package:platefulai/constants/sizes.dart';

class TagElement extends StatelessWidget {
  const TagElement({
    super.key,
    required this.text,
    required this.icon,
    this.recipePage = false,
    required this.onTap,
  });

  final String text;
  final IconData icon;
  final bool recipePage;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: AppColors.secondarywhite, borderRadius: BorderRadius.circular(recipePage ? 16 : 8)),
      child: Padding(
        padding: recipePage ? const EdgeInsets.all(8) : const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.min, children: [
          Icon(
            icon,
            size: recipePage ? 12 : 8,
            color: AppColors.primaryGreen,
          ),
          recipePage ? kGap4 : kGap2,
          Text(
            text,
            style: recipePage ? context.tag2 : context.tag,
          ),
        ]),
      ),
    );
  }
}
