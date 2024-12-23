import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:platefulai/alogrithms/methods.dart';
import 'package:platefulai/business_logic/cubits/AddItemField/add_item_field_cubit.dart';
import 'package:platefulai/business_logic/cubits/AddRecipeItem/add_recipe_item_cubit.dart';
import 'package:platefulai/business_logic/cubits/ChatPageUpdate/chat_page_update_cubit.dart';
import 'package:platefulai/business_logic/cubits/MarkStepDone/mark_step_done_cubit.dart';
import 'package:platefulai/constants/colors.dart';
import 'package:platefulai/constants/enum.dart';
import 'package:platefulai/constants/extensions.dart';
import 'package:platefulai/constants/sizes.dart';
import 'package:platefulai/data/models/chat.dart';
import 'package:platefulai/data/models/ingredients.dart';
import 'package:platefulai/data/models/instruction.dart';
import 'package:platefulai/data/models/recipe.dart';
import 'package:platefulai/data/models/step.dart';
import 'package:platefulai/data/models/tool.dart';
import 'package:platefulai/data/models/user.dart';
import 'package:platefulai/presentation/widget/action_button.dart';
import 'package:platefulai/presentation/widget/add_page_textfield.dart';
import 'package:platefulai/presentation/widget/chat_element_widgets/chat_element.dart';

class GptPage extends StatefulWidget {
  const GptPage({
    super.key,
    required this.title,
    required this.recipe,
    required this.user,
    this.instruction,
    required this.type,
  });

  final String title;
  final Recipe recipe;
  final UserModel user;
  final Instruction? instruction;
  final FieldDataType type;

  @override
  State<GptPage> createState() => _GptPageState();
}

class _GptPageState extends State<GptPage> {
  final TextEditingController controller = TextEditingController();
  final ScrollController scrollController = ScrollController();
  List<ChatModel> chats = [];
  Methods func = Methods();

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        backgroundColor: AppColors.primaryGreen,
        child: SafeArea(
            child: Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16, top: 16),
                child: BlocBuilder<ChatPageUpdateCubit, ChatPageUpdateState>(builder: (context, state) {
                  return Stack(
                    children: [
                      Column(children: [
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  widget.title,
                                  style: context.title.copyWith(color: AppColors.backgroundWhite),
                                ),
                                kGap4,
                                Text(
                                  "Chat size limit is 30 and limit on number of chats is 5",
                                  style: context.caption.copyWith(color: AppColors.backgroundWhite),
                                ),
                              ],
                            ),
                            kGap16,
                            if (state is WaitingForAI)
                              const CupertinoActivityIndicator(
                                color: AppColors.surfaceWhite,
                              ),
                            const Spacer(),
                            ActionButton(
                                size: 32,
                                icon: CupertinoIcons.check_mark,
                                onTap: () async {
                                  BlocProvider.of<ChatPageUpdateCubit>(context).onWaitingForAI();
                                  final body = await func.integrateGPT(
                                    context,
                                    widget.title,
                                    chats.first.chat,
                                    () {},
                                    widget.type,
                                  );
                                  if (widget.type == FieldDataType.Ingredients) {
                                    List<Ingredient> ingredients = body.map((e) => Ingredient.fromJson(e)).toList();
                                    widget.recipe.ingredients = ingredients;
                                    BlocProvider.of<AddRecipeItemCubit>(context).onAddItemCubit();
                                    BlocProvider.of<AddItemFieldCubit>(context).onAdd();
                                  } else if (widget.type == FieldDataType.Tools) {
                                    List<Tool> tools = body.map((e) => Tool.fromJson(e)).toList();
                                    widget.recipe.tools = tools;
                                    BlocProvider.of<AddRecipeItemCubit>(context).onAddItemCubit();
                                    BlocProvider.of<AddItemFieldCubit>(context).onAdd();
                                  } else {
                                    List<StepModel> steps = body.map((e) => StepModel.fromJson(e)).toList();
                                    widget.instruction!.steps = steps;
                                    BlocProvider.of<AddRecipeItemCubit>(context).onAddItemCubit();
                                    BlocProvider.of<MarkStepDoneCubit>(context).onDone();
                                  }
                                  Navigator.of(context).pop();
                                }),
                          ],
                        ),
                        kGap24,
                        Expanded(
                            child: ListView.builder(
                                controller: scrollController,
                                reverse: true,
                                itemCount: chats.length,
                                itemBuilder: (context, index) {
                                  return ChatElement(user: chats[index].user, text: chats[index].chat, ai: chats[index].ai);
                                })),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                child: AddPageTextfield(
                                  controller: controller,
                                  maxLength: 30,
                                  maxLines: 5,
                                  placeholder: "How can I help you better with ${widget.title}",
                                  style: context.body,
                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                                ),
                              ),
                              kGap8,
                              ActionButton(
                                  size: 44,
                                  iconSize: 16,
                                  icon: CupertinoIcons.paperplane_fill,
                                  onTap: () async {
                                    ChatModel chat = ChatModel(user: widget.user.name, chat: controller.value.text, ai: false);
                                    chats.insert(0, chat);
                                    controller.clear();
                                    BlocProvider.of<ChatPageUpdateCubit>(context).onWaitingForAI();
                                    ChatModel aiChat = ChatModel(user: "", chat: "", ai: true);
                                    if (chats.length > 5) {
                                      func.alert(context, "Error", "Text Limit exceeded");
                                    } else {
                                      await func.sendMsg(context, widget.title, chat.chat, scrollController, aiChat);
                                    }
                                    chats.insert(0, aiChat);
                                    BlocProvider.of<ChatPageUpdateCubit>(context).onUpdate();
                                  }),
                            ],
                          ),
                        ),
                      ]),
                    ],
                  );
                }))));
  }
}
