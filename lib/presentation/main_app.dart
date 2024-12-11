import 'package:flutter/cupertino.dart';
import 'package:platefulai/constants/colors.dart';
import 'package:platefulai/constants/extensions.dart';
import 'package:platefulai/data/models/user.dart';
import 'package:platefulai/presentation/screens/account.dart';
import 'package:platefulai/presentation/screens/chat.dart';
import 'package:platefulai/presentation/screens/home.dart';

class MainApp extends StatelessWidget {
  MainApp({
    super.key,
    required this.currUser,
  });

  final UserModel currUser;

  final CupertinoTabController controller = CupertinoTabController();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      controller: controller,
      tabBar: CupertinoTabBar(
          border: Border(
              top: BorderSide(
            width: 0.3,
            color: AppColors.primaryGreen.withOpacity(0.2),
          )),
          backgroundColor: AppColors.backgroundWhite,
          height: 56,
          items: [
            CupertinoIcons.home.toNavBarItem('Home'),
            CupertinoIcons.person_2.toNavBarItem('Friends'),
            CupertinoIcons.person_circle.toNavBarItem('Account'),
          ]),
      tabBuilder: (context, index) {
        switch (index) {
          case 0:
            return CupertinoTabView(
              builder: (context) => HomeScreen(
                currUser: currUser,
              ),
            );
          case 1:
            return CupertinoTabView(
              builder: (context) => ChatScreen(
                currUser: currUser,
              ),
            );
          case 2:
            return CupertinoTabView(
              builder: (context) => AccountScreen(
                currUser: currUser,
              ),
            );
          default:
            return CupertinoTabView(
              builder: (context) => HomeScreen(
                currUser: currUser,
              ),
            );
        }
      },
    );
  }
}
