// ignore_for_file: must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:platefulai/constants/colors.dart';
import 'package:platefulai/constants/enum.dart';
import 'package:platefulai/constants/extensions.dart';
import 'package:platefulai/constants/sizes.dart';

class CategoryOption extends StatelessWidget {
  CategoryOption({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.size = 56,
    this.selected = false,
  });

  final String icon;
  final Category title;
  final double size;
  final Function() onTap;
  bool selected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: GestureDetector(
        onTap: () => onTap(),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: selected ? AppColors.primaryGreen : AppColors.surfaceWhite,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Iconify(icon, size: 12, color: selected ? AppColors.surfaceWhite : AppColors.primaryGreen),
              kGap4,
              Text(
                title.name,
                style: context.optionsBody.copyWith(color: selected ? AppColors.surfaceWhite : AppColors.primaryGreen),
              )
            ],
          ),
        ),
      ),
    );
  }
}
