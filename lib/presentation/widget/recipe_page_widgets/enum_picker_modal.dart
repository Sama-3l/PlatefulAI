import 'package:flutter/cupertino.dart';
import 'package:platefulai/constants/colors.dart';
import 'package:platefulai/constants/enum.dart';
import 'package:platefulai/constants/extensions.dart';

class EnumPicker extends StatelessWidget {
  final Category initialOption;
  final void Function(Category selectedOption) onCategoryselected;

  const EnumPicker({
    Key? key,
    required this.initialOption,
    required this.onCategoryselected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final categoryList = Category.values.where((e) => e != Category.All).toList();
    final optionLabels = categoryList.map((e) => e.name).toList();

    return Container(
      height: 250,
      color: AppColors.backgroundWhite,
      child: Column(
        children: [
          SizedBox(
            height: 44,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CupertinoButton(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    "Cancel",
                    style: context.body,
                  ),
                ),
                CupertinoButton(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    "Done",
                    style: context.body,
                  ),
                ),
              ],
            ),
          ),
          // Picker
          Expanded(
            child: CupertinoPicker(
              itemExtent: 32.0,
              scrollController: FixedExtentScrollController(
                initialItem: categoryList.indexOf(initialOption),
              ),
              onSelectedItemChanged: (index) {
                onCategoryselected(categoryList[index]);
              },
              children: optionLabels
                  .map((label) => Center(
                          child: Text(
                        label,
                        style: context.body,
                      )))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
