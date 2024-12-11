import 'package:flutter/cupertino.dart';
import 'package:platefulai/constants/colors.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({super.key, required this.size, required this.icon, required this.onTap, this.widget, this.iconSize = 12});

  final double size;
  final IconData icon;
  final double iconSize;
  final Widget? widget;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(color: AppColors.surfaceWhite, borderRadius: BorderRadius.circular(4)),
          child: Center(
            child: widget ??
                Icon(
                  icon,
                  size: iconSize,
                  color: AppColors.primaryGreen,
                ),
          ),
        ));
  }
}
