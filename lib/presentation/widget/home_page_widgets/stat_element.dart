import 'package:flutter/cupertino.dart';
import 'package:platefulai/constants/colors.dart';
import 'package:platefulai/constants/extensions.dart';
import 'package:platefulai/constants/sizes.dart';

class StatElement extends StatelessWidget {
  const StatElement({super.key, required this.title, required this.icon});

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 8,
          color: AppColors.primaryGreen,
        ),
        kGap2,
        Text(
          title,
          style: context.likes,
        )
      ],
    );
  }
}
