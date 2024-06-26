import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:take_my_tym/core/utils/theme/color/app_colors.dart';

class AppDialog {
  static show({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String action,
    required VoidCallback actionCall,
    Color? actionColor,
    bool actionPop = false,
    String canecel = "Cancel",
  }) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 300,
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                SizedBox(height: 25.h),
                Text(
                  title,
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                SizedBox(height: 10.h),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppDarkColor.instance.primaryTextBlur,
                      ),
                  textAlign: TextAlign.center,
                ),
                const Spacer(),
                _MessageButton(
                  action: canecel,
                  backgroundColor: AppDarkColor.instance.buttonBackground,
                  foregroundColor: AppDarkColor.instance.buttonForground,
                  callback: () => Navigator.pop(context),
                ),
                SizedBox(height: 12.h),
                _MessageButton(
                  action: action,
                  backgroundColor: actionColor ?? AppDarkColor.instance.danger,
                  foregroundColor: AppDarkColor.instance.buttonBackground,
                  callback: () {
                    if (actionPop) {
                      Navigator.pop(context);
                    }
                    actionCall();
                  },
                ),
                const Spacer(),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _MessageButton extends StatelessWidget {
  final String action;
  final VoidCallback callback;
  final Color backgroundColor;
  final Color foregroundColor;
  const _MessageButton({
    required this.action,
    required this.backgroundColor,
    required this.callback,
    required this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              callback();
            },
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(backgroundColor),
              foregroundColor: WidgetStatePropertyAll(foregroundColor),
            ),
            child: Text(action),
          ),
        ),
      ],
    );
  }
}
