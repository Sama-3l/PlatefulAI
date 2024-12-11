// ignore_for_file: must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:platefulai/assets/svgs/svgs.dart';
import 'package:platefulai/business_logic/cubits/MarkStepDone/mark_step_done_cubit.dart';
import 'package:platefulai/constants/colors.dart';
import 'package:platefulai/constants/extensions.dart';
import 'package:platefulai/constants/sizes.dart';
import 'package:platefulai/data/models/step.dart';

class StepListElement extends StatelessWidget {
  StepListElement({super.key, required this.step});

  StepModel step;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: GestureDetector(
        onTap: () {
          step.done = !step.done;
          BlocProvider.of<MarkStepDoneCubit>(context).onDone();
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            step.done
                ? const Icon(
                    CupertinoIcons.check_mark_circled_solid,
                    size: 24,
                    color: AppColors.primaryGreen,
                  )
                : const Iconify(
                    circleDotted,
                    size: 24,
                    color: AppColors.primaryGreen,
                  ),
            kGap16,
            Expanded(
              child: Text(step.step,
                  softWrap: true,
                  maxLines: 100,
                  style: step.done
                      ? context.body.copyWith(
                          decoration: TextDecoration.lineThrough,
                          color: AppColors.primaryGreen.withOpacity(0.4),
                        )
                      : context.body),
            )
          ],
        ),
      ),
    );
  }
}
