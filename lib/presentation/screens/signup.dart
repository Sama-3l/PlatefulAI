import 'package:flutter/cupertino.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:platefulai/alogrithms/methods.dart';
import 'package:platefulai/assets/svgs/svgs.dart';
import 'package:platefulai/constants/colors.dart';
import 'package:platefulai/constants/extensions.dart';
import 'package:platefulai/constants/sizes.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({super.key});

  final Methods func = Methods();

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        backgroundColor: AppColors.primaryGreen,
        child: SafeArea(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Welcome to PlatefulAI",
                style: context.welcomeTitle,
              ),
              Text(
                "Sign in to access your account",
                style: context.navBar.copyWith(color: AppColors.backgroundWhite),
              ),
              kGap40,
              SizedBox(
                width: double.infinity,
                child: CupertinoButton(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    color: AppColors.backgroundWhite,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Iconify(
                          google,
                          size: 40,
                          color: AppColors.primaryGreen,
                        ),
                        kGap8,
                        Text(
                          "Sign in using Google",
                          style: context.button.copyWith(color: AppColors.primaryGreen),
                        )
                      ],
                    ),
                    onPressed: () {
                      func.handleSignIn(context);
                    }),
              )
            ],
          ),
        )));
  }
}