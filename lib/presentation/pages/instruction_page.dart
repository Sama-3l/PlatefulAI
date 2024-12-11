// ignore_for_file: must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:platefulai/business_logic/cubits/UpdateTextField/update_textfield_cubit.dart';
import 'package:platefulai/constants/extensions.dart';
import 'package:platefulai/constants/sizes.dart';
import 'package:platefulai/data/models/instruction.dart';
import 'package:platefulai/data/models/recipe.dart';
import 'package:platefulai/data/models/user.dart';
import 'package:platefulai/presentation/widget/recipe_page_widgets/instruction_page_list.dart';
import 'package:platefulai/presentation/widget/recipe_page_widgets/recipe_textfield.dart';

class InstructionPage extends StatefulWidget {
  InstructionPage({
    super.key,
    required this.instruction,
    required this.recipe,
    required this.user,
    required this.editable,
    required this.index,
  });

  Instruction instruction;
  Recipe recipe;
  UserModel user;
  bool editable;
  int index;

  @override
  State<InstructionPage> createState() => _InstructionPageState();
}

class _InstructionPageState extends State<InstructionPage> {
  final TextEditingController title = TextEditingController();
  String time = "Time taken By Step";

  @override
  void initState() {
    super.initState();
    title.text = widget.instruction.title;
    time = "${widget.instruction.timeTaken}h";
    title.addListener(() {
      widget.instruction.title = title.value.text;
      BlocProvider.of<UpdateTextfieldCubit>(context).onUpdate();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UpdateTextfieldCubit, UpdateTextfieldState>(
      builder: (context, state) {
        return ListView(
          padding: const EdgeInsets.all(16),
          shrinkWrap: true,
          children: [
            RecipeTextfield(
              controller: title,
              maxLines: 2,
              placeholder: "Add Title",
              style: context.title,
              readOnly: !widget.editable,
              iconPadding: const EdgeInsets.only(right: 8),
              icon: Text(
                "Step${widget.index}:",
                style: context.title,
              ),
            ),
            kGap24,
            InstructionPageList(
              recipe: widget.recipe,
              user: widget.user,
              index: widget.index,
              addPageTitle: title.value.text,
              instruction: widget.instruction,
              editable: widget.editable,
            ),
            kGap24,
          ],
        );
      },
    );
  }
}
