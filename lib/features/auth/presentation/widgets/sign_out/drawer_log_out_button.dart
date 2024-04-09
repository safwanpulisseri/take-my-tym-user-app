import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:take_my_tym/core/bloc/app_bloc.dart';
import 'package:take_my_tym/core/widgets/show_loading_dialog.dart';
import 'package:take_my_tym/core/widgets/snack_bar_messenger_widget.dart';
import 'package:take_my_tym/features/auth/presentation/bloc/sign_out_bloc/sign_out_bloc.dart';
import 'package:take_my_tym/features/auth/presentation/pages/welcome_page.dart';
import 'package:take_my_tym/features/auth/presentation/widgets/user_log_out_dialog.dart';
import 'package:take_my_tym/features/navigation_menu/presentation/widgets/drawer/widgets/drawer_button.dart';

class LogOutDrawerButton extends StatelessWidget {
  const LogOutDrawerButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignOutBloc, SignOutState>(
      listener: (context, state) {
        if (state is UserSignOutFailState) {
          SnackBarMessenger().showSnackBar(
            context: context,
            errorMessage: state.title,
            errorDescription: state.message,
          );
        }
        if (state is UserSignOutLoadingState) {
          ShowLoadingDialog().showLoadingIndicator(context);
        }
        if (state is UserSignOutSuccessState) {
          context.read<AppBloc>().add(UpdateUserSignOutEvent());
          log(context.read<AppBloc>().appUserModel.toString());
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const WelcomePage()),
              (route) => false);
        }
      },
      child: DrawerCustomButton(
        title: 'Log Out',
        function: () {
          UserLogOut().showLogOutDialog(
            context: context,
          );
        },
        icon: IconlyLight.logout,
      ),
    );
  }
}