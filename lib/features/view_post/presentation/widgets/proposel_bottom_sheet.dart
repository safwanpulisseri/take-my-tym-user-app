import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:take_my_tym/core/model/app_post_model.dart';
import 'package:take_my_tym/core/utils/app_colors.dart';
import 'package:take_my_tym/core/widgets/app_bottom_sheet.dart';
import 'package:take_my_tym/core/widgets/submit_button.dart';
import 'package:take_my_tym/features/proposals/presentation/pages/submit_proposel_page.dart';

class ProposelBottomSheet {
  void show(BuildContext context, {required PostModel postModel}) {
    AppBottomSheet.show(
      context: context,
      header: false,
      children: [
        SizedBox(height: 20.h),
        Align(
          alignment: Alignment.center,
          child: Text(
            "Great! 🎉",
            style: Theme.of(context).textTheme.headlineLarge,
          ),
        ),
        SizedBox(height: 10.h),
        Align(
          alignment: Alignment.center,
          child: Text(
            "Thanks for showing your intrest...",
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        SizedBox(height: 16.h),
        Align(
          alignment: Alignment.center,
          child: Text(
            "Before you forward, Please confirm that you read the description and make sure you are fit for the role.",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                ),
          ),
        ),
        SizedBox(height: 15.h),
        Row(
          children: [
            Expanded(
              child: SubmitButton(
                callback: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    SubmitProposelPage.route(
                      postModel: postModel,
                    ),
                  );
                },
                text: 'Continue',
                backgroundColor: AppDarkColor.instance.success,
                foregroundColor: AppDarkColor.instance.primaryText,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: SubmitButton(
                callback: () {
                  Navigator.pop(context);
                },
                text: 'Cancel',
                backgroundColor: AppDarkColor.instance.danger,
                foregroundColor: AppDarkColor.instance.primaryText,
              ),
            ),
          ],
        ),
        SizedBox(height: 15.h),
      ],
    );
  }
}
