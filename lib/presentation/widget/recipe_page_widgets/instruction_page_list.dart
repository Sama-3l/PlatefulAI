import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:platefulai/business_logic/cubits/MarkStepDone/mark_step_done_cubit.dart';
import 'package:platefulai/constants/colors.dart';
import 'package:platefulai/constants/enum.dart';
import 'package:platefulai/constants/extensions.dart';
import 'package:platefulai/constants/sizes.dart';
import 'package:platefulai/data/models/instruction.dart';
import 'package:platefulai/data/models/recipe.dart';
import 'package:platefulai/data/models/user.dart';
import 'package:platefulai/presentation/pages/recipe_add_data_page.dart';
import 'package:platefulai/presentation/widget/recipe_page_widgets/step_list_element.dart';

class InstructionPageList extends StatelessWidget {
  const InstructionPageList({
    super.key,
    required this.index,
    required this.recipe,
    required this.addPageTitle,
    required this.user,
    required this.instruction,
    required this.editable,
  });

  final Recipe recipe;
  final UserModel user;
  final int index;
  final String addPageTitle;
  final Instruction instruction;
  final bool editable;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MarkStepDoneCubit, MarkStepDoneState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text(
                  "Steps",
                  style: context.subTitle,
                ),
                const Spacer(),
                editable
                    ? CupertinoButton(
                        padding: EdgeInsets.zero,
                        child: const Icon(
                          CupertinoIcons.plus_circle_fill,
                          size: 24,
                        ),
                        onPressed: () {
                          Navigator.of(context).push(CupertinoPageRoute(
                              builder: (context) => RecipeItemAddDataPage(
                                    instruction: instruction,
                                    recipe: recipe,
                                    user: user,
                                    items: instruction.steps,
                                    title: "Step$index: $addPageTitle",
                                    type: FieldDataType.Steps,
                                    onSubmit: (obj) {
                                      instruction.title = addPageTitle;
                                      instruction.steps = obj;
                                    },
                                  )));
                        })
                    : CupertinoButton(
                        padding: EdgeInsets.zero,
                        child: Icon(
                          instruction.steps.every((ingredient) => ingredient.done) ? CupertinoIcons.check_mark_circled_solid : CupertinoIcons.check_mark_circled,
                          size: 24,
                          color: AppColors.primaryGreen,
                        ),
                        onPressed: () {
                          bool allDone = instruction.steps.every((ingredient) => ingredient.done);
                          for (var e in instruction.steps) {
                            e.done = !allDone;
                          }
                          BlocProvider.of<MarkStepDoneCubit>(context).onDone();
                        }),
              ],
            ),
            kGap16,
            ...instruction.steps.map((e) => StepListElement(step: e))
          ],
        );
      },
    );
  }
}
