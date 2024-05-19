import 'package:flutter/material.dart';

import '../../../../core/navigation/screen_transitions/no_movement.dart';
import '../../../../core/utils/app_padding.dart';
import '../../../../core/widgets/app_logo.dart';

import '../widgets/terms_and_conditions_widget.dart';
import '../widgets/welcome_button.dart';
import '../widgets/welcome_page_animation.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});
  static route() => noMovement(const WelcomePage());
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        resizeToAvoidBottomInset: false,
        body: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: EdgeInsets.only(
                  left: MyAppPadding.authPadding,
                  right: MyAppPadding.authPadding,
                ),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: WelcomePageAnimation(),
                    ),
                    SafeArea(
                      child: Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: AppLogo(),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          WelcomeButton(),
                          SizedBox(height: 25),
                          TermsAndConditionsWidget(animate: false),
                          SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
