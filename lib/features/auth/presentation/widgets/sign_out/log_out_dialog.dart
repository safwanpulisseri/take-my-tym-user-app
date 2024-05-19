import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/widgets/app_dialog.dart';
import '../../bloc/sign_out_bloc/sign_out_bloc.dart';

class LogOutWidget {
  void showLogOutDialog({
    required BuildContext context,
  }) {
    AppDialog.show(
      context: context,
      title: 'Log Out Confirmation',
      subtitle: 'Are you sure you want to log out?',
      action: "LOG OUT",
      canecel: "CANCEL",
      actionCall: () => context.read<SignOutBloc>().add(UserSignOutEvent()),
    );
  }
}
