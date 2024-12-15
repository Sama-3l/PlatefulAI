import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:platefulai/alogrithms/methods.dart';
import 'package:platefulai/business_logic/cubits/AddInstructionPage/add_instruction_page_cubit.dart';
import 'package:platefulai/business_logic/cubits/AddItemField/add_item_field_cubit.dart';
import 'package:platefulai/business_logic/cubits/AddRecipeItem/add_recipe_item_cubit.dart';
import 'package:platefulai/business_logic/cubits/ChatPageUpdate/chat_page_update_cubit.dart';
import 'package:platefulai/business_logic/cubits/LikeAndSave/like_and_save_cubit.dart';
import 'package:platefulai/business_logic/cubits/MarkStepDone/mark_step_done_cubit.dart';
import 'package:platefulai/business_logic/cubits/RecipePageItemSwitch/recipe_page_item_switch_cubit.dart';
import 'package:platefulai/business_logic/cubits/RefreshHomePage/refresh_home_page_cubit.dart';
import 'package:platefulai/business_logic/cubits/UpdateTextField/update_textfield_cubit.dart';
import 'package:platefulai/constants/colors.dart';
import 'package:platefulai/constants/theme.dart';
import 'package:platefulai/firebase_options.dart';
import 'package:platefulai/presentation/main_app.dart';
import 'package:platefulai/presentation/screens/signup.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Methods func = Methods();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => RecipePageItemSwitchCubit()),
        BlocProvider(create: (context) => AddRecipeItemCubit()),
        BlocProvider(create: (context) => AddInstructionPageCubit()),
        BlocProvider(create: (context) => MarkStepDoneCubit()),
        BlocProvider(create: (context) => AddItemFieldCubit()),
        BlocProvider(create: (context) => RefreshHomePageCubit()),
        BlocProvider(create: (context) => UpdateTextfieldCubit()),
        BlocProvider(create: (context) => LikeAndSaveCubit()),
        BlocProvider(create: (context) => ChatPageUpdateCubit()),
      ],
      child: CupertinoApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: theme,
          home: FutureBuilder(
              future: func.verifySignIn(context),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.data == null) {
                    return SignUpPage();
                  } else {
                    return MainApp(currUser: snapshot.data!);
                  }
                } else {
                  return const CupertinoPageScaffold(
                      backgroundColor: AppColors.primaryGreen,
                      child: Center(
                        child: CupertinoActivityIndicator(
                          color: AppColors.backgroundWhite,
                        ),
                      ));
                }
              })),
    );
  }
}
