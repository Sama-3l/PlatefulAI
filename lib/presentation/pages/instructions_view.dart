// ignore_for_file: must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:platefulai/alogrithms/methods.dart';
import 'package:platefulai/alogrithms/widget_decider.dart';
import 'package:platefulai/business_logic/cubits/AddInstructionPage/add_instruction_page_cubit.dart';
import 'package:platefulai/constants/colors.dart';
import 'package:platefulai/constants/sizes.dart';
import 'package:platefulai/data/models/instruction.dart';
import 'package:platefulai/data/models/recipe.dart';
import 'package:platefulai/data/models/user.dart';
import 'package:platefulai/presentation/pages/instruction_page.dart';
import 'package:platefulai/presentation/widget/action_button.dart';
import 'package:platefulai/presentation/widget/image_element.dart';

class InstructionsView extends StatefulWidget {
  InstructionsView({
    super.key,
    required this.recipe,
    required this.user,
    required this.editable,
  });

  Recipe recipe;
  UserModel user;
  bool editable;

  @override
  State<InstructionsView> createState() => _InstructionsViewState();
}

class _InstructionsViewState extends State<InstructionsView> {
  WidgetDecider wd = WidgetDecider();
  final Methods func = Methods();
  final PageController _pageController = PageController();
  List<Widget> pages = [];

  @override
  void initState() {
    super.initState();
    if (widget.recipe.instructions.isEmpty) {
      widget.recipe.instructions.add(
        Instruction(steps: [], title: "", image: "", timeTaken: 0),
      );
    }
    for (int i = 0; i < widget.recipe.instructions.length; i++) {
      pages.add(InstructionPage(
        recipe: widget.recipe,
        user: widget.user,
        instruction: widget.recipe.instructions[i],
        editable: widget.editable,
        index: i + 1,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddInstructionPageCubit, AddInstructionPageState>(
      builder: (context, state) {
        return CupertinoPageScaffold(
            backgroundColor: AppColors.backgroundWhite,
            child: SafeArea(
                top: false,
                child: Stack(children: [
                  ImageElement(options: [
                    ActionButton(size: 32, icon: CupertinoIcons.arrow_left, onTap: () => Navigator.of(context).pop()),
                    if (widget.editable) ...[
                      const Spacer(),
                      ActionButton(
                          size: 32,
                          icon: CupertinoIcons.trash,
                          onTap: () {
                            if (pages.length - 1 > 0) {
                              widget.recipe.instructions.removeAt(_pageController.page!.toInt());
                              pages.removeAt(_pageController.page!.toInt());
                              _pageController.animateToPage(_pageController.page!.toInt() - 1, duration: const Duration(milliseconds: 500), curve: Curves.easeInBack);
                              BlocProvider.of<AddInstructionPageCubit>(context).onAddPage();
                            } else {
                              func.alert(context, "Error", "Can't delete last instruction");
                            }
                          }),
                      kGap16,
                      ActionButton(
                          size: 32,
                          icon: CupertinoIcons.check_mark,
                          onTap: () {
                            Navigator.of(context).pop();
                          }),
                    ]
                  ]),
                  DraggableScrollableSheet(
                    initialChildSize: 0.6, // Start at 50% height
                    minChildSize: 0.6, // Minimum height is 50%
                    maxChildSize: 1.0, // Maximum height is 100%
                    builder: (context, scrollController) {
                      return ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24),
                        ),
                        child: Container(
                          color: AppColors.backgroundWhite,
                          child: PageView(
                            controller: _pageController,
                            children: pages,
                          ),
                        ),
                      );
                    },
                  ),
                  if (widget.editable)
                    wd.showButton(
                      context,
                      widget.recipe,
                      "Add Instruction",
                      () {
                        widget.recipe.instructions.add(Instruction(title: "", steps: [], image: "", timeTaken: 0));
                        pages.add(InstructionPage(
                          recipe: widget.recipe,
                          user: widget.user,
                          instruction: widget.recipe.instructions.last,
                          editable: widget.editable,
                          index: pages.length + 1,
                        ));
                        BlocProvider.of<AddInstructionPageCubit>(context).onAddPage();
                        _pageController.animateToPage(pages.length - 1, duration: const Duration(milliseconds: 500), curve: Curves.easeInBack);
                      },
                      widget.editable,
                    ),
                ])));
      },
    );
  }
}
