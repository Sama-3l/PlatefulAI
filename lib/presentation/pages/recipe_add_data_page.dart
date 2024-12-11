import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:platefulai/assets/svgs/svgs.dart';
import 'package:platefulai/business_logic/cubits/AddItemField/add_item_field_cubit.dart';
import 'package:platefulai/business_logic/cubits/AddRecipeItem/add_recipe_item_cubit.dart';
import 'package:platefulai/business_logic/cubits/MarkStepDone/mark_step_done_cubit.dart';
import 'package:platefulai/constants/colors.dart';
import 'package:platefulai/constants/enum.dart';
import 'package:platefulai/constants/extensions.dart';
import 'package:platefulai/constants/sizes.dart';
import 'package:platefulai/data/models/ingredients.dart';
import 'package:platefulai/data/models/instruction.dart';
import 'package:platefulai/data/models/recipe.dart';
import 'package:platefulai/data/models/step.dart';
import 'package:platefulai/data/models/tool.dart';
import 'package:platefulai/data/models/user.dart';
import 'package:platefulai/presentation/pages/gpt_page.dart';
import 'package:platefulai/presentation/widget/action_button.dart';
import 'package:platefulai/presentation/widget/add_page_textfield.dart';

class RecipeItemAddDataPage extends StatefulWidget {
  const RecipeItemAddDataPage({
    super.key,
    required this.title,
    required this.recipe,
    this.instruction,
    required this.user,
    required this.onSubmit,
    required this.type,
    required this.items,
  });

  final String title;
  final Recipe recipe;
  final Instruction? instruction;
  final UserModel user;
  final Function(dynamic obj) onSubmit;
  final FieldDataType type;
  final List<dynamic> items;

  @override
  State<RecipeItemAddDataPage> createState() => _RecipeItemAddDataPageState();
}

class _RecipeItemAddDataPageState extends State<RecipeItemAddDataPage> {
  final List<Map<String, TextEditingController>> controllers = [];
  String itemTitle = "Ingredient";

  void addField({String? title, String? subTitle}) {
    switch (widget.type) {
      case FieldDataType.Tools:
        itemTitle = "Tool";
        TextEditingController titleController = TextEditingController(text: title);
        TextEditingController subTitleController = TextEditingController(text: subTitle);
        controllers.add({
          "name": titleController,
          "use": subTitleController,
        });
        break;
      case FieldDataType.Ingredients:
        TextEditingController titleController = TextEditingController(text: title);
        TextEditingController subTitleController = TextEditingController(text: subTitle);
        controllers.add({
          "name": titleController,
          "quantity": subTitleController,
        });
        break;
      case FieldDataType.Steps:
        itemTitle = "Step";
        TextEditingController titleController = TextEditingController(text: title);
        controllers.add({
          "steps": titleController,
        });
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.items.isNotEmpty) {
      switch (widget.type) {
        case FieldDataType.Tools:
          for (Tool e in widget.items) {
            addField(title: e.name, subTitle: e.use);
          }
          break;
        case FieldDataType.Ingredients:
          for (Ingredient e in widget.items) {
            addField(title: e.name, subTitle: e.quantity);
          }
          break;
        case FieldDataType.Steps:
          for (StepModel e in widget.items) {
            addField(title: e.step);
          }
          break;
      }
    } else {
      addField();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        backgroundColor: AppColors.primaryGreen,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16, top: 16),
            child: BlocBuilder<AddItemFieldCubit, AddItemFieldState>(
              builder: (context, state) {
                return Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          widget.title,
                          style: context.title.copyWith(color: AppColors.backgroundWhite),
                        ),
                        const Spacer(),
                        kGap16,
                        ActionButton(
                            size: 32,
                            icon: CupertinoIcons.check_mark,
                            widget: const Iconify(
                              chatGPT,
                              size: 16,
                              color: AppColors.primaryGreen,
                            ),
                            onTap: () => Navigator.of(context).pushReplacement(CupertinoPageRoute(
                                  builder: (context) => GptPage(
                                    instruction: widget.instruction,
                                    recipe: widget.recipe,
                                    title: widget.type.name,
                                    user: widget.user,
                                    type: widget.type,
                                  ),
                                ))),
                        kGap16,
                        ActionButton(
                            size: 32,
                            icon: CupertinoIcons.check_mark,
                            onTap: () {
                              List returnValue;
                              switch (widget.type) {
                                case FieldDataType.Tools:
                                  returnValue = controllers
                                      .map(
                                        (e) => Tool(name: e["name"]!.value.text, use: e["use"]!.value.text, done: false),
                                      )
                                      .toList();
                                  break;
                                case FieldDataType.Ingredients:
                                  returnValue = controllers
                                      .map(
                                        (e) => Ingredient(name: e["name"]!.value.text, quantity: e["quantity"]!.value.text, done: false),
                                      )
                                      .toList();
                                  break;
                                case FieldDataType.Steps:
                                  returnValue = controllers
                                      .map(
                                        (e) => StepModel(step: e["steps"]!.value.text, done: false),
                                      )
                                      .toList();
                                  break;
                              }
                              widget.onSubmit(returnValue);
                              BlocProvider.of<MarkStepDoneCubit>(context).onDone();
                              BlocProvider.of<AddRecipeItemCubit>(context).onAddItemCubit();
                              Navigator.of(context).pop();
                            }),
                      ],
                    ),
                    Expanded(
                      child: ListView(
                        children: [
                          kGap24,
                          for (int i = 0; i < controllers.length; i++) ...[
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "${itemTitle}_${i + 1}",
                                      style: context.subTitle.copyWith(color: AppColors.backgroundWhite),
                                    ),
                                    const Spacer(),
                                    CupertinoButton(
                                        padding: EdgeInsets.zero,
                                        child: const Icon(
                                          CupertinoIcons.trash,
                                          size: 16,
                                          color: AppColors.backgroundWhite,
                                        ),
                                        onPressed: () {
                                          controllers.removeAt(i);
                                          BlocProvider.of<AddItemFieldCubit>(context).onAdd();
                                        })
                                  ],
                                ),
                                kGap16,
                                for (var placehoder in controllers[i].keys) ...[
                                  AddPageTextfield(
                                    controller: controllers[i][placehoder]!,
                                    maxLines: 20,
                                    placeholder: placehoder,
                                    style: context.body,
                                  ),
                                  kGap8,
                                ],
                                kGap8,
                              ],
                            )
                          ],
                          Align(
                            alignment: Alignment.center,
                            child: CupertinoButton(
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                addField();
                                BlocProvider.of<AddItemFieldCubit>(context).onAdd();
                              },
                              child: const Icon(
                                CupertinoIcons.plus_circle,
                                size: 24,
                                color: AppColors.backgroundWhite,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ));
  }
}
