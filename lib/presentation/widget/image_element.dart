import 'package:flutter/material.dart';
import 'package:platefulai/constants/colors.dart';

class ImageElement extends StatelessWidget {
  const ImageElement({super.key, required this.options});

  final List<Widget> options;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        color: AppColors.primaryGreen,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: options,
            ),
          ),
        ),
      ),
    );
  }
}
