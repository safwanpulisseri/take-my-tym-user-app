import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconly/iconly.dart';
import 'package:take_my_tym/core/utils/app_colors.dart';
import 'package:take_my_tym/core/utils/app_radius.dart';
import 'package:take_my_tym/features/wallet/presentation/pages/payment_page.dart';
import 'package:take_my_tym/features/wallet/presentation/util/wallet_action_type.dart';

class WalletCard extends StatelessWidget {
  final double balance;
  const WalletCard({
    required this.balance,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: 300.h,
        maxWidth: 600.h,
      ),
      child: Container(
        height: 150.h,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [
              AppDarkColor.instance.gradientPrimary,
              AppDarkColor.instance.gradientSecondary,
            ],
            center: Alignment.topLeft,
            radius: 0.9,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(MyAppRadius.borderRadius),
          ),
        ),
        child: Column(
          children: [
            const Spacer(),
            Text(
              'Main Balance',
              style: Theme.of(context).textTheme.labelSmall,
            ),
            const SizedBox(height: 5),
            Text(
              '₹${balance.toString()}',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _TransactionButton(
                  icon: IconlyLight.arrow_up,
                  title: 'Top up',
                  callback: () {
                    Navigator.push(
                      context,
                      PaymentPage.route(type: WalletAction.topUp),
                    );
                  },
                ),
                SizedBox(
                  height: 20.h,
                  child: const VerticalDivider(),
                ),
                _TransactionButton(
                  icon: IconlyLight.arrow_down,
                  title: 'Withdraw',
                  callback: () {
                    Navigator.push(
                        context,
                        PaymentPage.route(
                          type: WalletAction.widthdraw,
                        ));
                  },
                ),
              ],
            ),
            const Spacer()
          ],
        ),
      ),
    );
  }
}

class _TransactionButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback callback;
  const _TransactionButton({
    required this.icon,
    required this.title,
    required this.callback,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        callback();
      },
      child: Column(
        children: [
          Icon(icon),
          const SizedBox(height: 5),
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
          )
        ],
      ),
    );
  }
}
